import os
from typing import Optional
from uuid import UUID, uuid4

from fastapi import APIRouter, Depends, Header, HTTPException, Query, Request
from pydantic import BaseModel, EmailStr, Field
from sqlalchemy.orm import Session

from app.database import get_db
from app.models import AccessEventType, AccessLog, AdminAuditLog, User, UserRole
from app.security import decode_access_token, get_password_hash

# Mantiene la validacion introducida en main para evitar despliegues inseguros.
ENV = os.getenv("ENV", "dev").strip().lower()
ADMIN_TOKEN_GUARD_ENABLED = os.getenv("ADMIN_TOKEN_GUARD_ENABLED", "false").lower() in {
    "1",
    "true",
    "yes",
}

if ENV in {"prod", "production"} and not ADMIN_TOKEN_GUARD_ENABLED:
    raise RuntimeError("ADMIN_TOKEN_GUARD_ENABLED debe estar en true en produccion.")


ROLE_TO_TYPE = {
    UserRole.user: 1,
    UserRole.admin: 2,
    UserRole.owner: 3,
    UserRole.auditor: 4,
}
TYPE_TO_ROLE = {value: key for key, value in ROLE_TO_TYPE.items()}
ADMIN_PANEL_ROLES = {UserRole.owner, UserRole.admin, UserRole.auditor}


class UserCreate(BaseModel):
    full_name: str
    email: EmailStr
    password: str
    type: int = Field(..., ge=1, le=4)


class UserUpdate(BaseModel):
    full_name: Optional[str] = None
    email: Optional[EmailStr] = None
    password: Optional[str] = None
    type: Optional[int] = Field(None, ge=1, le=4)


def _role_by_type(user_type: int) -> UserRole:
    role = TYPE_TO_ROLE.get(user_type)
    if not role:
        raise HTTPException(status_code=400, detail={"msg": "Tipo de usuario invalido"})
    return role


def _role_label(role: UserRole | None):
    if role == UserRole.owner:
        return "Owner"
    if role == UserRole.admin:
        return "Administrador"
    if role == UserRole.auditor:
        return "Auditor"
    return "Usuario"


def _user_type_by_role(role: UserRole | None):
    return ROLE_TO_TYPE.get(role or UserRole.user, 1)


def _latest_login_date(db: Session, user_id: UUID):
    latest_access = (
        db.query(AccessLog)
        .filter(
            AccessLog.user_id == user_id,
            AccessLog.event_type == AccessEventType.LOGIN_SUCCESS,
        )
        .order_by(AccessLog.created_at.desc())
        .first()
    )
    return latest_access.created_at.strftime("%d/%m/%Y") if latest_access else "-"


def _serialize_user_payload(user: User):
    role_value = user.role.value if user.role else UserRole.user.value
    return {
        "id": str(user.id),
        "nombre": user.full_name,
        "name": user.full_name,
        "full_name": user.full_name,
        "email": user.email,
        "type": _user_type_by_role(user.role),
        "rol": role_value,
        "role_value": role_value,
    }


def _resolve_admin_token(x_token: Optional[str], authorization: Optional[str]):
    if x_token:
        return x_token[7:].strip() if x_token.lower().startswith("bearer ") else x_token.strip()
    if authorization and authorization.lower().startswith("bearer "):
        return authorization[7:].strip()
    return ""


def _extract_client_ip(request: Request):
    forwarded_for = request.headers.get("x-forwarded-for")
    if forwarded_for:
        return forwarded_for.split(",")[0].strip()
    if request.client and request.client.host:
        return request.client.host
    return "0.0.0.0"


def _extract_web_agent(request: Request):
    user_agent = (request.headers.get("user-agent") or "").strip()
    return user_agent[:255] if user_agent else "Desconocido"


def _add_admin_audit_log(
    db: Session,
    *,
    actor: User,
    action: str,
    request: Request,
    target_user_id: UUID | None = None,
    details: str | None = None,
):
    db.add(
        AdminAuditLog(
            actor_user_id=actor.id,
            target_user_id=target_user_id,
            action=action,
            details=details,
            ip_address=_extract_client_ip(request),
            web_agent=_extract_web_agent(request),
        )
    )


def _ensure_can_create(actor: User, new_role: UserRole):
    if actor.role == UserRole.owner:
        return
    if actor.role == UserRole.admin and new_role == UserRole.user:
        return
    raise HTTPException(status_code=403, detail={"msg": "No tienes permisos para crear este rol"})


def _ensure_can_view_user(actor: User, target: User):
    if actor.role in {UserRole.owner, UserRole.auditor}:
        return
    if actor.role == UserRole.admin and target.role == UserRole.user:
        return
    raise HTTPException(status_code=403, detail={"msg": "No tienes permisos para ver este usuario"})


