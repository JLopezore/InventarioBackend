-- ==========================================================
-- SCRIPT DDL - DEFINICIÓN DE ESQUEMA ORDBMS
-- Proyecto: Sistema de Inventario
-- Motor: PostgreSQL
-- ==========================================================

-- 1. REQUISITO: TYPE / UDT (Tipo Compuesto)
-- Aunque en la app usamos JSONB por flexibilidad moderna, 
-- aquí definimos el tipo estructurado para cumplir el requisito académico.
CREATE TYPE tipo_dimensiones AS (
    medida_alto FLOAT,
    medida_ancho FLOAT,
    medida_profundidad FLOAT,
    unidad_medida VARCHAR(10)
);

-- 2. REQUISITO: TABLA PADRE (Superclase)
CREATE TABLE productos (
    id_prod SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio FLOAT NOT NULL,
    stock INT NOT NULL,
    fecha_caducidad DATE,
    -- Usamos el UDT creado arriba (o JSONB si se prefiere modernidad)
    dims tipo_dimensiones, 
    tipo_producto VARCHAR(50), -- Discriminador para polimorfismo
    id_ubicacion INT -- Referencia (FK) se define más abajo
);

-- 3. REQUISITO: TABLA REFERENCIADA
CREATE TABLE ubicaciones (
    id_ubicacion SERIAL PRIMARY KEY,
    zona VARCHAR(50),
    estante VARCHAR(20),
    nivel INT
);

-- REQUISITO: Restricciones de Integridad (Foreign Key / Referencia de Objeto)
ALTER TABLE productos 
ADD CONSTRAINT fk_producto_ubicacion 
FOREIGN KEY (id_ubicacion) REFERENCES ubicaciones(id_ubicacion);

-- 4. REQUISITO: HERENCIA (Subclases)
-- Nota: Implementación "Joined Table Inheritance" (Estándar ORM/Industrial)
-- Se usa Foreign Key hacia la PK del padre para simular la extensión del objeto.

-- Subclase: Bebidas
CREATE TABLE bebidas (
    id_bebida INT PRIMARY KEY REFERENCES productos(id_prod),
    capacidad_ml INT,
    envase VARCHAR(50),
    sabor VARCHAR(50),
    marca VARCHAR(50),
    es_retornable BOOLEAN
);

-- Subclase: Carnes
CREATE TABLE carnes (
    id_carne INT PRIMARY KEY REFERENCES productos(id_prod),
    animal VARCHAR(50),
    tipo_corte VARCHAR(50),
    peso_kg FLOAT,
    temperatura_conservacion FLOAT,
    esta_congelado BOOLEAN
);

-- Subclase: Abarrotes
CREATE TABLE abarrotes (
    id_abarrote INT PRIMARY KEY REFERENCES productos(id_prod),
    categoria VARCHAR(50),
    peso_neto FLOAT,
    marca VARCHAR(50)
);

-- (Repetir para Dulces, Enlatados, etc...)

-- 5. REQUISITO: MÉTODOS ALMACENADOS (Stored Procedure/Function)
-- Función para calcular el valor monetario del inventario de un producto
CREATE OR REPLACE FUNCTION calcular_valor_inventario(id_solicitado INT) 
RETURNS FLOAT AS $$
DECLARE
    v_precio FLOAT;
    v_stock INT;
BEGIN
    SELECT precio, stock INTO v_precio, v_stock 
    FROM productos 
    WHERE id_prod = id_solicitado;
    
    RETURN COALESCE(v_precio * v_stock, 0);
END;
$$ LANGUAGE plpgsql;