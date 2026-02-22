from datetime import datetime
from typing import Optional
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session

from ..database import get_db
from ..models import Category, Expense, User
from ..security import decode_access_token

router = APIRouter(
    prefix="/expenses",
    tags=["Expenses"],
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


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


@router.get("/categories")
async def get_categories(
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


@router.get("/")
async def get_expenses(
    current_user: User = Depends(get_current_user),
    category_id: Optional[UUID] = Query(default=None),
    date_from: Optional[datetime] = Query(default=None),
    date_to: Optional[datetime] = Query(default=None),
    amount_min: Optional[float] = Query(default=None, ge=0),
    amount_max: Optional[float] = Query(default=None, ge=0),
    db: Session = Depends(get_db),
):
    query = db.query(Expense).filter(Expense.user_id == current_user.id)

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

    expenses_list = query.order_by(Expense.expense_date.desc()).all()
    return {
        "msg": "",
        "data": [_serialize_expense(expense) for expense in expenses_list],
    }
