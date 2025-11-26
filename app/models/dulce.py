from sqlalchemy import Column, Integer, String, Float, Date, ForeignKey, Boolean
from sqlalchemy.types import JSON
from sqlalchemy.orm import relationship
from app.models.producto import Producto
from app.database import Base

class Dulce(Producto):
    __tablename__ = "dulces"
    id_dulce = Column(Integer, ForeignKey('productos.id_prod'), primary_key=True)
    
    tipo_empaque = Column(String)
    peso_unidad = Column(Float)
    sabor = Column(String)
    es_libre_azucar = Column(Boolean)

    __mapper_args__ = {'polymorphic_identity': 'dulce'}