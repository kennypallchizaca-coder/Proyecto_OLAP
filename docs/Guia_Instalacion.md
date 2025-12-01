# 📖 GUÍA COMPLETA DEL PROYECTO OLAP

## Sistema de Pedidos - Oracle Database 21c + Power BI

---

# 📚 ÍNDICE

1. [Requisitos Previos](#-parte-1-requisitos-previos)
2. [Instalación de la Base de Datos](#-parte-2-instalación-de-la-base-de-datos)
3. [Cómo Usar el Sistema OLAP](#-parte-3-cómo-usar-el-sistema-olap)
4. [Conexión con Power BI](#-parte-4-conexión-con-power-bi)
5. [Consultas OLAP de Ejemplo](#-parte-5-consultas-olap-de-ejemplo)
6. [Solución de Problemas](#-parte-6-solución-de-problemas)

---

# 🔧 PARTE 1: REQUISITOS PREVIOS

## 1.1 Software Necesario

| Software | Versión | Descarga | Uso |
|----------|---------|----------|-----|
| **Oracle Database** | 21c o superior | [oracle.com](https://www.oracle.com/database/) | Base de datos |
| **SQL Developer** | Última | [oracle.com](https://www.oracle.com/tools/downloads/sqldev-downloads.html) | Interfaz gráfica SQL |
| **SQLcl** | Última | [oracle.com](https://www.oracle.com/tools/downloads/sqlcl-downloads.html) | Línea de comandos |
| **Power BI Desktop** | Última | [powerbi.microsoft.com](https://powerbi.microsoft.com/downloads/) | Visualización |
| **Oracle Instant Client** | 21c | [oracle.com](https://www.oracle.com/database/technologies/instant-client.html) | Conexión Power BI |

## 1.2 Conocimientos Previos

- SQL básico (SELECT, INSERT, JOIN)
- Conceptos de Data Warehouse
- Uso básico de Power BI

## 1.3 Archivos del Proyecto

```
📁 Proyecto_OLAP/
├── 📄 README.md                      ← Informe técnico
├── 📁 docs/
│   └── 📄 Guia_Instalacion.md        ← Esta guía
└── 📁 sql/
    ├── 📁 oltp/
    │   ├── 📄 Tablas.sql             ← Paso 1: Crear tablas
    │   └── 📄 Datos_Tablas.sql       ← Paso 2: Insertar datos
    └── 📁 olap/
        ├── 📄 TablaDatosDim.sql      ← Paso 3: Crear dimensiones
        ├── 📄 ETL.sql                ← Paso 4: Cargar datos OLAP
        ├── 📄 VistasOLAP_PowerBI.sql ← Paso 5: Crear vistas
        └── 📄 UsuarioOLAP.sql        ← Paso 6: Usuario lectura
```

---

# 💾 PARTE 2: INSTALACIÓN DE LA BASE DE DATOS

## 2.1 Crear Usuario en Oracle

### Paso 1: Conectarse como Administrador

```sql
-- En SQL Developer o SQLcl, conectarse como SYSDBA
sqlplus / as sysdba
```

### Paso 2: Crear Usuario del Proyecto

```sql
-- ═══════════════════════════════════════════════════════
-- CREAR USUARIO PARA EL PROYECTO
-- ═══════════════════════════════════════════════════════

-- Crear el usuario
CREATE USER alexis3 IDENTIFIED BY "MiPassword123";

-- Otorgar permisos
GRANT CONNECT, RESOURCE TO alexis3;
GRANT CREATE SESSION TO alexis3;
GRANT CREATE TABLE TO alexis3;
GRANT CREATE VIEW TO alexis3;
GRANT CREATE PROCEDURE TO alexis3;
GRANT CREATE SEQUENCE TO alexis3;
GRANT UNLIMITED TABLESPACE TO alexis3;

COMMIT;
```

### Paso 3: Conectarse con el Nuevo Usuario

```sql
CONNECT alexis3/MiPassword123
```

---

## 2.2 Ejecutar Scripts en Orden

### 📋 ORDEN OBLIGATORIO DE EJECUCIÓN

```
┌─────────────────────────────────────────────────────────────────┐
│  PASO 1  │  sql/oltp/Tablas.sql         │  Crear 8 tablas OLTP │
├──────────┼─────────────────────────────────────────────────────┤
│  PASO 2  │  sql/oltp/Datos_Tablas.sql   │  Insertar datos      │
├──────────┼─────────────────────────────────────────────────────┤
│  PASO 3  │  sql/olap/TablaDatosDim.sql  │  Crear modelo OLAP   │
├──────────┼─────────────────────────────────────────────────────┤
│  PASO 4  │  sql/olap/ETL.sql            │  Cargar dimensiones  │
├──────────┼─────────────────────────────────────────────────────┤
│  PASO 5  │  sql/olap/VistasOLAP_PowerBI │  Crear vistas BI     │
├──────────┼─────────────────────────────────────────────────────┤
│  PASO 6  │  sql/olap/UsuarioOLAP.sql    │  Usuario lectura     │
└─────────────────────────────────────────────────────────────────┘
```

### Ejecutar cada Script

En SQL Developer:
1. Abrir el archivo `.sql`
2. Conectarse con usuario `alexis3`
3. Presionar **F5** o clic en **Ejecutar Script**
4. Esperar a que termine
5. Verificar que no haya errores

---

## 2.3 Verificar Instalación Correcta

### Verificar Tablas OLTP

```sql
-- Debe mostrar 8 tablas
SELECT table_name, num_rows 
FROM user_tables 
WHERE table_name IN ('CATEGORIA','PROVEEDOR','EMPLEADO','CLIENTE',
                     'MODALIDADPAGO','PRODUCTO','PEDIDO','DETALLEPEDIDO')
ORDER BY table_name;
```

**Resultado esperado:**

| TABLE_NAME | NUM_ROWS |
|------------|----------|
| CATEGORIA | 5 |
| CLIENTE | 20 |
| DETALLEPEDIDO | ~550,000 |
| EMPLEADO | 5 |
| MODALIDADPAGO | 6 |
| PEDIDO | 100,000 |
| PRODUCTO | 200 |
| PROVEEDOR | 10 |

### Verificar Tablas OLAP

```sql
-- Debe mostrar 9 tablas OLAP
SELECT table_name, num_rows 
FROM user_tables 
WHERE table_name LIKE 'DIM%' OR table_name = 'FACTVENTAS'
ORDER BY table_name;
```

**Resultado esperado:**

| TABLE_NAME | NUM_ROWS |
|------------|----------|
| DIMCATEGORIA | 5 |
| DIMCLIENTE | 20 |
| DIMEMPLEADO | 5 |
| DIMMODALIDADPAGO | 6 |
| DIMPRODUCTO | 200 |
| DIMPROVEEDOR | 10 |
| DIMTIEMPO | 2,192 |
| DIMUBICACION | 4 |
| FACTVENTAS | ~550,000 |

---

# 🎯 PARTE 3: CÓMO USAR EL SISTEMA OLAP

## 3.1 ¿Qué es OLAP?

**OLAP** (Online Analytical Processing) permite analizar grandes volúmenes de datos desde múltiples perspectivas llamadas **dimensiones**.

```
                    ┌─────────────┐
                    │  ¿CUÁNTO?   │  ← HECHOS (métricas)
                    │  Cantidad   │     - Cantidad vendida
                    │  Total $    │     - Monto total
                    │  IVA        │     - IVA cobrado
                    └──────┬──────┘
                           │
    ┌──────────────────────┼──────────────────────┐
    │                      │                      │
    ▼                      ▼                      ▼
┌─────────┐          ┌─────────┐          ┌─────────┐
│ ¿CUÁNDO?│          │  ¿QUÉ?  │          │ ¿DÓNDE? │
│ Tiempo  │          │Producto │          │Ubicación│
└─────────┘          └─────────┘          └─────────┘
  - Año                - Nombre             - Ciudad
  - Mes                - Categoría          - País
  - Día                - Precio
```

## 3.2 El Modelo Estrella

Nuestro sistema usa un **Modelo Estrella** con:

- **1 Tabla de Hechos:** `FactVentas` (centro)
- **8 Dimensiones:** Tablas que rodean los hechos

```
         DimTiempo          DimProducto         DimCliente
              │                  │                  │
              └──────────────────┼──────────────────┘
                                 │
    DimProveedor ────────── FactVentas ────────── DimEmpleado
                                 │
              ┌──────────────────┼──────────────────┐
              │                  │                  │
         DimCategoria    DimModalidadPago      DimUbicacion
```

## 3.3 Las 8 Dimensiones Explicadas

### 📅 DimTiempo (Dimensión Temporal)

```sql
-- Estructura:
TiempoKey       -- Clave única (formato: YYYYMMDD)
Fecha           -- Fecha completa
Anio            -- Año (2020-2025)
Trimestre       -- Trimestre (1-4)
Mes             -- Número de mes (1-12)
NombreMes       -- Nombre del mes
Dia             -- Día del mes
DiaSemana       -- Día de la semana
NombreDia       -- Nombre del día
```

**Uso:** Analizar ventas por período (año, mes, día)

### 📦 DimProducto (Dimensión de Productos)

```sql
-- Estructura:
ProductoKey         -- Clave única
CodigoProducto      -- Código original
NombreProducto      -- Nombre del producto
Descripcion         -- Descripción detallada
PrecioUnitario      -- Precio de venta
PorcentajeIVA       -- 0% o 15%
NombreCategoria     -- Categoría (desnormalizado)
NombreProveedor     -- Proveedor (desnormalizado)
```

**Uso:** Analizar ventas por producto, categoría o proveedor

### 👤 DimCliente (Dimensión de Clientes)

```sql
-- Estructura:
ClienteKey          -- Clave única
CodigoCliente       -- Código original
NombreCompleto      -- Nombre del cliente
Email               -- Correo electrónico
Telefono            -- Teléfono
Direccion           -- Dirección
Ciudad              -- Ciudad
Pais                -- País
```

**Uso:** Analizar ventas por cliente o segmento

### 🏭 DimProveedor (Dimensión de Proveedores)

```sql
-- Estructura:
ProveedorKey        -- Clave única
CodigoProveedor     -- Código original
NombreProveedor     -- Nombre de la empresa
Contacto            -- Persona de contacto
Telefono            -- Teléfono
Email               -- Correo electrónico
Ciudad              -- Ciudad del proveedor
```

**Uso:** Analizar ventas por proveedor

### 👔 DimEmpleado (Dimensión de Empleados)

```sql
-- Estructura:
EmpleadoKey         -- Clave única
CodigoEmpleado      -- Código original
NombreCompleto      -- Nombre del empleado
Cargo               -- Cargo/Puesto
FechaContratacion   -- Fecha de ingreso
```

**Uso:** Analizar ventas por vendedor/empleado

### 🏷️ DimCategoria (Dimensión de Categorías)

```sql
-- Estructura:
CategoriaKey        -- Clave única
NombreCategoria     -- Nombre (Electrónica, Ropa, etc.)
Descripcion         -- Descripción de la categoría
```

**Uso:** Analizar ventas por tipo de producto

### 💳 DimModalidadPago (Dimensión de Pagos)

```sql
-- Estructura:
ModalidadPagoKey    -- Clave única
TipoPago            -- Efectivo, Transferencia, Tarjeta
NumeroCuotas        -- 0, 3, 6, 12 cuotas
Descripcion         -- Descripción completa
```

**Uso:** Analizar preferencias de pago

### 📍 DimUbicacion (Dimensión Geográfica)

```sql
-- Estructura:
UbicacionKey        -- Clave única
Ciudad              -- Ciudad
Pais                -- País
```

**Uso:** Analizar ventas por región

## 3.4 La Tabla de Hechos: FactVentas

```sql
-- Estructura:
VentaKey            -- Clave única
TiempoKey           -- FK → DimTiempo
ProductoKey         -- FK → DimProducto
ClienteKey          -- FK → DimCliente
ProveedorKey        -- FK → DimProveedor
EmpleadoKey         -- FK → DimEmpleado
CategoriaKey        -- FK → DimCategoria
ModalidadPagoKey    -- FK → DimModalidadPago
UbicacionKey        -- FK → DimUbicacion

-- MÉTRICAS (lo que se mide):
Cantidad            -- Unidades vendidas
Subtotal            -- Monto sin IVA
MontoIVA            -- IVA cobrado
Total               -- Monto total
PedidoID            -- Referencia al pedido original
```

---

# 📊 PARTE 4: CONEXIÓN CON POWER BI

## 4.1 Instalar Oracle Instant Client

### Paso 1: Descargar

1. Ir a: https://www.oracle.com/database/technologies/instant-client.html
2. Seleccionar **Windows 64-bit**
3. Descargar **Basic Package** (instantclient-basic-windows.x64-21.X.zip)

### Paso 2: Extraer

1. Crear carpeta: `C:\oracle\instantclient_21`
2. Extraer el ZIP en esa carpeta

### Paso 3: Configurar PATH

1. Abrir **Variables de entorno del sistema**
2. Editar la variable **Path**
3. Agregar: `C:\oracle\instantclient_21`
4. Aceptar y cerrar
5. **Reiniciar Power BI**

## 4.2 Conectar Power BI a Oracle

### Paso 1: Abrir Power BI Desktop

### Paso 2: Obtener Datos

```
Inicio → Obtener datos → Base de datos → Base de datos de Oracle
```

### Paso 3: Configurar Conexión

| Campo | Valor |
|-------|-------|
| **Servidor** | `localhost:1521/XEPDB1` (o tu servidor) |
| **Modo** | Import (recomendado) |

### Paso 4: Ingresar Credenciales

| Campo | Valor |
|-------|-------|
| **Usuario** | `alexis3` |
| **Contraseña** | `MiPassword123` |

### Paso 5: Seleccionar Tablas

Marcar las siguientes tablas:

- ✅ `ALEXIS3.FACTVENTAS`
- ✅ `ALEXIS3.DIMTIEMPO`
- ✅ `ALEXIS3.DIMPRODUCTO`
- ✅ `ALEXIS3.DIMCLIENTE`
- ✅ `ALEXIS3.DIMPROVEEDOR`
- ✅ `ALEXIS3.DIMCATEGORIA`
- ✅ `ALEXIS3.DIMMODALIDADPAGO`
- ✅ `ALEXIS3.DIMEMPLEADO`
- ✅ `ALEXIS3.DIMUBICACION`

### Paso 6: Cargar

Clic en **Cargar** y esperar a que se importen los datos.

## 4.3 Verificar Relaciones

Power BI debería detectar automáticamente las relaciones. Verificar en:

```
Modelo → Ver relaciones
```

Deben existir 8 relaciones desde `FactVentas` hacia cada dimensión.

## 4.4 Crear Medidas DAX

### Medidas Básicas

```dax
-- Total de Ventas
Total Ventas = SUM(FACTVENTAS[TOTAL])

-- Cantidad Total
Cantidad Total = SUM(FACTVENTAS[CANTIDAD])

-- Número de Pedidos
Numero Pedidos = DISTINCTCOUNT(FACTVENTAS[PEDIDOID])

-- Ticket Promedio
Ticket Promedio = DIVIDE([Total Ventas], [Numero Pedidos])
```

### Medidas de IVA

```dax
-- Ventas con IVA 15%
Ventas IVA 15 = 
    CALCULATE(
        [Total Ventas], 
        DIMPRODUCTO[PORCENTAJEIVA] = 15
    )

-- Ventas con IVA 0%
Ventas IVA 0 = 
    CALCULATE(
        [Total Ventas], 
        DIMPRODUCTO[PORCENTAJEIVA] = 0
    )

-- Total IVA Cobrado
Total IVA = SUM(FACTVENTAS[MONTOIVA])
```

## 4.5 Crear Visualizaciones

### Dashboard Sugerido

| Visualización | Campos | Uso |
|---------------|--------|-----|
| **Tarjeta** | Total Ventas | KPI principal |
| **Tarjeta** | Numero Pedidos | KPI pedidos |
| **Tarjeta** | Ticket Promedio | KPI ticket |
| **Gráfico Barras** | Categoria + Total Ventas | Ventas por categoría |
| **Gráfico Líneas** | Fecha + Total Ventas | Tendencia temporal |
| **Gráfico Circular** | TipoPago + Total Ventas | Distribución pagos |
| **Tabla** | Producto + Cantidad + Total | Detalle productos |

---

# 🔍 PARTE 5: CONSULTAS OLAP DE EJEMPLO

## 5.1 Hecho (a): Ventas por Proveedor, Tiempo y Ubicación

```sql
-- ═══════════════════════════════════════════════════════════════
-- CONSULTA OLAP: Productos por Proveedor, Tiempo y Ubicación
-- Dimensiones: Proveedor, Tiempo, Ubicación, Producto, Categoría (5)
-- ═══════════════════════════════════════════════════════════════

SELECT 
    dprov.NombreProveedor           AS Proveedor,
    dt.Anio                         AS Año,
    dt.NombreMes                    AS Mes,
    du.Ciudad                       AS Ciudad,
    dprod.NombreProducto            AS Producto,
    dc.NombreCategoria              AS Categoria,
    SUM(f.Cantidad)                 AS UnidadesVendidas,
    SUM(f.Total)                    AS VentaTotal,
    COUNT(DISTINCT f.PedidoID)      AS NumeroPedidos
FROM FactVentas f
    JOIN DimProveedor dprov ON dprov.ProveedorKey = f.ProveedorKey
    JOIN DimTiempo dt ON dt.TiempoKey = f.TiempoKey
    JOIN DimUbicacion du ON du.UbicacionKey = f.UbicacionKey
    JOIN DimProducto dprod ON dprod.ProductoKey = f.ProductoKey
    JOIN DimCategoria dc ON dc.CategoriaKey = f.CategoriaKey
GROUP BY 
    dprov.NombreProveedor, 
    dt.Anio, 
    dt.NombreMes, 
    du.Ciudad,
    dprod.NombreProducto, 
    dc.NombreCategoria
ORDER BY VentaTotal DESC
FETCH FIRST 20 ROWS ONLY;
```

## 5.2 Hecho (b): Modalidad de Pago por Tiempo y Región

```sql
-- ═══════════════════════════════════════════════════════════════
-- CONSULTA OLAP: Modalidad de Pago por Tiempo y Región
-- Dimensiones: ModalidadPago, Tiempo, Ubicación, Cliente (4)
-- ═══════════════════════════════════════════════════════════════

SELECT 
    dm.TipoPago                     AS FormaPago,
    dm.NumeroCuotas                 AS Cuotas,
    dt.Anio                         AS Año,
    dt.Trimestre                    AS Trimestre,
    du.Ciudad                       AS Ciudad,
    COUNT(*)                        AS NumeroTransacciones,
    SUM(f.Total)                    AS MontoTotal,
    ROUND(SUM(f.Total) * 100 / 
          SUM(SUM(f.Total)) OVER(), 2) AS PorcentajeTotal
FROM FactVentas f
    JOIN DimModalidadPago dm ON dm.ModalidadPagoKey = f.ModalidadPagoKey
    JOIN DimTiempo dt ON dt.TiempoKey = f.TiempoKey
    JOIN DimUbicacion du ON du.UbicacionKey = f.UbicacionKey
    JOIN DimCliente dc ON dc.ClienteKey = f.ClienteKey
GROUP BY 
    dm.TipoPago, 
    dm.NumeroCuotas, 
    dt.Anio, 
    dt.Trimestre, 
    du.Ciudad
ORDER BY MontoTotal DESC;
```

## 5.3 Hecho (e): Top Productos por Categoría

```sql
-- ═══════════════════════════════════════════════════════════════
-- CONSULTA OLAP: Producto Más Vendido por Categoría
-- Dimensiones: Categoría, Tiempo, Ubicación, ModalidadPago, Producto (5)
-- ═══════════════════════════════════════════════════════════════

WITH RankingProductos AS (
    SELECT 
        dc.NombreCategoria              AS Categoria,
        dprod.NombreProducto            AS Producto,
        dprod.PorcentajeIVA             AS IVA,
        SUM(f.Cantidad)                 AS CantidadVendida,
        SUM(f.Total)                    AS VentaTotal,
        RANK() OVER (
            PARTITION BY dc.NombreCategoria 
            ORDER BY SUM(f.Total) DESC
        ) AS Ranking
    FROM FactVentas f
        JOIN DimCategoria dc ON dc.CategoriaKey = f.CategoriaKey
        JOIN DimProducto dprod ON dprod.ProductoKey = f.ProductoKey
    GROUP BY 
        dc.NombreCategoria, 
        dprod.NombreProducto,
        dprod.PorcentajeIVA
)
SELECT * FROM RankingProductos 
WHERE Ranking <= 5
ORDER BY Categoria, Ranking;
```

## 5.4 Consulta de KPIs Generales

```sql
-- ═══════════════════════════════════════════════════════════════
-- DASHBOARD: KPIs Generales del Negocio
-- ═══════════════════════════════════════════════════════════════

SELECT 
    COUNT(DISTINCT f.PedidoID)      AS TotalPedidos,
    SUM(f.Cantidad)                 AS TotalUnidades,
    SUM(f.Subtotal)                 AS Subtotal,
    SUM(f.MontoIVA)                 AS TotalIVA,
    SUM(f.Total)                    AS VentasTotales,
    ROUND(AVG(f.Total), 2)          AS TicketPromedio,
    COUNT(DISTINCT f.ClienteKey)    AS ClientesUnicos,
    COUNT(DISTINCT f.ProductoKey)   AS ProductosVendidos
FROM FactVentas f;
```

## 5.5 Análisis de IVA

```sql
-- ═══════════════════════════════════════════════════════════════
-- ANÁLISIS: Distribución de Ventas por IVA
-- ═══════════════════════════════════════════════════════════════

SELECT 
    dprod.PorcentajeIVA             AS TipoIVA,
    COUNT(DISTINCT dprod.ProductoKey) AS NumProductos,
    SUM(f.Cantidad)                 AS UnidadesVendidas,
    SUM(f.Subtotal)                 AS Subtotal,
    SUM(f.MontoIVA)                 AS IVACobrado,
    SUM(f.Total)                    AS VentaTotal,
    ROUND(SUM(f.Total) * 100 / 
          SUM(SUM(f.Total)) OVER(), 2) AS Porcentaje
FROM FactVentas f
    JOIN DimProducto dprod ON dprod.ProductoKey = f.ProductoKey
GROUP BY dprod.PorcentajeIVA
ORDER BY TipoIVA DESC;
```

---

# 🔧 PARTE 6: SOLUCIÓN DE PROBLEMAS

## 6.1 Errores Comunes en Oracle

### Error: ORA-01017 (Usuario/Contraseña inválidos)

```sql
-- Verificar que el usuario existe
SELECT username FROM all_users WHERE username = 'ALEXIS3';

-- Resetear contraseña
ALTER USER alexis3 IDENTIFIED BY "NuevaPassword123";
```

### Error: ORA-00942 (Tabla no existe)

```sql
-- Verificar tablas del usuario
SELECT table_name FROM user_tables ORDER BY table_name;

-- Si ejecutaste con otro usuario, dar permisos:
GRANT SELECT ON alexis3.FactVentas TO tu_usuario;
```

### Error: ORA-01653 (Sin espacio)

```sql
-- Verificar espacio disponible
SELECT tablespace_name, bytes/1024/1024 MB 
FROM dba_free_space;

-- Agregar más espacio al tablespace
ALTER DATABASE DATAFILE '/path/to/file.dbf' RESIZE 2G;
```

## 6.2 Errores Comunes en Power BI

### Error: No se encuentra el controlador Oracle

**Solución:**
1. Descargar Oracle Instant Client
2. Extraer en `C:\oracle\instantclient_21`
3. Agregar al PATH del sistema
4. Reiniciar Power BI

### Error: Timeout de conexión

**Solución:**
1. Verificar que Oracle esté corriendo
2. Verificar firewall (puerto 1521)
3. Probar conexión con SQL Developer primero

### Error: Las relaciones no se detectan

**Solución:**
1. Ir a **Modelo** en Power BI
2. Crear relaciones manualmente:
   - FactVentas[TiempoKey] → DimTiempo[TiempoKey]
   - FactVentas[ProductoKey] → DimProducto[ProductoKey]
   - (repetir para cada dimensión)

## 6.3 Rendimiento Lento

### En Oracle

```sql
-- Actualizar estadísticas
EXEC DBMS_STATS.GATHER_SCHEMA_STATS('ALEXIS3');

-- Crear índices adicionales
CREATE INDEX idx_fact_tiempo ON FactVentas(TiempoKey);
CREATE INDEX idx_fact_producto ON FactVentas(ProductoKey);
```

### En Power BI

1. Usar modo **Import** en lugar de DirectQuery
2. Reducir columnas importadas
3. Crear agregaciones

---

# 📞 INFORMACIÓN DE REFERENCIA

## Credenciales por Defecto

| Usuario | Contraseña | Uso |
|---------|------------|-----|
| `alexis3` | (tu password) | Usuario principal |
| `usuario_olap` | OL@P_R3ad0nly2025 | Solo lectura (Power BI) |

## Volumen de Datos

| Tabla | Registros |
|-------|-----------|
| Pedidos OLTP | 100,000 |
| Detalle Pedidos | ~550,000 |
| FactVentas | ~550,000 |
| Productos | 200 |
| Clientes | 20 |

## Contacto

Para dudas sobre el proyecto, revisar el informe técnico en `README.md`.

---

**Guía de Instalación - Proyecto OLAP**  
**Oracle Database 21c + Power BI**  
**Versión:** 1.0 | **Fecha:** Noviembre 2025
