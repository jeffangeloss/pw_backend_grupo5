"""agregar avatar_url en tabla user

Revision ID: c9f1a27e4d11
Revises: b8f2c1d4e6a0
Create Date: 2026-02-23 00:00:00.000000

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "c9f1a27e4d11"
down_revision: Union[str, Sequence[str], None] = "b8f2c1d4e6a0"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.add_column("user", sa.Column("avatar_url", sa.String(length=2000), nullable=True))


def downgrade() -> None:
    op.drop_column("user", "avatar_url")