def _ensure_can_update(actor: User, target: User, requested_role: UserRole | None):
    if actor.role == UserRole.owner:
        if target.id == actor.id and requested_role is not None and requested_role != UserRole.owner:
            raise HTTPException(
                status_code=400,
                detail={"msg": "Owner no puede degradarse a si mismo"},
            )
        return

    if actor.role == UserRole.admin:
        if target.role != UserRole.user:
            raise HTTPException(
                status_code=403,
                detail={"msg": "Admin solo puede editar usuarios de rol User"},
            )
        if requested_role is not None and requested_role != UserRole.user:
            raise HTTPException(
                status_code=403,
                detail={"msg": "Admin no puede cambiar roles a Admin/Owner/Auditor"},
            )
        return

    raise HTTPException(status_code=403, detail={"msg": "No tienes permisos para editar usuarios"})


def _ensure_can_delete(actor: User, target: User, db: Session):
    if target.id == actor.id:
        raise HTTPException(status_code=400, detail={"msg": "No puedes eliminar tu propio usuario"})

    if actor.role == UserRole.owner:
        if target.role == UserRole.owner:
            owners_count = db.query(User).filter(User.role == UserRole.owner).count()
            if owners_count <= 1:
                raise HTTPException(
                    status_code=400,
                    detail={"msg": "Debe existir al menos un Owner activo"},
                )
        return

    if actor.role == UserRole.admin and target.role == UserRole.user:
        return

    raise HTTPException(status_code=403, detail={"msg": "No tienes permisos para eliminar este usuario"})


def _ensure_can_manage_users(actor: User):
    if actor.role not in {UserRole.owner, UserRole.admin}:
        raise HTTPException(status_code=403, detail={"msg": "No tienes permisos para gestionar usuarios"})


async def verify_admin_token(
    x_token: Optional[str] = Header(default=None),
    authorization: Optional[str] = Header(default=None),
    db: Session = Depends(get_db),
):
    token = _resolve_admin_token(x_token, authorization)
    if not token:
        raise HTTPException(status_code=401, detail={"msg": "Token requerido"})

    try:
        payload = decode_access_token(token)
    except Exception as exc:
        raise HTTPException(status_code=403, detail={"msg": "Token incorrecto"}) from exc

    email = (payload.get("sub") or "").strip().lower()
    if not email:
        raise HTTPException(status_code=403, detail={"msg": "Token incorrecto"})

    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise HTTPException(status_code=403, detail={"msg": "Token incorrecto"})

    if user.role not in ADMIN_PANEL_ROLES:
        raise HTTPException(
            status_code=403,
            detail={"msg": "Acceso denegado: se requiere rol Admin/Owner/Auditor"},
        )
    return user


router = APIRouter(prefix="/admin", tags=["Admin"])


@router.post("/", status_code=201)
async def add_user(
    user: UserCreate,
    request: Request,
    actor: User = Depends(verify_admin_token),
    db: Session = Depends(get_db),
):
    _ensure_can_manage_users(actor)
    new_role = _role_by_type(user.type)
    _ensure_can_create(actor, new_role)

    email = user.email.strip().lower()
    existing = db.query(User).filter(User.email == email).first()
    if existing:
        raise HTTPException(status_code=400, detail={"msg": "Email ya registrado"})

    db_user = User(
        id=uuid4(),
        full_name=user.full_name.strip(),
        email=email,
        password_hash=get_password_hash(user.password),
        role=new_role,
    )
    db.add(db_user)
    db.flush()

    _add_admin_audit_log(
        db,
        actor=actor,
        action="USER_CREATE",
        request=request,
        target_user_id=db_user.id,
        details=f"role={db_user.role.value}",
    )

    db.commit()
    db.refresh(db_user)

    return {
        "msg": "Usuario creado",
        "user": _serialize_user_payload(db_user),
    }


@router.get("/")
async def get_users(
    user_type: Optional[int] = Query(default=None, ge=1, le=4),
    actor: User = Depends(verify_admin_token),
    db: Session = Depends(get_db),
):
    users = db.query(User).all()

    data = []
    for user in users:
        current_type = _user_type_by_role(user.role)
        if user_type is not None and current_type != user_type:
            continue

        if actor.role == UserRole.admin and user.role != UserRole.user:
            continue

        data.append(
            {
                "id": str(user.id),
                "nombre": user.full_name,
                "name": user.full_name,
                "full_name": user.full_name,
                "email": user.email,
                "rol": _role_label(user.role),
                "ultimoAcceso": _latest_login_date(db, user.id),
                "type": current_type,
                "role_value": user.role.value if user.role else UserRole.user.value,
            }
        )

    return {"msg": "", "data": data}


@router.get("/email/{email}")
async def get_user_by_email(
    email: str,
    actor: User = Depends(verify_admin_token),
    db: Session = Depends(get_db),
):
    email_buscado = email.lower().strip()

    user = db.query(User).filter(User.email == email_buscado).first()
    if not user:
        raise HTTPException(status_code=404, detail={"msg": "Usuario no encontrado con ese email"})

    _ensure_can_view_user(actor, user)

    payload = _serialize_user_payload(user)
    payload["ultimoAcceso"] = _latest_login_date(db, user.id)

    return {
        "msg": "",
        "data": payload,
    }


