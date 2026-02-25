from contextlib import asynccontextmanager
from datetime import datetime
from pathlib import Path
from typing import Optional
from uuid import uuid4

import os

from fastapi import Depends, FastAPI, File, Header, HTTPException, Request, UploadFile, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from pydantic import AliasChoices, BaseModel, EmailStr, Field, field_validator
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session

try:
    import cloudinary
    from cloudinary import uploader as cloudinary_uploader
except Exception:
    cloudinary = None
    cloudinary_uploader = None

from .database import get_db, session
from .models import AccessEventType, AccessLog, User, UserRole
from .password_policy import ensure_password_policy
from .routers import admin, expenses, resetPass, categories, mailVerif, chatbot
from .security import (
    DUMMY_HASH,
    create_access_token,
    decode_access_token,
    get_password_hash,
    is_password_hashed,
    verify_password,
)

MAX_AVATAR_BYTES = 5 * 1024 * 1024
CLOUDINARY_FOLDER = (os.getenv("CLOUDINARY_FOLDER") or "pw-backend-grupo5/avatars").strip()
ALLOWED_AVATAR_EXTENSIONS = {
    ".png",
    ".jpg",
    ".jpeg",
    ".jpe",
    ".webp",
    ".svg",
    ".heic",
    ".gif",
    ".ico",
    ".xbm",
    ".xjl",
    ".xpm",
    ".dib",
    ".tif",
    ".tiff",
    ".pjpeg",
    ".pjp",
    ".apng",
    ".avif",
    ".jfif",
    ".bmp",
}


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


def _serialize_user(user: User):
    return {
        "id": str(user.id),
        "email": user.email,
        "name": user.full_name,
        "rol": user.role.value if user.role else "user",
        "avatar_url": user.avatar_url,
        "updated_at": user.updated_at.isoformat() if user.updated_at else None,
    }


def _validate_avatar_extension(filename: str):
    extension = Path(filename or "").suffix.lower()
    if extension not in ALLOWED_AVATAR_EXTENSIONS:
        raise HTTPException(status_code=400, detail="Formato de imagen no permitido")


def _configure_cloudinary():
    if cloudinary is None:
        raise HTTPException(status_code=503, detail="Cloudinary no esta disponible en el servidor")

    cloud_name = (os.getenv("CLOUDINARY_CLOUD_NAME") or "").strip()
    api_key = (os.getenv("CLOUDINARY_API_KEY") or "").strip()
    api_secret = (os.getenv("CLOUDINARY_API_SECRET") or "").strip()
    if not cloud_name or not api_key or not api_secret:
        raise HTTPException(status_code=503, detail="Cloudinary no esta configurado")
    
    cloudinary.config(
        cloud_name=cloud_name,
        api_key=api_key,
        api_secret=api_secret,
        secure=True,
    )


def _upload_avatar_to_cloudinary(file_bytes: bytes, *, user_id: str):
    _configure_cloudinary()

    try:
        result = cloudinary_uploader.upload(
            file_bytes,
            resource_type="image",
            folder=CLOUDINARY_FOLDER,
            public_id=f"user-{user_id}-{uuid4().hex}",
            overwrite=True,
            invalidate=True,
        )
    except Exception as exc:
        raise HTTPException(status_code=502, detail="No se pudo subir la imagen a Cloudinary") from exc

    avatar_url = (result.get("secure_url") or result.get("url") or "").strip()
    if not avatar_url:
        raise HTTPException(status_code=502, detail="Cloudinary no devolvio URL de imagen")
    return avatar_url


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
    # Campo canonico de login: email.
    # Compatibilidad: tambien acepta payloads legacy con "correo" o "username".
    email: EmailStr = Field(
        ...,
        max_length=100,
        validation_alias=AliasChoices("email", "correo", "username"),
    )
    password: str = Field(..., min_length=8, max_length=300)


class RegisterRequest(BaseModel):
    full_name: str = Field(..., min_length=1, max_length=300)
    email: EmailStr = Field(..., max_length=100)
    password: str = Field(..., min_length=8, max_length=300)

    @field_validator("password")
    @classmethod
    def validate_password_policy(cls, value: str):
        return ensure_password_policy(value)


class LogoutRequest(BaseModel):
    token: str = Field(..., min_length=8)


class UpdateProfileRequest(BaseModel):
    full_name: Optional[str] = Field(default=None, min_length=1, max_length=300)
    email: Optional[EmailStr] = Field(default=None, max_length=100)
    avatar_url: Optional[str] = Field(default=None, max_length=2000)


