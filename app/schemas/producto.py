from pydantic import BaseModel
from typing import Optional, Dict, Any

class ProductoBase(BaseModel):
    nombre: str
    precio: float
    descripcion: Optional[str] = None
    detalles: Optional[Dict[str, Any]] = None


class ProductoCreate(ProductoBase):
    pass

class ProductoResponse(ProductoBase):
    id: int

    class Config:
        from_attributes = True