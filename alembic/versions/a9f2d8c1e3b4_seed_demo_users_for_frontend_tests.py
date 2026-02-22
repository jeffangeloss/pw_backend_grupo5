"""seed demo users for frontend tests

Revision ID: a9f2d8c1e3b4
Revises: 096705cc8648
Create Date: 2026-02-22 20:00:00.000000

"""

from typing import Sequence, Union
import uuid

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql
from pwdlib import PasswordHash


# revision identifiers, used by Alembic.
revision: str = "a9f2d8c1e3b4"
down_revision: Union[str, Sequence[str], None] = "096705cc8648"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Seed demo users for local/frontend testing."""
    bind = op.get_bind()
    hasher = PasswordHash.recommended()

    user_table = sa.table(
        "user",
        sa.column("id", sa.UUID()),
        sa.column("full_name", sa.String(length=300)),
        sa.column("email", sa.String(length=100)),
        sa.column("password_hash", sa.String(length=300)),
        sa.column(
            "role",
            postgresql.ENUM("user", "admin", name="user_role", create_type=False),
        ),
        sa.column("email_verified", sa.Boolean()),
        sa.column("is_active", sa.Boolean()),
    )

    rows = [
        {
            "id": uuid.uuid4(),
            "full_name": "Usuario Demo",
            "email": "ejemplo@user.com",
            "password_hash": hasher.hash("user1234"),
            "role": "user",
            "email_verified": True,
            "is_active": True,
        },
        {
            "id": uuid.uuid4(),
            "full_name": "Admin Demo",
            "email": "ejemplo@admin.com",
            "password_hash": hasher.hash("admin1234"),
            "role": "admin",
            "email_verified": True,
            "is_active": True,
        },
    ]

    stmt = postgresql.insert(user_table).values(rows)
    stmt = stmt.on_conflict_do_update(
        index_elements=["email"],
        set_={
            "full_name": stmt.excluded.full_name,
            "password_hash": stmt.excluded.password_hash,
            "role": stmt.excluded.role,
            "email_verified": stmt.excluded.email_verified,
            "is_active": stmt.excluded.is_active,
        },
    )
    bind.execute(stmt)


def downgrade() -> None:
    """Remove demo users."""
    user_table = sa.table(
        "user",
        sa.column("email", sa.String(length=100)),
    )
    op.execute(
        user_table.delete().where(
            user_table.c.email.in_(["ejemplo@user.com", "ejemplo@admin.com"])
        )
    )
