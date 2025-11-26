from pydantic import BaseModel, model_validator
from typing import Optional, Dict, Any
from datetime import date

class Dimensiones(BaseModel):
    medida_alto: float
    medida_ancho: float
    medida_profundidad: float
    unidad_medida: str  # Ej. 'cm'

    @model_validator(mode='before')
    @classmethod
    def convertir_sql_record(cls, v):
        # Si v existe, no es un diccionario y parece un Record de base de datos...
        if v is not None and not isinstance(v, dict) and not hasattr(v, '__dict__'):
            try:
                return dict(v) # ...lo forzamos a ser un diccionario.
            except (ValueError, TypeError):
                pass
        return v

    class Config:
        from_attributes = True

class ProductoBase(BaseModel):
    nombre: str
    precio: float
    stock: int
    fecha_caducidad: Optional[date] = None
    dims: Optional[Dimensiones] = None
    id_ubicacion: int


# Esquemas para crear y responder productos


class BebidaCreate(ProductoBase):
    capacidad_ml: int
    envase: str
    sabor: str
    marca:str
    es_retornable: bool

class CarneCreate(ProductoBase):
    animal: str
    tipo_corte: str
    peso_kg: float
    temperatura_conservacion: float
    esta_congelado: bool

class DulceCreate(ProductoBase):
    tipo_empaque: str
    peso_unidad: float
    sabor: str
    es_libre_azucar: bool

class EnlatadoCreate(ProductoBase):
    tipo_envase: str
    peso_drenado: float
    peso_neto: float
    tipo_alimento: str

class LicorCreate(ProductoBase):
    grado_alcohol: float
    tipo_licor: str
    capacidad_ml: float
    anos_anejamiento: Optional[int] = None
    pais_origen: str

class LimpiezaCreate(ProductoBase):
    presentacion: str
    es_biodegradable: bool
    contenido_neto: float
    unidad_contenido: str
    uso_principal: str


class PanCreate(ProductoBase):
    tipo_masa: str
    presentacion: str
    es_artesanal: bool

class AbarroteCreate(ProductoBase):
    categoria: str
    peso_neto: float
    marca: str

class ubicacionCreate(BaseModel):
    id_ubicacion: int
    zona: str
    estante: str
    nivel: int

class ProductoCreate(ProductoBase):
    pass

class ProductoResponse(ProductoBase):
    id_prod: int
    tipo_producto: str

    class Config:
        from_attributes = True