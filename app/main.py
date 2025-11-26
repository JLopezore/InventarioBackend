from fastapi import FastAPI
from app.database import engine, Base
from app.routes import productos

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



app = FastAPI()

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

