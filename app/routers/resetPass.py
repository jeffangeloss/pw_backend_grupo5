import datetime
import logging
import os
import uuid

from fastapi import APIRouter, BackgroundTasks, Depends, HTTPException, Request
from fastapi_mail import FastMail, MessageSchema
from sqlalchemy.orm import Session

from ..database import get_db
from ..mailing import build_mail_config
from ..models import AccessEventType, AccessLog, User
from ..schemas import ResetForm, ResetRequest
from ..security import get_password_hash

# Estos metodos se mantienen aqui para evitar imports circulares.

logger = logging.getLogger(__name__)


router = APIRouter(
    prefix="/reset-pass",
    tags=["PassReset"],
)


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


def _build_frontend_reset_link(token: str):
    frontend_url = (os.getenv("FRONTEND_URL") or "http://localhost:5173").rstrip("/")
    return f"{frontend_url}/#/restablecer/form?token={token}"


async def _send_reset_email(conf, message: MessageSchema, email: str):
    try:
        fm = FastMail(conf)
        await fm.send_message(message)
    except Exception:
        logger.exception("Fallo envio de correo de reset para %s", email)


@router.put("/request")
async def reset_pass_request(
    payload: ResetRequest,
    request: Request,
    bg_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
):
    email = payload.email.strip().lower()
    db_query = db.query(User).filter(User.email == email)
    db_user = db_query.first()
    token = str(uuid.uuid4())

    if db_user:
        expires_at = datetime.datetime.now() + datetime.timedelta(minutes=15)
        _create_access_log(
            db,
            user=db_user,
            event_type=AccessEventType.PASSWORD_RESET_REQUEST,
            attempt_email=email,
            request=request,
        )

        db_query.update(
            {
                "token_pass": token,
                "token_pass_expires": expires_at,
            }
        )
        db.commit()

        link = _build_frontend_reset_link(token)
        html_content = f"""
        <!DOCTYPE html>
        <html lang="es">
        <head>
        <meta charset="UTF-8">
        <title>Restablecer contrasena</title>
        </head>
        <body style="margin:0;padding:0;background-color:#f4f4f5;">
        <table width="100%" cellpadding="0" cellspacing="0" style="background-color:#f4f4f5;">
            <tr>
            <td align="center" style="padding:24px;">

                <table width="100%" cellpadding="0" cellspacing="0" style="max-width:600px;background-color:#ffffff;border-radius:8px;">
                <tr>
                    <td align="center" style="padding:32px;font-family:Arial, Helvetica, sans-serif;">

                    <h1 style="margin:0 0 32px 0;font-size:32px;letter-spacing:2px;color:#0b3aa4;">
                        GRUPO 5
                    </h1>

                    <h2 style="margin:0 0 16px 0;font-size:22px;color:#3f3f46;">
                        RESTABLECER CONTRASENA
                    </h2>

                    <p style="margin:0 0 24px 0;font-size:15px;line-height:1.5;color:#18181b;">
                        Recibimos una solicitud para restablecer tu contrasena.
                        Haz clic en el siguiente boton para crear una nueva.
                    </p>

                    <div style="margin:0 0 24px 0;">
                        <a href="{link}"
                        style="
                            display:inline-block;
                            padding:14px 28px;
                            background-color:#4f46e5;
                            color:#ffffff;
                            text-decoration:none;
                            border-radius:6px;
                            font-size:16px;
                            font-weight:bold;
                        ">
                            Restablecer contrasena
                        </a>
                    </div>

                    <p style="margin:0 0 8px 0;font-size:14px;color:#18181b;">
                        Este enlace expira en 15 minutos.
                    </p>

                    <p style="margin:0 0 24px 0;font-size:14px;color:#18181b;">
                        Si el boton no funciona, copia y pega el siguiente enlace en tu navegador:
                    </p>

                    <p style="word-break:break-all;font-size:12px;color:#1e293b;margin:0 0 24px 0;">
                        {link}
                    </p>

                    <p style="margin:0;font-size:12px;color:#a1a1aa;line-height:1.4;">
                        Si no solicitaste este cambio de contrasena, puedes ignorar este correo.
                        Tu cuenta permanecera segura.
                    </p>

                    </td>
                </tr>
                </table>

            </td>
            </tr>
        </table>
        </body>
        </html>
        """
        message = MessageSchema(
            subject="Restablecer contrasena",
            recipients=[email],
            body=html_content,
            subtype="html",
        )

        conf = build_mail_config()
        if conf:
            bg_tasks.add_task(_send_reset_email, conf, message, email)
        else:
            logger.warning(
                "Configuracion SMTP incompleta: SENDER_EMAIL/SENDER_PASSWORD no definidos"
            )

    return {
        "msg": "Se completo el request",
    }


@router.post("/confirm")
async def reset_pass_confirm(
    form: ResetForm,
    request: Request,
    db: Session = Depends(get_db),
):
    token = form.token.strip()
    db_user = db.query(User).filter(User.token_pass == token).first()
    if not db_user:
        raise HTTPException(
            status_code=400,
            detail={
                "msg": "INVALID TOKEN",
            },
        )
    if not db_user.token_pass_expires or db_user.token_pass_expires < datetime.datetime.now():
        raise HTTPException(
            status_code=400,
            detail={
                "msg": "EXPIRED TOKEN",
            },
        )

    db_user.password_hash = get_password_hash(form.password)
    db_user.token_pass = None
    db_user.token_pass_expires = None

    _create_access_log(
        db,
        user=db_user,
        event_type=AccessEventType.PASSWORD_RESET_SUCCESS,
        attempt_email=db_user.email,
        request=request,
    )

    db.commit()

    return {
        "msg": "",
    }
