from pydantic import BaseModel

class Dimensiones(BaseModel):
    medida_alto: float
    medida_ancho: float
    medida_profundidad: float
    unidad_medida: str # Ej. 'cm'

    