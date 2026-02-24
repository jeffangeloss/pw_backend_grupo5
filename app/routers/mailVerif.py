from fastapi import APIRouter, Request, BackgroundTasks, Depends, HTTPException
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
from sqlalchemy.orm import Session
import uuid
import datetime
import os

from ..database import get_db
from ..models import User
from ..security import get_password_hash

router = APIRouter(
    prefix="/mailverif",
    tags=["MailVerification"]
)

def _build_mail_config():
    sender_email = os.getenv("SENDER_EMAIL")
    sender_password = os.getenv("SENDER_PASSWORD")
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

@router.post("/send")
async def send_verification_email(
    email: str,
    bg_tasks: BackgroundTasks,
    db: Session = Depends(get_db)
):
    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")

    # Generar token único
    token = str(uuid.uuid4())
    expires_at = datetime.datetime.now() + datetime.timedelta(hours=24)

    # Guardar token en la DB
    user.token_verification = token
    user.token_verification_expires = expires_at
    db.commit()

    # Construir link de verificación
    link = f"http://localhost:5173/#/verificar-email?token={token}"

    # Contenido HTML del correo
    html_content = f"""
    <!DOCTYPE html>
    <html lang="es">
    <head>
    <meta charset="UTF-8">
    <title>Confirmación de correo</title>
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
                    Gracias por registrarte. Haz clic en el siguiente botón para activar tu cuenta:
                </p>
                
                <!-- Botón con link del token -->
                <a href="{link}" 
                    style="
                    display:inline-block;
                    margin:0 0 24px 0;
                    padding:16px 24px;
                    background:#4f46e5;
                    color:white;
                    text-decoration:none;
                    border-radius:8px;
                    font-weight:bold;
                    font-size:16px;
                    ">
                    Verificar correo
                </a>

                <p style="margin:0 0 4px 0;font-size:14px;color:#18181b;">
                    Este enlace expira en 24 horas.
                </p>

                <p style="margin:0;font-size:12px;color:#a1a1aa;line-height:1.4;">
                    Si no solicitaste este registro, puedes ignorar este correo.
                    La cuenta no se activará sin confirmar el correo.
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
        recipients=[email],
        body=html_content,
        subtype="html"
    )

    # Configuración y envío en background
    conf = _build_mail_config()
    if conf:
        fm = FastMail(conf)
        bg_tasks.add_task(fm.send_message, message)

    return {"msg": "Correo de verificación enviado"}

@router.post("/confirm")
async def confirm_email(token: str, db: Session = Depends(get_db)):
    """
    Confirma el correo de un usuario usando el token de verificación.
    """
    user = db.query(User).filter(User.token_verification == token).first()
    if not user:
        raise HTTPException(status_code=400, detail="Token inválido")

    if not user.token_verification_expires or user.token_verification_expires < datetime.datetime.now():
        raise HTTPException(status_code=400, detail="Token expirado")

    # Activar cuenta y marcar email como verificado
    user.email_verified = True
    user.is_active = True
    user.token_verification = None
    user.token_verification_expires = None

    db.commit()

    return {"msg": "Correo verificado y cuenta activada"}