@router.get("/auditoria/admin")
async def get_admin_audit_logs(
    action: Optional[str] = Query(default=None),
    limit: int = Query(default=100, ge=1, le=500),
    actor: User = Depends(verify_admin_token),
    db: Session = Depends(get_db),
):
    if actor.role not in {UserRole.owner, UserRole.auditor}:
        raise HTTPException(
            status_code=403,
            detail={"msg": "Solo Owner o Auditor pueden ver la auditoria administrativa"},
        )

    query = db.query(AdminAuditLog).order_by(AdminAuditLog.created_at.desc())
    if action:
        query = query.filter(AdminAuditLog.action == action.strip().upper())

    logs_db = query.limit(limit).all()
    users = db.query(User).all()
    users_by_id = {str(user.id): user for user in users}

    data = []
    for log in logs_db:
        actor_user = users_by_id.get(str(log.actor_user_id))
        target_user = users_by_id.get(str(log.target_user_id)) if log.target_user_id else None
        data.append(
            {
                "id": str(log.id),
                "accion": log.action,
                "detalle": log.details or "",
                "fecha": log.created_at.strftime("%d/%m/%Y") if log.created_at else "-",
                "hora": log.created_at.strftime("%H:%M") if log.created_at else "-",
                "actor": {
                    "id": str(log.actor_user_id),
                    "nombre": actor_user.full_name if actor_user else "-",
                    "email": actor_user.email if actor_user else "-",
                },
                "target": (
                    {
                        "id": str(log.target_user_id),
                        "nombre": target_user.full_name if target_user else "-",
                        "email": target_user.email if target_user else "-",
                    }
                    if log.target_user_id
                    else None
                ),
                "ip": log.ip_address or "-",
                "web_agent": log.web_agent or "Desconocido",
            }
        )

    return {"msg": "", "data": data}


@router.get("/auditoria/usuario/{user_id}")
async def get_logs_user(
    user_id: str,
    actor: User = Depends(verify_admin_token),
    db: Session = Depends(get_db),
):
    try:
        user_uuid = UUID(user_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail={"msg": "User id invalido"}) from exc

    user = db.query(User).filter(User.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail={"msg": "User id no encontrado"})

    _ensure_can_view_user(actor, user)

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


@router.get("/{user_id}")
async def get_user(
    user_id: str,
    actor: User = Depends(verify_admin_token),
    db: Session = Depends(get_db),
):
    try:
        user_uuid = UUID(user_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail={"msg": "User id invalido"}) from exc

    user = db.query(User).filter(User.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail={"msg": "User id no encontrado"})

    _ensure_can_view_user(actor, user)

    payload = _serialize_user_payload(user)
    payload["ultimoAcceso"] = _latest_login_date(db, user.id)

    return {
        "msg": "",
        "data": payload,
    }


@router.patch("/{user_id}")
async def update_user(
    updated_user: UserUpdate,
    user_id: str,
    request: Request,
    actor: User = Depends(verify_admin_token),
    db: Session = Depends(get_db),
):
    _ensure_can_manage_users(actor)

    try:
        user_uuid = UUID(user_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail={"msg": "User id invalido"}) from exc

    user = db.query(User).filter(User.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail={"msg": "User id no encontrado"})

    requested_role = _role_by_type(updated_user.type) if updated_user.type is not None else None
    _ensure_can_update(actor, user, requested_role)

    changed_fields = []

    if updated_user.full_name is not None:
        user.full_name = updated_user.full_name.strip()
        changed_fields.append("full_name")
    if updated_user.email is not None:
        new_email = updated_user.email.strip().lower()
        existing = (
            db.query(User)
            .filter(
                User.email == new_email,
                User.id != user_uuid,
            )
            .first()
        )
        if existing:
            raise HTTPException(status_code=400, detail={"msg": "Email ya registrado"})
        user.email = new_email
        changed_fields.append("email")
    if updated_user.password is not None:
        user.password_hash = get_password_hash(updated_user.password)
        changed_fields.append("password")
    if requested_role is not None and requested_role != user.role:
        user.role = requested_role
        changed_fields.append("role")

    _add_admin_audit_log(
        db,
        actor=actor,
        action="USER_UPDATE",
        request=request,
        target_user_id=user.id,
        details=f"fields={','.join(changed_fields) if changed_fields else 'none'}",
    )

    db.commit()
    db.refresh(user)

    return {
        "msg": "Usuario actualizado",
        "data": _serialize_user_payload(user),
    }


@router.delete("/{user_id}")
async def delete_user(
    user_id: str,
    request: Request,
    actor: User = Depends(verify_admin_token),
    db: Session = Depends(get_db),
):
    _ensure_can_manage_users(actor)

    try:
        user_uuid = UUID(user_id)
    except ValueError as exc:
        raise HTTPException(status_code=400, detail={"msg": "User id invalido"}) from exc

    user = db.query(User).filter(User.id == user_uuid).first()
    if not user:
        raise HTTPException(status_code=404, detail={"msg": "User id no encontrado"})

    _ensure_can_delete(actor, user, db)

    _add_admin_audit_log(
        db,
        actor=actor,
        action="USER_DELETE",
        request=request,
        target_user_id=user.id,
        details=f"deleted_role={user.role.value if user.role else UserRole.user.value}",
    )

    db.delete(user)
    db.commit()
    return {"msg": "User borrado correctamente."}
