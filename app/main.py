from contextlib import asynccontextmanager
from typing import Optional

from fastapi import Depends, FastAPI, Header, HTTPException, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, EmailStr, Field
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

from .database import get_db, session
from .models import AccessEventType, AccessLog, User, UserRole
from .routers import admin, expenses
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


def _extract_browser_from_sec_ch_ua(sec_ch_ua: str | None):
    raw = (sec_ch_ua or "").lower()
    if not raw:
        return None
    if "brave" in raw:
        return "Brave"
    if "edg" in raw or "edge" in raw:
        return "Edge"
    if "opr" in raw or "opera" in raw:
        return "Opera"
    if "firefox" in raw:
        return "Firefox"
    if "safari" in raw and "chrom" not in raw:
        return "Safari"
    if "chrom" in raw:
        return "Chrome"
    return None


def _extract_web_agent(request: Request):
    explicit_browser = (request.headers.get("x-browser-name") or "").strip()
    if explicit_browser:
        return explicit_browser[:255]

    browser_from_hint = _extract_browser_from_sec_ch_ua(request.headers.get("sec-ch-ua"))
    if browser_from_hint:
        return browser_from_hint

    user_agent = (request.headers.get("user-agent") or "").strip()
    if user_agent:
        return user_agent[:255]
    return "Desconocido"


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
        web_agent=_extract_web_agent(request),
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


class RegisterRequest(BaseModel):
    full_name: str = Field(..., min_length=1, max_length=300)
    email: EmailStr
    password: str = Field(..., min_length=8)


class LogoutRequest(BaseModel):
    token: str = Field(..., min_length=8)


class ChangePasswordRequest(BaseModel):
    current_password: str = Field(..., min_length=8)
    new_password: str = Field(..., min_length=8)


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


@app.post("/register", status_code=201)
async def register(register_request: RegisterRequest, db: Session = Depends(get_db)):
    email = register_request.email.strip().lower()
    full_name = register_request.full_name.strip()

    if not full_name:
        raise HTTPException(status_code=400, detail="Nombre completo requerido")

    existing = db.query(User).filter(User.email == email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email ya registrado")

    user = User(
        full_name=full_name,
        email=email,
        password_hash=get_password_hash(register_request.password),
        role=UserRole.user,
        is_active=True,
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    return {
        "msg": "Cuenta creada",
        "user": {
            "id": str(user.id),
            "name": user.full_name,
            "email": user.email,
            "rol": user.role.value,
        },
    }


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


@app.patch("/me/password")
async def change_my_password(
    payload: ChangePasswordRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if payload.current_password == payload.new_password:
        raise HTTPException(
            status_code=400,
            detail="La nueva contraseña debe ser diferente a la actual",
        )

    if is_password_hashed(current_user.password_hash):
        password_ok = verify_password(payload.current_password, current_user.password_hash)
    else:
        password_ok = current_user.password_hash == payload.current_password

    if not password_ok:
        raise HTTPException(status_code=400, detail="La contraseña actual es incorrecta")

    current_user.password_hash = get_password_hash(payload.new_password)
    _create_access_log(
        db,
        user=current_user,
        event_type=AccessEventType.PASSWORD_RESET_SUCCESS,
        attempt_email=current_user.email,
        request=request,
    )
    db.commit()
    return {"msg": "Contraseña actualizada"}


app.include_router(admin.router)
app.include_router(expenses.router)
