import logging
import os

import httpx
from fastapi_mail import ConnectionConfig, FastMail, MessageSchema

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


def _resolve_mail_from() -> str:
    mail_from = (os.getenv("MAIL_FROM") or "").strip()
    if mail_from:
        return mail_from
    sender_email = (os.getenv("SENDER_EMAIL") or "").strip()
    if sender_email:
        return sender_email
    return "onboarding@resend.dev"


def _build_mail_from_header(mail_from: str) -> str:
    mail_from_name = (os.getenv("MAIL_FROM_NAME") or "").strip()
    if mail_from_name:
        return f"{mail_from_name} <{mail_from}>"
    return mail_from


def _using_resend() -> bool:
    provider = (os.getenv("MAIL_PROVIDER") or "").strip().lower()
    if provider == "resend":
        return True
    return bool((os.getenv("RESEND_API_KEY") or "").strip())


async def _send_email_with_resend(*, subject: str, recipients: list[str], html_body: str):
    resend_api_key = (os.getenv("RESEND_API_KEY") or "").strip()
    if not resend_api_key:
        raise ValueError("Falta RESEND_API_KEY para envio por API")

    mail_from = _resolve_mail_from()
    payload = {
        "from": _build_mail_from_header(mail_from),
        "to": recipients,
        "subject": subject,
        "html": html_body,
    }

    timeout_seconds = _parse_int_env("MAIL_TIMEOUT", 12, min_value=1, max_value=300)
    request_timeout = httpx.Timeout(timeout_seconds)
    async with httpx.AsyncClient(timeout=request_timeout) as client:
        response = await client.post(
            "https://api.resend.com/emails",
            headers={
                "Authorization": f"Bearer {resend_api_key}",
                "Content-Type": "application/json",
            },
            json=payload,
        )

    if response.status_code >= 400:
        detail = (response.text or "").strip()
        if len(detail) > 300:
            detail = detail[:300] + "..."
        raise RuntimeError(
            f"Resend respondio {response.status_code}" + (f": {detail}" if detail else "")
        )


async def _send_email_with_smtp(*, subject: str, recipients: list[str], html_body: str):
    conf = build_mail_config()
    if not conf:
        raise ValueError(
            "Configuracion de correo incompleta: define SENDER_EMAIL y SENDER_PASSWORD"
        )

    message = MessageSchema(
        subject=subject,
        recipients=recipients,
        body=html_body,
        subtype="html",
    )
    fm = FastMail(conf)
    await fm.send_message(message)


async def send_html_email(*, subject: str, recipients: list[str], html_body: str):
    if _using_resend():
        await _send_email_with_resend(
            subject=subject,
            recipients=recipients,
            html_body=html_body,
        )
        return

    await _send_email_with_smtp(
        subject=subject,
        recipients=recipients,
        html_body=html_body,
    )
