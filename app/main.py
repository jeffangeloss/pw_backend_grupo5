from contextlib import asynccontextmanager
from datetime import datetime, timedelta
from pathlib import Path
from typing import Optional
from uuid import UUID, uuid4

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
from .models import AccessEventType, AccessLog, AuthChallenge, TokenDevice, User, UserRole
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
from .totp_utils import verify_totp_code

MAX_AVATAR_BYTES = 5 * 1024 * 1024
CLOUDINARY_FOLDER = (os.getenv("CLOUDINARY_FOLDER") or "pw-backend-grupo5/avatars").strip()
DEVICE_SERIAL = ((os.getenv("DEVICE_SERIAL") or "ESP32-DEMO-001").strip() or "ESP32-DEMO-001")
TOTP_SECRET_GLOBAL = (os.getenv("TOTP_SECRET_GLOBAL") or "").strip()
TOTP_DIGITS = int(os.getenv("TOTP_DIGITS", "6"))
TOTP_PERIOD_SECONDS = int(os.getenv("TOTP_PERIOD_SECONDS", "60"))
TOTP_VALID_WINDOW = int(os.getenv("TOTP_VALID_WINDOW", "1"))
TWO_FACTOR_TMP_TOKEN_EXPIRE_MINUTES = int(os.getenv("TWO_FACTOR_TMP_TOKEN_EXPIRE_MINUTES", "5"))
TWO_FACTOR_MAX_ATTEMPTS = int(os.getenv("TWO_FACTOR_MAX_ATTEMPTS", "5"))
TWO_FACTOR_REQUIRED = (os.getenv("TWO_FACTOR_REQUIRED", "true").strip().lower() not in {"0", "false", "no", "off"})
DEVICE_NOTIFY_PATTERN = (os.getenv("DEVICE_NOTIFY_PATTERN") or "TRIPLE").strip().upper() or "TRIPLE"
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


def _utcnow() -> datetime:
    return datetime.utcnow()


def _is_two_factor_enabled() -> bool:
    return TWO_FACTOR_REQUIRED


def _resolve_totp_secret(db: Session | None = None) -> str:
    if TOTP_SECRET_GLOBAL:
        return TOTP_SECRET_GLOBAL

    if db is None or not DEVICE_SERIAL:
        return ""

    try:
        device = db.query(TokenDevice).filter(TokenDevice.serial == DEVICE_SERIAL).first()
    except SQLAlchemyError:
        db.rollback()
        return ""

    if not device:
        return ""

    if (device.status or "").upper() != "ACTIVE":
        return ""

    return (device.secret_enc or "").strip()


def _serialize_login_success(user: User, access_token: str):
    role_name = user.role.value if user.role else "user"
    return {
        "msg": "Acceso concedido",
        "rol": role_name,
        "id": str(user.id),
        "email": user.email,
        "name": user.full_name,
        "avatar_url": _sanitize_avatar_url(user.avatar_url),
        "token": access_token,
        "access_token": access_token,
        "token_type": "bearer",
    }


def _ensure_demo_device(db: Session):
    if not DEVICE_SERIAL:
        return

    try:
        device = db.query(TokenDevice).filter(TokenDevice.serial == DEVICE_SERIAL).first()
        if not device:
            if not TOTP_SECRET_GLOBAL:
                return
            device = TokenDevice(
                serial=DEVICE_SERIAL,
                secret_enc=TOTP_SECRET_GLOBAL,
                digits=TOTP_DIGITS,
                period=TOTP_PERIOD_SECONDS,
                status="ACTIVE",
            )
            db.add(device)
            db.commit()
            return

        updated = False
        if TOTP_SECRET_GLOBAL and device.secret_enc != TOTP_SECRET_GLOBAL:
            device.secret_enc = TOTP_SECRET_GLOBAL
            updated = True
        if device.digits != TOTP_DIGITS:
            device.digits = TOTP_DIGITS
            updated = True
        if device.period != TOTP_PERIOD_SECONDS:
            device.period = TOTP_PERIOD_SECONDS
            updated = True
        if updated:
            db.commit()
    except SQLAlchemyError:
        db.rollback()


