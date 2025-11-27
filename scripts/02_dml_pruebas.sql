-- ==========================================================
-- SCRIPT DML - MANIPULACIÓN Y PRUEBAS (DATOS EXTENDIDOS)
-- ==========================================================

-- 1. INSERTAR DATOS (Creación de Objetos)

-- A) UBICACIONES (5 Registros)
INSERT INTO ubicaciones (zona, estante, nivel) VALUES 
('Refrigeradores', 'REF-01', 1),
('Pasillo Central', 'PAS-05', 3),
('Carnicería', 'CAR-02', 1),
('Licores', 'LIC-01', 2),
('Panadería', 'PAN-03', 2);


-- B) PRODUCTOS Y SUBCLASES
-- Nota: Usamos JSON para 'dims' para compatibilidad con la App Web.
-- Usamos una transacción lógica de inserción Padre -> Hijo recuperando el ID.

-- --- BEBIDAS (5 Registros) ---

-- 1. Coca Cola
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Coca Cola 600ml', 18.00, 100, '2025-12-31', '{"medida_alto": 20, "medida_ancho": 5, "medida_profundidad": 5, "unidad_medida": "cm"}', 'bebida', 1);
INSERT INTO bebidas (id_bebida, capacidad_ml, envase, sabor, marca, es_retornable)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Coca Cola 600ml'), 600, 'plastico', 'cola', 'CocaCola', false);

-- 2. Pepsi
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Pepsi 600ml', 17.50, 80, '2025-11-30', '{"medida_alto": 20, "medida_ancho": 5, "medida_profundidad": 5, "unidad_medida": "cm"}', 'bebida', 1);
INSERT INTO bebidas (id_bebida, capacidad_ml, envase, sabor, marca, es_retornable)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Pepsi 600ml'), 600, 'plastico', 'cola', 'PepsiCo', false);

-- 3. Fanta
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Fanta Naranja', 16.00, 50, '2025-10-15', '{"medida_alto": 20, "medida_ancho": 5, "medida_profundidad": 5, "unidad_medida": "cm"}', 'bebida', 1);
INSERT INTO bebidas (id_bebida, capacidad_ml, envase, sabor, marca, es_retornable)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Fanta Naranja'), 600, 'plastico', 'naranja', 'CocaCola', false);

-- 4. Agua Ciel
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Agua Ciel 1L', 12.00, 120, '2026-01-01', '{"medida_alto": 25, "medida_ancho": 7, "medida_profundidad": 7, "unidad_medida": "cm"}', 'bebida', 2);
INSERT INTO bebidas (id_bebida, capacidad_ml, envase, sabor, marca, es_retornable)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Agua Ciel 1L'), 1000, 'plastico', 'natural', 'Ciel', false);

-- 5. Jugo del Valle
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Jugo del Valle Manzana', 22.00, 40, '2025-06-20', '{"medida_alto": 15, "medida_ancho": 5, "medida_profundidad": 5, "unidad_medida": "cm"}', 'bebida', 2);
INSERT INTO bebidas (id_bebida, capacidad_ml, envase, sabor, marca, es_retornable)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Jugo del Valle Manzana'), 413, 'vidrio', 'manzana', 'Del Valle', false);


-- --- CARNES (5 Registros) ---

-- 1. Arrachera
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Arrachera Marinada', 250.00, 10, '2024-02-20', '{"medida_alto": 10, "medida_ancho": 20, "medida_profundidad": 30, "unidad_medida": "cm"}', 'carne', 3);
INSERT INTO carnes (id_carne, animal, tipo_corte, peso_kg, temperatura_conservacion, esta_congelado)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Arrachera Marinada'), 'res', 'fino', 1.0, -4.0, true);

-- 2. Pollo Entero
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Pollo Entero', 85.00, 15, '2024-02-15', '{"medida_alto": 15, "medida_ancho": 15, "medida_profundidad": 15, "unidad_medida": "cm"}', 'carne', 3);
INSERT INTO carnes (id_carne, animal, tipo_corte, peso_kg, temperatura_conservacion, esta_congelado)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Pollo Entero'), 'pollo', 'entero', 1.5, -2.0, false);

