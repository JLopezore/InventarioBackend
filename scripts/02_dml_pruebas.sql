-- ==========================================================
-- SCRIPT DML - MANIPULACIÓN Y PRUEBAS
-- ==========================================================

-- 1. INSERTAR DATOS (Creación de Objetos)

-- Primero creamos una Ubicación (Referencia)
INSERT INTO ubicaciones (zona, estante, nivel) VALUES 
('Refrigeradores', 'REF-01', 1),
('Pasillo Central', 'PAS-05', 3);

-- Inserción Polimórfica (Manual en SQL para Joined Inheritance)
-- A) Crear una BEBIDA (Coca Cola)
-- Paso 1: Insertar en padre (usando el constructor del UDT ROW(...))
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Coca Cola 600ml', 18.00, 100, '2025-12-31', ROW(20.0, 5.0, 5.0, 'cm'), 'bebida', 1)
RETURNING id_prod; -- Supongamos que devuelve ID 1

-- Paso 2: Insertar en hijo usando el ID del padre
INSERT INTO bebidas (id_bebida, capacidad_ml, envase, sabor, marca, es_retornable)
VALUES (1, 600, 'plastico', 'cola', 'CocaCola', false);


-- B) Crear una CARNE (Arrachera)
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Arrachera Marinada', 250.00, 10, '2024-02-20', ROW(10, 20, 30, 'cm'), 'carne', 1);
-- Supongamos que devolvió ID 2
INSERT INTO carnes (id_carne, animal, tipo_corte, peso_kg, temperatura_conservacion, esta_congelado)
VALUES (2, 'res', 'fino', 1.0, -4.0, true);


-- 2. CONSULTAS COMPLEJAS (SELECT)

-- A) Navegación de Referencias de Objeto
-- "Obtener todos los productos y su ubicación detallada"
SELECT 
    p.nombre, 
    p.precio, 
    (p.dims).medida_alto as alto, -- Acceso a atributo del UDT
    u.zona, 
    u.estante
FROM productos p
JOIN ubicaciones u ON p.id_ubicacion = u.id_ubicacion;

-- B) Consultas Polimórficas (Jerarquía de Herencia)
-- "Traer todos los productos, y si es bebida mostrar su sabor, si es carne mostrar su corte"
-- Esto demuestra cómo unimos la superclase con las subclases
SELECT 
    p.id_prod,
    p.nombre,
    p.tipo_producto,
    b.sabor as sabor_bebida,
    c.tipo_corte as corte_carne
FROM productos p
LEFT JOIN bebidas b ON p.id_prod = b.id_bebida
LEFT JOIN carnes c ON p.id_prod = c.id_carne;

-- C) Invocación de Métodos Almacenados en Consultas
-- "Calcular valor total del inventario para productos caros"
SELECT 
    nombre, 
    precio, 
    stock, 
    calcular_valor_inventario(id_prod) as valor_total_inventario
FROM productos
WHERE precio > 100;