def _get_active_device_or_404(serial: str, db: Session) -> TokenDevice:
    requested_serial = (serial or "").strip()
    if not requested_serial:
        raise HTTPException(status_code=400, detail="Serial requerido")

    try:
        device = db.query(TokenDevice).filter(TokenDevice.serial == requested_serial).first()
        if not device and requested_serial == DEVICE_SERIAL and TOTP_SECRET_GLOBAL:
            device = TokenDevice(
                serial=DEVICE_SERIAL,
                secret_enc=TOTP_SECRET_GLOBAL,
                digits=TOTP_DIGITS,
                period=TOTP_PERIOD_SECONDS,
                status="ACTIVE",
            )
            db.add(device)
            db.commit()
            db.refresh(device)
    except SQLAlchemyError as exc:
        db.rollback()
        raise HTTPException(status_code=503, detail="Esquema 2FA pendiente de migracion") from exc

    if not device:
        raise HTTPException(status_code=404, detail="Dispositivo no registrado")
    if (device.status or "").upper() != "ACTIVE":
        raise HTTPException(status_code=403, detail="Dispositivo inactivo")
    return device


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
    detail: str | None = None,
):
    log = AccessLog(
        user_id=user.id if user else None,
        event_type=event_type,
        attempt_email=attempt_email,
        ip_address=_extract_client_ip(request),
        web_agent=_extract_web_agent(request),
        detail=detail,
    )
    db.add(log)


def _get_user_from_token(token: str, db: Session) -> User | None:
    try:
        payload = decode_access_token(token)
    except Exception:
        return None

    token_stage = str(payload.get("stage") or "").upper()
    if _is_two_factor_enabled():
        if token_stage != "FULL":
            return None
    elif token_stage and token_stage != "FULL":
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
        "avatar_url": _sanitize_avatar_url(user.avatar_url),
        "updated_at": user.updated_at.isoformat() if user.updated_at else None,
    }


def _sanitize_avatar_url(avatar_url: str | None):
    clean_avatar = (avatar_url or "").strip()
    if not clean_avatar:
        return None
    if clean_avatar.startswith("/"):
        return None
    return clean_avatar


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
    db = session()
    try:
        _ensure_demo_device(db)
    finally:
        db.close()
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


class TwoFactorVerifyRequest(BaseModel):
    tmp_token: str = Field(..., min_length=16)
    code: str = Field(..., min_length=6, max_length=10)


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


@app.post("/auth/login")
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

    if not _is_two_factor_enabled():
        access_token = create_access_token({"sub": user.email})
        _create_access_log(
            db,
            user=user,
            event_type=AccessEventType.LOGIN_SUCCESS,
            attempt_email=user.email,
            request=request,
            detail="2FA_DISABLED",
        )
        db.commit()
        return _serialize_login_success(user, access_token)

    totp_secret = _resolve_totp_secret(db)
    if not totp_secret:
        raise HTTPException(status_code=503, detail="2FA obligatorio no configurado")

    (
        db.query(AuthChallenge)
        .filter(AuthChallenge.user_id == user.id, AuthChallenge.status == "PENDING")
        .update({"status": "EXPIRED"}, synchronize_session=False)
    )

    expires_at = _utcnow() + timedelta(minutes=TWO_FACTOR_TMP_TOKEN_EXPIRE_MINUTES)
    challenge = AuthChallenge(
        user_id=user.id,
        status="PENDING",
        attempts=0,
        expires_at=expires_at,
        request_ip=_extract_client_ip(request),
        user_agent=_extract_web_agent(request),
    )
    db.add(challenge)
    db.flush()

    role_name = user.role.value if user.role else "user"
    tmp_token = create_access_token(
        {
            "sub": str(user.id),
            "email": user.email,
            "role": role_name,
            "stage": "PWD_OK",
            "challenge_id": str(challenge.id),
        },
        expires_minutes=TWO_FACTOR_TMP_TOKEN_EXPIRE_MINUTES,
    )
    _create_access_log(
        db,
        user=user,
        event_type=AccessEventType.LOGIN_PWD_OK,
        attempt_email=user.email,
        request=request,
        detail=f"challenge_id={challenge.id}",
    )
    db.commit()

    return {
        "msg": "Segundo factor requerido",
        "requires_2fa": True,
        "tmp_token": tmp_token,
        "challenge_id": str(challenge.id),
        "expires_in": TWO_FACTOR_TMP_TOKEN_EXPIRE_MINUTES * 60,
        "rol": role_name,
        "id": str(user.id),
        "email": user.email,
        "name": user.full_name,
        "avatar_url": _sanitize_avatar_url(user.avatar_url),
    }


