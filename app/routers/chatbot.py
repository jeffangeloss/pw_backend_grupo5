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

router = APIRouter(prefix="/chat", tags=["Chatbot"])

logger = logging.getLogger("chatbot")
model = None

sessions: Dict[str, dict] = {}
SESSION_TIMEOUT = 1800
MAX_CHAT_HISTORY = 3  # ultimos 3 turnos
MAX_EXPENSES_CONTEXT = 10  # ultimos 10 egresos
MAX_ACTIVE_SESSIONS = 20
lock = threading.Lock()


def _resolve_api_key():
    return (os.getenv("GEMINI_API_KEY") or "").strip()


def _resolve_model_name():
    return (os.getenv("GEMINI_MODEL") or "gemini-2.5-flash-lite").strip()


def _get_model():
    global model
    if model is not None:
        return model

    api_key = _resolve_api_key()
    if not api_key:
        raise HTTPException(
            status_code=503,
            detail="Chatbot no configurado: falta GEMINI_API_KEY",
        )

    try:
        genai.configure(api_key=api_key)
        model = genai.GenerativeModel(_resolve_model_name())
    except Exception as exc:
        logger.exception("No se pudo inicializar el modelo Gemini")
        raise HTTPException(status_code=503, detail="Chatbot no disponible temporalmente") from exc

    return model


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

    total_general = db_query.with_entities(func.coalesce(func.sum(Expense.amount), 0)).scalar()

    monthly_rows = db_query.with_entities(
        extract("month", Expense.expense_date).label("month"),
        func.sum(Expense.amount).label("total")
    ).group_by("month").order_by("month").all()

    monthly = [{"month": int(row.month), "total": float(row.total)} for row in monthly_rows]

    category_rows = (
        db.query(Category.name.label("category"), func.sum(Expense.amount).label("total"))
        .join(Expense, Expense.category_id == Category.id)
        .filter(Expense.user_id == current_user.id)
    )
    if year:
        category_rows = category_rows.filter(extract("year", Expense.expense_date) == year)
    if month:
        category_rows = category_rows.filter(extract("month", Expense.expense_date) == month)

    category_rows = category_rows.group_by(Category.name).order_by(func.sum(Expense.amount).desc()).all()
    by_category = [{"category": row.category, "total": float(row.total)} for row in category_rows]

    return {"total": float(total_general or 0), "monthly": monthly, "by_category": by_category}


def _get_recent_expenses(current_user: User, db: Session):
    rows = (
        db.query(
            Expense.amount.label("amount"),
            Expense.expense_date.label("expense_date"),
            Category.name.label("category"),
        )
        .outerjoin(Category, Expense.category_id == Category.id)
        .filter(Expense.user_id == current_user.id)
        .order_by(Expense.expense_date.desc())
        .limit(MAX_EXPENSES_CONTEXT)
        .all()
    )

    return [
        {
            "amount": float(row.amount or 0),
            "category": row.category or "Sin categoria",
            "date": str(row.expense_date),
        }
        for row in rows
    ]


def _format_history(history: list[dict]):
    if not history:
        return "Sin historial."

    lines = []
    for item in history:
        role = item.get("role", "user")
        text = (item.get("text") or "").strip()
        lines.append(f"{role}: {text}")
    return "\n".join(lines)


def _build_prompt(*, user_message: str, stats: dict, expenses: list[dict], history: list[dict]):
    return f"""
Eres un asesor financiero personal.
Responde en espanol, de forma clara y breve.
Usa SOLO los datos del CONTEXTO ACTUAL para responder.
Si te preguntan por categorias (por ejemplo alimentacion), usa by_category.
No pidas al usuario que clasifique egresos si ya hay categorias en el contexto.
Si falta informacion en el contexto, dilo de forma explicita.

FECHA_ACTUAL: {datetime.datetime.today()}

CONTEXTO ACTUAL:
ESTADISTICAS:
{stats}

ULTIMOS EGRESOS:
{expenses}

HISTORIAL RECIENTE:
{_format_history(history)}

PREGUNTA ACTUAL:
{user_message}
""".strip()


@router.post("/")
async def chat(request: ChatRequest, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    try:
        current_model = _get_model()
        cleanup_sessions()
        user_id = str(user.id)

        with lock:
            if len(sessions) >= MAX_ACTIVE_SESSIONS and user_id not in sessions:
                oldest = min(sessions.items(), key=lambda x: x[1]["last_used"])[0]
                del sessions[oldest]

            if user_id not in sessions:
                sessions[user_id] = {"history": [], "last_used": time.time()}

            user_session = sessions[user_id]
            user_session["last_used"] = time.time()
            user_session["history"].append({"role": "user", "text": request.message})
            user_session["history"] = user_session["history"][-(MAX_CHAT_HISTORY * 2):]
            history_for_prompt = list(user_session["history"])

        stats = get_expenses_stats(current_user=user, db=db)
        expenses_list = _get_recent_expenses(current_user=user, db=db)
        prompt = _build_prompt(
            user_message=request.message,
            stats=stats,
            expenses=expenses_list,
            history=history_for_prompt,
        )

        response = current_model.generate_content(
            prompt,
            generation_config={"temperature": 0.4, "max_output_tokens": 300},
        )

        if not response or not response.text:
            raise HTTPException(500, "Respuesta vacia del modelo")

        reply_text = response.text
        with lock:
            if user_id in sessions:
                sessions[user_id]["history"].append({"role": "model", "text": reply_text})
                sessions[user_id]["history"] = sessions[user_id]["history"][-(MAX_CHAT_HISTORY * 2):]

        return {"text": reply_text}

    except HTTPException:
        raise
    except Exception:
        logger.exception("Error en chatbot")
        raise HTTPException(500, "Error generando respuesta")
