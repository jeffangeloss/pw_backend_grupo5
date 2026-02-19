from sqlalchemy import UUID, Column, DateTime, Numeric, Integer, Boolean, String, ForeignKey
from .database import Base
from sqlalchemy.orm import relationship
import uuid
from datetime import datetime

# TABLAS EN PROCESO...

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

class Navegador(Base):
    __tablename__ = "navegador"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    nombre = Column(String)
    accesos = relationship("Acceso", back_populates="navegador")

# BLOQUE AUDITORIA: catalogo de sistemas operativos.
class SistemaOperativo(Base):
    __tablename__ = "sistema_operativo"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    nombre = Column(String, unique=True)
    accesos = relationship("Acceso", back_populates="sistema_operativo")
    
class Usuario(Base):
    __tablename__ = "usuario"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    name = Column(String(100))
    email = Column(String, unique=True, nullable=False, index=True)
    contra_hash = Column(String, nullable=False)
    rol_id = Column(
        UUID(as_uuid=True),
        ForeignKey("rol.id"),
        nullable=False,
        index=True
    )
    created_at = Column(DateTime, nullable=False)
    rol = relationship("Rol", back_populates="usuarios")
    egresos = relationship("Egreso", back_populates="usuario")
    accesos = relationship("Acceso", back_populates="usuario")
    tokens_2fa = relationship("UsuarioToken2FA", back_populates="usuario")

class Egreso(Base):
    __tablename__ = "egreso"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    fecha = Column(DateTime, nullable=False)
    descripcion = Column(String, nullable=False)
    monto = Column(Numeric(10,2), nullable=False)
    usuario_id = Column(
        UUID(as_uuid=True), 
        ForeignKey("usuario.id"),
        nullable=False)
    categoria_id = Column(
        UUID(as_uuid=True), 
        ForeignKey("categoria.id"),
        nullable=False)
    usuario = relationship("Usuario", back_populates="egresos")
    categoria = relationship("Categoria", back_populates="egresos")

class Resultado(Base):
    __tablename__ = "resultado"
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
    fecha = Column(DateTime, nullable=False)
    ip = Column(String(45))
    session_token = Column(String, unique=True, index=True)
    logout_at = Column(DateTime)
    usuario_id = Column(
        UUID(as_uuid=True), 
        ForeignKey("usuario.id"),
        nullable=False, 
        index=True
        )
    resultado_id = Column(
            UUID(as_uuid=True), 
            ForeignKey("resultado.id"), 
            nullable=False
        )
    web_agent = Column(String)
    usuario = relationship("Usuario", back_populates="accesos")
    estado = relationship("Estado", back_populates="accesos")

class UsuarioToken2FA(Base):
    __tablename__ = "usuario_token_2fa"
    
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    usuario_id = Column(
        UUID(as_uuid=True), 
        ForeignKey("usuario.id"), 
        nullable=False
    )
    secret = Column(String, nullable=False, comment="Semilla Base32 para TOTP")
    digits = Column(Integer, nullable=False, default=4)
    period = Column(Integer, nullable=False, default=30)
    is_active = Column(Boolean, nullable=False, default=True)
    created_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    revoked_at = Column(DateTime)
    label = Column(String)
    usuario = relationship("Usuario", back_populates="tokens_2fa")
