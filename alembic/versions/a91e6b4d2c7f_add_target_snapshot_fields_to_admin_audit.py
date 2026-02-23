"""add target snapshot fields to admin audit log

Revision ID: a91e6b4d2c7f
Revises: f3a7c2d9e5b1
Create Date: 2026-02-23 09:30:00.000000

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "a91e6b4d2c7f"
down_revision: Union[str, Sequence[str], None] = "f3a7c2d9e5b1"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column(
        "admin_audit_log",
        sa.Column("target_snapshot_id", sa.UUID(as_uuid=True), nullable=True),
    )
    op.add_column(
        "admin_audit_log",
        sa.Column("target_snapshot_name", sa.String(length=300), nullable=True),
    )
    op.add_column(
        "admin_audit_log",
        sa.Column("target_snapshot_email", sa.String(length=100), nullable=True),
    )

    op.execute(
        """
        UPDATE admin_audit_log AS aal
        SET target_snapshot_id = aal.target_user_id,
            target_snapshot_name = u.full_name,
            target_snapshot_email = u.email
        FROM "user" AS u
        WHERE aal.target_user_id = u.id
        """
    )

    op.execute(
        """
        UPDATE admin_audit_log
        SET target_snapshot_id = target_user_id
        WHERE target_snapshot_id IS NULL
          AND target_user_id IS NOT NULL
        """
    )


def downgrade() -> None:
    op.drop_column("admin_audit_log", "target_snapshot_email")
    op.drop_column("admin_audit_log", "target_snapshot_name")
    op.drop_column("admin_audit_log", "target_snapshot_id")
