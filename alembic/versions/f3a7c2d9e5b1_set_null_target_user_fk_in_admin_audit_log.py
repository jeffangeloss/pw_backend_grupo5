"""set null on delete for admin_audit_log target user fk

Revision ID: f3a7c2d9e5b1
Revises: d14a4b2f8c31
Create Date: 2026-02-23 09:05:00.000000

"""

from typing import Sequence, Union

from alembic import op


# revision identifiers, used by Alembic.
revision: str = "f3a7c2d9e5b1"
down_revision: Union[str, Sequence[str], None] = "d14a4b2f8c31"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.drop_constraint(
        "admin_audit_log_target_user_id_fkey",
        "admin_audit_log",
        type_="foreignkey",
    )
    op.create_foreign_key(
        "admin_audit_log_target_user_id_fkey",
        "admin_audit_log",
        "user",
        ["target_user_id"],
        ["id"],
        ondelete="SET NULL",
    )


def downgrade() -> None:
    op.drop_constraint(
        "admin_audit_log_target_user_id_fkey",
        "admin_audit_log",
        type_="foreignkey",
    )
    op.create_foreign_key(
        "admin_audit_log_target_user_id_fkey",
        "admin_audit_log",
        "user",
        ["target_user_id"],
        ["id"],
    )
