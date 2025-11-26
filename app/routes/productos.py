from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List

from app.database import get_db
from app.models.producto import Producto
from app.schemas.producto import ProductoCreate, ProductoResponse

router = APIRouter(
    prefix="/productos",
    tags=["productos"]
)

@router.post("/", response_model=ProductoResponse)
async def crear_producto(item: ProductoCreate, db: AsyncSession = Depends(get_db)):
    nuevo_producto = Producto (**item.dict()) # Desempaquetar el diccionario directamente
    db.add(nuevo_producto)
    await db.commit()
    await db.refresh(nuevo_producto)
    return nuevo_producto

@router.get("/", response_model=List[ProductoResponse])
async def leer_productos(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Producto))
    return result.scalars().all()
