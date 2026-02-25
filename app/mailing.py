import logging
import os

from fastapi_mail import ConnectionConfig

logger = logging.getLogger(__name__)


def _parse_bool(value: str | None, default: bool) -> bool:
    if value is None:
        return default

    normalized = value.strip().lower()
    if normalized in {"1", "true", "t", "yes", "y", "on"}:
        return True
    if normalized in {"0", "false", "f", "no", "n", "off"}:
        return False
    return default


def _parse_int_env(name: str, default: int, *, min_value: int, max_value: int) -> int:
    raw_value = (os.getenv(name) or "").strip()
    if not raw_value:
        return default

    try:
        parsed = int(raw_value)
    except ValueError:
        logger.warning("Valor invalido para %s=%r. Se usa %s.", name, raw_value, default)
        return default

    if parsed < min_value or parsed > max_value:
        logger.warning(
            "%s fuera de rango (%s). Se usa %s.", name, parsed, default
        )
        return default

    return parsed


def build_mail_config() -> ConnectionConfig | None:
    sender_email = (os.getenv("SENDER_EMAIL") or "").strip()
    sender_password = (os.getenv("SENDER_PASSWORD") or "").strip()
    if not sender_email or not sender_password:
        return None

    mail_server = (os.getenv("MAIL_SERVER") or "smtp.gmail.com").strip()
    mail_port = _parse_int_env("MAIL_PORT", 587, min_value=1, max_value=65535)
    mail_timeout = _parse_int_env("MAIL_TIMEOUT", 12, min_value=1, max_value=300)
    mail_starttls = _parse_bool(os.getenv("MAIL_STARTTLS"), True)
    mail_ssl_tls = _parse_bool(os.getenv("MAIL_SSL_TLS"), False)
    validate_certs = _parse_bool(os.getenv("MAIL_VALIDATE_CERTS"), True)
    mail_from_name = (os.getenv("MAIL_FROM_NAME") or "").strip() or None

    if mail_starttls and mail_ssl_tls:
        logger.warning(
            "MAIL_STARTTLS y MAIL_SSL_TLS no pueden estar activos a la vez. "
            "Se usara MAIL_SSL_TLS y se desactiva MAIL_STARTTLS."
        )
        mail_starttls = False

    return ConnectionConfig(
        MAIL_USERNAME=sender_email,
        MAIL_PASSWORD=sender_password,
        MAIL_FROM=sender_email,
        MAIL_FROM_NAME=mail_from_name,
        MAIL_PORT=mail_port,
        MAIL_SERVER=mail_server,
        MAIL_STARTTLS=mail_starttls,
        MAIL_SSL_TLS=mail_ssl_tls,
        USE_CREDENTIALS=True,
        VALIDATE_CERTS=validate_certs,
        TIMEOUT=mail_timeout,
    )