class ChangePasswordRequest(BaseModel):
    current_password: str = Field(..., min_length=1, max_length=300)
    new_password: str = Field(..., min_length=1, max_length=300)


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
        "user": _serialize_user(user),
    }


@app.post("/login")
async def login(login_request: LoginRequest, request: Request, db: Session = Depends(get_db)):
    # BLOQUE LOGIN BD: validacion real contra tabla user en PostgreSQL.
    login_email = login_request.email.strip().lower()

    user = db.query(User).filter(User.email == login_email).first()

    if not user:
        verify_password(login_request.password, DUMMY_HASH)
        _create_access_log(
            db,
            user=None,
            event_type=AccessEventType.LOGIN_FAIL,
            attempt_email=login_email,
            request=request,
        )
        db.commit()
        raise HTTPException(status_code=400, detail="Credenciales incorrectas")
    
    if not user.email_verified:
        raise HTTPException(
            status_code=403,
            detail="Se debe verificar el correo antes de iniciar sesion"
        )

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
            attempt_email=login_email,
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
        "id": str(user.id),
        "email": user.email,
        "name": user.full_name,
        "avatar_url": user.avatar_url,
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
    return _serialize_user(current_user)


@app.patch("/me/profile")
async def update_my_profile(
    payload: UpdateProfileRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if payload.full_name is None and payload.email is None and payload.avatar_url is None:
        raise HTTPException(status_code=400, detail="No hay cambios para actualizar")

    if payload.full_name is not None:
        clean_name = payload.full_name.strip()
        if not clean_name:
            raise HTTPException(status_code=400, detail="Nombre completo requerido")
        current_user.full_name = clean_name

    if payload.email is not None:
        clean_email = payload.email.strip().lower()
        existing = (
            db.query(User)
            .filter(User.email == clean_email, User.id != current_user.id)
            .first()
        )
        if existing:
            raise HTTPException(status_code=400, detail="Email ya registrado")
        current_user.email = clean_email

    if payload.avatar_url is not None:
        clean_avatar = payload.avatar_url.strip()
        current_user.avatar_url = clean_avatar or None

    current_user.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(current_user)

    return {
        "msg": "Perfil actualizado",
        "user": _serialize_user(current_user),
    }


@app.patch("/me/password")
async def change_my_password(
    payload: ChangePasswordRequest,
    request: Request,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    current_password = payload.current_password
    new_password = payload.new_password

    if current_password == new_password:
        raise HTTPException(
            status_code=400,
            detail="La nueva contrasena debe ser diferente a la actual",
        )

    try:
        ensure_password_policy(new_password)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc

    if is_password_hashed(current_user.password_hash):
        password_ok = verify_password(current_password, current_user.password_hash)
    else:
        password_ok = current_user.password_hash == current_password

    if not password_ok:
        raise HTTPException(status_code=400, detail="La contrasena actual es incorrecta")

    current_user.password_hash = get_password_hash(new_password)
    current_user.updated_at = datetime.utcnow()
    _create_access_log(
        db,
        user=current_user,
        event_type=AccessEventType.PASSWORD_RESET_SUCCESS,
        attempt_email=current_user.email,
        request=request,
    )
    db.commit()

    return {"msg": "Contrasena actualizada"}


@app.post("/me/avatar")
async def upload_my_avatar(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if not file.filename:
        raise HTTPException(status_code=400, detail="Archivo invalido")

    _validate_avatar_extension(file.filename)
    content_type = (file.content_type or "").lower()
    if not content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="El archivo debe ser una imagen")

    file_bytes = await file.read()
    if not file_bytes:
        raise HTTPException(status_code=400, detail="El archivo esta vacio")
    if len(file_bytes) > MAX_AVATAR_BYTES:
        raise HTTPException(status_code=413, detail="La imagen excede el limite de 5MB")

    cloudinary_avatar_url = _upload_avatar_to_cloudinary(
        file_bytes,
        user_id=str(current_user.id),
    )
    current_user.avatar_url = cloudinary_avatar_url
    current_user.updated_at = datetime.utcnow()
    db.commit()
    db.refresh(current_user)

    return {
        "msg": "Imagen de perfil actualizada",
        "avatar_url": current_user.avatar_url,
        "user": _serialize_user(current_user),
    }


app.include_router(admin.router)
app.include_router(expenses.router)
app.include_router(resetPass.router)
app.include_router(categories.router)
app.include_router(mailVerif.router)
app.include_router(chatbot.router)
