from sqlalchemy import TIMESTAMP, UUID, Column, DateTime, Numeric, Integer, Boolean, String, ForeignKey, Text, text
from .database import Base
from sqlalchemy.orm import relationship
import uuid

# Según diagrama de Miro

class Category(Base):
    __tablename__ = "category"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    name = Column(String(255), unique=True, nullable=False)
    created_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))
    
    expenses = relationship("Expense", back_populates="category")

class User(Base):
    __tablename__ = "user"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    full_name = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, nullable=False, index=True)
    password_hash = Column(String(255), nullable=False)
    role = Column(String(20), server_default='user')
    
    token_pass = Column(String(255), unique=True, nullable=False)
    token_pass_expires = Column(DateTime, nullable=True)
    
    verification_token = Column(String(255), unique=True, nullable=True)
    verification_token_expires = Column(DateTime, nullable=True)
    email_verified = Column(Boolean, default=False)
    
    recovery_token = Column(String(255), unique=True, nullable=True)
    recovery_token_expires = Column(DateTime, nullable=True)
    
    is_active = Column(Boolean, nullable=False, default=False)
    created_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))
    updated_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))

    expenses = relationship("Expense", back_populates="user")
    access_logs = relationship("AccessLog", back_populates="user")
    user_tokens = relationship("UserToken", back_populates="user")

class Expense(Base):
    __tablename__ = "expense"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    user_id = Column(UUID(as_uuid=True), ForeignKey("user.id"), nullable=False, index=True)
    category_id = Column(UUID(as_uuid=True), ForeignKey("category.id"), nullable=False)
    amount = Column(Numeric(15, 2), nullable=False)
    expense_date = Column(DateTime, nullable=False)
    description = Column(Text, nullable=True)
    created_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))
    updated_at = Column(TIMESTAMP)

    user = relationship("User", back_populates="expenses")
    category = relationship("Category", back_populates="expenses")

class AccessEventType(Base):
    __tablename__ = "access_event_type"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    name = Column(String(50), unique=True, nullable=False)
    logs = relationship("AccessLog", back_populates="event_type")

class AccessLog(Base):
    __tablename__ = "access_log"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    user_id = Column(UUID(as_uuid=True), ForeignKey("user.id"), nullable=True, index=True)
    event_id = Column(UUID(as_uuid=True), ForeignKey("access_event_type.id"), nullable=False)
    ip_address = Column(String(45), nullable=True)
    web_agent = Column(String(255))
    created_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))

    user = relationship("User", back_populates="access_logs")
    event_type = relationship("AccessEventType", back_populates="logs")

class UserToken(Base):
    __tablename__ = "user_token"
    user_id = Column(UUID(as_uuid=True), ForeignKey("user.id"), primary_key=True)
    token_id = Column(UUID(as_uuid=True), ForeignKey("token_device.id"), primary_key=True, unique=True)
    
    assigned_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))
    revoked_at = Column(TIMESTAMP, nullable=True)

    user = relationship("User", back_populates="user_tokens")
    device = relationship("TokenDevice", back_populates="user_links")

class TokenDevice(Base):
    __tablename__ = "token_device"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    serial = Column(String(80), unique=True, nullable=False)
    secret_enc = Column(String(255), nullable=False, comment="Semilla Base32 para TOTP")
    digits = Column(Integer, nullable=False, default=4)
    period = Column(Integer, nullable=False, default=30)
    status = Column(String(20), nullable=False, default='ACTIVE')
    created_at = Column(TIMESTAMP, server_default=text('CURRENT_TIMESTAMP'))
    last_seen_at = Column(TIMESTAMP, nullable=True)

    user_links = relationship("UserToken", back_populates="device")

# TABLAS LEGACY
class Navegador(Base):
    __tablename__ = "navegador"
    id = Column(
        UUID(as_uuid=True),
        primary_key=True,
        default=lambda: str(uuid.uuid4()),
        index=True
    )
    nombre = Column(String)

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

