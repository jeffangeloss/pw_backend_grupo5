import datetime
import uuid
from contextlib import asynccontextmanager
from typing import Optional

from fastapi import Depends, FastAPI, Header, HTTPException, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, Field
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session, joinedload

from .database import get_db, session
from .models import Acceso, Estado, Navegador, Usuario
from .routers import admin
from .security import DUMMY_HASH, get_password_hash, is_password_hashed, verify_password


BROWSER_CATALOG = [
    "Brave",
    "Chrome",
    "Firefox",
    "Edge",
    "Safari",
    "Opera",
    "Desconocido",
]


def migrate_plain_passwords_to_hash() -> None:
    # BLOQUE SEGURIDAD: migra contraseñas en texto plano a hash Argon2.
    db = session()
    try:
        users = db.query(Usuario).filter(Usuario.contra_hash.isnot(None)).all()
        changed = 0
        for user in users:
            if user.contra_hash and not is_password_hashed(user.contra_hash):
                user.contra_hash = get_password_hash(user.contra_hash)
                changed += 1

        if changed:
            db.commit()
    except SQLAlchemyError:
        db.rollback()
        # BLOQUE SEGURIDAD: evita caída de la API si falla esta migración.
        print("No se pudo completar la migración de passwords a hash.")
    finally:
        db.close()


def ensure_browser_catalog() -> None:
    # BLOQUE NAVEGADOR: asegura catálogo base de navegadores en BD.
    db = session()
    try:
        existing_names = {row[0] for row in db.query(Navegador.nombre).all()}
        for browser_name in BROWSER_CATALOG:
            if browser_name not in existing_names:
                db.add(Navegador(id=uuid.uuid4(), nombre=browser_name))
        db.commit()
    except SQLAlchemyError:
        db.rollback()
        print("No se pudo sincronizar catálogo de navegadores.")
    finally:
        db.close()


def _normalize_action_name(action_name: str) -> str:
    return action_name.strip().upper()


def _detect_browser_name(user_agent: str | None, sec_ch_ua: str | None = None) -> str:
    # BLOQUE NAVEGADOR: primero priorizamos Client Hints.
    ch = (sec_ch_ua or "").lower()
    if "brave" in ch:
        return "Brave"
    if "edg" in ch:
        return "Edge"
    if "firefox" in ch:
        return "Firefox"
    if "opera" in ch or "opr" in ch:
        return "Opera"
    if "safari" in ch and "chrome" not in ch and "chromium" not in ch:
        return "Safari"
    if "chrome" in ch or "chromium" in ch:
        return "Chrome"

    # BLOQUE NAVEGADOR: fallback clásico con User-Agent.
    ua = (user_agent or "").lower()
    if "brave" in ua:
        return "Brave"
    if "edg/" in ua:
        return "Edge"
    if "firefox/" in ua:
        return "Firefox"
    if "opr/" in ua or "opera" in ua:
        return "Opera"
    if "chrome/" in ua and "edg/" not in ua:
        # Brave suele identificarse como Chrome en UA; si no llegó CH, cae aquí.
        return "Chrome"
    if "safari/" in ua and "chrome/" not in ua:
        return "Safari"
    return "Desconocido"


def _extract_client_ip(request: Request) -> str:
    forwarded_for = request.headers.get("x-forwarded-for")
    if forwarded_for:
        return forwarded_for.split(",")[0].strip()
    if request.client and request.client.host:
        return request.client.host
    return "0.0.0.0"


def _get_or_create_estado(db: Session, action_name: str) -> Estado:
    normalized_name = _normalize_action_name(action_name)
    estado = db.query(Estado).filter(Estado.nombre == normalized_name).first()
    if estado:
        return estado

    estado = Estado(id=uuid.uuid4(), nombre=normalized_name)
    db.add(estado)
    db.flush()
    return estado


def _get_or_create_navegador(db: Session, browser_name: str) -> Navegador:
    navegador = db.query(Navegador).filter(Navegador.nombre == browser_name).first()
    if navegador:
        return navegador

    navegador = Navegador(id=uuid.uuid4(), nombre=browser_name)
    db.add(navegador)
    db.flush()
    return navegador


def _create_access_log(
    db: Session,
    *,
    user: Usuario | None,
    action_name: str,
    request: Request,
    token: str | None,
    active: bool,
) -> Acceso:
    # BLOQUE AUDITORIA: registra evento de acceso con navegador e IP.
    browser_name = _detect_browser_name(
        request.headers.get("user-agent"),
        request.headers.get("sec-ch-ua"),
    )
    navegador = _get_or_create_navegador(db, browser_name)
    estado = _get_or_create_estado(db, action_name)

    access = Acceso(
        id=uuid.uuid4(),
        fecha=datetime.datetime.now(),
        ip=_extract_client_ip(request),
        token=token,
        activo=active,
        usuario_id=user.id if user else None,
        estado_id=estado.id,
        navegador_id=navegador.id,
    )
    db.add(access)
    return access


@asynccontextmanager
async def lifespan(app: FastAPI):
    # BLOQUE LIFESPAN: reemplaza startup event deprecado.
    migrate_plain_passwords_to_hash()
    ensure_browser_catalog()
    yield


app = FastAPI(lifespan=lifespan)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)

class LoginRequest(BaseModel):
    # BLOQUE LOGIN: mantenemos username como en tu estructura.
    username: Optional[str] = Field(default=None, min_length=5)
    # BLOQUE COMPAT: también acepta "correo" para no romper clientes actuales.
    correo: Optional[str] = Field(default=None, min_length=5)
    password: str = Field(..., min_length=8)


