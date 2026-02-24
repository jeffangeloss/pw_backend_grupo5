from datetime import date, datetime, time
from decimal import Decimal
from typing import Optional
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, Field
from sqlalchemy import extract, func
from sqlalchemy.orm import Session, joinedload

from ..database import get_db
from ..models import Category, Expense, User
from ..security import decode_access_token
from ..schemas import ExpenseUpdate

router = APIRouter(
    prefix="/expenses",
    tags=["Expenses"],
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


class ExpenseCreateRequest(BaseModel):
    amount: Decimal = Field(..., gt=0, max_digits=15, decimal_places=2)
    expense_date: date
    description: str = Field(..., min_length=1)
    category_name: str = Field(..., min_length=1, max_length=100)


def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="No autorizado",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = decode_access_token(token)
    except Exception as exc:
        raise credentials_exception from exc

    email = (payload.get("sub") or "").strip().lower()
    if not email:
        raise credentials_exception

    user = db.query(User).filter(User.email == email).first()
    if not user:
        raise credentials_exception
    return user


def _serialize_expense(expense: Expense):
    return {
        "id": str(expense.id),
        "user_id": str(expense.user_id),
        "category_id": str(expense.category_id),
        "category_name": expense.category.name if expense.category else None,
        "amount": float(expense.amount),
        "expense_date": expense.expense_date.isoformat(),
        "description": expense.description,
        "created_at": expense.created_at.isoformat() if expense.created_at else None,
        "updated_at": expense.updated_at.isoformat() if expense.updated_at else None,
    }


def _normalize_category_name(value: str):
    return " ".join(value.strip().split())


@router.post("/", status_code=201)
async def create_expense(
    payload: ExpenseCreateRequest,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    category_name = _normalize_category_name(payload.category_name)
    if not category_name:
        raise HTTPException(status_code=400, detail="Categoria invalida")

    category = (
        db.query(Category)
        .filter(func.lower(Category.name) == category_name.lower())
        .first()
    )

    if not category:
        category = Category(name=category_name)
        db.add(category)
        db.flush()

    clean_description = payload.description.strip()
    if not clean_description:
        raise HTTPException(status_code=400, detail="Descripcion invalida")

    expense = Expense(
        user_id=current_user.id,
        category_id=category.id,
        amount=payload.amount,
        expense_date=datetime.combine(payload.expense_date, time.min),
        description=clean_description,
    )
    db.add(expense)
    db.commit()
    db.refresh(expense)
    expense.category = category

    return {
        "msg": "Egreso registrado",
        "data": _serialize_expense(expense),
    }


@router.get("/")
async def get_expenses(
    current_user: User = Depends(get_current_user),
    category_id: Optional[UUID] = Query(default=None),
    date_from: Optional[datetime] = Query(default=None),
    date_to: Optional[datetime] = Query(default=None),
    amount_min: Optional[float] = Query(default=None, ge=0),
    amount_max: Optional[float] = Query(default=None, ge=0),
    order: str = Query(default="desc", pattern="^(asc|desc)$"),
    db: Session = Depends(get_db),
):
    if date_from and date_to and date_from > date_to:
        raise HTTPException(status_code=400, detail="Rango de fechas invalido")

    if amount_min is not None and amount_max is not None and amount_min > amount_max:
        raise HTTPException(status_code=400, detail="Rango de montos invalido")

    query = (
        db.query(Expense)
        .options(joinedload(Expense.category))
        .filter(Expense.user_id == current_user.id)
    )

    if category_id:
        query = query.filter(Expense.category_id == category_id)
    if date_from:
        query = query.filter(Expense.expense_date >= date_from)
    if date_to:
        query = query.filter(Expense.expense_date <= date_to)
    if amount_min is not None:
        query = query.filter(Expense.amount >= amount_min)
    if amount_max is not None:
        query = query.filter(Expense.amount <= amount_max)

    if order == "asc":
        query = query.order_by(Expense.expense_date.asc())
    else:
        query = query.order_by(Expense.expense_date.desc())
    
    expenses_list = query.all()
    return {
        "msg": "",
        "data": [_serialize_expense(expense) for expense in expenses_list],
    }


@router.get("/categories")
async def get_expense_categories(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    categories = (
        db.query(Category.id, Category.name)
        .join(Expense, Expense.category_id == Category.id)
        .filter(Expense.user_id == current_user.id)
        .distinct()
        .order_by(Category.name.asc())
        .all()
    )

    return {
        "msg": "",
        "data": [{"id": str(category.id), "name": category.name} for category in categories],
    }

@router.put("/{expense_id}")
async def update_expense(
    expense_id: UUID,
    payload: ExpenseUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    expense = (
        db.query(Expense).filter(
            Expense.id == expense_id,
            Expense.user_id == current_user.id
        ).first()
    )
    
    if not expense:
        raise HTTPException(
            status_code=404,
            detail="Egreso no encontrado"
        )
    
    has_changes = False

    if payload.amount is not None:
        expense.amount = payload.amount
        has_changes = True
    
    if payload.category_id is not None:
        category = db.query(Category).filter(Category.id == payload.category_id).first()
        if not category:
            raise HTTPException(status_code=400, detail="Categoria no encontrada")
        expense.category_id = payload.category_id
        has_changes = True

    if payload.expense_date is not None:
        expense.expense_date = payload.expense_date
        has_changes = True

    if payload.description is not None:
        clean_description = payload.description.strip()
        if not clean_description:
            raise HTTPException(status_code=400, detail="Descripcion invalida")
        expense.description = clean_description
        has_changes = True

    if not has_changes:
        raise HTTPException(status_code=400, detail="No hay cambios para actualizar")
    
    expense.updated_at = datetime.utcnow()
    
    db.commit()
    db.refresh(expense)
    
    return {
        "msg" : "Egreso actualizado",
        "data" : _serialize_expense(expense)
    }

@router.delete("/{expense_id}")
async def delete_expense(
    expense_id: UUID,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    expense = (
        db.query(Expense).filter(
            Expense.id == expense_id,
            Expense.user_id == current_user.id
        ).first()
    )
    
    if not expense:
        raise HTTPException(
            status_code=404,
            detail="Egreso no encontrado"
        )
    
    db.delete(expense)
    db.commit()
    
    return {
        "msg" : "Egreso eliminado"
    }

@router.get("/stats")
async def get_expenses_stats(
    year: Optional[int] = Query(default=None, ge=1900, le=9999),
    month: Optional[int] = Query(default=None, ge=1, le=12),
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    db_query = db.query(Expense).filter(Expense.user_id == current_user.id)

    # Filtrado por año
    if year:
        db_query = db_query.filter(extract("year", Expense.expense_date) == year)

    # filtrado por mes
    if month:
        db_query = db_query.filter(extract("month", Expense.expense_date) == month)
    
    # total general
    total_general = (
        db_query.with_entities(
            func.coalesce(func.sum(Expense.amount), 0)
        ).scalar()
    )

    # total por mes
    monthly_rows = (
        db_query.with_entities(
            extract("month", Expense.expense_date).label("month"),
            func.sum(Expense.amount).label("total")
        )
        .group_by("month")
        .order_by("month")
        .all()
    )

    monthly = [
        {
            "month": int(row.month),
            "total": float(row.total)
        }
        for row in monthly_rows
    ]

    # total por categoria
    category_query = (
    db.query(
        Category.name.label("category"),
        func.sum(Expense.amount).label("total")
    )
    .join(Expense, Expense.category_id == Category.id)
    .filter(Expense.user_id == current_user.id)
    )

    if year:
        category_query = category_query.filter(extract("year", Expense.expense_date) == year)

    if month:
        category_query = category_query.filter(extract("month", Expense.expense_date) == month)

    category_rows = (
        category_query
        .group_by(Category.name)
        .order_by(func.sum(Expense.amount).desc())
        .all()
        )

    by_category = [
        {
            "category": row.category,
            "total": float(row.total)
        }
        for row in category_rows
    ]

    # total por mes y categoria (para stacked bar)
    monthly_category_rows = (
        db.query(
            extract("month", Expense.expense_date).label("month"),
            Category.name.label("category"),
            func.sum(Expense.amount).label("total")
        )
        .join(Category, Expense.category_id == Category.id)
        .filter(Expense.user_id == current_user.id)
    )

    if year:
        monthly_category_rows = monthly_category_rows.filter(extract("year", Expense.expense_date) == year)

    if month:
        monthly_category_rows = monthly_category_rows.filter(extract("month", Expense.expense_date) == month)

    monthly_category_rows = (
        monthly_category_rows
        .group_by("month", Category.name)
        .order_by("month")
        .all()
    )

    monthly_by_category = [
        {
            "month": int(row.month),
            "category": row.category,
            "total": float(row.total)
        }
        for row in monthly_category_rows
    ]

    return {
        "total": float(total_general or 0),
        "monthly": monthly,
        "by_category": by_category,
        "monthly_by_category": monthly_by_category
    }


