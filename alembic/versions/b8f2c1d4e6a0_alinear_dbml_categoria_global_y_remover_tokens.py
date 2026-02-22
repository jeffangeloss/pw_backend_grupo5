"""crear esquema inicial final

Revision ID: b8f2c1d4e6a0
Revises:
Create Date: 2026-02-22 22:10:00.000000

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = "b8f2c1d4e6a0"
down_revision: Union[str, Sequence[str], None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create final schema aligned to DBML."""
    bind = op.get_bind()
    user_role = postgresql.ENUM("user", "admin", name="user_role", create_type=False)
    access_event_type = postgresql.ENUM(
        "LOGIN_SUCCESS",
        "LOGIN_FAIL",
        "LOGOUT",
        "PASSWORD_RESET_REQUEST",
        "PASSWORD_RESET_SUCCESS",
        "EMAIL_VERIFY_SENT",
        "EMAIL_VERIFY_SUCCESS",
        "ACCOUNT_DISABLED",
        "ACCOUNT_ENABLED",
        name="access_event_type",
        create_type=False,
    )

    user_role.create(bind, checkfirst=True)
    access_event_type.create(bind, checkfirst=True)

    op.create_table(
        "user",
        sa.Column("id", sa.UUID(), nullable=False),
        sa.Column("full_name", sa.String(length=300), nullable=False),
        sa.Column("email", sa.String(length=100), nullable=False),
        sa.Column("password_hash", sa.String(length=300), nullable=False),
        sa.Column("role", user_role, nullable=False, server_default=sa.text("'user'")),
        sa.Column("token_pass", sa.String(length=255), nullable=True),
        sa.Column("token_pass_expires", sa.DateTime(), nullable=True),
        sa.Column("token_verification", sa.String(length=255), nullable=True),
        sa.Column("token_verification_expires", sa.DateTime(), nullable=True),
        sa.Column("email_verified", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column("is_active", sa.Boolean(), nullable=False, server_default=sa.text("false")),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.text("CURRENT_TIMESTAMP")),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.text("CURRENT_TIMESTAMP")),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("email", name="uq_user_email"),
        sa.UniqueConstraint("token_pass", name="uq_user_token_pass"),
        sa.UniqueConstraint("token_verification", name="uq_user_token_verification"),
    )

    op.create_table(
        "category",
        sa.Column("id", sa.UUID(), nullable=False),
        sa.Column("name", sa.String(length=100), nullable=False),
        sa.Column("description", sa.Text(), nullable=True),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.text("CURRENT_TIMESTAMP")),
        sa.PrimaryKeyConstraint("id"),
        sa.UniqueConstraint("name", name="uq_category_name"),
    )

    op.create_table(
        "expense",
        sa.Column("id", sa.UUID(), nullable=False),
        sa.Column("user_id", sa.UUID(), nullable=False),
        sa.Column("category_id", sa.UUID(), nullable=False),
        sa.Column("amount", sa.Numeric(15, 2), nullable=False),
        sa.Column("expense_date", sa.DateTime(), nullable=False),
        sa.Column("description", sa.Text(), nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.text("CURRENT_TIMESTAMP")),
        sa.Column("updated_at", sa.DateTime(), nullable=False, server_default=sa.text("CURRENT_TIMESTAMP")),
        sa.ForeignKeyConstraint(["category_id"], ["category.id"]),
        sa.ForeignKeyConstraint(["user_id"], ["user.id"]),
        sa.PrimaryKeyConstraint("id"),
    )

    op.create_table(
        "access_log",
        sa.Column("id", sa.UUID(), nullable=False),
        sa.Column("user_id", sa.UUID(), nullable=True),
        sa.Column("event_type", access_event_type, nullable=False),
        sa.Column("attempt_email", sa.String(length=100), nullable=False),
        sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.text("CURRENT_TIMESTAMP")),
        sa.Column("ip_address", sa.String(length=45), nullable=True),
        sa.Column("web_agent", sa.String(length=255), nullable=True),
        sa.ForeignKeyConstraint(["user_id"], ["user.id"]),
        sa.PrimaryKeyConstraint("id"),
    )


def downgrade() -> None:
    """Drop schema objects."""
    bind = op.get_bind()
    access_event_type = postgresql.ENUM(
        "LOGIN_SUCCESS",
        "LOGIN_FAIL",
        "LOGOUT",
        "PASSWORD_RESET_REQUEST",
        "PASSWORD_RESET_SUCCESS",
        "EMAIL_VERIFY_SENT",
        "EMAIL_VERIFY_SUCCESS",
        "ACCOUNT_DISABLED",
        "ACCOUNT_ENABLED",
        name="access_event_type",
        create_type=False,
    )
    user_role = postgresql.ENUM("user", "admin", name="user_role", create_type=False)

    op.drop_table("access_log")
    op.drop_table("expense")
    op.drop_table("category")
    op.drop_table("user")

    access_event_type.drop(bind, checkfirst=True)
    user_role.drop(bind, checkfirst=True)
