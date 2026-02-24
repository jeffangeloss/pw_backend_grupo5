from datetime import datetime
from decimal import Decimal
from typing import Optional
from uuid import UUID

from pydantic import AliasChoices, BaseModel, EmailStr, Field


class LoginRequest(BaseModel):
    email: EmailStr = Field(
        ...,
        max_length=100,
        validation_alias=AliasChoices("email", "correo", "username"),
    )
    password: str = Field(..., min_length=8, max_length=300)


class UserOut(BaseModel):
    id: str
    full_name: str
    email: EmailStr
    role: str


class UserCreate(BaseModel):
    full_name: str = Field(..., min_length=1, max_length=300)
    email: EmailStr = Field(..., max_length=100)
    password: str = Field(..., min_length=8, max_length=300)
    type: int = Field(..., ge=1, le=4)


class UserUpdate(BaseModel):
    full_name: Optional[str] = Field(None, min_length=1, max_length=300)
    email: Optional[EmailStr] = Field(default=None, max_length=100)
    password: Optional[str] = Field(None, min_length=8, max_length=300)
    type: Optional[int] = Field(None, ge=1, le=4)

class ResetRequest(BaseModel):
    email: EmailStr = Field(..., max_length=100)

class ResetForm(BaseModel):
    token: str = Field(..., min_length=10, max_length=255)
    password: str = Field(..., min_length=8, max_length=300)

class ExpenseUpdate(BaseModel):
    amount: Optional[Decimal] = Field(default=None, gt=0, max_digits=15, decimal_places=2)
    category_id: Optional[UUID] = None
    expense_date: Optional[datetime] = None
    description: Optional[str] = Field(default=None, min_length=1)

class CategoryOut(BaseModel):
    id: UUID
    name: str

    class Config:
        from_attributes = True
