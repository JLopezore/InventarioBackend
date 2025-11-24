from fastapi import FastAPI, Depends
from sqlalchemy.future import select
from sqlalchemy.ext.asyncio import AsyncSession
from database import engine, Base, get_db
from models import Producto
from pydantic import BaseModel


app = FastAPI()

# Evento inicial: Crear las tablas automaticamente
@app.on_event("startup")
async def startup():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

# Modelo Pydantic para validación de datos
class ProductoCreate(BaseModel):
    nombre: str
    precio: float
    descripcion: str = None

# RUTA 1: Crear Producto (POST)
@app.post("/productos/")
async def crear_producto(item: ProductoCreate, db: AsyncSession = Depends(get_db)):
    # Creamos una instancia del modelo DB con los datos recibidos
    nuevo_producto = Producto(
        nombre=item.nombre,
        precio=item.precio,
        descripcion=item.descripcion
    )
    db.add(nuevo_producto) # Agregamos a la sesión
    await db.commit() # Guardamos en la BD real
    await db.refresh(nuevo_producto) # Refrescamos para obtener datos generados (ej. ID)
    return nuevo_producto

# RUTA 2: Listar Productos (GET)
@app.get("/productos/")
async def leer_productos(db: AsyncSession = Depends(get_db)):
    # Ejecutar una consulta SQL tip "Select * from productos"
    result = await db.execute(select(Producto))
    productos = result.scalars().all()
    return productos




@app.get("/")
def leer_raiz():
    return {"mensaje": "¡Bienvenido a mi API"}

