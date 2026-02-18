"""agregar tabla sistema_operativo y so_id en acceso

Revision ID: c4a7a1f5b182
Revises: 56ee731c264d
Create Date: 2026-02-18 13:35:00.000000

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = "c4a7a1f5b182"
down_revision: Union[str, Sequence[str], None] = "56ee731c264d"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.create_table(
        "sistema_operativo",
        sa.Column("id", sa.UUID(), nullable=False),
        sa.Column("nombre", sa.String(), nullable=False),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(op.f("ix_sistema_operativo_id"), "sistema_operativo", ["id"], unique=False)
    op.create_unique_constraint(
        "uq_sistema_operativo_nombre",
        "sistema_operativo",
        ["nombre"],
    )
    op.add_column("acceso", sa.Column("so_id", sa.UUID(), nullable=True))
    op.create_foreign_key(
        "fk_acceso_so_id_sistema_operativo",
        "acceso",
        "sistema_operativo",
        ["so_id"],
        ["id"],
    )


def downgrade() -> None:
    """Downgrade schema."""
    op.drop_constraint("fk_acceso_so_id_sistema_operativo", "acceso", type_="foreignkey")
    op.drop_column("acceso", "so_id")
    op.drop_constraint("uq_sistema_operativo_nombre", "sistema_operativo", type_="unique")
    op.drop_index(op.f("ix_sistema_operativo_id"), table_name="sistema_operativo")
    op.drop_table("sistema_operativo")
