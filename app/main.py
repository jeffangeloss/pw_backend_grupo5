from contextlib import asynccontextmanager
from typing import Optional

from fastapi import Depends, FastAPI, Header, HTTPException, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, Field
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from .database import get_db, session
from .models import AccessEventType, AccessLog, User
from .routers import admin, expenses, resetPass
from .security import (
    DUMMY_HASH,
    create_access_token,
    decode_access_token,
    get_password_hash,
    is_password_hashed,
    verify_password,
)


def migrate_plain_passwords_to_hash():
    # BLOQUE SEGURIDAD: migra passwords en texto plano a hash Argon2.
    db = session()
    try:
        users = db.query(User).filter(User.password_hash.isnot(None)).all()
        changed = 0
        for user in users:
            if user.password_hash and not is_password_hashed(user.password_hash):
                user.password_hash = get_password_hash(user.password_hash)
                changed += 1

        if changed:
            db.commit()
    except SQLAlchemyError as exc:
        db.rollback()
        # BLOQUE SEGURIDAD: evita caida total de la API si falla la migracion.
        print(f"No se pudo completar la migracion de passwords a hash: {exc}")
    finally:
        db.close()


def _extract_client_ip(request: Request):
    forwarded_for = request.headers.get("x-forwarded-for")
    if forwarded_for:
        return forwarded_for.split(",")[0].strip()
    if request.client and request.client.host:
        return request.client.host
    return "0.0.0.0"


def _create_access_log(
    db: Session,
    *,
    user: User | None,
    event_type: AccessEventType,
    attempt_email: str,
    request: Request,
):
    log = AccessLog(
        user_id=user.id if user else None,
        event_type=event_type,
        attempt_email=attempt_email,
        ip_address=_extract_client_ip(request),
        web_agent=request.headers.get("user-agent"),
    )
    db.add(log)


def _get_user_from_token(token: str, db: Session) -> User | None:
    try:
        payload = decode_access_token(token)
    except Exception:
        return None

    email = (payload.get("sub") or "").strip().lower()
    if not email:
        return None

    return db.query(User).filter(User.email == email).first()


def _resolve_token(
    logout_request: Optional["LogoutRequest"],
    authorization: Optional[str],
):
    if logout_request and logout_request.token:
        return logout_request.token
    if authorization and authorization.lower().startswith("bearer "):
        return authorization[7:].strip()
    return None


def _register_logout(token: str, request: Request, db: Session):
    user = _get_user_from_token(token, db)
    if not user:
        raise HTTPException(status_code=401, detail="Token invalido")

    _create_access_log(
        db,
        user=user,
        event_type=AccessEventType.LOGOUT,
        attempt_email=user.email,
        request=request,
    )
    db.commit()


@asynccontextmanager
async def lifespan(app: FastAPI):
    migrate_plain_passwords_to_hash()
    yield


app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


class LoginRequest(BaseModel):
    # BLOQUE LOGIN: mantenemos username para frontend actual.
    username: Optional[str] = Field(default=None, min_length=5)
    # BLOQUE COMPAT: tambien acepta "correo" para clientes antiguos.
    correo: Optional[str] = Field(default=None, min_length=5)
    password: str = Field(..., min_length=8)


class LogoutRequest(BaseModel):
    token: str = Field(..., min_length=8)


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


@app.post("/login")
async def login(login_request: LoginRequest, request: Request, db: Session = Depends(get_db)):
    # BLOQUE LOGIN BD: validacion real contra tabla user en PostgreSQL.
    username = (login_request.username or login_request.correo or "").strip().lower()
    if not username:
        raise HTTPException(status_code=400, detail="Username/correo requerido")

    user = db.query(User).filter(User.email == username).first()

    if not user:
        verify_password(login_request.password, DUMMY_HASH)
        _create_access_log(
            db,
            user=None,
            event_type=AccessEventType.LOGIN_FAIL,
            attempt_email=username,
            request=request,
        )
        db.commit()
        raise HTTPException(status_code=400, detail="Credenciales incorrectas")

    if is_password_hashed(user.password_hash):
        password_ok = verify_password(login_request.password, user.password_hash)
    else:
        password_ok = user.password_hash == login_request.password
        if password_ok:
            user.password_hash = get_password_hash(login_request.password)
            db.commit()

    if not password_ok:
        _create_access_log(
            db,
            user=user,
            event_type=AccessEventType.LOGIN_FAIL,
            attempt_email=username,
            request=request,
        )
        db.commit()
        raise HTTPException(status_code=400, detail="Credenciales incorrectas")

    access_token = create_access_token({"sub": user.email})
    _create_access_log(
        db,
        user=user,
        event_type=AccessEventType.LOGIN_SUCCESS,
        attempt_email=user.email,
        request=request,
    )
    db.commit()

    role_name = user.role.value if user.role else "user"
    return {
        "msg": "Acceso concedido",
        "rol": role_name,
        "email": user.email,
        "name": user.full_name,
        "token": access_token,
        "access_token": access_token,
        "token_type": "bearer",
    }


@app.post("/logout")
async def logout(
    request: Request,
    logout_request: Optional[LogoutRequest] = None,
    authorization: Optional[str] = Header(default=None),
    db: Session = Depends(get_db),
):
    token = _resolve_token(logout_request, authorization)
    if not token:
        raise HTTPException(status_code=400, detail="Token requerido")

    _register_logout(token, request, db)
    return {"msg": "Sesion cerrada"}


@app.get("/logout")
async def logout_get(token: str, request: Request, db: Session = Depends(get_db)):
    _register_logout(token, request, db)
    return {"msg": "Sesion cerrada"}


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="No autorizado",
        headers={"WWW-Authenticate": "Bearer"},
    )

    user = _get_user_from_token(token, db)
    if not user:
        raise credentials_exception
    return user


@app.get("/me")
async def read_me(current_user: User = Depends(get_current_user)):
    return {
        "email": current_user.email,
        "name": current_user.full_name,
        "rol": current_user.role.value if current_user.role else "user",
    }


app.include_router(admin.router)
app.include_router(expenses.router)
app.include_router(resetPass.router)
