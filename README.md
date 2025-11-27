# Sistema de Inventario ORDBMS

Este proyecto implementa un sistema de base de datos objeto-relacional para la gestión de inventario de una tienda, utilizando **PostgreSQL** y **Python (FastAPI)**.

El sistema demuestra características avanzadas de bases de datos como:

- **Herencia de Tablas** (_Joined Table Inheritance_).
    
- **Tipos Compuestos / UDT** (Mapeo de objetos estructurados).
    
- **Métodos Almacenados** (Lógica de negocio en PL/pgSQL).

- **Polimorfismo** en consultas.
    

## Requisitos Previos

Únicamente se requiere tener instalado **Docker** y **Docker Compose**.

> **Nota:** No es necesario instalar Python ni PostgreSQL localmente, ya que todo el entorno está contenerizado.

## Cumplimiento de Requisitos

Este proyecto satisface los puntos técnicos solicitados en la rúbrica de evaluación mediante la siguiente implementación:

### 1. Jerarquía de Clases (Herencia)

- **Estado:** Cumplido
    
- **Descripción:** Se implementó el patrón _"Joined Table Inheritance"_ (Herencia de Tablas Unidas). Existe una tabla padre (`productos`) y múltiples tablas hijas (`bebidas`, `carnes`, etc.) que heredan los atributos base.
    
- **Implementación:** SQLAlchemy gestiona la unión automática de tablas mediante _Foreign Keys_ hacia la llave primaria del padre.
    

### 2. Tipo Compuesto (UDT)

- **Estado:** Cumplido
    
- **Descripción:** Se utiliza el tipo de dato estructurado para almacenar dimensiones físicas complejas (alto, ancho, profundidad, unidad) en una sola columna.
    
- **Implementación:** En los scripts SQL se define explícitamente con `CREATE TYPE`, y en la aplicación se maneja mediante columnas JSON para flexibilidad moderna y compatibilidad web.
    

### 3. Referencias a Objetos (OIDs)

- **Estado:** Cumplido
    
- **Descripción:** Se implementaron relaciones directas entre objetos.
    
- **Implementación:** La clase `Producto` mantiene una referencia directa a la clase `Ubicacion`, permitiendo la navegación entre objetos relacionados.
    

### 4. Transacciones (Persistencia)

- **Estado:** Cumplido
    
- **Descripción:** Las operaciones críticas de creación, actualización y eliminación se manejan dentro de bloques transaccionales atómicos.
    
- **Implementación:** Uso de sesiones de base de datos con `commit` explícito y `rollback` automático en caso de error.
    

### 5. Consultas Polimórficas

- **Estado:** Cumplido
    
- **Descripción:** El sistema permite realizar consultas sobre la superclase que resuelven automáticamente las instancias de las subclases correspondientes.
    
- **Implementación:** Al consultar el endpoint de productos generales, el ORM realiza los `JOINs` necesarios para devolver una lista heterogénea de objetos (Bebidas, Carnes, Abarrotes) con sus atributos específicos.
    

### 6. Método Almacenado

- **Estado:** Cumplido
    
- **Descripción:** La lógica de negocio compleja se ha encapsulado dentro del motor de base de datos.
    
- **Implementación:** Se definió la función `calcular_valor_inventario` en PL/pgSQL, la cual es invocada directamente desde el backend mediante sentencias SQL textuales.
    

## Instrucciones de Ejecución

### 1. Levantar el Entorno (Backend + Base de Datos)

Abra una terminal en la carpeta raíz del proyecto y ejecute:

```
docker compose up --build
```

Espere unos segundos hasta ver el mensaje `Application startup complete`.

- 🌐 **API:** `http://localhost:8000`
    
- 🗄️ **Base de Datos:** Puerto `5432`
    

### 2. Evaluación de Scripts SQL (Parte 2 de la Rúbrica)

Para verificar que los scripts SQL (`01_ddl_esquema.sql` y `02_dml_pruebas.sql`) son correctos y funcionan de manera autónoma en el motor de base de datos, ejecute los siguientes comandos en otra terminal.

Esto creará una base de datos limpia llamada `tienda` y ejecutará los scripts entregables:

**Paso A: Crear base de datos de prueba**

```
docker compose exec db psql -U postgres -c "CREATE DATABASE tienda;"
```

_(Si la base de datos ya existe, puede omitir este paso o borrarla previamente)_

**Paso B: Ejecutar DDL (Creación de Esquema, Tipos y Funciones)**

```
docker compose exec -T db psql -U postgres -d tienda < scripts/01_ddl_esquema.sql
```

_(Asegúrese de ajustar la ruta `scripts/` si sus archivos están en la raíz)_

**Paso C: Ejecutar DML (Datos de prueba y Consultas Complejas)**

```
docker compose exec -T db psql -U postgres -d tienda < scripts/02_dml_pruebas.sql
```

> **Nota:** Si no aparecen errores, los scripts cumplen con la integridad referencial y la lógica SQL solicitada.

## Estructura del Proyecto

- `app/`: Código fuente del Backend (FastAPI, Modelos SQLAlchemy).
    
- `scripts/01_ddl_esquema.sql`: Script de definición de estructura (Entregable).
    
- `scripts/02_dml_pruebas.sql`: Script de manipulación y consultas (Entregable).
    
- `docker-compose.yml`: Orquestación de contenedores.