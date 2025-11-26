from sqlalchemy import Column, Integer, String, Float, Date, ForeignKey, Boolean
from sqlalchemy.types import JSON
from sqlalchemy.orm import relationship
from app.models.producto import Producto
from app.database import Base

class Bebida(Producto):
    __tablename__ = "bebidas"
    id_bebida = Column(Integer, ForeignKey('productos.id_prod'), primary_key=True)
    
    capacidad_ml = Column(Integer)
    envase = Column(String)
    sabor = Column(String)
    marca = Column(String)
    es_retornable = Column(Boolean)

    __mapper_args__ = {'polymorphic_identity': 'bebida'}