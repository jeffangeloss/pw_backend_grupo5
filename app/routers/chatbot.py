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
MAX_CHAT_HISTORY = 3
MAX_EXPENSES_CONTEXT = 10
MAX_ACTIVE_SESSIONS = 20
lock = threading.Lock()


def _resolve_api_key() -> str:
    return (os.getenv("GEMINI_API_KEY") or "").strip()


def _resolve_model_name() -> str:
    return (os.getenv("GEMINI_MODEL") or "gemini-2.5-flash-lite").strip()


def _resolve_max_output_tokens() -> int:
    raw = (os.getenv("CHAT_MAX_OUTPUT_TOKENS") or "700").strip()
    try:
        value = int(raw)
    except ValueError:
        value = 700
    return max(128, min(value, 2048))


MAX_OUTPUT_TOKENS = _resolve_max_output_tokens()


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
Responde de forma amigable y clara, como un asistente util y concreto.
No dejes frases incompletas.
Hoy dia es {datetime.datetime.today()}.

ESTADISTICAS:
{stats}

ULTIMOS EGRESOS:
{expenses_list}
"""

                sessions[user_id] = {
                    "chat": current_model.start_chat(
                        history=[{"role": "model", "parts": [f"Contexto de trabajo:\n{contexto}"]}]
                    ),
                    "last_used": time.time(),
                }

            user_session = sessions[user_id]
            user_session["last_used"] = time.time()

            try:
                chat_history = user_session["chat"].history[-MAX_CHAT_HISTORY:]
                user_session["chat"].history = chat_history
            except Exception:
                pass

        response = user_session["chat"].send_message(
            request.message,
            generation_config={"temperature": 0.4, "max_output_tokens": MAX_OUTPUT_TOKENS},
        )

        if not response or not response.text:
            raise HTTPException(500, "Respuesta vacia del modelo")

        text = response.text

        # If output was cut by token limit, ask for a short continuation.
        if _response_cut_by_tokens(response):
            continuation = user_session["chat"].send_message(
                "Continua exactamente donde te quedaste, sin repetir, y cierra con una frase completa.",
                generation_config={"temperature": 0.2, "max_output_tokens": 220},
            )
            if continuation and continuation.text:
                text = f"{text.rstrip()}\n{continuation.text.strip()}"

        return {"text": text}

    except HTTPException:
        raise
    except Exception:
        logger.exception("Error en chatbot")
        raise HTTPException(500, "Error generando respuesta")
