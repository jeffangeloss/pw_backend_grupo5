from typing import Optional
from fastapi import HTTPException, APIRouter, Query, Header
from pydantic import BaseModel, Field
from sqlalchemy.orm import Session
from uuid import uuid4
import datetime

router = APIRouter(
    prefix="/users",
    tags=["Users"]
)

class User(BaseModel):
    id: str
    name: str
    email: str
    password: str
    type: int = Field(..., ge = 1, le = 2)

class UserCreate(BaseModel):
    name: str
    email: str
    password: str
    type: int = Field(..., ge=1, le=2)

class UserUpdate(BaseModel):
    name: Optional[str] = None
    email: Optional[str] = None
    password: Optional[str] = None
    type: Optional[int] = Field(None, ge = 1, le = 2)

users: list[User] = []

@router.put("/")
async def add_user(user: UserCreate):
    newUser = User(
        id = str(uuid4()),
        name = user.name,
        email = user.email,
        password = user.password,
        type = user.type
    )
    users.append(newUser)
    return {
        "msg": "",
        "user": newUser
    }

@router.get("/{user_id}")
async def get_user(user_id: str):
    for user in users:
        if user.id == user_id:
            return {
                "msg": "",
                "data": user
            }
    raise HTTPException(
        status_code=404,
        detail="User id no encontrado.")

@router.get("/")
async def get_users(user_type: Optional[int] = Query(default=None, ge=1, le=2)):
    if user_type is None:
        return {
            "msg": "",
            "data": users
        }
    usersFiltro: list[User] = []
    for user in users:
        if user.type == user_type:
            usersFiltro.append(user)
    return {
        "msg": "",
        "data": usersFiltro
    }

@router.patch("/{user_id}")
async def update_user(UpdatedUser: UserUpdate, user_id: str):
    for user in users:
        if user.id == user_id:
            # Por implementar
            return {
                "msg": "",
                "data": user
            }
    raise HTTPException(
        status_code=404,
        detail="User id no encontrado.")

@router.delete("/{user_id}")
async def delete_user(user_id: str):
    for index, user in enumerate(users):
        if user.id == user_id:
            users.pop(index)
            return {
                "msg": "User borrado correctamente.",
            }
    raise HTTPException(
        status_code=404,
        detail="User id no encontrado."
    )

@router.get("/auditoria/{user_id}")
async def get_logs_user(user_id: str):
    pass