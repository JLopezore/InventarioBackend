from sqlalchemy import Column, Integer, String, Float, Date, ForeignKey, Boolean
from sqlalchemy.types import JSON
from sqlalchemy.orm import relationship
from datetime import datetime, date
from app.database import Base

class Producto(Base):
    __tablename__ = "productos"

    id_prod = Column(Integer, primary_key=True, index=True)
    nombre = Column(String, index=True)
    precio = Column(Float)
    stock = Column(Integer)
    fecha_caducidad = Column(Date, nullable=True)

    dims = Column(JSON, nullable=True)  # Almacenar dimensiones como JSON

    id_ubicacion = Column(Integer, ForeignKey("ubicaciones.id_ubicacion"))
    ubicacion = relationship("app.models.ubicacion.Ubicacion", back_populates="productos")

    tipo_producto = Column(String)  

    __mapper_args__ = {
        'polymorphic_identity':'producto',
        'polymorphic_on':tipo_producto
    }

    def es_caducable(self) -> str:
        if not self.es_caducable:
            return "Vigente (No caduca)"
        
        hoy = date.today()
        if hoy <= 7:
            return "Proximo a caducar"
        
        return "Vigente"


    