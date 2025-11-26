from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List
from sqlalchemy import text # Importar text para consultas SQL crudas

from app.database import get_db

from app.models.producto import Producto
from app.models.bebidas import Bebida
from app.models.carne import Carne
from app.models.pan import Pan
from app.models.abarrote import Abarrote
from app.models.dulce import Dulce
from app.models.enlatado import Enlatado
from app.models.licor import Licor
from app.models.limpieza import Limpieza

from app.schemas.producto import ( ProductoResponse, BebidaCreate, CarneCreate, PanCreate, AbarroteCreate, DulceCreate, EnlatadoCreate, LicorCreate, LimpiezaCreate )

router = APIRouter(
    prefix="/productos",
    tags=["productos"]
)

# Ruta para obtener todos los productos
@router.get("/", response_model=List[ProductoResponse])
async def leer_productos(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Producto))
    productos = result.scalars().all()
    return productos
    
# Ruta para obtener un producto por su ID
@router.get("/{producto_id}", response_model=ProductoResponse)
async def leer_producto(producto_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Producto).where(Producto.id_prod == producto_id))
    producto = result.scalar_one_or_none()
    if producto is None:
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    return producto 

# Ruta para obtener todos los productos de una categoría específica
@router.get("/tipo/{tipo}", response_model=List[ProductoResponse])
async def leer_productos_por_tipo(tipo: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Producto).where(Producto.tipo_producto == tipo))
    productos = result.scalars().all()
    return productos

# Rutas para crear productos específicos
@router.post("/abarrotes", response_model=ProductoResponse)
async def crear_abarrote(item: AbarroteCreate, db: AsyncSession = Depends(get_db)):
    # **item.dict() convierte el objeto Pydantic en un diccionario
    # SQLAlchemy es listo y mapea los campos a la tabla padre y a la hija automáticamente
    nuevo = Abarrote(**item.dict())
    db.add(nuevo)
    await db.commit()
    await db.refresh(nuevo)
    return nuevo

@router.post("/bebidas", response_model=ProductoResponse)
async def crear_bebida(item: BebidaCreate, db: AsyncSession = Depends(get_db)):
    nuevo = Bebida(**item.dict())
    db.add(nuevo)
    await db.commit()
    await db.refresh(nuevo)
    return nuevo

@router.post("/carnes", response_model=ProductoResponse)
async def crear_carne(item: CarneCreate, db: AsyncSession = Depends(get_db)):
    nuevo = Carne(**item.dict())
    db.add(nuevo)
    await db.commit()
    await db.refresh(nuevo)
    return nuevo

@router.post("/dulces", response_model=ProductoResponse)
async def crear_dulce(item: DulceCreate, db: AsyncSession = Depends(get_db)):
    nuevo = Dulce(**item.dict())
    db.add(nuevo)
    await db.commit()
    await db.refresh(nuevo)
    return nuevo

@router.post("/enlatados", response_model=ProductoResponse)
async def crear_enlatado(item: EnlatadoCreate, db: AsyncSession = Depends(get_db)):
    nuevo = Enlatado(**item.dict())
    db.add(nuevo)
    await db.commit()
    await db.refresh(nuevo)
    return nuevo

@router.post("/licores", response_model=ProductoResponse)
async def crear_licor(item: LicorCreate, db: AsyncSession = Depends(get_db)):
    nuevo = Licor(**item.dict())
    db.add(nuevo)
    await db.commit()
    await db.refresh(nuevo)
    return nuevo

@router.post("/limpieza", response_model=ProductoResponse)
async def crear_limpieza(item: LimpiezaCreate, db: AsyncSession = Depends(get_db)):
    nuevo = Limpieza(**item.dict())
    db.add(nuevo)
    await db.commit()
    await db.refresh(nuevo)
    return nuevo

@router.post("/panes", response_model=ProductoResponse)
async def crear_pan(item: PanCreate, db: AsyncSession = Depends(get_db)):
    nuevo = Pan(**item.dict())
    db.add(nuevo)
    await db.commit()
    await db.refresh(nuevo)
    return nuevo

# Rutas de modificación y eliminación de productos

@router.put("/ubicacion/{producto_id}", response_model=ProductoResponse)
async def asignar_ubicacion(producto_id: int, id_ubicacion: int, db: AsyncSession = Depends(get_db)):
    """Mueve un producto a una nueva ubicación."""
    # 1. Buscar producto
    result = await db.execute(select(Producto).where(Producto.id_prod == producto_id))
    producto = result.scalar_one_or_none()
    
    if producto is None:
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    # 2. Asignar nueva ubicación
    producto.id_ubicacion = id_ubicacion
    
    # 3. Guardar cambios
    db.add(producto)
    await db.commit()
    await db.refresh(producto)
    return producto 

# Ruta para eliminar un producto por su ID
@router.delete("/{producto_id}", response_model=dict)
async def eliminar_producto(producto_id: int, db: AsyncSession = Depends(get_db)):  
    result = await db.execute(select(Producto).where(Producto.id_prod == producto_id))
    producto = result.scalar_one_or_none()
    if producto is None:
        raise HTTPException(status_code=404, detail="Producto no encontrado")
    await db.delete(producto)
    await db.commit()
    return {"mensaje": "Producto eliminado correctamente"}



@router.get("/{producto_id}/valor-inventario")
async def obtener_valor_inventario(producto_id: int, db: AsyncSession = Depends(get_db)):
    query = text("SELECT calcular_valor_total(:id)")
    result = await db.execute(query, {"id": producto_id})
    valor_total = result.scalar()
    
    return {
        "id_prod": producto_id, 
        "valor_inventario_calculado_en_db": valor_total
    }