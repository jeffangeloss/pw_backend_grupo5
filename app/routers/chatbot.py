from fastapi import APIRouter, Depends, HTTPException, Query, status
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, Field
import google.generativeai as genai
import os
from typing import Dict, Optional
from dotenv import load_dotenv
import time
from sqlalchemy import extract, func
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Category, Expense, User
from app.security import decode_access_token
import threading
import logging

load_dotenv()

API_KEY = os.getenv("GEMINI_API_KEY")
if not API_KEY:
    raise RuntimeError("Falta GEMINI_API_KEY")

genai.configure(api_key=API_KEY)
model = genai.GenerativeModel("gemini-2.5-flash-lite")

router = APIRouter(prefix="/chat", tags=["Chatbot"])

logger = logging.getLogger("chatbot")

sessions: Dict[str, dict] = {}
SESSION_TIMEOUT = 1800
lock = threading.Lock()


class ChatRequest(BaseModel):
    message: str = Field(..., min_length=1, max_length=2000)


def cleanup_sessions():
    now = time.time()
    with lock:
        expired = [
            uid for uid, data in sessions.items()
            if now - data["last_used"] > SESSION_TIMEOUT
        ]
        for uid in expired:
            del sessions[uid]


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


def _get_user_from_token(token: str, db: Session) -> User | None:
    try:
        payload = decode_access_token(token)
    except Exception:
        return None

    email = (payload.get("sub") or "").strip().lower()
    if not email:
        return None

    return db.query(User).filter(User.email == email).first()


def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    user = _get_user_from_token(token, db)

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="No autorizado",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return user


def get_expenses_stats(
    current_user: User,
    db: Session,
    year: Optional[int] = None,
    month: Optional[int] = None
):
    db_query = db.query(Expense).filter(Expense.user_id == current_user.id)

    if year:
        db_query = db_query.filter(extract("year", Expense.expense_date) == year)

    if month:
        db_query = db_query.filter(extract("month", Expense.expense_date) == month)

    total_general = (
        db_query.with_entities(
            func.coalesce(func.sum(Expense.amount), 0)
        ).scalar()
    )

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
        {"month": int(row.month), "total": float(row.total)}
        for row in monthly_rows
    ]

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
        {"category": row.category, "total": float(row.total)}
        for row in category_rows
    ]

    return {
        "total": float(total_general or 0),
        "monthly": monthly,
        "by_category": by_category
    }


@router.post("/")
async def chat(
    request: ChatRequest,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    try:
        cleanup_sessions()
        user_id = str(user.id)

        with lock:
            if user_id not in sessions:

                stats = get_expenses_stats(current_user=user, db=db)

                expenses = (
                    db.query(Expense)
                    .filter(Expense.user_id == user.id)
                    .order_by(Expense.expense_date.desc())
                    .limit(50)
                    .all()
                )

                expenses_list = [
                    {
                        "amount": float(e.amount),
                        "category": e.category.name if e.category else None,
                        "date": str(e.expense_date)
                    }
                    for e in expenses
                ]

                contexto = f"""
Eres un asesor financiero personal.
Responde siempre breve y directo.

ESTADISTICAS:
{stats}

ULTIMOS EGRESOS:
{expenses_list}
"""

                sessions[user_id] = {
                    "chat": model.start_chat(
                        history=[{"role": "user", "parts": [contexto]}]
                    ),
                    "last_used": time.time()
                }

            user_session = sessions[user_id]
            user_session["last_used"] = time.time()

        response = user_session["chat"].send_message(
            request.message,
            generation_config={
                "temperature": 0.4,
                "max_output_tokens": 1000
            }
        )

        if not response or not response.text:
            raise HTTPException(500, "Respuesta vacía del modelo")

        return {"text": response.text}

    except HTTPException:
        raise

    except Exception as e:
        logger.exception("Error en chatbot")
        raise HTTPException(500, "Error generando respuesta")