def _decode_2fa_token_or_401(raw_token: str) -> dict:
    try:
        payload = decode_access_token(raw_token)
    except Exception as exc:
        raise HTTPException(status_code=401, detail="Token temporal invalido o expirado") from exc

    if not payload.get("sub"):
        raise HTTPException(status_code=401, detail="Token temporal invalido o expirado")

    return payload


@app.post("/auth/2fa/verify")
async def verify_two_factor(payload: TwoFactorVerifyRequest, request: Request, db: Session = Depends(get_db)):
    if not _is_two_factor_enabled():
        raise HTTPException(status_code=400, detail="2FA no esta habilitado")

    totp_secret = _resolve_totp_secret(db)
    if not totp_secret:
        raise HTTPException(status_code=503, detail="2FA obligatorio no configurado")

    now = _utcnow()
    token_payload = _decode_2fa_token_or_401(payload.tmp_token)
    token_stage = str(token_payload.get("stage") or "").upper()

    user: User | None = None
    challenge: AuthChallenge | None = None

    if token_stage == "PWD_OK":
        challenge_id_raw = (token_payload.get("challenge_id") or "").strip()
        user_id_raw = (token_payload.get("sub") or "").strip()
        if not challenge_id_raw or not user_id_raw:
            raise HTTPException(status_code=401, detail="Token temporal invalido o expirado")

        try:
            challenge_id = UUID(challenge_id_raw)
            user_id = UUID(user_id_raw)
        except Exception as exc:
            raise HTTPException(status_code=401, detail="Token temporal invalido o expirado") from exc

        challenge = (
            db.query(AuthChallenge)
            .filter(AuthChallenge.id == challenge_id, AuthChallenge.user_id == user_id)
            .first()
        )
        if not challenge:
            raise HTTPException(status_code=401, detail="Token temporal invalido o expirado")

        user = db.query(User).filter(User.id == user_id).first()
    elif token_stage in {"FULL", ""}:
        user_email = str(token_payload.get("email") or token_payload.get("sub") or "").strip().lower()
        if not user_email:
            raise HTTPException(status_code=401, detail="Token temporal invalido o expirado")

        user = db.query(User).filter(User.email == user_email).first()
        if user:
            challenge = (
                db.query(AuthChallenge)
                .filter(
                    AuthChallenge.user_id == user.id,
                    AuthChallenge.status == "PENDING",
                    AuthChallenge.expires_at >= now,
                )
                .order_by(AuthChallenge.created_at.desc())
                .first()
            )
            if not challenge:
                challenge = AuthChallenge(
                    user_id=user.id,
                    status="PENDING",
                    attempts=0,
                    expires_at=now + timedelta(minutes=TWO_FACTOR_TMP_TOKEN_EXPIRE_MINUTES),
                    request_ip=_extract_client_ip(request),
                    user_agent=_extract_web_agent(request),
                )
                db.add(challenge)
                db.flush()
    else:
        raise HTTPException(status_code=401, detail="Token temporal invalido o expirado")

    if not user or not user.is_active or not user.email_verified or not challenge:
        raise HTTPException(status_code=401, detail="Usuario no autorizado")

    if challenge.status != "PENDING":
        raise HTTPException(status_code=401, detail="Desafio 2FA ya utilizado o invalido")

    if challenge.expires_at < now:
        challenge.status = "EXPIRED"
        _create_access_log(
            db,
            user=user,
            event_type=AccessEventType.TWO_FACTOR_FAIL,
            attempt_email=user.email,
            request=request,
            detail=f"challenge_id={challenge.id};reason=EXPIRED",
        )
        db.commit()
        raise HTTPException(status_code=401, detail="Codigo incorrecto o expirado")

    if challenge.attempts >= TWO_FACTOR_MAX_ATTEMPTS:
        challenge.status = "FAILED"
        db.commit()
        raise HTTPException(status_code=429, detail="Demasiados intentos de 2FA")

    provided_code = "".join(ch for ch in payload.code if ch.isdigit())
    try:
        valid_code = verify_totp_code(
            totp_secret,
            provided_code,
            period=TOTP_PERIOD_SECONDS,
            digits=TOTP_DIGITS,
            valid_window=TOTP_VALID_WINDOW,
        )
    except ValueError as exc:
        raise HTTPException(status_code=503, detail="2FA no configurado correctamente") from exc

    if not valid_code:
        challenge.attempts += 1
        if challenge.attempts >= TWO_FACTOR_MAX_ATTEMPTS:
            challenge.status = "FAILED"
        _create_access_log(
            db,
            user=user,
            event_type=AccessEventType.TWO_FACTOR_FAIL,
            attempt_email=user.email,
            request=request,
            detail=f"challenge_id={challenge.id};attempts={challenge.attempts}",
        )
        db.commit()
        raise HTTPException(status_code=401, detail="Codigo incorrecto o expirado")

    challenge.status = "VERIFIED"
    challenge.verified_at = now
    challenge.device_notified = False
    challenge.device_notified_at = None

    role_name = user.role.value if user.role else "user"
    access_token = create_access_token({"sub": user.email, "role": role_name, "stage": "FULL"})
    _create_access_log(
        db,
        user=user,
        event_type=AccessEventType.TWO_FACTOR_SUCCESS,
        attempt_email=user.email,
        request=request,
        detail=f"challenge_id={challenge.id}",
    )
    _create_access_log(
        db,
        user=user,
        event_type=AccessEventType.LOGIN_SUCCESS,
        attempt_email=user.email,
        request=request,
        detail=f"challenge_id={challenge.id};2FA_OK",
    )
    db.commit()

    response = _serialize_login_success(user, access_token)
    response["requires_2fa"] = False
    response["two_factor_verified"] = True
    return response


