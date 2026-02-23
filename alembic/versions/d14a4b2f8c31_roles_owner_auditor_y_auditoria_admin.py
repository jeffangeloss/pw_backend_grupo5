"""roles owner/auditor y auditoria administrativa

Revision ID: d14a4b2f8c31
Revises: c9f1a27e4d11
Create Date: 2026-02-23 00:30:00.000000

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "d14a4b2f8c31"
down_revision: Union[str, Sequence[str], None] = "c9f1a27e4d11"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.execute("ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'owner'")
    op.execute("ALTER TYPE user_role ADD VALUE IF NOT EXISTS 'auditor'")

    op.create_table(
        "admin_audit_log",
        sa.Column("id", sa.UUID(as_uuid=True), nullable=False),
        sa.Column("actor_user_id", sa.UUID(as_uuid=True), nullable=False),
        sa.Column("target_user_id", sa.UUID(as_uuid=True), nullable=True),
        sa.Column("action", sa.String(length=100), nullable=False),
        sa.Column("details", sa.Text(), nullable=True),
        sa.Column("created_at", sa.DateTime(), server_default=sa.func.current_timestamp(), nullable=False),
        sa.Column("ip_address", sa.String(length=45), nullable=True),
        sa.Column("web_agent", sa.String(length=255), nullable=True),
        sa.ForeignKeyConstraint(["actor_user_id"], ["user.id"]),
        sa.ForeignKeyConstraint(["target_user_id"], ["user.id"]),
        sa.PrimaryKeyConstraint("id"),
    )


def downgrade() -> None:
    op.drop_table("admin_audit_log")

    op.execute("ALTER TYPE user_role RENAME TO user_role_old")
    op.execute("CREATE TYPE user_role AS ENUM ('user', 'admin')")
    op.execute(
        """
        ALTER TABLE "user"
        ALTER COLUMN role DROP DEFAULT,
        ALTER COLUMN role TYPE user_role
        USING (
            CASE
                WHEN role::text IN ('owner', 'auditor') THEN 'user'
                ELSE role::text
            END
        )::user_role
        """
    )
    op.execute("ALTER TABLE \"user\" ALTER COLUMN role SET DEFAULT 'user'::user_role")
    op.execute("DROP TYPE user_role_old")
