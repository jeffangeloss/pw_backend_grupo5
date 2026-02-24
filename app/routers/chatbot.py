from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, Field
import google.generativeai as genai
import os
from typing import Dict
from dotenv import load_dotenv
import time
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import User
from app.security import decode_access_token
import threading
import logging

load_dotenv()

API_KEY = os.getenv("GEMINI_API_KEY")
if not API_KEY:
    raise RuntimeError("Falta GEMINI_API_KEY")

genai.configure(api_key=API_KEY)
model = genai.GenerativeModel("gemini-2.5-flash")

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
    token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    user = _get_user_from_token(token, db)

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="No autorizado",
            headers={"WWW-Authenticate": "Bearer"},
        )

    return user

@router.post("/")
async def chat(
    request: ChatRequest, user: User = Depends(get_current_user)):
    try:
        cleanup_sessions()
        user_id = str(user.id)

        with lock:
            if user_id not in sessions:
                sessions[user_id] = {
                    "chat": model.start_chat(history=[]),
                    "last_used": time.time()
                }

            user_session = sessions[user_id]
            user_session["last_used"] = time.time()

        response = user_session["chat"].send_message(request.message)

        if not response or not response.text:
            raise HTTPException(500, "Respuesta vacía del modelo")

        return {"text": response.text}

    except HTTPException:
        raise

    except Exception as e:
        logger.exception("Error en chatbot")
        raise HTTPException(500, "Error generando respuesta")