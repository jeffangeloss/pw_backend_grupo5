import base64
import hashlib
import hmac
import struct
import time


def _normalize_base32_secret(secret: str) -> str:
    compact = "".join((secret or "").strip().split()).upper()
    if not compact:
        raise ValueError("TOTP secret vacio")

    padding = "=" * ((8 - len(compact) % 8) % 8)
    return compact + padding


def _decode_base32_secret(secret: str) -> bytes:
    normalized = _normalize_base32_secret(secret)
    try:
        return base64.b32decode(normalized, casefold=True)
    except Exception as exc:
        raise ValueError("TOTP secret invalido") from exc


def generate_totp_code(
    secret: str,
    *,
    timestamp: int | None = None,
    period: int = 60,
    digits: int = 6,
) -> str:
    if period <= 0:
        raise ValueError("El periodo TOTP debe ser mayor que cero")
    if digits <= 0:
        raise ValueError("La cantidad de digitos TOTP debe ser mayor que cero")

    key = _decode_base32_secret(secret)
    now_ts = int(time.time()) if timestamp is None else int(timestamp)
    counter = now_ts // period
    msg = struct.pack(">Q", counter)

    digest = hmac.new(key, msg, hashlib.sha1).digest()
    offset = digest[-1] & 0x0F
    binary = (
        ((digest[offset] & 0x7F) << 24)
        | ((digest[offset + 1] & 0xFF) << 16)
        | ((digest[offset + 2] & 0xFF) << 8)
        | (digest[offset + 3] & 0xFF)
    )
    otp = binary % (10**digits)
    return str(otp).zfill(digits)


def verify_totp_code(
    secret: str,
    code: str,
    *,
    period: int = 60,
    digits: int = 6,
    valid_window: int = 1,
) -> bool:
    normalized_code = "".join(ch for ch in str(code) if ch.isdigit())
    if len(normalized_code) != digits:
        return False
    if valid_window < 0:
        raise ValueError("valid_window no puede ser negativo")

    now_ts = int(time.time())
    for window in range(-valid_window, valid_window + 1):
        expected = generate_totp_code(
            secret,
            timestamp=now_ts + (window * period),
            period=period,
            digits=digits,
        )
        if hmac.compare_digest(expected, normalized_code):
            return True

    return False
