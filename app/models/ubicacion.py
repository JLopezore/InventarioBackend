from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from app.database import Base

class Ubicacion(Base):
    __tablename__ = "ubicaciones"

    id_ubicacion = Column(Integer, primary_key=True, index=True)
    zona = Column(String) # 'Refrigeradores'
    estante = Column(String)# 'A-1'
    nivel = Column(Integer)

    productos = relationship("Producto", back_populates="ubicacion") # relación inversa