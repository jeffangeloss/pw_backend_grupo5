"""add 2fa esp32 support tables

Revision ID: 9ad1f4c2b7e8
Revises: e2c4b1f9a8d0
Create Date: 2026-02-25 00:00:00.000000

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "9ad1f4c2b7e8"
down_revision: Union[str, Sequence[str], None] = "e2c4b1f9a8d0"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def _table_exists(table_name: str) -> bool:
    bind = op.get_bind()
    inspector = sa.inspect(bind)
    return table_name in inspector.get_table_names()


def _column_exists(table_name: str, column_name: str) -> bool:
    bind = op.get_bind()
    inspector = sa.inspect(bind)
    if table_name not in inspector.get_table_names():
        return False
    return column_name in {column["name"] for column in inspector.get_columns(table_name)}


def upgrade() -> None:
    op.execute("ALTER TYPE access_event_type ADD VALUE IF NOT EXISTS 'LOGIN_PWD_OK'")
    op.execute("ALTER TYPE access_event_type ADD VALUE IF NOT EXISTS '2FA_SUCCESS'")
    op.execute("ALTER TYPE access_event_type ADD VALUE IF NOT EXISTS '2FA_FAIL'")

    if not _column_exists("access_log", "detail"):
        op.add_column("access_log", sa.Column("detail", sa.Text(), nullable=True))

    if not _table_exists("token_device"):
        op.create_table(
            "token_device",
            sa.Column("id", sa.UUID(as_uuid=True), nullable=False),
            sa.Column("serial", sa.String(length=100), nullable=False),
            sa.Column("secret_enc", sa.String(length=512), nullable=False),
            sa.Column("digits", sa.Integer(), nullable=False, server_default=sa.text("6")),
            sa.Column("period", sa.Integer(), nullable=False, server_default=sa.text("60")),
            sa.Column("status", sa.String(length=20), nullable=False, server_default=sa.text("'ACTIVE'")),
            sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.current_timestamp()),
            sa.Column("last_seen_at", sa.DateTime(), nullable=True),
            sa.PrimaryKeyConstraint("id"),
            sa.UniqueConstraint("serial", name="uq_token_device_serial"),
        )

    if not _table_exists("auth_challenge"):
        op.create_table(
            "auth_challenge",
            sa.Column("id", sa.UUID(as_uuid=True), nullable=False),
            sa.Column("user_id", sa.UUID(as_uuid=True), nullable=False),
            sa.Column("status", sa.String(length=30), nullable=False, server_default=sa.text("'PENDING'")),
            sa.Column("attempts", sa.Integer(), nullable=False, server_default=sa.text("0")),
            sa.Column("expires_at", sa.DateTime(), nullable=False),
            sa.Column("created_at", sa.DateTime(), nullable=False, server_default=sa.func.current_timestamp()),
            sa.Column("verified_at", sa.DateTime(), nullable=True),
            sa.Column("request_ip", sa.String(length=45), nullable=True),
            sa.Column("user_agent", sa.String(length=255), nullable=True),
            sa.Column("device_notified", sa.Boolean(), nullable=False, server_default=sa.text("false")),
            sa.Column("device_notified_at", sa.DateTime(), nullable=True),
            sa.ForeignKeyConstraint(["user_id"], ["user.id"], ondelete="CASCADE"),
            sa.PrimaryKeyConstraint("id"),
        )
        op.create_index("ix_auth_challenge_status", "auth_challenge", ["status"], unique=False)
        op.create_index("ix_auth_challenge_user_id", "auth_challenge", ["user_id"], unique=False)
        op.create_index("ix_auth_challenge_expires_at", "auth_challenge", ["expires_at"], unique=False)


def downgrade() -> None:
    if _table_exists("auth_challenge"):
        op.drop_index("ix_auth_challenge_expires_at", table_name="auth_challenge")
        op.drop_index("ix_auth_challenge_user_id", table_name="auth_challenge")
        op.drop_index("ix_auth_challenge_status", table_name="auth_challenge")
        op.drop_table("auth_challenge")

    if _table_exists("token_device"):
        op.drop_table("token_device")

    if _column_exists("access_log", "detail"):
        op.drop_column("access_log", "detail")

    # Nota: PostgreSQL no permite eliminar valores de ENUM de forma directa.
    # Se conservan LOGIN_PWD_OK, 2FA_SUCCESS y 2FA_FAIL en access_event_type.
