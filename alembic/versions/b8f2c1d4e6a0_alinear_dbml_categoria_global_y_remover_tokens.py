"""alinear dbml categoria global y remover tokens

Revision ID: b8f2c1d4e6a0
Revises: a9f2d8c1e3b4
Create Date: 2026-02-22 22:10:00.000000

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql


# revision identifiers, used by Alembic.
revision: str = "b8f2c1d4e6a0"
down_revision: Union[str, Sequence[str], None] = "a9f2d8c1e3b4"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


TARGET_ACCESS_EVENT_VALUES = [
    "LOGIN_SUCCESS",
    "LOGIN_FAIL",
    "LOGOUT",
    "PASSWORD_RESET_REQUEST",
    "PASSWORD_RESET_SUCCESS",
    "EMAIL_VERIFY_SENT",
    "EMAIL_VERIFY_SUCCESS",
    "ACCOUNT_DISABLED",
    "ACCOUNT_ENABLED",
]


def _enum_labels(bind, enum_name: str) -> list[str]:
    rows = bind.execute(
        sa.text(
            """
            SELECT e.enumlabel
            FROM pg_type t
            JOIN pg_namespace n ON n.oid = t.typnamespace
            JOIN pg_enum e ON e.enumtypid = t.oid
            WHERE t.typname = :enum_name
            ORDER BY e.enumsortorder
            """
        ),
        {"enum_name": enum_name},
    ).fetchall()
    return [row[0] for row in rows]


def upgrade() -> None:
    bind = op.get_bind()
    inspector = sa.inspect(bind)

    table_names = set(inspector.get_table_names())
    if "user_token" in table_names:
        op.drop_table("user_token")
    if "token_device" in table_names:
        op.drop_table("token_device")

    op.execute(sa.text("DROP TYPE IF EXISTS token_status"))

    labels = _enum_labels(bind, "access_event_type")
    if labels and labels != TARGET_ACCESS_EVENT_VALUES:
        if "access_log" in table_names:
            op.execute(
                sa.text(
                    """
                    UPDATE access_log
                    SET event_type = 'LOGIN_SUCCESS'
                    WHERE event_type::text = 'PIN_2FA_SUCCESS'
                    """
                )
            )
            op.execute(
                sa.text(
                    """
                    UPDATE access_log
                    SET event_type = 'LOGIN_FAIL'
                    WHERE event_type::text = 'PIN_2FA_FAIL'
                    """
                )
            )

        op.execute(sa.text("ALTER TYPE access_event_type RENAME TO access_event_type_old"))
        postgresql.ENUM(*TARGET_ACCESS_EVENT_VALUES, name="access_event_type").create(
            bind,
            checkfirst=True,
        )
        if "access_log" in table_names:
            op.execute(
                sa.text(
                    """
                    ALTER TABLE access_log
                    ALTER COLUMN event_type TYPE access_event_type
                    USING event_type::text::access_event_type
                    """
                )
            )
        op.execute(sa.text("DROP TYPE access_event_type_old"))

    inspector = sa.inspect(bind)
    table_names = set(inspector.get_table_names())

    if "category" in table_names:
        category_columns = {column["name"] for column in inspector.get_columns("category")}
        if "user_id" in category_columns:
            duplicates = bind.execute(
                sa.text(
                    """
                    SELECT name
                    FROM category
                    GROUP BY name
                    HAVING COUNT(*) > 1
                    """
                )
            ).fetchall()
            if duplicates:
                duplicate_names = ", ".join(row[0] for row in duplicates[:5])
                raise RuntimeError(
                    "No se puede migrar category a global; hay nombres duplicados. "
                    f"Ejemplos: {duplicate_names}"
                )

            if "expense" in table_names:
                for fk in inspector.get_foreign_keys("expense"):
                    if (
                        fk.get("referred_table") == "category"
                        and "user_id" in (fk.get("constrained_columns") or [])
                        and fk.get("name")
                    ):
                        op.drop_constraint(fk["name"], "expense", type_="foreignkey")

            for uq in inspector.get_unique_constraints("category"):
                if "user_id" in (uq.get("column_names") or []) and uq.get("name"):
                    op.drop_constraint(uq["name"], "category", type_="unique")

            for fk in inspector.get_foreign_keys("category"):
                if (
                    fk.get("constrained_columns") == ["user_id"]
                    and fk.get("name")
                ):
                    op.drop_constraint(fk["name"], "category", type_="foreignkey")

            op.drop_column("category", "user_id")

        inspector = sa.inspect(bind)
        unique_constraints = inspector.get_unique_constraints("category")
        has_unique_name = any(
            set(uq.get("column_names") or []) == {"name"} for uq in unique_constraints
        )
        if not has_unique_name:
            op.create_unique_constraint("uq_category_name", "category", ["name"])

    inspector = sa.inspect(bind)
    if "expense" in inspector.get_table_names():
        has_category_fk = any(
            fk.get("referred_table") == "category"
            and (fk.get("constrained_columns") or []) == ["category_id"]
            for fk in inspector.get_foreign_keys("expense")
        )
        if not has_category_fk:
            op.create_foreign_key(
                "fk_expense_category_id_category",
                "expense",
                "category",
                ["category_id"],
                ["id"],
            )


def downgrade() -> None:
    raise NotImplementedError(
        "Downgrade no soportado: revertir category global a category por usuario requiere decision de negocio."
    )
