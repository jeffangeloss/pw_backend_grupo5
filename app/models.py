import enum
import uuid

from sqlalchemy import (
    UUID,
    Boolean,
    Column,
    DateTime,
    Enum,
    ForeignKey,
    Integer,
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
    owner = "owner"
    auditor = "auditor"


class AccessEventType(str, enum.Enum):
    LOGIN_SUCCESS = "LOGIN_SUCCESS"
    LOGIN_PWD_OK = "LOGIN_PWD_OK"
    LOGIN_FAIL = "LOGIN_FAIL"
    TWO_FACTOR_SUCCESS = "2FA_SUCCESS"
    TWO_FACTOR_FAIL = "2FA_FAIL"
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
    avatar_url = Column(String(2000), nullable=True)

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

    expenses = relationship("Expense", back_populates="user", cascade="all, delete-orphan")
    access_logs = relationship("AccessLog", back_populates="user")
    auth_challenges = relationship("AuthChallenge", back_populates="user", cascade="all, delete-orphan")


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

    user_id = Column(UUID(as_uuid=True), ForeignKey("user.id", ondelete="SET NULL"), nullable=True)
    event_type = Column(
        Enum(
            AccessEventType,
            name="access_event_type",
            values_callable=lambda enum_cls: [member.value for member in enum_cls],
        ),
        nullable=False,
    )

    attempt_email = Column(String(100), nullable=False)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())

    ip_address = Column(String(45), nullable=True)
    web_agent = Column(String(255), nullable=True)
    detail = Column(Text, nullable=True)

    user = relationship("User", back_populates="access_logs")


class TokenDevice(Base):
    __tablename__ = "token_device"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    serial = Column(String(100), nullable=False, unique=True)
    secret_enc = Column(String(512), nullable=False)
    digits = Column(Integer, nullable=False, default=6, server_default=text("6"))
    period = Column(Integer, nullable=False, default=60, server_default=text("60"))
    status = Column(String(20), nullable=False, default="ACTIVE", server_default=text("'ACTIVE'"))
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())
    last_seen_at = Column(DateTime, nullable=True)


class AuthChallenge(Base):
    __tablename__ = "auth_challenge"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("user.id", ondelete="CASCADE"), nullable=False)
    status = Column(String(30), nullable=False, default="PENDING", server_default=text("'PENDING'"))
    attempts = Column(Integer, nullable=False, default=0, server_default=text("0"))
    expires_at = Column(DateTime, nullable=False)
    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())
    verified_at = Column(DateTime, nullable=True)
    request_ip = Column(String(45), nullable=True)
    user_agent = Column(String(255), nullable=True)
    device_notified = Column(Boolean, nullable=False, default=False, server_default=text("false"))
    device_notified_at = Column(DateTime, nullable=True)

    user = relationship("User", back_populates="auth_challenges")


class AdminAuditLog(Base):
    __tablename__ = "admin_audit_log"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)

    actor_user_id = Column(UUID(as_uuid=True), ForeignKey("user.id"), nullable=False)
    target_user_id = Column(UUID(as_uuid=True), ForeignKey("user.id", ondelete="SET NULL"), nullable=True)
    target_snapshot_id = Column(UUID(as_uuid=True), nullable=True)
    target_snapshot_name = Column(String(300), nullable=True)
    target_snapshot_email = Column(String(100), nullable=True)
    action = Column(String(100), nullable=False)
    details = Column(Text, nullable=True)

    created_at = Column(DateTime, nullable=False, server_default=func.current_timestamp())
    ip_address = Column(String(45), nullable=True)
    web_agent = Column(String(255), nullable=True)
