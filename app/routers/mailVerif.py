import datetime
import os
import uuid

from fastapi import APIRouter, Depends, HTTPException
from fastapi_mail import ConnectionConfig, FastMail, MessageSchema
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import User
from ..schemas import TokenRequest, VerifRequest

router = APIRouter(prefix="/mailverif", tags=["MailVerification"])

TOKEN_EXPIRATION_HOURS = int(os.getenv("EMAIL_VERIFICATION_TOKEN_HOURS", "24"))


def _build_mail_config():
    sender_email = (os.getenv("SENDER_EMAIL") or "").strip()
    sender_password = (os.getenv("SENDER_PASSWORD") or "").strip()
    if not sender_email or not sender_password:
        return None

    return ConnectionConfig(
        MAIL_USERNAME=sender_email,
        MAIL_PASSWORD=sender_password,
        MAIL_FROM=sender_email,
        MAIL_PORT=587,
        MAIL_SERVER="smtp.gmail.com",
        MAIL_STARTTLS=True,
        MAIL_SSL_TLS=False,
        USE_CREDENTIALS=True,
    )


def _build_frontend_verify_link(token: str):
    frontend_url = (os.getenv("FRONTEND_URL") or "http://localhost:5173").rstrip("/")
    return f"{frontend_url}/#/registro/verif?token={token}"


async def send_verification_email_for_user(*, email: str, db: Session):
    clean_email = (email or "").strip().lower()
    user = db.query(User).filter(User.email == clean_email).first()
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")

    if user.email_verified:
        raise HTTPException(status_code=400, detail="El correo ya fue verificado")

    token = str(uuid.uuid4())
    expires_at = datetime.datetime.now() + datetime.timedelta(hours=TOKEN_EXPIRATION_HOURS)

    user.token_verification = token
    user.token_verification_expires = expires_at
    db.commit()

    link = _build_frontend_verify_link(token)
    html_content = f"""
    <!DOCTYPE html>
    <html lang="es">
    <head>
    <meta charset="UTF-8">
    <title>Confirmacion de correo</title>
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
                    CONFIRMA TU CORREO
                </h2>

                <p style="margin:0 0 24px 0;font-size:15px;line-height:1.5;color:#18181b;">
                    Gracias por registrarte. Usa el siguiente codigo para confirmar tu cuenta:
                </p>

                <div style="
                    margin:0 0 24px 0;
                    padding:16px;
                    border:2px dashed #64748b;
                    font-size:28px;
                    font-weight:bold;
                    letter-spacing:4px;
                    color:#1e293b;
                ">
                    {token}
                </div>

                <p style="margin:0 0 8px 0;font-size:14px;color:#18181b;">
                    Tambien puedes abrir este enlace para completar la verificacion:
                </p>

                <p style="margin:0 0 16px 0;font-size:14px;word-break:break-all;">
                    <a href="{link}" style="color:#2563eb;text-decoration:none;">{link}</a>
                </p>

                <p style="margin:0 0 24px 0;font-size:14px;color:#18181b;">
                    El codigo expira en {TOKEN_EXPIRATION_HOURS} horas.
                </p>

                <p style="margin:0;font-size:12px;color:#a1a1aa;line-height:1.4;">
                    Si no solicitaste este registro, puedes ignorar este correo.
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
        subject="Verifica tu correo",
        recipients=[clean_email],
        body=html_content,
        subtype="html",
    )

    conf = _build_mail_config()
    if not conf:
        raise HTTPException(
            status_code=503,
            detail="Configuracion de correo incompleta: define SENDER_EMAIL y SENDER_PASSWORD",
        )

    try:
        fm = FastMail(conf)
        await fm.send_message(message)
    except Exception as exc:
        raise HTTPException(status_code=502, detail="No se pudo enviar el correo de verificacion") from exc


@router.post("/send")
async def send_verification_email(request: VerifRequest, db: Session = Depends(get_db)):
    await send_verification_email_for_user(email=request.email, db=db)
    return {"msg": "Correo de verificacion enviado"}


@router.post("/confirm")
async def confirm_email(body: TokenRequest, db: Session = Depends(get_db)):
    token = (body.token or "").strip()
    if not token:
        raise HTTPException(status_code=400, detail="Token invalido")

    user = db.query(User).filter(User.token_verification == token).first()
    if not user:
        raise HTTPException(status_code=400, detail="Token invalido")

    if not user.token_verification_expires or user.token_verification_expires < datetime.datetime.now():
        raise HTTPException(status_code=400, detail="Token expirado")

    user.email_verified = True
    user.is_active = True
    user.token_verification = None
    user.token_verification_expires = None
    db.commit()

    return {"msg": "Correo verificado y cuenta activada"}
