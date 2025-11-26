from sqlalchemy import Column, Integer, String, Float, Date, ForeignKey, Boolean
from sqlalchemy.types import JSON
from sqlalchemy.orm import relationship
from app.models.producto import Producto
from app.database import Base

class Licor(Producto):
    __tablename__ = "licores"
    id_licor = Column(Integer, ForeignKey('productos.id_prod'), primary_key=True)
    
    grado_alcohol = Column(Float)
    tipo_licor = Column(String)
    capacidad_ml = Column(Float)
    anos_anejamiento = Column(Integer, nullable=True)
    pais_origen = Column(String)

    __mapper_args__ = {'polymorphic_identity': 'licor'}