import os
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker, declarative_base

# URL de conexión: usuario:password@host:port/dbname
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+asyncpg://postgres:Lopez#880@localhost:5432/tienda")

# 1. El motor (Engine): El punto de entrada a la BD
engine = create_async_engine(DATABASE_URL, echo=True)

# 2. La sesión: Lo que usaremos para hacer consultas 
AsyncSessionLocal = sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False
)

# 3. La Base: clase padre para nuestros modelos
Base = declarative_base()

# Dependencia para obtener la base de datos en cada petición
async def get_db():
    async with AsyncSessionLocal() as session:
        yield session