@app.get("/device/notify")
async def device_notify(serial: str, db: Session = Depends(get_db)):
    _get_active_device_or_404(serial, db)
    pending = (
        db.query(AuthChallenge)
        .filter(AuthChallenge.status == "VERIFIED", AuthChallenge.device_notified.is_(False))
        .order_by(AuthChallenge.verified_at.asc(), AuthChallenge.created_at.asc())
        .first()
    )
    if not pending:
        return {"beep": False, "pattern": None}

    return {"beep": True, "pattern": DEVICE_NOTIFY_PATTERN}


@app.post("/device/notify/ack")
async def device_notify_ack(serial: str, db: Session = Depends(get_db)):
    _get_active_device_or_404(serial, db)
    pending = (
        db.query(AuthChallenge)
        .filter(AuthChallenge.status == "VERIFIED", AuthChallenge.device_notified.is_(False))
        .order_by(AuthChallenge.verified_at.asc(), AuthChallenge.created_at.asc())
        .first()
    )
    if not pending:
        return {"acknowledged": False}

    pending.device_notified = True
    pending.device_notified_at = _utcnow()
    db.commit()
    return {"acknowledged": True, "pattern": DEVICE_NOTIFY_PATTERN}


@app.post("/device/ping")
async def device_ping(serial: str, db: Session = Depends(get_db)):
    device = _get_active_device_or_404(serial, db)
    device.last_seen_at = _utcnow()
    db.commit()
    return {"ok": True, "serial": device.serial, "last_seen_at": device.last_seen_at.isoformat()}


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
    if not user or not user.is_active or not user.email_verified:
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
        if clean_avatar.startswith("/"):
            raise HTTPException(status_code=400, detail="La URL de avatar local ya no es valida")
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
