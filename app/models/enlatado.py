from sqlalchemy import Column, Integer, String, Float, Date, ForeignKey, Boolean
from sqlalchemy.types import JSON
from sqlalchemy.orm import relationship
from app.models.producto import Producto
from app.database import Base

class Enlatado(Producto):
    __tablename__ = "enlatados"
    id_enlatado = Column(Integer, ForeignKey('productos.id_prod'), primary_key=True)
    
    tipo_envase = Column(String)
    peso_drenado = Column(Float)
    peso_neto = Column(Float)
    tipo_alimento = Column(String)

    __mapper_args__ = {'polymorphic_identity': 'enlatado'}