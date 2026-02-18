from typing import Optional
from uuid import UUID, uuid4

from fastapi import APIRouter, Depends, HTTPException, Query
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session, joinedload

from app.database import get_db
from app.models import Acceso, Estado, Rol, Usuario
from app.security import get_password_hash

router = APIRouter(
    prefix="/users",
    tags=["Users"]
)


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


def _role_name_by_type(user_type: int) -> str:
    return "admin" if user_type == 2 else "user"


def _role_label(role_name: str | None) -> str:
    return "Administrador" if (role_name or "").lower() == "admin" else "Usuario"


def _user_type_by_role(role_name: str | None) -> int:
    return 2 if (role_name or "").lower() == "admin" else 1


@router.put("/")
async def add_user(user: UserCreate, db: Session = Depends(get_db)):
    existing = db.query(Usuario).filter(Usuario.email == user.email.strip().lower()).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email ya registrado")

    role_name = _role_name_by_type(user.type)
    role = db.query(Rol).filter(Rol.nombre == role_name).first()
    if not role:
        role = Rol(id=uuid4(), nombre=role_name)
        db.add(role)
        db.flush()

    db_user = Usuario(
        id=uuid4(),
        name=user.name,
        email=user.email.strip().lower(),
        contra_hash=get_password_hash(user.password),
        rol_id=role.id,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)

    return {
        "msg": "Usuario creado",
        "user": {
            "id": str(db_user.id),
            "name": db_user.name,
            "email": db_user.email,
            "type": user.type,
        }
    }


@router.get("/{user_id}")
async def get_user(user_id: str, db: Session = Depends(get_db)):
    try:
        user_uuid = UUID(user_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="User id invalido")

    user = (
        db.query(Usuario)
        .options(joinedload(Usuario.rol))
        .filter(Usuario.id == user_uuid)
        .first()
    )
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    return {
        "msg": "",
        "data": {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "type": _user_type_by_role(user.rol.nombre if user.rol else None),
        }
    }


@router.get("/")
async def get_users(
    user_type: Optional[int] = Query(default=None, ge=1, le=2),
    db: Session = Depends(get_db),
):
    users = db.query(Usuario).options(joinedload(Usuario.rol)).all()

    data = []
    for user in users:
        role_name = user.rol.nombre if user.rol else "user"
        role_label = _role_label(role_name)
        current_type = _user_type_by_role(role_name)

        if user_type is not None and current_type != user_type:
            continue

        latest_access = (
            db.query(Acceso)
            .join(Estado, Acceso.estado_id == Estado.id)
            .filter(
                Acceso.usuario_id == user.id,
                Estado.nombre == "LOGIN_SUCCESS",
            )
            .order_by(Acceso.fecha.desc())
            .first()
        )

        last_access = latest_access.fecha.strftime("%d/%m/%Y") if latest_access and latest_access.fecha else "-"

        data.append({
            "id": str(user.id),
            "nombre": user.name,
            "email": user.email,
            "rol": role_label,
            "ultimoAcceso": last_access,
            "type": current_type,
        })

    return {"msg": "", "data": data}


@router.patch("/{user_id}")
async def update_user(updated_user: UserUpdate, user_id: str, db: Session = Depends(get_db)):
    try:
        user_uuid = UUID(user_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="User id invalido")

    user = db.query(Usuario).options(joinedload(Usuario.rol)).filter(Usuario.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    if updated_user.name is not None:
        user.name = updated_user.name
    if updated_user.email is not None:
        user.email = updated_user.email.strip().lower()
    if updated_user.password is not None:
        user.contra_hash = get_password_hash(updated_user.password)
    if updated_user.type is not None:
        role_name = _role_name_by_type(updated_user.type)
        role = db.query(Rol).filter(Rol.nombre == role_name).first()
        if not role:
            role = Rol(id=uuid4(), nombre=role_name)
            db.add(role)
            db.flush()
        user.rol_id = role.id

    db.commit()
    db.refresh(user)

    return {
        "msg": "Usuario actualizado",
        "data": {
            "id": str(user.id),
            "name": user.name,
            "email": user.email,
            "type": _user_type_by_role(user.rol.nombre if user.rol else None),
        }
    }


@router.delete("/{user_id}")
async def delete_user(user_id: str, db: Session = Depends(get_db)):
    try:
        user_uuid = UUID(user_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="User id invalido")

    user = db.query(Usuario).filter(Usuario.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    db.delete(user)
    db.commit()
    return {"msg": "User borrado correctamente."}


@router.get("/auditoria/{user_id}")
async def get_logs_user(user_id: str, db: Session = Depends(get_db)):
    try:
        user_uuid = UUID(user_id)
    except ValueError:
        raise HTTPException(status_code=400, detail="User id invalido")

    user = db.query(Usuario).options(joinedload(Usuario.rol)).filter(Usuario.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail="User id no encontrado.")

    logs_db = (
        db.query(Acceso)
        .options(
            joinedload(Acceso.estado),
            joinedload(Acceso.navegador),
            joinedload(Acceso.sistema_operativo),
        )
        .filter(Acceso.usuario_id == user_uuid)
        .order_by(Acceso.fecha.desc())
        .all()
    )

    logs = []
    for access in logs_db:
        logs.append({
            "navegador": access.navegador.nombre if access.navegador else "Desconocido",
            "sistema_operativo": access.sistema_operativo.nombre if access.sistema_operativo else "Desconocido",
            "ip": access.ip or "-",
            "fecha": access.fecha.strftime("%d/%m/%Y") if access.fecha else "-",
            "hora": access.fecha.strftime("%H:%M") if access.fecha else "-",
            "accion": (access.estado.nombre if access.estado else "DESCONOCIDA").upper(),
        })

    role_label = _role_label(user.rol.nombre if user.rol else None)
    return {
        "msg": "",
        "user": {
            "id": str(user.id),
            "nombre": user.name,
            "email": user.email,
            "rol": role_label,
        },
        "data": logs,
    }
