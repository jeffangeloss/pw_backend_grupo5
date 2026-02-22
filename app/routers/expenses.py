from datetime import date, datetime, time
from decimal import Decimal
from typing import Optional
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, Field
from sqlalchemy import func
from sqlalchemy.orm import Session, joinedload

from ..database import get_db
from ..models import Category, Expense, User
from ..security import decode_access_token

router = APIRouter(
    prefix="/expenses",
    tags=["Expenses"],
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


class ExpenseCreateRequest(BaseModel):
    amount: Decimal = Field(..., gt=0)
    expense_date: date
    description: str = Field(..., min_length=1, max_length=1000)
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

    expense = Expense(
        user_id=current_user.id,
        category_id=category.id,
        amount=payload.amount,
        expense_date=datetime.combine(payload.expense_date, time.min),
        description=payload.description.strip(),
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
    db: Session = Depends(get_db),
):
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

    expenses_list = query.order_by(Expense.expense_date.desc()).all()
    return {
        "msg": "",
        "data": [_serialize_expense(expense) for expense in expenses_list],
    }
