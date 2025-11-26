from fastapi import FastAPI
from app.database import engine, Base
from app.routes import productos
from fastapi.middleware.cors import CORSMiddleware

# Modelos
from app.models.producto import Producto
from app.models.ubicacion import Ubicacion
from app.models.pan import Pan
from app.models.abarrote import Abarrote
from app.models.bebidas import Bebida
from app.models.carne import Carne
from app.models.dulce import Dulce
from app.models.enlatado import Enlatado
from app.models.licor import Licor
from app.models.limpieza import Limpieza


app = FastAPI(
    title="Sistema de Inventario ORDBMS",
    description="API para gestión de productos con herencia y tipos compuestos",
    version="1.0.0"
)

# --- 2. CONFIGURACIÓN DE CORS ---
# Esto es lo que permite que tu archivo index.html hable con la API
origins = [
    "http://localhost",
    "http://localhost:3000",
    "http://127.0.0.1:5500", # Puerto común de Live Server
    "*" # Comodín: Acepta todo (Ideal para desarrollo)
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],     # Permite cualquier origen (dominio/puerto)
    allow_credentials=True,
    allow_methods=["*"],     # Permite GET, POST, PUT, DELETE, etc.
    allow_headers=["*"],     # Permite todos los encabezados
)
# -----------------------------
# Evento inicial: Crear las tablas automaticamente
@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

app.include_router(productos.router)

@app.get("/")
def root():
    print ("Servidor iniciado correctamente")
    return {"mensaje": "¡Bienvenido a mi API"}

