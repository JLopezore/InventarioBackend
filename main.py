from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional

app = FastAPI()

# 1. Modelado de Datos (Pydantic)
# Esto define qué datos ESPERAS recibir. Si te mandan otra cosa, falla.
class Item(BaseModel):
    nombre: str
    precio:float
    oferta: Optional[bool] = None

# 2. Ruta GET
@app.get("/")
def leer_raiz():
    return {"mensaje": "¡Bienvenido a mi API"}

# 3. Ruta GET con Parámetro (validación de tipos)
@app.get("/items/{item_id}")
def leer_item(item_id: int, q:str = None):
    # FastAPI convierte item_id a entero automáticamente
    return {"item_id": item_id, "query": q}

# 4. Ruta POST (Crear datos)
@app.post("/items/")
async def crear_item(item: Item):
    # 'item' ya viene validado como objeto Python, no es un JSON crudo
    precio_final = item.precio
    if item.oferta:
        precio_final = item.precio * 0.8 
    return {"nombre": item.nombre, "precio_final": precio_final}