from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from jwt.exceptions import InvalidTokenError
from pydantic import BaseModel
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy.orm import Session, joinedload

from .database import get_db, session
from .models import Usuario
from .routers import admin
from .schemas import LoginRequest
from .security import (
    DUMMY_HASH,
    create_access_token,
    decode_access_token,
    get_password_hash,
    is_password_hashed,
    verify_password,
)

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


@app.on_event("startup")
def migrate_plain_passwords_to_hash() -> None:
    # BLOQUE SEGURIDAD: migra contraseñas en texto plano a hash Argon2.
    db = session()
    try:
        users = db.query(Usuario).filter(Usuario.contra_hash.isnot(None)).all()
        changed = 0
        for user in users:
            if user.contra_hash and not is_password_hashed(user.contra_hash):
                user.contra_hash = get_password_hash(user.contra_hash)
                changed += 1

        if changed:
            db.commit()
    except SQLAlchemyError:
        db.rollback()
        # BLOQUE SEGURIDAD: evita caída de la API si falla esta migración.
        print("No se pudo completar la migración de passwords a hash.")
    finally:
        db.close()


@app.post("/login")
async def login(login_request: LoginRequest, db: Session = Depends(get_db)):
    # BLOQUE LOGIN BD: validación real contra tabla usuario de PostgreSQL.
    correo = login_request.correo.strip().lower()
    user = (
        db.query(Usuario)
        .options(joinedload(Usuario.rol))
        .filter(Usuario.email == correo)
        .first()
    )

    if not user:
        # BLOQUE SEGURIDAD: tiempo similar entre usuario existente/no existente.
        verify_password(login_request.password, DUMMY_HASH)
        raise HTTPException(status_code=400, detail="Credenciales incorrectas")

    password_ok = False

    # BLOQUE SEGURIDAD: valida hash Argon2.
    if is_password_hashed(user.contra_hash):
        password_ok = verify_password(login_request.password, user.contra_hash)
    else:
        # BLOQUE COMPAT: si quedó texto plano, permite login y migra a hash.
        password_ok = user.contra_hash == login_request.password
        if password_ok:
            user.contra_hash = get_password_hash(login_request.password)
            db.commit()

    if not password_ok:
        raise HTTPException(status_code=400, detail="Credenciales incorrectas")

    # BLOQUE LOGIN BD: el rol vuelve desde la relación Usuario -> Rol.
    role_name = user.rol.nombre if user.rol else "user"
    # BLOQUE SEGURIDAD: token JWT para frontend.
    access_token = create_access_token({"sub": user.email, "rol": role_name})

    return {
        "msg": "Acceso concedido",
        "rol": role_name,
        "email": user.email,
        "name": user.name,
        "access_token": access_token,
        "token_type": "bearer",
    }


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> Usuario:
    # BLOQUE SEGURIDAD: valida JWT y recupera usuario actual.
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="No autorizado",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = decode_access_token(token)
        email = payload.get("sub")
        if not email:
            raise credentials_exception
    except InvalidTokenError:
        raise credentials_exception

    user = (
        db.query(Usuario)
        .options(joinedload(Usuario.rol))
        .filter(Usuario.email == email)
        .first()
    )
    if not user:
        raise credentials_exception
    return user


@app.get("/me")
async def read_me(current_user: Usuario = Depends(get_current_user)):
    # BLOQUE SEGURIDAD: endpoint de prueba para frontend con Bearer token.
    role_name = current_user.rol.nombre if current_user.rol else "user"
    return {
        "email": current_user.email,
        "name": current_user.name,
        "rol": role_name,
    }


app.include_router(admin.router)
