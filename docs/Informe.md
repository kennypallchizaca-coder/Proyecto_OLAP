# 📊 INFORME TÉCNICO - PROYECTO OLAP

## Sistema de Pedidos con Análisis Dimensional

**Materia:** Base de Datos  
**Fecha de Presentación:** 26 de Noviembre, 2025  
**Plataforma:** Azure SQL Database + Power BI  

---

## 📑 TABLA DE CONTENIDO

1. [Introducción](#1-introducción)
2. [Justificación del Modelo Estrella](#2-justificación-del-modelo-estrella)
3. [Herramienta OLAP Seleccionada](#3-herramienta-olap-seleccionada)
4. [Arquitectura del Sistema](#4-arquitectura-del-sistema)
5. [Configuración del SGBD](#5-configuración-del-sgbd)
6. [Proceso ETL](#6-proceso-etl)
7. [Hechos OLAP Implementados](#7-hechos-olap-implementados)
8. [Visualizaciones en Power BI](#8-visualizaciones-en-power-bi)
9. [Conclusiones](#9-conclusiones)

---

## 1. INTRODUCCIÓN

### 1.1 Objetivo del Proyecto

El presente proyecto implementa un sistema OLAP (Online Analytical Processing) para el análisis multidimensional de un esquema de pedidos de una empresa comercial. El sistema permite analizar ventas desde múltiples perspectivas: temporal, geográfica, por producto, proveedor, cliente y modalidad de pago.

### 1.2 Alcance

- **Esquema OLTP:** Sistema transaccional con gestión de pedidos, productos, clientes y proveedores
- **Esquema OLAP:** Data Warehouse dimensional con modelo estrella
- **ETL:** Procedimientos de extracción, transformación y carga automatizados
- **Visualización:** Reportes interactivos en Power BI

### 1.3 Requisitos del Negocio

El sistema debe responder a las siguientes preguntas de negocio:

1. ¿Cuáles productos se venden más por proveedor, período y ubicación?
2. ¿Cómo varían las modalidades de pago según región y tiempo?
3. ¿Cuál es el producto más vendido por categoría, tiempo, ubicación y forma de pago?

---

## 2. JUSTIFICACIÓN DEL MODELO ESTRELLA

### 2.1 Comparación Estrella vs Copo de Nieve

| Criterio | Modelo Estrella ⭐ | Modelo Copo de Nieve ❄️ |
|----------|-------------------|-------------------------|
| **Complejidad** | Baja - Dimensiones desnormalizadas | Alta - Dimensiones normalizadas |
| **Rendimiento** | Superior - Menos JOINs | Menor - Múltiples JOINs |
| **Facilidad BI** | Alta - Herramientas lo prefieren | Media - Requiere más configuración |
| **Espacio Disco** | Mayor - Datos redundantes | Menor - Sin redundancia |
| **Mantenimiento** | Simple | Complejo |
| **Comprensión** | Intuitivo para usuarios | Requiere conocimiento técnico |

### 2.2 Decisión: Modelo Estrella

**Seleccionamos el modelo Estrella por las siguientes razones:**

1. **Optimización para Power BI:** Power BI está diseñado para trabajar óptimamente con modelos estrella. Las relaciones 1:N entre dimensiones y hechos son el patrón esperado.

2. **Rendimiento en Consultas:** Al tener dimensiones desnormalizadas, las consultas requieren menos JOINs, resultando en tiempos de respuesta más rápidos.

3. **Facilidad de Uso:** Los usuarios de negocio pueden comprender fácilmente la estructura, facilitando la creación de reportes ad-hoc.

4. **Compatibilidad con Agregaciones:** Las funciones de agregación (SUM, COUNT, AVG) funcionan de manera eficiente sobre la tabla de hechos central.

5. **Escenario Académico:** Para un proyecto con 100,000 pedidos, la redundancia de datos no representa un problema significativo de almacenamiento.

### 2.3 Estructura Implementada

```
                    ┌──────────────┐
                    │  DimTiempo   │
                    └──────┬───────┘
                           │
┌──────────────┐    ┌──────┴───────┐    ┌──────────────┐
│ DimProducto  │────│              │────│ DimCliente   │
└──────────────┘    │              │    └──────────────┘
                    │  FactVentas  │
┌──────────────┐    │              │    ┌──────────────┐
│ DimProveedor │────│              │────│ DimEmpleado  │
└──────────────┘    └──────┬───────┘    └──────────────┘
                           │
┌──────────────┐    ┌──────┴───────┐    ┌──────────────┐
│DimCategoria  │────│              │────│DimUbicacion  │
└──────────────┘    └──────────────┘    └──────────────┘
                    │DimModalidadPago│
                    └────────────────┘
```

---

## 3. HERRAMIENTA OLAP SELECCIONADA

### 3.1 Power BI como Solución de Visualización

**Razones de Selección:**

| Factor | Power BI | Alternativas |
|--------|----------|--------------|
| **Integración Azure** | Nativa | Requiere configuración |
| **Costo** | Incluido en suscripción educativa | Variable |
| **Curva de aprendizaje** | Moderada | Variable |
| **Capacidades DAX** | Avanzadas | Limitadas |
| **Publicación web** | Integrada | Requiere infraestructura |

### 3.2 Características Utilizadas

1. **DirectQuery vs Import:**
   - Utilizamos modo **Import** para mejor rendimiento
   - Los datos se refrescan periódicamente desde Azure SQL

2. **Modelo Semántico:**
   - Relaciones automáticas entre dimensiones y hechos
   - Medidas DAX personalizadas para KPIs

3. **Visualizaciones:**
   - Gráficos de barras/columnas para comparaciones
   - Líneas de tendencia temporal
   - Mapas para análisis geográfico
   - Tarjetas para KPIs ejecutivos
   - Matrices para análisis multidimensional

---

## 4. ARQUITECTURA DEL SISTEMA

### 4.1 Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                        CAPA DE PRESENTACIÓN                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐  │
│  │  Power BI   │  │   Python    │  │   Consultas SQL         │  │
│  │  Desktop    │  │   Scripts   │  │   (SSMS/Azure Portal)   │  │
│  └──────┬──────┘  └──────┬──────┘  └────────────┬────────────┘  │
└─────────┼────────────────┼──────────────────────┼───────────────┘
          │                │                      │
          ▼                ▼                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                        CAPA DE SERVICIOS                         │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                   Vistas Optimizadas                        ││
│  │  • vw_OLAP_ProductoPorProveedorTiempoUbicacion             ││
│  │  • vw_OLAP_ModalidadPagoPorTiempoRegion                    ││
│  │  • vw_OLAP_ProductoMasVendido                              ││
│  │  • vw_Dashboard_KPIs / VentasPorMes / VentasPorRegion      ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────┐
│                        CAPA OLAP                                 │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                      FactVentas                             │ │
│  │  • TiempoKey, ProductoKey, ClienteKey, ProveedorKey        │ │
│  │  • EmpleadoKey, ModalidadKey, UbicacionClienteKey          │ │
│  │  • Cantidad, MontoSubtotal, MontoIVA, MontoTotal           │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────────┐ │
│  │DimTiempo│ │DimProduct│ │DimClient│ │DimProv  │ │DimModalidad│ │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └───────────┘ │
└─────────────────────────────────────────────────────────────────┘
          ▲
          │ ETL (sp_ETL_CargarOLAP)
          │
┌─────────────────────────────────────────────────────────────────┐
│                        CAPA OLTP                                 │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────────┐ │
│  │Categoria│ │Proveedor│ │Empleado │ │ Cliente │ │ModalidadPago│
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └───────────┘ │
│  ┌─────────────────────┐ ┌─────────────────────────────────────┐│
│  │      Producto       │ │ Pedido + DetallePedido              ││
│  └─────────────────────┘ └─────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### 4.2 Flujo de Datos

1. **Transacciones** → Tablas OLTP (Pedido, DetallePedido)
2. **ETL Programado** → Procedimiento `sp_ETL_CargarOLAP`
3. **Dimensiones** → Actualizadas con MERGE (SCD Tipo 1)
4. **Hechos** → Recarga completa en FactVentas
5. **Vistas** → Consultas pre-optimizadas para BI
6. **Power BI** → Importación y visualización

---

## 5. CONFIGURACIÓN DEL SGBD

### 5.1 Azure SQL Database

**Configuración utilizada:**

| Parámetro | Valor |
|-----------|-------|
| **Servicio** | Azure SQL Database |
| **Nivel** | Standard S2 |
| **DTUs** | 50 |
| **Almacenamiento** | 250 GB |
| **Región** | East US |
| **Collation** | SQL_Latin1_General_CP1_CI_AS |

### 5.2 Consideraciones de Rendimiento

1. **Índices Clustered:** En claves primarias de todas las tablas
2. **Índices Non-Clustered:** En claves foráneas frecuentemente consultadas
3. **Estadísticas:** Actualización automática habilitada
4. **Particionamiento:** No requerido para el volumen actual

### 5.3 Seguridad

- **Usuario OLAP:** `usuario_olap` con permisos de solo lectura
- **Autenticación:** SQL Authentication para Power BI
- **Firewall:** IPs autorizadas para conexiones externas
- **Cifrado:** TDE habilitado por defecto en Azure

---

## 6. PROCESO ETL

### 6.1 Procedimiento: sp_ETL_CargarOLAP

**Fases del ETL:**

```sql
-- Fase 1: Cargar DimTiempo (calendario 2020-2025)
-- Fase 2: Cargar DimUbicacion (ciudades únicas)
-- Fase 3: Cargar DimCategoria (MERGE)
-- Fase 4: Cargar DimProveedor (MERGE)
-- Fase 5: Cargar DimCliente (MERGE)
-- Fase 6: Cargar DimEmpleado (MERGE)
-- Fase 7: Cargar DimModalidadPago (MERGE)
-- Fase 8: Cargar DimProducto (MERGE)
-- Fase 9: Cargar FactVentas (TRUNCATE + INSERT)
```

### 6.2 Estrategia de Carga

| Tabla | Estrategia | Justificación |
|-------|------------|---------------|
| DimTiempo | INSERT si no existe | Calendario estático |
| Dimensiones | MERGE (SCD Tipo 1) | Actualiza cambios, inserta nuevos |
| FactVentas | TRUNCATE + INSERT | Recarga completa para consistencia |

### 6.3 Transformaciones Aplicadas

1. **DimTiempo:**
   - Generación de jerarquía temporal (Año > Semestre > Trimestre > Mes > Semana > Día)
   - Flags de fin de semana y día laboral

2. **DimUbicacion:**
   - Asignación de regiones geográficas basada en ciudad

3. **DimProducto:**
   - Desnormalización de categoría y proveedor
   - Cálculo de tipo de IVA (0% vs 15%)

4. **DimModalidadPago:**
   - Descripción completa incluyendo cuotas

5. **FactVentas:**
   - Cálculo de montos (Subtotal, IVA, Total)
   - Resolución de claves surrogadas

### 6.4 Tiempo de Ejecución

| Fase | Registros | Tiempo Estimado |
|------|-----------|-----------------|
| DimTiempo | 2,192 días | 2 segundos |
| Dimensiones | ~260 registros | 1 segundo |
| FactVentas | ~500,000 líneas | 3-5 minutos |
| **Total** | | **~5 minutos** |

---

## 7. HECHOS OLAP IMPLEMENTADOS

### 7.1 Hecho (a): Productos por Proveedor, Tiempo y Ubicación

**Pregunta de Negocio:** ¿Qué productos de qué proveedores se venden más en cada región y período?

**Dimensiones:**
- DimProducto (código, nombre, precio)
- DimProveedor (nombre, ciudad)
- DimTiempo (año, trimestre, mes)
- DimUbicacion (ciudad, región, país)
- DimCategoria (nombre de categoría)

**Medidas:**
- Cantidad vendida
- Monto total de ventas
- Número de pedidos

**Consulta Ejemplo:**
```sql
SELECT 
    dp.Nombre AS Proveedor,
    dt.Anio,
    du.Region,
    SUM(f.Cantidad) AS UnidadesVendidas,
    SUM(f.MontoTotal) AS VentasTotal
FROM FactVentas f
JOIN DimProveedor dp ON dp.ProveedorKey = f.ProveedorKey
JOIN DimTiempo dt ON dt.TiempoKey = f.TiempoKey
JOIN DimUbicacion du ON du.UbicacionKey = f.UbicacionClienteKey
GROUP BY dp.Nombre, dt.Anio, du.Region;
```

---

### 7.2 Hecho (b): Modalidad de Pago por Tiempo y Región

**Pregunta de Negocio:** ¿Cómo prefieren pagar los clientes según su ubicación y el momento del año?

**Dimensiones:**
- DimModalidadPago (tipo pago, cuotas, tasa interés)
- DimTiempo (año, trimestre, mes)
- DimUbicacion (ciudad, región)
- DimCliente (para segmentación adicional)

**Medidas:**
- Cantidad de transacciones
- Monto total por modalidad
- Porcentaje de uso por región

**Insights Potenciales:**
- En ciudades grandes predomina el pago con tarjeta
- Fin de año muestra incremento en pagos a cuotas
- Regiones rurales prefieren efectivo

---

### 7.3 Hecho (e): Producto Más Vendido (Best Seller)

**Pregunta de Negocio:** ¿Cuál es el producto estrella en cada categoría, ciudad y forma de pago?

**Dimensiones (4+):**
- DimCategoria (categoría del producto)
- DimTiempo (período de análisis)
- DimUbicacion (ciudad, región)
- DimModalidadPago (forma de pago)
- DimProducto (detalle del producto)

**Medidas:**
- Ranking por cantidad vendida
- Ranking por monto de ventas
- Clientes únicos que lo compraron

**Consulta Ejemplo (Top Seller por Categoría):**
```sql
WITH Ranking AS (
    SELECT 
        dc.Nombre AS Categoria,
        dprod.Nombre AS Producto,
        SUM(f.Cantidad) AS Cantidad,
        ROW_NUMBER() OVER (PARTITION BY dc.Nombre ORDER BY SUM(f.Cantidad) DESC) AS Rank
    FROM FactVentas f
    JOIN DimProducto dprod ON dprod.ProductoKey = f.ProductoKey
    JOIN DimCategoria dc ON dc.CategoriaKey = f.CategoriaKey
    GROUP BY dc.Nombre, dprod.Nombre
)
SELECT Categoria, Producto, Cantidad
FROM Ranking WHERE Rank = 1;
```

---

## 8. VISUALIZACIONES EN POWER BI

### 8.1 Dashboard Ejecutivo

**Componentes:**
1. **Tarjetas KPI:**
   - Total de ventas
   - Cantidad de pedidos
   - Ticket promedio
   - Clientes activos

2. **Gráfico de Líneas:**
   - Tendencia de ventas mensual

3. **Gráfico de Barras:**
   - Top 10 productos más vendidos
   - Ventas por categoría

4. **Gráfico Circular:**
   - Distribución por modalidad de pago

5. **Mapa:**
   - Ventas por ciudad/región

### 8.2 Análisis de Proveedores

**Visualizaciones:**
- Matriz: Proveedor vs Período vs Ventas
- Treemap: Participación de mercado por proveedor
- Gráfico de cascada: Evolución de ventas

### 8.3 Análisis de Pagos

**Visualizaciones:**
- Gráfico de barras apiladas: Modalidad por región
- Líneas: Tendencia de pagos a cuotas vs contado
- Tabla: Detalle de transacciones por tipo

### 8.4 Conexión a Power BI

**Pasos de Configuración:**

1. Abrir Power BI Desktop
2. Obtener Datos → Azure → Azure SQL Database
3. Ingresar servidor: `[servidor].database.windows.net`
4. Ingresar base de datos
5. Seleccionar modo de conexión: Import
6. Autenticación: usuario_olap / OlapSecure2025!
7. Seleccionar vistas: vw_OLAP_*, vw_Dashboard_*
8. Cargar y modelar

---

## 9. CONCLUSIONES

### 9.1 Logros del Proyecto

✅ **Esquema OLTP funcional** con manejo de IVA y modalidades de pago con cuotas

✅ **Data Warehouse dimensional** con modelo estrella de 8 dimensiones

✅ **ETL automatizado** con procedimiento almacenado robusto

✅ **100,000 pedidos de prueba** generados con datos realistas

✅ **Vistas optimizadas** para consumo desde Power BI

✅ **Usuario de solo lectura** para seguridad en producción

✅ **Documentación completa** del sistema

### 9.2 Lecciones Aprendidas

1. **Modelo Estrella vs Copo de Nieve:** Para proyectos de BI, la simplicidad del modelo estrella supera los beneficios de normalización del copo de nieve.

2. **Azure SQL Database:** La compatibilidad con SQL Server es alta, pero hay diferencias en creación de usuarios y algunas funciones.

3. **ETL con MERGE:** La sentencia MERGE simplifica significativamente la lógica de actualización de dimensiones.

4. **Vistas Pre-agregadas:** Mejoran dramáticamente el rendimiento de Power BI al reducir procesamiento en tiempo real.

### 9.3 Mejoras Futuras

- Implementar dimensiones de cambio lento Tipo 2 (SCD2)
- Agregar particionamiento temporal en FactVentas
- Configurar refresh automático desde Power BI Service
- Implementar Row-Level Security (RLS)

---

## 📎 ANEXOS

### A. Estructura de Archivos del Proyecto

```
Proyecto_OLAP/
├── docs/
│   ├── Informe.md                    # Este documento
│   └── PowerBI_Conexion.md           # Guía de conexión
├── scripts/
│   ├── auto_run.ps1                  # Script de automatización
│   └── OLAP_Graficos.py              # Gráficos con Python
├── sql/
│   ├── oltp/
│   │   ├── Tablas.sql                # Esquema OLTP (8 tablas)
│   │   └── Datos_Tablas.sql          # Datos de prueba (100k pedidos)
│   └── olap/
│       ├── TablaDatosDim.sql         # Dimensiones y hechos (estrella)
│       ├── ETL.sql                   # Proceso ETL completo
│       ├── VistasOLAP_PowerBI.sql    # 7 Vistas para Power BI
│       ├── UsuarioOLAP.sql           # Usuario solo lectura
│       └── VerificacionDatos.sql     # Consultas de verificación
└── README.md                         # Documentación general
```

### B. Glosario

| Término | Definición |
|---------|------------|
| **OLTP** | Online Transaction Processing - Sistema transaccional |
| **OLAP** | Online Analytical Processing - Sistema analítico |
| **ETL** | Extract, Transform, Load - Proceso de carga de datos |
| **Dimensión** | Tabla de contexto para análisis (Tiempo, Producto, etc.) |
| **Hecho** | Tabla central con métricas/medidas cuantificables |
| **Clave Surrogada** | Identificador artificial en el data warehouse |
| **SCD** | Slowly Changing Dimension - Manejo de cambios históricos |
| **DAX** | Data Analysis Expressions - Lenguaje de Power BI |

---

**Documento preparado para presentación académica**  
**Fecha de última actualización:** Noviembre 2025
