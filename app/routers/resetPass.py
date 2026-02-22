from datetime import datetime, timedelta

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import AccessEventType, AccessLog, User
from ..schemas import ResetConfirmRequest, ResetRequest
from ..security import create_access_token, decode_access_token, get_password_hash

router = APIRouter(
    prefix="/reset-contra",
    tags=["Restablecer contra"],
)


def _create_access_log(
    db: Session,
    *,
    user: User | None,
    event_type: AccessEventType,
    attempt_email: str,
):
    db.add(
        AccessLog(
            user_id=user.id if user else None,
            event_type=event_type,
            attempt_email=attempt_email,
        )
    )


@router.put("/request")
async def request_reset_contra(request: ResetRequest, db: Session = Depends(get_db)):
    email = request.email.strip().lower()
    db_user = db.query(User).filter(User.email == email).first()

    if db_user:
        reset_token = create_access_token(
            {"sub": db_user.email, "type": "password_reset"},
            expires_minutes=5,
        )
        db_user.token_pass = reset_token
        db_user.token_pass_expires = datetime.utcnow() + timedelta(minutes=5)
        _create_access_log(
            db,
            user=db_user,
            event_type=AccessEventType.PASSWORD_RESET_REQUEST,
            attempt_email=db_user.email,
        )
    else:
        _create_access_log(
            db,
            user=None,
            event_type=AccessEventType.PASSWORD_RESET_REQUEST,
            attempt_email=email,
        )

    db.commit()

    # Respuesta generica para no revelar si existe o no el email.
    return {"msg": "Si el correo existe, se enviaron instrucciones de recuperacion"}


@router.post("/confirm/")
async def request_confirm_contra(payload: ResetConfirmRequest, db: Session = Depends(get_db)):
    try:
        claims = decode_access_token(payload.token)
    except Exception as exc:
        raise HTTPException(status_code=400, detail="Token invalido o expirado") from exc

    if claims.get("type") != "password_reset":
        raise HTTPException(status_code=400, detail="Token no valido para reset")

    email = (claims.get("sub") or "").strip().lower()
    if not email:
        raise HTTPException(status_code=400, detail="Token sin subject valido")

    db_user = db.query(User).filter(User.email == email).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="Usuario no encontrado")

    if db_user.token_pass != payload.token:
        raise HTTPException(status_code=400, detail="Token no coincide con el usuario")

    if not db_user.token_pass_expires or db_user.token_pass_expires < datetime.utcnow():
        raise HTTPException(status_code=400, detail="Token expirado")

    db_user.password_hash = get_password_hash(payload.password)
    db_user.token_pass = None
    db_user.token_pass_expires = None

    _create_access_log(
        db,
        user=db_user,
        event_type=AccessEventType.PASSWORD_RESET_SUCCESS,
        attempt_email=db_user.email,
    )
    db.commit()

    return {"msg": "Contrasena restablecida correctamente"}
