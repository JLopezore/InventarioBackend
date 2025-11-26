# Proyecto: Sistema de Inventario de Tienda (Backend)

Este documento detalla la correspondencia entre los requisitos solicitados en el documento "Proyecto BDOR-1.pdf" y la implementación técnica realizada en Python (FastAPI) y PostgreSQL.

1. Jerarquía de Clases (Herencia)

Requisito: Modelar una relación de herencia entre entidades (Superclase y Subclases).
Estado: Cumplido

Justificación Técnica:
Se implementó el patrón "Joined Table Inheritance" (Herencia de Tablas Unidas) utilizando SQLAlchemy. Existe una tabla padre (productos) y múltiples tablas hijas (bebidas, carnes, etc.) que heredan los atributos base y añaden los propios.

Evidencia en Código:

Archivo: app/models/producto.py

Código:

# Superclase
class Producto(Base):
    __tablename__ = "productos"
    id_prod = Column(Integer, primary_key=True)
    tipo_producto = Column(String(50)) # Discriminador

    __mapper_args__ = {
        'polymorphic_identity': 'producto',
        'polymorphic_on': tipo_producto
    }

# Subclase (Ejemplo)
class Bebida(Producto):
    __tablename__ = "bebidas"
    # La Primary Key es también Foreign Key al padre
    id_bebida = Column(Integer, ForeignKey('productos.id_prod'), primary_key=True)

    __mapper_args__ = {'polymorphic_identity': 'bebida'}



2. Tipo Compuesto (UDT)

Requisito: Crear un tipo de dato estructurado para atributos complejos.
Estado: Cumplido (Vía JSON Moderno)

Justificación Técnica:
Se utiliza el tipo de dato JSON de PostgreSQL para almacenar la estructura compleja de Dimensiones. Esto permite guardar objetos estructurados (alto, ancho, profundidad, unidad) dentro de una sola columna, emulando el comportamiento de un UDT moderno.

Evidencia en Código:

Archivo (Modelo): app/models/producto.py

from sqlalchemy.types import JSON
# ...
dims = Column(JSON, nullable=True) # Almacena el objeto complejo



Archivo (Esquema): app/schemas/producto.py

class Dimensiones(BaseModel):
    medida_alto: float
    medida_ancho: float
    # ...



3. Referencias a Objetos (OIDs)

Requisito: Usar referencias directas a objetos para relaciones clave.
Estado: Cumplido

Justificación Técnica:
Se implementó una relación Referencial entre Producto y Ubicacion. El producto contiene una referencia (Foreign Key) que apunta a la instancia del objeto Ubicacion donde se encuentra almacenado.

Evidencia en Código:

Archivo: app/models/producto.py

# Referencia al objeto Ubicacion
id_ubicacion = Column(Integer, ForeignKey("ubicaciones.id_ubicacion"))
ubicacion = relationship("Ubicacion", back_populates="productos")



4. Transacciones (Persistencia)

Requisito: Demostrar el uso de transacciones (BEGIN, COMMIT, ROLLBACK).
Estado: Cumplido

Justificación Técnica:
Cada operación de creación, actualización o eliminación (CUD) se maneja dentro de una sesión de base de datos atómica. SQLAlchemy gestiona el BEGIN implícitamente al iniciar la sesión y se requiere un commit() explícito para persistir. Si ocurre un error, FastAPI realiza un ROLLBACK automático (cierre de sesión sin guardar).

Evidencia en Código:

Archivo: app/routers/productos.py

@router.post("/bebidas", ...)
async def crear_bebida(...):
    # Inicia transacción implícita
    nuevo = Bebida(**item.dict())
    db.add(nuevo)

    # Confirma la transacción (COMMIT)
    await db.commit() 

    # Recupera el objeto persistido
    await db.refresh(nuevo)
    return nuevo



5. Consultas Polimórficas

Requisito: Consultas que demuestren navegación sobre la jerarquía de herencia.
Estado: Cumplido

Justificación Técnica:
El endpoint general de productos realiza una consulta polimórfica. Al consultar la tabla base Producto, el ORM automáticamente realiza los JOINs necesarios para traer las instancias correctas de las subclases (Bebida, Carne, etc.) en una sola lista heterogénea.

Evidencia en Código:

Archivo: app/routers/productos.py

@router.get("/", response_model=List[ProductoResponse])
async def leer_productos(...):
    # Esta consulta trae TODOS los tipos de hijos automáticamente
    result = await db.execute(select(Producto))
    return result.scalars().all()



6. Método Almacenado

Requisito: Invocación de métodos almacenados en las consultas.
Estado: Cumplido

Justificación Técnica:
Se definió una función almacenada en PostgreSQL (calcular_valor_total u otra lógica de negocio) que encapsula lógica en la base de datos. Desde el backend (FastAPI), se invoca esta función utilizando sentencias SQL textuales (text) a través de SQLAlchemy, demostrando la interacción directa con métodos del SGBD.

Evidencia en Código:

Archivo: app/routers/productos.py

from sqlalchemy import text

@router.get("/{id}/valor")
async def valor_inventario(id: int, db: AsyncSession = Depends(get_db)):
    # Invoca a la función almacenada en PostgreSQL
    result = await db.execute(text("SELECT calcular_valor_total(:id)"), {"id": id})
    return {"valor": result.scalar()}

