"""set null on delete for access_log user fk

Revision ID: e2c4b1f9a8d0
Revises: a91e6b4d2c7f
Create Date: 2026-02-24 16:20:00.000000

"""

from typing import Sequence, Union

from alembic import op


# revision identifiers, used by Alembic.
revision: str = "e2c4b1f9a8d0"
down_revision: Union[str, Sequence[str], None] = "a91e6b4d2c7f"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.drop_constraint(
        "access_log_user_id_fkey",
        "access_log",
        type_="foreignkey",
    )
    op.create_foreign_key(
        "access_log_user_id_fkey",
        "access_log",
        "user",
        ["user_id"],
        ["id"],
        ondelete="SET NULL",
    )


def downgrade() -> None:
    op.drop_constraint(
        "access_log_user_id_fkey",
        "access_log",
        type_="foreignkey",
    )
    op.create_foreign_key(
        "access_log_user_id_fkey",
        "access_log",
        "user",
        ["user_id"],
        ["id"],
    )
