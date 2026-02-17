from sqlalchemy import UUID, Column, DateTime, Double, String, ForeignKey
from .database import Base
from sqlalchemy.orm import relationship
import uuid
from datetime import datetime

# TABLAS POR DEFINIRSE, ESTAS NO SON LAS FINALES

class CategoriaBase():
    __tablename__ = "categoria"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    nombre = Column(String)

# admin o usuario
class RolBase():
    __tablename__ = "rol"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    nombre = Column((String), unique=True)

#este se refiere a navegadores chrome, edge. etc.
# Lau: creo q mejor sea un atributo de acceso para no complicar
class NavegadorBase():
    __tablename__ = "navegador"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    nombre = Column(String)

class AccesoBase():
    __tablename__ = "acceso"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    fecha = Column(DateTime)
    # accion (tabla?)
    # navegador_id
    # user_id

class UserBase(Base):
    __tablename__ = "user"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    name = Column(String)
    email = Column((String), unique=True)
    password = Column(String)
    # rol_id
    # accesos (?)

class EgresoBase():
    __tablename__ = "egreso"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    fecha = Column(DateTime)
    descripcion = Column(String)
    monto = Column(Double)
    # user_id
    # categoria_id