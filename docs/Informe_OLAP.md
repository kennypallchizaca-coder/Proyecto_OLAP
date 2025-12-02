# INFORME TÉCNICO: SISTEMA OLAP - DATAWAREHOUSE

## PROYECTO: Sistema de Análisis de Ventas con Modelo Dimensional

**Materia:** Gestión de Bases de Datos  
**Docente:** Germán Parra  
**Fecha:** Diciembre 2025

---

## TABLA DE CONTENIDOS

1. [Esquema de Datos OLAP](#1-esquema-de-datos-olap)
2. [Herramienta OLAP Elegida](#2-herramienta-olap-elegida)
3. [Configuración del DBMS y OLAP](#3-configuración-del-dbms-y-olap)
4. [Proceso ETL](#4-proceso-etl)
5. [Conclusiones](#5-conclusiones)
6. [Referencias Bibliográficas](#6-referencias-bibliográficas)

---

## 1. ESQUEMA DE DATOS OLAP

### 1.1 Modelo Dimensional Implementado: MODELO ESTRELLA

Se eligió el **Modelo Estrella (Star Schema)** para el diseño del Data Warehouse por las siguientes razones:

#### Justificación de la Elección del Modelo Estrella

| Aspecto | Modelo Estrella | Modelo Copo de Nieve |
|---------|-----------------|----------------------|
| **Complejidad de consultas** | ✅ Menos JOINs, consultas más simples | ❌ Más JOINs, consultas complejas |
| **Rendimiento** | ✅ Mejor rendimiento en agregaciones | ❌ Menor rendimiento por normalización |
| **Compatibilidad con BI** | ✅ Power BI/Tableau optimizados para estrella | ⚠️ Requiere más configuración |
| **Mantenimiento** | ✅ Más fácil de entender y mantener | ❌ Mayor complejidad estructural |
| **Espacio en disco** | ⚠️ Mayor redundancia | ✅ Menos redundancia |
| **ETL** | ✅ Proceso más simple | ❌ Transformaciones más complejas |

**Decisión:** Para un sistema de análisis de ventas donde el rendimiento de consultas es crítico y se utilizará Power BI como herramienta de visualización, el Modelo Estrella es la opción óptima.

### 1.2 Diagrama del Modelo Estrella

```
                                    ┌─────────────────┐
                                    │   DIMTIEMPO     │
                                    ├─────────────────┤
                                    │ TiempoKey (PK)  │
                                    │ Fecha           │
                                    │ Año             │
                                    │ Semestre        │
                                    │ Trimestre       │
                                    │ Mes             │
                                    │ Semana          │
                                    │ DiaSemana       │
                                    └────────┬────────┘
                                             │
    ┌─────────────────┐             ┌────────┴────────┐             ┌─────────────────┐
    │  DIMPRODUCTO    │             │                 │             │   DIMCLIENTE    │
    ├─────────────────┤             │                 │             ├─────────────────┤
    │ ProductoKey(PK) │─────────────┤                 ├─────────────│ ClienteKey (PK) │
    │ Codigo          │             │                 │             │ Codigo          │
    │ Nombre          │             │   FACTVENTAS    │             │ NombreCompleto  │
    │ NombreCategoria │             │                 │             │ Ciudad          │
    │ NombreProveedor │             │  (Tabla Hechos) │             │ Pais            │
    │ PrecioUnitario  │             │                 │             │ UbicacionKey    │
    │ PorcentajeIVA   │             │                 │             └─────────────────┘
    │ TipoIVA         │             │                 │
    └─────────────────┘             │                 │             ┌─────────────────┐
                                    │                 │             │  DIMEMPLEADO    │
    ┌─────────────────┐             │                 │             ├─────────────────┤
    │  DIMCATEGORIA   │─────────────┤                 ├─────────────│ EmpleadoKey(PK) │
    ├─────────────────┤             │                 │             │ Codigo          │
    │ CategoriaKey(PK)│             │                 │             │ NombreCompleto  │
    │ Codigo          │             │                 │             │ Cargo           │
    │ Nombre          │             │                 │             └─────────────────┘
    │ Descripcion     │             │                 │
    └─────────────────┘             │                 │             ┌─────────────────┐
                                    │                 │             │DIMMODALIDADPAGO │
    ┌─────────────────┐             │                 │             ├─────────────────┤
    │  DIMPROVEEDOR   │─────────────┤                 ├─────────────│ModalidadKey(PK) │
    ├─────────────────┤             │                 │             │ Codigo          │
    │ ProveedorKey(PK)│             │                 │             │ Descripcion     │
    │ Codigo          │             │                 │             │ TipoPago        │
    │ Nombre          │             └────────┬────────┘             │ Cuotas          │
    │ Ciudad          │                      │                      │ TasaInteres     │
    │ Pais            │                      │                      └─────────────────┘
    │ UbicacionKey    │             ┌────────┴────────┐
    └─────────────────┘             │  DIMUBICACION   │
                                    ├─────────────────┤
                                    │UbicacionKey(PK) │
                                    │ Pais            │
                                    │ Ciudad          │
                                    │ Region          │
                                    └─────────────────┘
```

### 1.3 Tabla de Hechos: FACTVENTAS

| Campo | Tipo | Descripción |
|-------|------|-------------|
| FactVentaID | NUMBER(19) | Clave primaria |
| TiempoKey | NUMBER(10) | FK → DimTiempo |
| ProductoKey | NUMBER(10) | FK → DimProducto |
| CategoriaKey | NUMBER(10) | FK → DimCategoria |
| ClienteKey | NUMBER(10) | FK → DimCliente |
| ProveedorKey | NUMBER(10) | FK → DimProveedor |
| EmpleadoKey | NUMBER(10) | FK → DimEmpleado |
| ModalidadKey | NUMBER(10) | FK → DimModalidadPago |
| UbicacionClienteKey | NUMBER(10) | FK → DimUbicacion |
| Cantidad | NUMBER(10) | Medida: unidades vendidas |
| PrecioUnitario | NUMBER(18,2) | Medida: precio de venta |
| PorcentajeIVA | NUMBER(5,2) | Medida: % IVA aplicado |
| MontoSubtotal | NUMBER(18,2) | Medida: subtotal sin IVA |
| MontoIVA | NUMBER(18,2) | Medida: monto del IVA |
| MontoTotal | NUMBER(18,2) | Medida: total con IVA |

### 1.4 Dimensiones Implementadas (8 dimensiones)

| Dimensión | Registros | Descripción |
|-----------|-----------|-------------|
| DimTiempo | 2,192 | Calendario 2020-2025 (año, trimestre, mes, semana, día) |
| DimUbicacion | 5 | Ciudades de Ecuador (Sierra/Costa) |
| DimCategoria | 5 | Categorías de productos |
| DimProveedor | 10 | Proveedores ecuatorianos |
| DimCliente | 20 | Clientes registrados |
| DimEmpleado | 5 | Vendedores de la empresa |
| DimModalidadPago | 7 | Formas de pago (efectivo, tarjeta, etc.) |
| DimProducto | 200 | Productos desnormalizados |

### 1.5 Hechos de Información Implementados

Se implementaron **3 hechos** de los 5 propuestos en el manual:

#### Hecho (a): Producto más vendido por proveedor, tiempo y ubicación
- **Vista:** `VW_VENTASPRODUCTOPROVEEDOR`
- **Dimensiones:** Tiempo, Producto, Proveedor, Ubicación
- **Métricas:** Unidades vendidas, Venta total, Promedio

#### Hecho (b): Forma de pago preferida por tiempo y región
- **Vista:** `VW_VENTASMODALIDADPAGO`
- **Dimensiones:** Tiempo, ModalidadPago, Ubicación, Cliente
- **Métricas:** Número de pedidos, Clientes únicos, Ticket promedio

#### Hecho (e): Mejor vendedor por categoría, tiempo, ubicación y modalidad
- **Vista:** `VW_VENTASEMPLEADO`
- **Dimensiones:** Tiempo, Empleado, Categoría, Ubicación, ModalidadPago
- **Métricas:** Pedidos, Clientes atendidos, Venta total

---

## 2. HERRAMIENTA OLAP ELEGIDA

### 2.1 Herramienta Seleccionada: Oracle Database 21c + Power BI

#### Componentes del Stack Tecnológico

| Componente | Tecnología | Función |
|------------|------------|---------|
| **DBMS** | Oracle Database 21c Express Edition | Almacenamiento y procesamiento OLAP |
| **Motor OLAP** | Oracle nativo (vistas materializadas, índices) | Agregaciones y consultas analíticas |
| **Visualización** | Power BI Desktop | Dashboards y reportes interactivos |
| **ETL** | PL/SQL Scripts | Extracción, transformación y carga |

### 2.2 Justificación de la Elección

#### ¿Por qué Oracle Database?

1. **Capacidades OLAP nativas:**
   - Funciones analíticas avanzadas (ROLLUP, CUBE, GROUPING SETS)
   - Vistas materializadas para pre-agregación
   - Índices bitmap para consultas dimensionales

2. **Escalabilidad:**
   - Maneja eficientemente más de 600,000 registros en FactVentas
   - Soporte para particionamiento de tablas

3. **Compatibilidad:**
   - Conector nativo para Power BI
   - Driver ODBC/JDBC estándar

4. **Disponibilidad:**
   - Oracle XE es gratuito para desarrollo y educación
   - Documentación extensa

#### ¿Por qué Power BI?

1. **Facilidad de uso:** Interfaz drag-and-drop intuitiva
2. **Conectividad:** Conector Oracle incluido
3. **Visualizaciones:** Amplia galería de gráficos
4. **Costo:** Versión Desktop gratuita
5. **Adopción:** Herramienta líder en el mercado BI

### 2.3 Alternativas Consideradas

| Herramienta | Ventajas | Desventajas | Decisión |
|-------------|----------|-------------|----------|
| Oracle + Power BI | Robusto, escalable, gratuito | Requiere instalación local | ✅ **Elegida** |
| SQL Server + SSAS | Integración Microsoft nativa | Licenciamiento costoso | ❌ |
| PostgreSQL + Metabase | 100% open source | Menos funciones OLAP | ❌ |
| Snowflake | Cloud-native, muy escalable | Costo por uso | ❌ |

---

## 3. CONFIGURACIÓN DEL DBMS Y OLAP

### 3.1 Requisitos del Sistema

| Componente | Requisito Mínimo | Recomendado |
|------------|------------------|-------------|
| Sistema Operativo | Windows 10 64-bit | Windows 11 64-bit |
| RAM | 4 GB | 8 GB |
| Espacio en Disco | 10 GB | 20 GB |
| Oracle Database | 21c XE | 21c XE |
| Power BI Desktop | Última versión | Última versión |

### 3.2 Instalación de Oracle Database 21c XE

#### Paso 1: Descarga
```
https://www.oracle.com/database/technologies/xe-downloads.html
```

#### Paso 2: Instalación
```powershell
# Ejecutar como Administrador
setup.exe /s /v"RSP_FILE=C:\oracle\response.rsp"
```

#### Paso 3: Configuración de Variables de Entorno
```powershell
# Agregar al PATH
$env:ORACLE_HOME = "C:\app\oracle\product\21c\dbhomeXE"
$env:PATH += ";$env:ORACLE_HOME\bin"
```

### 3.3 Configuración de la Base de Datos

#### Conexión al Pluggable Database
```sql
-- Conectar como SYSDBA
sqlplus sys/password@localhost:1521/XE as sysdba

-- Cambiar a PDB
ALTER SESSION SET CONTAINER = XEPDB1;

-- Crear usuario para el proyecto
CREATE USER proyecto_olap IDENTIFIED BY "Password2025";
GRANT CONNECT, RESOURCE, DBA TO proyecto_olap;
GRANT UNLIMITED TABLESPACE TO proyecto_olap;
```

#### Cadena de Conexión
```
Usuario: proyecto_olap
Password: Password2025
Host: localhost
Puerto: 1521
Servicio: XEPDB1
```

### 3.4 Configuración de Power BI

#### Paso 1: Instalar Oracle Instant Client
```
https://www.oracle.com/database/technologies/instant-client/winx64-64-downloads.html
```
- Descargar: instantclient-basic-windows.x64-21.x.0.0.0dbru.zip
- Extraer en: `C:\oracle\instantclient_21`
- Agregar al PATH del sistema

#### Paso 2: Configurar TNS
Crear archivo `tnsnames.ora` en `C:\oracle\instantclient_21\network\admin\`:
```
XEPDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = localhost)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = XEPDB1)
    )
  )
```

#### Paso 3: Conectar desde Power BI
1. Obtener datos → Base de datos Oracle
2. Servidor: `localhost:1521/XEPDB1`
3. Modo: Import (recomendado para mejor rendimiento)
4. Credenciales: `USUARIO_OLAP` / `OLAPReadOnly2025`

### 3.5 Estructura de Archivos del Proyecto

```
Proyecto_OLAP/
├── sql/
│   └── oracle/
│       ├── oltp/
│       │   ├── Tablas.sql          # Esquema transaccional
│       │   └── Datos_Tablas.sql    # Carga de datos OLTP
│       └── olap/
│           ├── TablaDatosDim.sql   # Esquema dimensional
│           ├── ETL.sql             # Proceso ETL
│           ├── VistasOLAP_PowerBI.sql  # Vistas para BI
│           └── UsuarioOLAP.sql     # Usuario de solo lectura
├── docs/
│   ├── Guia_Instalacion.md
│   └── Informe_OLAP.md
└── README.md
```

---

## 4. PROCESO ETL

### 4.1 Diagrama del Proceso ETL

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           PROCESO ETL                                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────┐    ┌──────────────┐    ┌─────────────┐    ┌─────────────┐ │
│  │  EXTRACCIÓN │───▶│TRANSFORMACIÓN│───▶│    CARGA    │───▶│ VERIFICACIÓN│ │
│  └─────────────┘    └──────────────┘    └─────────────┘    └─────────────┘ │
│                                                                              │
│  Tablas OLTP:        Operaciones:        Tablas OLAP:      Validaciones:   │
│  - CATEGORIA         - Limpieza          - DIMTIEMPO       - Conteos       │
│  - PROVEEDOR         - Desnormalización  - DIMUBICACION    - Integridad    │
│  - EMPLEADO          - Generación de     - DIMCATEGORIA    - Totales       │
│  - CLIENTE             claves surrogate  - DIMPROVEEDOR                    │
│  - MODALIDAD_PAGO    - Cálculo de        - DIMCLIENTE                      │
│  - PRODUCTO            regiones          - DIMEMPLEADO                     │
│  - PEDIDO            - Enriquecimiento   - DIMMODALIDADPAGO                │
│  - DETALLE_PEDIDO      de tiempo         - DIMPRODUCTO                     │
│                                          - FACTVENTAS                       │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 4.2 Fases del ETL Implementado

#### FASE 1: Carga de DimTiempo (Calendario 2020-2025)
```sql
-- Genera 2,192 registros de fechas con atributos temporales
-- TiempoKey = YYYYMMDD (ej: 20251201)
-- Incluye: Año, Semestre, Trimestre, Mes, Semana, Día, EsFinDeSemana
```

**Transformaciones aplicadas:**
- Generación de clave surrogate basada en fecha (YYYYMMDD)
- Cálculo de semestre (1 o 2)
- Cálculo de trimestre (Q1-Q4)
- Determinación de día laboral vs fin de semana
- Nombres en español (Enero, Lunes, etc.)

#### FASE 2: Carga de DimUbicacion
```sql
-- Extrae ciudades únicas de CLIENTE y PROVEEDOR
-- Asigna región: Sierra (Quito, Cuenca, Loja) o Costa (Guayaquil, Manta)
```

**Transformaciones aplicadas:**
- UNION de ciudades de clientes y proveedores
- Clasificación geográfica por región
- Eliminación de duplicados

#### FASE 3: Carga de Dimensiones Maestras
```sql
-- DimCategoria: Copia directa con clave surrogate
-- DimProveedor: Enriquecido con UbicacionKey
-- DimCliente: Enriquecido con UbicacionKey
-- DimEmpleado: Copia directa
-- DimModalidadPago: Enriquecido con EsTarjeta y DescripcionCompleta
```

**Transformaciones aplicadas:**
- Generación de claves surrogate mediante secuencias
- JOIN con DimUbicacion para asignar ubicaciones
- Cálculo de campo derivado `EsTarjeta`
- Concatenación para `DescripcionCompleta`

#### FASE 4: Carga de DimProducto (Desnormalizada)
```sql
-- Producto desnormalizado con nombre de categoría y proveedor
-- Incluye clasificación de IVA (IVA 15% / IVA 0%)
```

**Transformaciones aplicadas:**
- Desnormalización (incluye NombreCategoria, NombreProveedor)
- Clasificación de tipo de IVA
- Campo booleano TieneIVA

#### FASE 5: Carga de FactVentas
```sql
-- Une DETALLE_PEDIDO con PEDIDO y todas las dimensiones
-- Calcula métricas de venta
```

**Transformaciones aplicadas:**
- Resolución de claves foráneas a claves surrogate
- Mapeo de fecha a TiempoKey
- Cálculo de Subtotal, IVA y Total por línea

#### FASE 6: Verificación
```sql
-- Conteo de registros por tabla
-- Estadísticas de ventas
-- Validación de integridad referencial
```

### 4.3 Volumen de Datos Procesados

| Tabla | Registros | Descripción |
|-------|-----------|-------------|
| PEDIDO (OLTP) | 100,000 | Pedidos generados |
| DETALLE_PEDIDO (OLTP) | ~650,000 | 3-10 productos por pedido |
| FACTVENTAS (OLAP) | ~650,000 | Un registro por línea de detalle |
| DIMTIEMPO | 2,192 | 6 años de calendario |

### 4.4 Script de Ejecución del ETL

```sql
-- Orden de ejecución:
-- 1. Crear esquema OLTP
@sql/oracle/oltp/Tablas.sql

-- 2. Cargar datos OLTP (toma ~10-15 minutos)
@sql/oracle/oltp/Datos_Tablas.sql

-- 3. Crear esquema OLAP
@sql/oracle/olap/TablaDatosDim.sql

-- 4. Ejecutar ETL (toma ~5-10 minutos)
@sql/oracle/olap/ETL.sql

-- 5. Crear vistas para Power BI
@sql/oracle/olap/VistasOLAP_PowerBI.sql

-- 6. Crear usuario de solo lectura
@sql/oracle/olap/UsuarioOLAP.sql
```

### 4.5 Tiempo de Ejecución Estimado

| Fase | Tiempo Aproximado |
|------|-------------------|
| Creación de tablas OLTP | 5 segundos |
| Carga de 100,000 pedidos | 10-15 minutos |
| Creación de tablas OLAP | 5 segundos |
| Proceso ETL completo | 5-10 minutos |
| **Total** | **~20-30 minutos** |

---

## 5. CONCLUSIONES

### 5.1 Objetivos Alcanzados

✅ **Diseño dimensional:** Implementación exitosa de modelo estrella con 8 dimensiones y 1 tabla de hechos.

✅ **Volumen de datos:** Generación de 100,000 pedidos con más de 650,000 líneas de detalle.

✅ **Proceso ETL:** Desarrollo completo de scripts PL/SQL para extracción, transformación y carga.

✅ **Análisis OLAP:** Creación de 7 vistas optimizadas para consultas analíticas.

✅ **Seguridad:** Implementación de usuario de solo lectura para consultas BI.

✅ **Integración BI:** Configuración lista para conexión con Power BI/Tableau.

### 5.2 Lecciones Aprendidas

1. **Modelo Estrella vs Copo de Nieve:** El modelo estrella demostró ser más eficiente para consultas agregadas y más simple de mantener.

2. **Claves Surrogate:** El uso de claves surrogate (secuencias) facilita el manejo de dimensiones que cambian lentamente (SCD).

3. **Desnormalización:** La desnormalización de DimProducto mejora significativamente el rendimiento de consultas.

4. **ETL Incremental:** Para producción, se recomienda implementar cargas incrementales en lugar de cargas completas.

### 5.3 Mejoras Futuras

- Implementar Slowly Changing Dimensions (SCD Tipo 2)
- Agregar particionamiento por fecha en FactVentas
- Crear vistas materializadas para agregaciones frecuentes
- Implementar ETL incremental con marcas de tiempo

---

## 6. REFERENCIAS BIBLIOGRÁFICAS

1. Kimball, R., & Ross, M. (2013). *The Data Warehouse Toolkit: The Definitive Guide to Dimensional Modeling* (3rd ed.). Wiley.

2. Oracle Corporation. (2024). *Oracle Database Data Warehousing Guide, 21c*. https://docs.oracle.com/en/database/oracle/oracle-database/21/dwhsg/

3. Microsoft. (2024). *Power BI Documentation*. https://docs.microsoft.com/en-us/power-bi/

4. Inmon, W. H. (2005). *Building the Data Warehouse* (4th ed.). Wiley.

5. Oracle Corporation. (2024). *Oracle Database PL/SQL Language Reference*. https://docs.oracle.com/en/database/oracle/oracle-database/21/lnpls/

---

**Documento generado automáticamente**  
*Proyecto OLAP - Sistema de Análisis de Ventas*  
*Diciembre 2025*
