import enum
import uuid

from sqlalchemy import (
    UUID,
    Boolean,
    Column,
    DateTime,
    Enum,
    ForeignKey,
    Numeric,
    String,
    Text,
    func,
    text,
)
from sqlalchemy.orm import relationship

from .database import Base


class UserRole(str, enum.Enum):
    user = "user"
    admin = "admin"


class AccessEventType(str, enum.Enum):
    LOGIN_SUCCESS = "LOGIN_SUCCESS"
    LOGIN_FAIL = "LOGIN_FAIL"
    LOGOUT = "LOGOUT"
    PASSWORD_RESET_REQUEST = "PASSWORD_RESET_REQUEST"
    PASSWORD_RESET_SUCCESS = "PASSWORD_RESET_SUCCESS"
    EMAIL_VERIFY_SENT = "EMAIL_VERIFY_SENT"
    EMAIL_VERIFY_SUCCESS = "EMAIL_VERIFY_SUCCESS"
    ACCOUNT_DISABLED = "ACCOUNT_DISABLED"
    ACCOUNT_ENABLED = "ACCOUNT_ENABLED"


class User(Base):
    __tablename__ = "user"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    full_name = Column(String(300), nullable=False)
    email = Column(String(100), nullable=False, unique=True)
    password_hash = Column(String(300), nullable=False)

    role = Column(
        Enum(UserRole, name="user_role"),
        nullable=False,
        default=UserRole.user,
        server_default=text("'user'"),
    )

    token_pass = Column(String(255), unique=True, nullable=True)
    token_pass_expires = Column(DateTime, nullable=True)
    token_verification = Column(String(255), unique=True, nullable=True)
    token_verification_expires = Column(DateTime, nullable=True)

    email_verified = Column(Boolean, nullable=False, default=False, server_default=text("false"))
    is_active = Column(Boolean, nullable=False, default=False, server_default=text("false"))

    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())
    updated_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())

    expenses = relationship("Expense", back_populates="user")
    access_logs = relationship("AccessLog", back_populates="user")


class Category(Base):
    __tablename__ = "category"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(100), nullable=False, unique=True)
    description = Column(Text, nullable=True)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())

    expenses = relationship("Expense", back_populates="category")


class Expense(Base):
    __tablename__ = "expense"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    user_id = Column(UUID(as_uuid=True), ForeignKey("user.id"), nullable=False)
    category_id = Column(UUID(as_uuid=True), ForeignKey("category.id"), nullable=False)

    amount = Column(Numeric(15, 2), nullable=False)
    expense_date = Column(DateTime, nullable=False)
    description = Column(Text, nullable=False)

    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())
    updated_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())

    user = relationship("User", back_populates="expenses")
    category = relationship("Category", back_populates="expenses")


class AccessLog(Base):
    __tablename__ = "access_log"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    user_id = Column(UUID(as_uuid=True), ForeignKey("user.id"), nullable=True)
    event_type = Column(Enum(AccessEventType, name="access_event_type"), nullable=False)

    attempt_email = Column(String(100), nullable=False)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())

    ip_address = Column(String(45), nullable=True)
    web_agent = Column(String(255), nullable=True)

    user = relationship("User", back_populates="access_logs")
