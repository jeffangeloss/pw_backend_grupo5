from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from uuid import uuid4

app = FastAPI()

# Esto es inseguro, pero lo hacemos por ahora
origins = [
    "*"
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_methods=["*"],
    allow_headers=["*"]
)

class LoginRequest(BaseModel):
    username : str = Field(..., min_length=5)
    password : str = Field(..., min_length=8)
    

# Muchas personas se conectan a la vez, en el mismo momento
# Tú mismo quieres que el backend genere el uuid → es por eso es que tú desde el cliente NO tienes
# que enviarle el uuid

# pero si quieres modificar o eliminar... aquí si tienes que pasarle
# Creación es None → si lo vas a editar será str
class Categoria(BaseModel):
    id : str | None = None
    nombre : str
class videoJuego(BaseModel):
    id : str | None = None
    nombre : str
    descripcion: str
    url_imagen: str
    categoria : str

categorias = []

@app.post("/login")
async def login(login_request : LoginRequest):
    if login_request.username == "PROGRAWEB" and login_request.password == "123123123":
        # Si pones la contraseña correspondiente te mostrará el siguiente mensaje
        return {
            "msg" : "Acceso concedido"
        }
    else:
        raise HTTPException(
            status_code=400, 
            detail="Error en el login, credenciales incorrectas")
        # return{
        #     "msg" : "Error en login"
        # }
        
@app.get("/categorias")
async def list_categorias():
    return categorias

# Objeto json que se enviará por el cuerpo de la petición
@app.post("/categoria")
async def create_categoria(categoria: Categoria):
    categoria.id = str(uuid4())
    # TO.DO: Trabajar con uan base de datos
    categorias.append(categoria)
    return categoria