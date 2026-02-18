from sqlalchemy import UUID, Column, DateTime, Double, String, ForeignKey
from .database import Base
from sqlalchemy.orm import relationship
import uuid
from datetime import datetime

# TABLAS EN PROCESO...
# hola

class Categoria(Base):
    __tablename__ = "categoria"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    nombre = Column(String, unique=True)
    egresos = relationship("Egreso", back_populates="categoria")

class Rol(Base):
    __tablename__ = "rol"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    nombre = Column(String, unique=True)
    usuarios = relationship("Usuario", back_populates="rol")

class Usuario(Base):
    __tablename__ = "usuario"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    name = Column(String)
    email = Column(String, unique=True, nullable=False)
    contra_hash = Column(String)
    rol_id = Column(
        UUID(as_uuid=True),
        ForeignKey("rol.id")
    )
    rol = relationship("Rol", back_populates="usuarios")
    egresos = relationship("Egreso", back_populates="usuario")
    accesos = relationship("Acceso", back_populates="usuario")

class Egreso(Base):
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
    usuario_id = Column(
        UUID(as_uuid=True), 
        ForeignKey("usuario.id"))
    categoria_id = Column(
        UUID(as_uuid=True), 
        ForeignKey("categoria.id"))
    usuario = relationship("Usuario", back_populates="egresos")
    categoria = relationship("Categoria", back_populates="egresos")

class Estado(Base):
    __tablename__ = "estado"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    nombre = Column(String, unique=True)
    accesos = relationship("Acceso", back_populates="estado")

class Acceso(Base):
    __tablename__ = "acceso"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    fecha = Column(DateTime)
    navegador = Column(String)
    usuario_id = Column(UUID(as_uuid=True), ForeignKey("usuario.id"))
    estado_id = Column(UUID(as_uuid=True), ForeignKey("estado.id"))
    usuario = relationship("Usuario", back_populates="accesos")
    estado = relationship("Estado", back_populates="accesos")
