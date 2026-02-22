import os
from typing import Optional
from uuid import UUID, uuid4

from fastapi import APIRouter, Depends, Header, HTTPException, Query
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import AccessEventType, AccessLog, User, UserRole, UserToken
from app.security import get_password_hash


class UserCreate(BaseModel):
    name: str
    email: str
    password: str
    type: int = Field(..., ge=1, le=2)


class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None
    type: Optional[int] = Field(None, ge=1, le=2)


def _role_by_type(user_type: int):
    return UserRole.admin if user_type == 2 else UserRole.user


def _role_label(role: UserRole | None):
    return "Administrador" if role == UserRole.admin else "Usuario"


def _user_type_by_role(role: UserRole | None):
    return 2 if role == UserRole.admin else 1


async def verify_admin_token(x_token: str = Header(...), db: Session = Depends(get_db)):
    # Permite activar control admin sin forzarlo en entornos donde aun no se usa.
    try:
        token_uuid = UUID(x_token)
    except ValueError as exc:
        raise HTTPException(status_code=403, detail={"msg": "Token incorrecto."}) from exc

    user_token = db.query(UserToken).filter(UserToken.token_id == token_uuid).first()
    if not user_token:
        raise HTTPException(status_code=403, detail={"msg": "Token incorrecto."})
    if user_token.revoked_at is not None:
        raise HTTPException(status_code=403, detail={"msg": "Token vencido."})
    if not user_token.user or user_token.user.role != UserRole.admin:
        raise HTTPException(
            status_code=403,
            detail={"msg": "Acceso denegado: Se requiere rol Admin."},
        )
    return user_token.user


ADMIN_TOKEN_GUARD_ENABLED = os.getenv("ADMIN_TOKEN_GUARD_ENABLED", "false").lower() in {
    "1",
    "true",
    "yes",
}

router = APIRouter(
    prefix="/users",
    tags=["Users"],
    dependencies=[Depends(verify_admin_token)] if ADMIN_TOKEN_GUARD_ENABLED else [],
)


@router.put("/")
async def add_user(user: UserCreate, db: Session = Depends(get_db)):
    email = user.email.strip().lower()
    existing = db.query(User).filter(User.email == email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email ya registrado")

    db_user = User(
        id=uuid4(),
        full_name=user.name.strip(),
        email=email,
        password_hash=get_password_hash(user.password),
        role=_role_by_type(user.type),
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    return {
        "msg": "Usuario creado",
        "user": {
            "id": str(db_user.id),
            "name": db_user.full_name,
            "email": db_user.email,
            "type": _user_type_by_role(db_user.role),
        },
    }


@router.get("/{user_id}")
async def get_user(user_id: str, db: Session = Depends(get_db)):
    try:
        user_uuid = UUID(user_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail="User id invalido") from exc

    user = db.query(User).filter(User.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    return {
        "msg": "",
        "data": {
            "id": str(user.id),
            "name": user.full_name,
            "email": user.email,
            "type": _user_type_by_role(user.role),
        },
    }


@router.get("/")
async def get_users(
    user_type: Optional[int] = Query(default=None, ge=1, le=2),
    db: Session = Depends(get_db),
):
    users = db.query(User).all()

    data = []
    for user in users:
        current_type = _user_type_by_role(user.role)
        if user_type is not None and current_type != user_type:
            continue

        latest_access = (
            db.query(AccessLog)
            .filter(
                AccessLog.user_id == user.id,
                AccessLog.event_type == AccessEventType.LOGIN_SUCCESS,
            )
            .order_by(AccessLog.created_at.desc())
            .first()
        )
        last_access = latest_access.created_at.strftime("%d/%m/%Y") if latest_access else "-"

        data.append(
            {
                "id": str(user.id),
                "nombre": user.full_name,
                "email": user.email,
                "rol": _role_label(user.role),
                "ultimoAcceso": last_access,
                "type": current_type,
            }
        )

    return {"msg": "", "data": data}


@router.patch("/{user_id}")
async def update_user(updated_user: UserUpdate, user_id: str, db: Session = Depends(get_db)):
    try:
        user_uuid = UUID(user_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail="User id invalido") from exc

    user = db.query(User).filter(User.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    if updated_user.name is not None:
        user.full_name = updated_user.name.strip()
    if updated_user.email is not None:
        user.email = updated_user.email.strip().lower()
    if updated_user.password is not None:
        user.password_hash = get_password_hash(updated_user.password)
    if updated_user.type is not None:
        user.role = _role_by_type(updated_user.type)

    db.commit()
    db.refresh(user)

    return {
        "msg": "Usuario actualizado",
        "data": {
            "id": str(user.id),
            "name": user.full_name,
            "email": user.email,
            "type": _user_type_by_role(user.role),
        },
    }


@router.delete("/{user_id}")
async def delete_user(user_id: str, db: Session = Depends(get_db)):
    try:
        user_uuid = UUID(user_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail="User id invalido") from exc

    user = db.query(User).filter(User.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    db.delete(user)
    db.commit()
    return {"msg": "User borrado correctamente."}


@router.get("/auditoria/{user_id}")
async def get_logs_user(user_id: str, db: Session = Depends(get_db)):
    try:
        user_uuid = UUID(user_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail="User id invalido") from exc

    user = db.query(User).filter(User.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    logs_db = (
        db.query(AccessLog)
        .filter(AccessLog.user_id == user_uuid)
        .order_by(AccessLog.created_at.desc())
        .all()
    )

    logs = []
    for access in logs_db:
        logs.append(
            {
                "ip": access.ip_address or "-",
                "web_agent": access.web_agent or "Desconocido",
                "fecha": access.created_at.strftime("%d/%m/%Y") if access.created_at else "-",
                "hora": access.created_at.strftime("%H:%M") if access.created_at else "-",
                "accion": access.event_type.value if access.event_type else "DESCONOCIDA",
                "attempt_email": access.attempt_email,
            }
        )

    return {
        "msg": "",
        "user": {
            "id": str(user.id),
            "nombre": user.full_name,
            "email": user.email,
            "rol": _role_label(user.role),
        },
        "data": logs,
    }
