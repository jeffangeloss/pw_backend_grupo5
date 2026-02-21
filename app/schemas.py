from typing import Optional
from pydantic import BaseModel, Field
from datetime import datetime

class LoginRequest(BaseModel):
    correo: str
    password: str

## USUARIO DEL LADO DEL ADMIN
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

class ResetRequest(BaseModel):
    email: str
    
## EGRESOS

class expenseUpdate(BaseModel):
    amount: Optional[float] = None
    category_id: Optional[str] = None
    expense_date: Optional[datetime] = None
    description: Optional[str] = None