class LogoutRequest(BaseModel):
    token: str = Field(..., min_length=8)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


@app.post("/login")
async def login(login_request: LoginRequest, request: Request, db: Session = Depends(get_db)):
    # BLOQUE LOGIN BD: validación real contra tabla usuario de PostgreSQL.
    username = (login_request.username or login_request.correo or "").strip().lower()
    if not username:
        raise HTTPException(status_code=400, detail="Username/correo requerido")

    user = (
        db.query(Usuario)
        .options(joinedload(Usuario.rol))
        .filter(Usuario.email == username)
        .first()
    )

    if not user:
        # BLOQUE SEGURIDAD: tiempo similar entre usuario existente/no existente.
        verify_password(login_request.password, DUMMY_HASH)
        _create_access_log(
            db,
            user=None,
            action_name="LOGIN_FAIL",
            request=request,
            token=None,
            active=False,
        )
        db.commit()
        raise HTTPException(status_code=400, detail="Credenciales incorrectas")

    password_ok = False

    # BLOQUE SEGURIDAD: valida hash Argon2.
    if is_password_hashed(user.contra_hash):
        password_ok = verify_password(login_request.password, user.contra_hash)
    else:
        # BLOQUE COMPAT: si quedó texto plano, permite login y migra a hash.
        password_ok = user.contra_hash == login_request.password
        if password_ok:
            user.contra_hash = get_password_hash(login_request.password)
            db.commit()

    if not password_ok:
        _create_access_log(
            db,
            user=user,
            action_name="LOGIN_FAIL",
            request=request,
            token=None,
            active=False,
        )
        db.commit()
        raise HTTPException(status_code=400, detail="Credenciales incorrectas")

    # BLOQUE TOKEN BD: creamos y guardamos token de sesión en tabla acceso.
    session_token = str(uuid.uuid4())
    _create_access_log(
        db,
        user=user,
        action_name="LOGIN_SUCCESS",
        request=request,
        token=session_token,
        active=True,
    )
    db.commit()

    # BLOQUE LOGIN BD: el rol vuelve desde la relación Usuario -> Rol.
    role_name = user.rol.nombre if user.rol else "user"

    return {
        "msg": "Acceso concedido",
        "rol": role_name,
        "email": user.email,
        "name": user.name,
        # BLOQUE LOGIN: token simple para frontend (y futuras operaciones CRUD).
        "token": session_token,
        "access_token": session_token,
        "token_type": "bearer",
    }


def _invalidate_token(token: str, request: Request, db: Session) -> bool:
    # BLOQUE LOGOUT: invalida token activo y deja traza de LOGOUT.
    access_active = (
        db.query(Acceso)
        .join(Estado, Acceso.estado_id == Estado.id)
        .options(joinedload(Acceso.usuario))
        .filter(
            Acceso.token == token,
            Acceso.activo.is_(True),
            Estado.nombre == "LOGIN_SUCCESS",
        )
        .order_by(Acceso.fecha.desc())
        .first()
    )
    if not access_active:
        return False

    access_active.activo = False

    _create_access_log(
        db,
        user=access_active.usuario,
        action_name="LOGOUT",
        request=request,
        token=token,
        active=False,
    )
    db.commit()
    return True


@app.post("/logout")
async def logout(
    request: Request,
    logout_request: Optional[LogoutRequest] = None,
    authorization: Optional[str] = Header(default=None),
    db: Session = Depends(get_db),
):
    # BLOQUE LOGOUT: toma token por body o header Authorization Bearer.
    token = None
    if logout_request and logout_request.token:
        token = logout_request.token
    elif authorization and authorization.lower().startswith("bearer "):
        token = authorization[7:].strip()

    if not token:
        raise HTTPException(status_code=400, detail="Token requerido")

    ok = _invalidate_token(token, request, db)
    if not ok:
        return {"msg": "Token no existe"}

    return {"msg": "Sesión cerrada"}


@app.get("/logout")
async def logout_get(token: str, request: Request, db: Session = Depends(get_db)):
    # BLOQUE LOGOUT: compatibilidad con logout por query param.
    ok = _invalidate_token(token, request, db)
    if not ok:
        return {"msg": "Token no existe"}
    return {"msg": "Sesión cerrada"}


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> Usuario:
    # BLOQUE SEGURIDAD: valida token de sesión guardado en BD.
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="No autorizado",
        headers={"WWW-Authenticate": "Bearer"},
    )

    acceso = (
        db.query(Acceso)
        .join(Estado, Acceso.estado_id == Estado.id)
        .options(joinedload(Acceso.usuario).joinedload(Usuario.rol))
        .filter(
            Acceso.token == token,
            Acceso.activo.is_(True),
            Estado.nombre == "LOGIN_SUCCESS",
        )
        .order_by(Acceso.fecha.desc())
        .first()
    )
    if not acceso or not acceso.usuario:
        raise credentials_exception
    return acceso.usuario


@app.get("/me")
async def read_me(current_user: Usuario = Depends(get_current_user)):
    # BLOQUE SEGURIDAD: endpoint de prueba para frontend con Bearer token.
    role_name = current_user.rol.nombre if current_user.rol else "user"
    return {
        "email": current_user.email,
        "name": current_user.name,
        "rol": role_name,
    }


app.include_router(admin.router)
