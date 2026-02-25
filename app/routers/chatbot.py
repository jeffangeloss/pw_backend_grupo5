from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, Field
import google.generativeai as genai
import os
from typing import Dict, Optional
import time
from sqlalchemy import extract, func
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Category, Expense, User
from app.security import decode_access_token
import threading
import logging
import datetime
import hashlib

router = APIRouter(prefix="/chat", tags=["Chatbot"])

logger = logging.getLogger("chatbot")

SESSION_TIMEOUT = 900
MAX_EXPENSES_CONTEXT = 5
MAX_ACTIVE_SESSIONS = 5

sessions: Dict[str, dict] = {}
lock = threading.Lock()


def _resolve_api_key() -> str:
    return (os.getenv("GEMINI_API_KEY") or "").strip()


def _resolve_model_name() -> str:
    return (os.getenv("GEMINI_MODEL") or "gemini-2.5-flash-lite").strip()


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


def _get_user_from_token(token: str, db: Session) -> Optional[User]:
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

    if not user or not user.is_active or not user.email_verified:
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

    total_general = db_query.with_entities(
        func.coalesce(func.sum(Expense.amount), 0)
    ).scalar()

    monthly_rows = db_query.with_entities(
        extract("month", Expense.expense_date).label("month"),
        func.sum(Expense.amount).label("total")
    ).group_by("month").order_by("month").all()

    monthly = [
        {"month": int(row.month), "total": float(row.total)}
        for row in monthly_rows
    ]

    category_rows = (
        db.query(Category.name.label("category"),
                 func.sum(Expense.amount).label("total"))
        .join(Expense, Expense.category_id == Category.id)
        .filter(Expense.user_id == current_user.id)
    )

    if year:
        category_rows = category_rows.filter(
            extract("year", Expense.expense_date) == year
        )
    if month:
        category_rows = category_rows.filter(
            extract("month", Expense.expense_date) == month
        )

    category_rows = (
        category_rows
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
        "by_category": by_category,
    }


def _response_cut_by_tokens(response) -> bool:
    try:
        candidates = getattr(response, "candidates", None) or []
        if not candidates:
            return False

        reason = getattr(candidates[0], "finish_reason", None)
        if reason is None:
            return False

        reason_text = str(reason).upper()
        return "MAX_TOKENS" in reason_text or str(reason) == "2"
    except Exception:
        return False


@router.post("/")
async def chat(
    request: ChatRequest,
    user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    try:
        cleanup_sessions()
        user_id = str(user.id)

        with lock:
            if len(sessions) >= MAX_ACTIVE_SESSIONS and user_id not in sessions:
                oldest = min(
                    sessions.items(),
                    key=lambda x: x[1]["last_used"]
                )[0]
                del sessions[oldest]

        stats = get_expenses_stats(current_user=user, db=db)

        expenses = (
            db.query(Expense)
            .filter(Expense.user_id == user.id)
            .order_by(Expense.expense_date.desc())
            .limit(MAX_EXPENSES_CONTEXT)
            .all()
        )

        expenses_list = [
            {
                "amount": float(e.amount),
                "category": e.category.name if e.category else None,
                "date": str(e.expense_date),
            }
            for e in expenses
        ]

        contexto = f"""
Eres un asesor financiero personal.
Responde claro, breve y útil.
No dejes frases incompletas.
Hoy es {datetime.datetime.today()}.

ESTADISTICAS:
{stats}

ULTIMOS EGRESOS:
{expenses_list}
"""

        raw_context = str(stats) + str(expenses_list)
        context_hash = hashlib.md5(raw_context.encode()).hexdigest()

        with lock:
            session = sessions.get(user_id)

            if session is None or session["context_hash"] != context_hash:
                sessions[user_id] = {
                    "context": contexto,
                    "context_hash": context_hash,
                    "last_used": time.time(),
                }
            else:
                sessions[user_id]["last_used"] = time.time()

        api_key = _resolve_api_key()
        if not api_key:
            raise HTTPException(
                status_code=503,
                detail="Falta GEMINI_API_KEY",
            )

        genai.configure(api_key=api_key)

        model = genai.GenerativeModel(
            model_name=_resolve_model_name(),
            system_instruction=sessions[user_id]["context"],
        )

        chat = model.start_chat()

        response = chat.send_message(
            request.message,
            generation_config={
                "temperature": 0.4,
                "max_output_tokens": 500,
            },
        )

        if not response or not response.text:
            raise HTTPException(500, "Respuesta vacía del modelo")

        text = response.text

        if _response_cut_by_tokens(response):
            continuation = chat.send_message(
                "Continúa exactamente donde te quedaste y cierra la idea.",
                generation_config={
                    "temperature": 0.2,
                    "max_output_tokens": 200,
                },
            )

            if continuation and continuation.text:
                text = f"{text.rstrip()}\n{continuation.text.strip()}"

        return {"text": text}

    except HTTPException:
        raise
    except Exception:
        logger.exception("Error en chatbot")
        raise HTTPException(500, "Error generando respuesta")
