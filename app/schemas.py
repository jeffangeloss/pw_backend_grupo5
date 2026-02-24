from typing import Optional

from pydantic import BaseModel, EmailStr, Field

from datetime import datetime

from uuid import UUID


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
    type: int = Field(..., ge=1, le=4)


class UserUpdate(BaseModel):
    full_name: Optional[str] = Field(None, min_length=1, max_length=300)
    email: Optional[EmailStr] = None
    password: Optional[str] = Field(None, min_length=8)
    type: Optional[int] = Field(None, ge=1, le=4)

class ResetRequest(BaseModel):
    email: EmailStr
    
class VerifRequest(BaseModel):
    email: EmailStr
    
class TokenRequest(BaseModel):
    token: str

class ResetForm(BaseModel):
    token: str = Field(..., min_length=10)
    password: str = Field(..., min_length=8)

class ExpenseUpdate(BaseModel):
    amount: Optional[float] = None
    category_id: Optional[UUID] = None
    expense_date: Optional[datetime] = None
    description: Optional[str] = None

class CategoryOut(BaseModel):
    id: UUID
    name: str

    class Config:
        from_attributes = True