-- 3. Chuleta de Cerdo
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Chuleta Ahumada', 120.00, 20, '2024-03-01', '{"medida_alto": 5, "medida_ancho": 20, "medida_profundidad": 20, "unidad_medida": "cm"}', 'carne', 3);
INSERT INTO carnes (id_carne, animal, tipo_corte, peso_kg, temperatura_conservacion, esta_congelado)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Chuleta Ahumada'), 'cerdo', 'chuleta', 1.0, 0.0, false);

-- 4. Filete Tilapia
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Filete Tilapia', 90.00, 30, '2024-05-10', '{"medida_alto": 2, "medida_ancho": 15, "medida_profundidad": 20, "unidad_medida": "cm"}', 'carne', 3);
INSERT INTO carnes (id_carne, animal, tipo_corte, peso_kg, temperatura_conservacion, esta_congelado)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Filete Tilapia'), 'pescado', 'filete', 0.5, -18.0, true);

-- 5. Rib Eye
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Rib Eye Premium', 450.00, 5, '2024-02-25', '{"medida_alto": 5, "medida_ancho": 20, "medida_profundidad": 25, "unidad_medida": "cm"}', 'carne', 3);
INSERT INTO carnes (id_carne, animal, tipo_corte, peso_kg, temperatura_conservacion, esta_congelado)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Rib Eye Premium'), 'res', 'rib eye', 0.8, -2.0, false);


-- --- LICORES (5 Registros) ---

-- 1. Whisky
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Whisky Johnnie Walker', 850.00, 20, NULL, '{"medida_alto": 30, "medida_ancho": 10, "medida_profundidad": 10, "unidad_medida": "cm"}', 'licor', 4);
INSERT INTO licores (id_licor, grado_alcohol, tipo_licor, capacidad_ml, anos_anejamiento, pais_origen)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Whisky Johnnie Walker'), 40.0, 'whisky', 750, 12, 'Escocia');

-- 2. Tequila
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Tequila Don Julio 70', 1200.00, 15, NULL, '{"medida_alto": 28, "medida_ancho": 10, "medida_profundidad": 10, "unidad_medida": "cm"}', 'licor', 4);
INSERT INTO licores (id_licor, grado_alcohol, tipo_licor, capacidad_ml, anos_anejamiento, pais_origen)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Tequila Don Julio 70'), 35.0, 'tequila', 700, 2, 'México');

-- 3. Vodka
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Vodka Absolut Azul', 350.00, 25, NULL, '{"medida_alto": 28, "medida_ancho": 9, "medida_profundidad": 9, "unidad_medida": "cm"}', 'licor', 4);
INSERT INTO licores (id_licor, grado_alcohol, tipo_licor, capacidad_ml, anos_anejamiento, pais_origen)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Vodka Absolut Azul'), 40.0, 'vodka', 750, 0, 'Suecia');

-- 4. Ron
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Ron Bacardi Blanco', 280.00, 30, NULL, '{"medida_alto": 29, "medida_ancho": 9, "medida_profundidad": 9, "unidad_medida": "cm"}', 'licor', 4);
INSERT INTO licores (id_licor, grado_alcohol, tipo_licor, capacidad_ml, anos_anejamiento, pais_origen)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Ron Bacardi Blanco'), 38.0, 'ron', 980, 1, 'Puerto Rico');

-- 5. Vino Tinto
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Vino Tinto Casillero', 220.00, 40, NULL, '{"medida_alto": 32, "medida_ancho": 8, "medida_profundidad": 8, "unidad_medida": "cm"}', 'licor', 4);
INSERT INTO licores (id_licor, grado_alcohol, tipo_licor, capacidad_ml, anos_anejamiento, pais_origen)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Vino Tinto Casillero'), 13.5, 'vino', 750, 2, 'Chile');


-- --- ABARROTES (5 Registros - Adicional para robustez) ---

