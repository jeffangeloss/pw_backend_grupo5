from typing import Optional
from pydantic import BaseModel, Field

class LoginRequest(BaseModel):
    correo: str
    password: str

## USUARIO
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