from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)

class LoginRequest(BaseModel):
    correo: str
    password: str

@app.post("/login")
async def login(login_request: LoginRequest):
    # Credenciales hardcodeadas por el momento, luego BD y encriptamiento
    if login_request.correo == "ejemplo@admin.com" and login_request.password == "admin1234":
        return {"msg": "Acceso concedido", "rol": "admin"}

    if login_request.correo == "ejemplo@user.com" and login_request.password == "user1234":
        return {"msg": "Acceso concedido", "rol": "user"}  # usa "user" para que sea consistente

    raise HTTPException(status_code=400, detail="Credenciales incorrectas")