-- 1. Arroz
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Arroz Verde Valle 1kg', 35.00, 100, '2026-05-01', '{"medida_alto": 20, "medida_ancho": 10, "medida_profundidad": 5, "unidad_medida": "cm"}', 'abarrote', 2);
INSERT INTO abarrotes (id_abarrote, categoria, peso_neto, marca)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Arroz Verde Valle 1kg'), 'granos', 1.0, 'Verde Valle');

-- 2. Frijol
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Frijol Negro 1kg', 40.00, 80, '2026-04-01', '{"medida_alto": 20, "medida_ancho": 10, "medida_profundidad": 5, "unidad_medida": "cm"}', 'abarrote', 2);
INSERT INTO abarrotes (id_abarrote, categoria, peso_neto, marca)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Frijol Negro 1kg'), 'granos', 1.0, 'La Sierra');

-- 3. Azucar
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Azúcar Estándar 1kg', 28.00, 60, NULL, '{"medida_alto": 18, "medida_ancho": 10, "medida_profundidad": 6, "unidad_medida": "cm"}', 'abarrote', 2);
INSERT INTO abarrotes (id_abarrote, categoria, peso_neto, marca)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Azúcar Estándar 1kg'), 'endulzantes', 1.0, 'Zulka');

-- 4. Aceite
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Aceite 1-2-3', 55.00, 40, '2025-08-01', '{"medida_alto": 25, "medida_ancho": 8, "medida_profundidad": 8, "unidad_medida": "cm"}', 'abarrote', 2);
INSERT INTO abarrotes (id_abarrote, categoria, peso_neto, marca)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Aceite 1-2-3'), 'aceites', 1.0, '1-2-3');

-- 5. Pasta
INSERT INTO productos (nombre, precio, stock, fecha_caducidad, dims, tipo_producto, id_ubicacion)
VALUES ('Spaghetti Barilla', 15.00, 150, '2026-12-01', '{"medida_alto": 30, "medida_ancho": 5, "medida_profundidad": 2, "unidad_medida": "cm"}', 'abarrote', 2);
INSERT INTO abarrotes (id_abarrote, categoria, peso_neto, marca)
VALUES ((SELECT id_prod FROM productos WHERE nombre = 'Spaghetti Barilla'), 'pasta', 0.5, 'Barilla');


-- 2. CONSULTAS COMPLEJAS (SELECT)

-- A) Navegación de Referencias de Objeto
-- "Obtener todos los productos, extrayendo un atributo del objeto JSON (simulando UDT) y su ubicación"
SELECT 
    p.nombre, 
    p.precio, 
    p.dims->>'medida_alto' as alto_producto, 
    u.zona, 
    u.estante
FROM productos p
JOIN ubicaciones u ON p.id_ubicacion = u.id_ubicacion;

-- B) Consultas Polimórficas (Jerarquía de Herencia)
-- "Traer una lista unificada de inventario, mostrando atributos específicos según el tipo"
SELECT 
    p.id_prod,
    p.nombre,
    p.tipo_producto,
    COALESCE(b.marca, l.tipo_licor, a.marca, 'Genérico') as detalle_marca_tipo,
    CASE 
        WHEN p.tipo_producto = 'bebida' THEN b.sabor 
        WHEN p.tipo_producto = 'carne' THEN c.tipo_corte
        WHEN p.tipo_producto = 'licor' THEN l.pais_origen
        WHEN p.tipo_producto = 'abarrote' THEN a.categoria
    END as atributo_variable
FROM productos p
LEFT JOIN bebidas b ON p.id_prod = b.id_bebida
LEFT JOIN carnes c ON p.id_prod = c.id_carne
LEFT JOIN licores l ON p.id_prod = l.id_licor
LEFT JOIN abarrotes a ON p.id_prod = a.id_abarrote;

-- C) Invocación de Métodos Almacenados en Consultas
-- "Calcular valor total del inventario usando la función almacenada en BD"
SELECT 
    id_prod,
    nombre, 
    precio, 
    stock, 
    calcular_valor_inventario(id_prod) as valor_total_calculado_plpgsql
FROM productos
ORDER BY valor_total_calculado_plpgsql DESC;