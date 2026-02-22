from fastapi import Depends, APIRouter, BackgroundTasks, HTTPException
from sqlalchemy.orm import Session
from fastapi_mail import FastMail, MessageSchema, ConnectionConfig
import datetime
import uuid
import os

from ..security import get_password_hash
from ..schemas import ResetForm
from ..database import get_db
from ..models import User


router = APIRouter(
    prefix="/reset-pass",
    tags = ["PassReset"]
)

#configuracion para envio de email
conf = ConnectionConfig(
    MAIL_USERNAME = os.getenv("SENDER_EMAIL"),
    MAIL_PASSWORD = os.getenv("SENDER_PASSWORD"),
    MAIL_FROM = os.getenv("SENDER_EMAIL"),
    MAIL_PORT = 587,
    MAIL_SERVER = "smtp.gmail.com",
    MAIL_STARTTLS=True,
    MAIL_SSL_TLS=False,
    USE_CREDENTIALS=True
)

@router.put("/request")
async def reset_pass_request( email : str, bg_tasks : BackgroundTasks,  db : Session = Depends(get_db) ):
    db_query = db.query(User).filter(User.email == email)
    db_usuario = db_query.first()
    token = str(uuid.uuid4())
    if db_usuario:
        
        expires_at = datetime.datetime.now() + datetime.timedelta(minutes=15)
        #db_access_log = crear access log
        #db.add(db_access_log) y guardarlo en bd
        db_query.update({
            "token_pass" : token,
            "token_pass_expires" : expires_at
        })
        db.commit()

        link = f"http://localhost:5173/#/restablecer/form?token={token}"
        html_content = f"""
        <h3>Restablecimiento de contraseña</h3>
        <p>Haz clic en el siguiente botón para restablecer tu contraseña:</p>
        <a href="{link}"
        style="padding:10px 20px;background:#4f46e5;color:white;text-decoration:none;border-radius:5px;">
        Restablecer contraseña
        </a>
        <p>Este enlace expira en 15 minutos.</p>
        """
        message = MessageSchema(
            subject="Restablecer contraseña",
            recipients=[email],
            body = html_content,
            subtype="html"
        )

        fm = FastMail(conf)

        bg_tasks.add_task(fm.send_message, message)

    return {
        "msg" : "Se completo el request",
        "DELETE" : token
    }

@router.post("/confirm")
async def reset_pass_confirm( form: ResetForm, db : Session = Depends(get_db) ):
    db_user = db.query(User).filter(User.token_pass == form.token).first()
    if not db_user:
        raise HTTPException(
            status_code=400,
            detail={
                "msg" : "INVALID TOKEN"
            }
        )
    if not db_user.token_pass_expires or db_user.token_pass_expires<datetime.datetime.now():
        raise HTTPException(
            status_code=400,
            detail={
                "msg" : "EXPIRED TOKEN"
            }
        )
    
    db_user.password_hash = get_password_hash(form.password)
    db_user.token_pass = None
    db_user.token_pass_expires = None

    db.commit()

    return {
        "msg" : ""
    }

