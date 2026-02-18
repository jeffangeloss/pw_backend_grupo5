import os
from datetime import datetime, timedelta, timezone
from typing import Any

import jwt
from pwdlib import PasswordHash

# BLOQUE SEGURIDAD: clave y vencimiento para token JWT.
# En producción define JWT_SECRET_KEY en variables de entorno.
SECRET_KEY = os.getenv("JWT_SECRET_KEY", "dev-only-change-this-secret-key-min-32-bytes")
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))

# BLOQUE SEGURIDAD: hash recomendado (Argon2).
password_hash = PasswordHash.recommended()

# BLOQUE SEGURIDAD: hash dummy para mitigar timing attacks.
DUMMY_HASH = password_hash.hash("dummy-password")


def get_password_hash(password: str) -> str:
    return password_hash.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    try:
        return password_hash.verify(plain_password, hashed_password)
    except Exception:
        return False


def is_password_hashed(password_value: str | None) -> bool:
    return bool(password_value) and password_value.startswith("$argon2")


def create_access_token(data: dict[str, Any], expires_minutes: int = ACCESS_TOKEN_EXPIRE_MINUTES) -> str:
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=expires_minutes)
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def decode_access_token(token: str) -> dict[str, Any]:
    return jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
