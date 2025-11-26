from sqlalchemy import Column, Integer, String, Float, Date, ForeignKey, Boolean
from sqlalchemy.types import JSON
from sqlalchemy.orm import relationship
from app.models.producto import Producto
from app.database import Base

class Limpieza(Producto):
    __tablename__ = "limpieza"
    id_limpieza = Column(Integer, ForeignKey('productos.id_prod'), primary_key=True)
    
    presentacion = Column(String)
    es_biodegradable = Column(Boolean)
    contenido_neto = Column(Float)
    unidad_contenido = Column(String)
    uso_principal = Column(String)

    __mapper_args__ = {'polymorphic_identity': 'limpieza'}