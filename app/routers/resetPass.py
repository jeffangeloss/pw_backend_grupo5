from fastapi import Depends, HTTPException, APIRouter
from sqlalchemy.orm import Session

from ..security import create_access_token
from ..schemas import ResetRequest
from ..database import get_db
from ..models import User as Usuario

router = APIRouter(
    prefix="/reset-contra",
    tags = ["Restablecer contra"]
)

@router.put("/request")
async def request_reset_contra( request : ResetRequest,  db : Session = Depends(get_db) ):
    db_usuario = db.query(Usuario).filter(Usuario.email == request.email).first()
    if db_usuario:
        # crear token
        reset_token = create_access_token (
            {"sub" : db_usuario.email,
            "type" : "password_reset"},
            expires_minutes=5
        )

    # ENVIAR EMAIL
    # en el email se deberia enviar el token

    return {
        "msg" : "Se completo el request"
        #"data" : token BORRAR LUEGO
    }

@router.post("confirm/")
async def request_confirm_contra( token: str, db : Session = Depends(get_db) ):
    pass

