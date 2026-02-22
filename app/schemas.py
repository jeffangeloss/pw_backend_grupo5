from typing import Optional

from pydantic import BaseModel, EmailStr, Field


class LoginRequest(BaseModel):
    username: Optional[EmailStr] = None
    correo: Optional[EmailStr] = None
    password: str = Field(..., min_length=8)


class UserOut(BaseModel):
    id: str
    full_name: str
    email: EmailStr
    role: str


class UserCreate(BaseModel):
    full_name: str = Field(..., min_length=1, max_length=300)
    email: EmailStr
    password: str = Field(..., min_length=8)
    type: int = Field(..., ge=1, le=2)


class UserUpdate(BaseModel):
    full_name: Optional[str] = Field(None, min_length=1, max_length=300)
    email: Optional[EmailStr] = None
    password: Optional[str] = Field(None, min_length=8)
    type: Optional[int] = Field(None, ge=1, le=2)


class ResetRequest(BaseModel):
    email: EmailStr


class ResetConfirmRequest(BaseModel):
    token: str = Field(..., min_length=10)
    password: str = Field(..., min_length=8)
