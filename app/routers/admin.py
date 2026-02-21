from typing import Optional
from uuid import UUID, uuid4
from fastapi import APIRouter, Depends, HTTPException, Header, Query
from pydantic import BaseModel, EmailStr, Field
from sqlalchemy.orm import Session, joinedload
from app.database import get_db
from app.models import User, AccessLog, UserToken
from app.security import get_password_hash


async def verify_admin_token(x_token : str = Header(...), db: Session = Depends(get_db)):
    db_query = db.query(UserToken).filter(UserToken.token_id == x_token)
    db_token = db_query.first()

    if  not db_token:
        raise HTTPException(
            status_code=403,
            detail={
                "msg": "Token incorrecto."
            }
        )
    
    if db_token.revoked_at is not None:
        raise HTTPException(
            status_code=403,
            detail={
                "msg": "Token vencido."
            }
        )

    if db_token.user.role != "admin":
        raise HTTPException(
            status_code=403,
            detail={
                "msg": "Acceso denegado: Se requiere rol Admin."
            }
        )    
    
    return db_token.user

router = APIRouter(
    prefix="/admin",
    tags=["Admin"]
    #dependencies=[Depends(verify_admin_token)]
)

class UserCreate(BaseModel):
    full_name: str
    email: EmailStr
    password: str
    type: int = Field(..., ge=1, le=2)

class UserUpdate(BaseModel):
    full_name: Optional[str] = Field(None)
    email: Optional[EmailStr] = None
    password: Optional[str] = None
    type: Optional[int] = Field(None, ge=1, le=2)

def _get_role_string(user_type: int):
    return "admin" if user_type == 2 else "user"


@router.put("/")
async def add_user(user: UserCreate, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.email == user.email.strip().lower()).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email ya registrado")

    db_user = User(
        id=uuid4(),
        full_name=user.full_name,
        email=user.email.strip().lower(),
        password_hash=get_password_hash(user.password),
        role=_get_role_string(user.type),
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    return {
        "msg": "Usuario creado correctamente.",
        "user": {
            "id": str(db_user.id),
            "name": db_user.full_name,
            "email": db_user.email,
            "role": db_user.role,
        }
    }


@router.get("/{user_id}")
async def get_user(user_id: UUID, db: Session = Depends(get_db)):
    user = (
        db.query(User).filter(User.id == user_id).first()
    )
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    return {
        "msg": "",
        "data": {
            "id": str(user.id),
            "name": user.full_name,
            "email": user.email,
            "role": user.role
        }
    }


@router.get("/")
async def get_users(user_type: Optional[int] = Query(default=None, ge=1, le=2), db: Session = Depends(get_db)):
    query = db.query(User)

    if user_type is not None:
        selected_role = _get_role_string(user_type)
        query = query.filter(User.role == selected_role)

    users = query.all()

    return {"msg": "", "data": users}


@router.patch("/{user_id}")
async def update_user(updated_user: UserUpdate, user_id: UUID, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    if updated_user.full_name is not None:
        user.full_name = updated_user.full_name # type: ignore
    if updated_user.email is not None:
        user.email = updated_user.email.strip().lower() # type: ignore
    if updated_user.password is not None:
        user.password_hash = get_password_hash(updated_user.password) # type: ignore
    if updated_user.type is not None:
        user.role = _get_role_string(updated_user.type) # type: ignore

    db.commit()
    db.refresh(user)

    return {
        "msg": "Usuario actualizado",
        "data": {
            "id": str(user.id),
            "name": user.full_name,
            "email": user.email,
            "type": user.role,
        }
    }


@router.delete("/{user_id}")
async def delete_user(user_id: UUID, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    db.delete(user)
    db.commit()
    return {"msg": "User borrado correctamente."}


# AUDITORIA DE USUARIO
@router.get("/auditoria/{user_id}")
async def get_logs_user(user_id: str, db: Session = Depends(get_db)):
    try:
        user_uuid = UUID(user_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="User id invalido")

    user = db.query(User).filter(User.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    logs_db = (
        db.query(AccessLog)
        .filter(AccessLog.user_id == user_uuid)
        .order_by(AccessLog.timestamp.desc())
        .all()
    )

    logs = []
    for access in logs_db:
        logs.append({
            "ip": access.ip_address or "-",
            "fecha": access.timestamp.strftime("%d/%m/%Y") if access.timestamp else "-",
            "hora": access.timestamp.strftime("%H:%M") if access.timestamp else "-",
            "accion": (access.event_type if access.event_type else "DESCONOCIDA").upper(),
        })

    return {
        "msg": "",
        "user": {
            "id": str(user.id),
            "nombre": user.full_name,
            "email": user.email,
            "rol": user.role,
        },
        "data": logs,
    }
