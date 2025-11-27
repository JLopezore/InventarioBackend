-- ==========================================================
-- SCRIPT DDL - DEFINICIÓN DE ESQUEMA ORDBMS
-- Proyecto: Sistema de Inventario
-- Motor: PostgreSQL
-- ==========================================================

-- 1. REQUISITO: TYPE / UDT (Tipo Compuesto)
-- Definimos el tipo para cumplir el requisito académico
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
    
    -- TRUCO DE COMPATIBILIDAD:
    -- Usamos JSON para compatibilidad con el Backend Web (FastAPI),
    -- pero conceptualmente mapea a la estructura del TYPE definido arriba.
    dims JSON, 
    
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
-- Nota: Implementación "Joined Table Inheritance"

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

-- Subclase: Dulces
CREATE TABLE dulces (
    id_dulce INT PRIMARY KEY REFERENCES productos(id_prod),
    tipo_empaque VARCHAR(50),
    peso_unidad FLOAT,
    sabor VARCHAR(50),
    es_libre_azucar BOOLEAN
);

-- Subclase: Enlatados
CREATE TABLE enlatados (
    id_enlatado INT PRIMARY KEY REFERENCES productos(id_prod),
    tipo_envase VARCHAR(50),
    peso_drenado FLOAT,
    peso_neto FLOAT,
    tipo_alimento VARCHAR(50)
);

-- Subclase: Licores
CREATE TABLE licores (
    id_licor INT PRIMARY KEY REFERENCES productos(id_prod),
    grado_alcohol FLOAT,
    tipo_licor VARCHAR(50),
    capacidad_ml FLOAT,
    anos_anejamiento INT,
    pais_origen VARCHAR(50)
);

-- Subclase: Limpieza
CREATE TABLE limpieza (
    id_limpieza INT PRIMARY KEY REFERENCES productos(id_prod),
    presentacion VARCHAR(50),
    es_biodegradable BOOLEAN,
    contenido_neto FLOAT,
    unidad_contenido VARCHAR(20),
    uso_principal VARCHAR(50)
);

-- Subclase: Panaderia
CREATE TABLE panaderia ( -- Corregido nombre de tabla a plural/estándar si se requiere
    id_pan INT PRIMARY KEY REFERENCES productos(id_prod),
    tipo_masa VARCHAR(50),
    presentacion VARCHAR(50),
    es_artesanal BOOLEAN
);


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