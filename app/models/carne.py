from sqlalchemy import Column, Integer, String, Float, Date, ForeignKey, Boolean
from sqlalchemy.types import JSON
from sqlalchemy.orm import relationship
from app.models.producto import Producto
from app.database import Base

class Carne(Producto):
    __tablename__ = "carnes"
    id_carne = Column(Integer, ForeignKey('productos.id_prod'), primary_key=True)
    
    animal = Column(String)
    tipo_corte = Column(String)
    peso_kg = Column(Float)
    temperatura_conservacion = Column(Float)
    esta_congelado = Column(Boolean)

    __mapper_args__ = {'polymorphic_identity': 'carne'}