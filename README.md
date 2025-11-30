# 📊 INFORME TÉCNICO - PROYECTO OLAP

## Sistema de Pedidos con Análisis Dimensional

**Materia:** Base de Datos  
**Fecha de Presentación:** Noviembre 2025  
**Plataforma:** Oracle Database 21c + Power BI  

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
- **ETL:** Procedimientos de extracción, transformación y carga
- **Visualización:** Reportes interactivos en Power BI

### 1.3 Requisitos del Negocio

El sistema debe responder a las siguientes preguntas de negocio:

1. ¿Cuáles productos se venden más por proveedor, período y ubicación?
2. ¿Cómo varían las modalidades de pago según región y tiempo?
3. ¿Cuál es el producto más vendido por categoría, tiempo, ubicación y forma de pago?

### 1.4 Checklist de Requerimientos del Enunciado

| # | Requerimiento | Evidencia de cumplimiento |
|---|---------------|---------------------------|
| 1.a | Registrar modalidad de pago (efectivo, transferencia, tarjeta con cuotas) | Tabla `ModalidadPago` con tipos de pago y cuotas (0-12), relacionada con `Pedido` |
| 1.b | Cobrar IVA (15% o 0% por producto) | Columna `PorcentajeIVA` en `Producto` con restricción CHECK (0 o 15) |
| 2 | Carga de datos mínima | ✅ 10 proveedores, 5 empleados, 20 clientes, 5 categorías, 200 productos (100 IVA 15%, 100 IVA 0%), 100,000 pedidos |
| 3 | Diseño OLAP con 3 hechos (4+ dimensiones) | Modelo estrella con 8 dimensiones + FactVentas |
| 4 | Herramienta OLAP configurada | Oracle Database 21c + Power BI |
| 5 | Procedimientos ETL | Scripts de carga para dimensiones y tabla de hechos |
| 6 | Usuario de consulta OLAP | Usuario de solo lectura para Power BI |
| 7 | Consultas con Power BI | Vistas optimizadas para reportes |
| 8 | Informe técnico | Este documento |
| 9 | Sustentación 15 minutos | Preparada |

### 1.5 Datos del Sistema

**Volumen de Datos Generados:**
- **Categorías:** 5 (Electrónica, Ropa, Hogar, Deportes, Alimentos)
- **Proveedores:** 10 empresas
- **Empleados:** 5 vendedores
- **Clientes:** 20 clientes con datos completos (nombre, email, teléfono, dirección)
- **Productos:** 200 con nombres reales (100 con IVA 15%, 100 con IVA 0%)
- **Pedidos:** 100,000 pedidos
- **Detalle de Pedidos:** ~550,000 líneas de detalle
- **Modalidades de Pago:** 6 (Efectivo, Transferencia, Tarjeta a cuotas)

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

### 3.1 Oracle Database 21c

**Características utilizadas:**

| Factor | Descripción |
|--------|-------------|
| **Versión** | Oracle Database 21c |
| **Tipo** | Base de datos relacional empresarial |
| **OLAP** | Soporte nativo para operaciones analíticas |
| **PL/SQL** | Lenguaje procedural para ETL |

### 3.2 Power BI como Visualización

| Factor | Power BI |
|--------|----------|
| **Integración** | Conector nativo Oracle |
| **Modo** | Import para mejor rendimiento |
| **DAX** | Capacidades avanzadas de cálculo |
| **Publicación** | Web integrada |

### 3.3 Características Utilizadas

1. **Modo Import:** Los datos se importan periódicamente desde Oracle
2. **Modelo Semántico:** Relaciones automáticas entre dimensiones y hechos
3. **Medidas DAX:** KPIs personalizados

---

## 4. ARQUITECTURA DEL SISTEMA

### 4.1 Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                        CAPA DE PRESENTACIÓN                      │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                      POWER BI                                ││
│  │   • Dashboards ejecutivos                                    ││
│  │   • Análisis por proveedor/tiempo/ubicación                 ││
│  │   • Reportes de modalidad de pago                           ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        CAPA DE SERVICIOS                         │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                   Vistas Optimizadas                        ││
│  │  • vw_OLAP_ProductoPorProveedorTiempoUbicacion             ││
│  │  • vw_OLAP_ModalidadPagoPorTiempoRegion                    ││
│  │  • vw_OLAP_ProductoMasVendido                              ││
│  │  • vw_Dashboard_KPIs                                        ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        CAPA OLAP                                 │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                      FactVentas                             │ │
│  │  • TiempoKey, ProductoKey, ClienteKey, ProveedorKey        │ │
│  │  • EmpleadoKey, ModalidadKey, UbicacionKey, CategoriaKey   │ │
│  │  • Cantidad, Subtotal, MontoIVA, Total                     │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────────┐ │
│  │DimTiempo│ │DimProduct│ │DimClient│ │DimProv  │ │DimModalidad│ │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └───────────┘ │
│  ┌─────────┐ ┌─────────┐ ┌───────────┐                         │
│  │DimCateg │ │DimUbicac│ │DimEmpleado│                         │
│  └─────────┘ └─────────┘ └───────────┘                         │
└─────────────────────────────────────────────────────────────────┘
                              ▲
                              │ ETL
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
2. **ETL** → Scripts de carga de dimensiones y hechos
3. **Dimensiones** → Carga completa desde OLTP
4. **Hechos** → Tabla FactVentas con métricas calculadas
5. **Vistas** → Consultas pre-optimizadas para BI
6. **Power BI** → Importación y visualización

---

## 5. CONFIGURACIÓN DEL SGBD

### 5.1 Oracle Database 21c

**Configuración utilizada:**

| Parámetro | Valor |
|-----------|-------|
| **SGBD** | Oracle Database 21c |
| **Usuario OLTP/OLAP** | alexis3 |
| **Character Set** | AL32UTF8 |
| **NLS_LANGUAGE** | AMERICAN |
| **NLS_TERRITORY** | AMERICA |

### 5.2 Tablas OLTP Creadas

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| Categoria | Categorías de productos | 5 |
| Proveedor | Proveedores | 10 |
| Empleado | Empleados/Vendedores | 5 |
| Cliente | Clientes con datos completos | 20 |
| ModalidadPago | Formas de pago con cuotas | 6 |
| Producto | Productos con IVA | 200 |
| Pedido | Encabezados de pedido | 100,000 |
| DetallePedido | Líneas de detalle | ~550,000 |

### 5.3 Tablas OLAP Creadas

| Tabla | Descripción | Registros |
|-------|-------------|-----------|
| DimTiempo | Dimensión temporal 2020-2025 | 2,192 |
| DimUbicacion | Ciudades y países | 4 |
| DimCategoria | Categorías | 5 |
| DimProveedor | Proveedores | 10 |
| DimCliente | Clientes | 20 |
| DimEmpleado | Empleados | 5 |
| DimModalidadPago | Modalidades de pago | 6 |
| DimProducto | Productos desnormalizados | 200 |
| FactVentas | Tabla de hechos | ~550,000 |

---

## 6. PROCESO ETL

### 6.1 Fases del ETL

```
Fase 1: Cargar DimTiempo (calendario 2020-2025)
Fase 2: Cargar DimUbicacion (ciudades únicas de clientes)
Fase 3: Cargar DimCategoria
Fase 4: Cargar DimProveedor
Fase 5: Cargar DimCliente
Fase 6: Cargar DimEmpleado
Fase 7: Cargar DimModalidadPago
Fase 8: Cargar DimProducto (desnormalizado con categoría y proveedor)
Fase 9: Cargar FactVentas (join de todas las dimensiones)
```

### 6.2 Estrategia de Carga

| Tabla | Estrategia | Justificación |
|-------|------------|---------------|
| DimTiempo | INSERT directo | Calendario estático |
| Dimensiones | DELETE + INSERT | Recarga completa simple |
| FactVentas | DELETE + INSERT | Consistencia total |

### 6.3 Transformaciones Aplicadas

1. **DimTiempo:**
   - Generación de jerarquía: Año > Trimestre > Mes > Día
   - Nombre de mes y día de la semana

2. **DimUbicacion:**
   - Extracción de ciudades únicas desde clientes
   - Asignación de país (Ecuador)

3. **DimProducto:**
   - Desnormalización de categoría y proveedor
   - Inclusión de porcentaje IVA

4. **FactVentas:**
   - Cálculo de Subtotal, MontoIVA y Total
   - Resolución de claves foráneas a dimensiones

---

## 7. HECHOS OLAP IMPLEMENTADOS

### 7.1 Hecho (a): Productos por Proveedor, Tiempo y Ubicación

**Pregunta de Negocio:** ¿Qué productos de qué proveedores se venden más en cada región y período?

**Dimensiones (5):**
- DimProducto
- DimProveedor
- DimTiempo
- DimUbicacion
- DimCategoria

**Medidas:**
- Cantidad vendida
- Monto total de ventas
- Número de pedidos

**Consulta Ejemplo:**
```sql
SELECT 
    dp.NombreProveedor,
    dt.Anio,
    du.Ciudad,
    SUM(f.Cantidad) AS UnidadesVendidas,
    SUM(f.Total) AS VentasTotal
FROM FactVentas f
JOIN DimProveedor dp ON dp.ProveedorKey = f.ProveedorKey
JOIN DimTiempo dt ON dt.TiempoKey = f.TiempoKey
JOIN DimUbicacion du ON du.UbicacionKey = f.UbicacionKey
GROUP BY dp.NombreProveedor, dt.Anio, du.Ciudad;
```

---

### 7.2 Hecho (b): Modalidad de Pago por Tiempo y Región

**Pregunta de Negocio:** ¿Cómo prefieren pagar los clientes según su ubicación y el momento del año?

**Dimensiones (4):**
- DimModalidadPago
- DimTiempo
- DimUbicacion
- DimCliente

**Medidas:**
- Cantidad de transacciones
- Monto total por modalidad
- Porcentaje de uso por región

**Insights Potenciales:**
- En ciudades grandes predomina el pago con tarjeta
- Fin de año muestra incremento en pagos a cuotas
- Preferencias por tipo de cliente

---

### 7.3 Hecho (e): Producto Más Vendido (Best Seller)

**Pregunta de Negocio:** ¿Cuál es el producto estrella en cada categoría, ciudad y forma de pago?

**Dimensiones (5):**
- DimCategoria
- DimTiempo
- DimUbicacion
- DimModalidadPago
- DimProducto

**Medidas:**
- Ranking por cantidad vendida
- Ranking por monto de ventas
- Clientes únicos

**Consulta Ejemplo:**
```sql
SELECT 
    dc.NombreCategoria,
    dprod.NombreProducto,
    SUM(f.Cantidad) AS Cantidad,
    SUM(f.Total) AS MontoTotal
FROM FactVentas f
JOIN DimProducto dprod ON dprod.ProductoKey = f.ProductoKey
JOIN DimCategoria dc ON dc.CategoriaKey = f.CategoriaKey
GROUP BY dc.NombreCategoria, dprod.NombreProducto
ORDER BY SUM(f.Total) DESC;
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

### 8.2 Análisis de Proveedores

- Matriz: Proveedor vs Período vs Ventas
- Treemap: Participación por proveedor
- Top productos por proveedor

### 8.3 Análisis de Pagos

- Gráfico de barras: Modalidad por región
- Tendencia de cuotas vs contado
- Distribución de IVA (15% vs 0%)

### 8.4 Conexión a Power BI

**Pasos:**
1. Abrir Power BI Desktop
2. Obtener Datos → Oracle Database
3. Ingresar servidor y credenciales
4. Seleccionar tablas/vistas OLAP
5. Cargar y modelar

---

## 9. CONCLUSIONES

### 9.1 Logros del Proyecto

✅ **Esquema OLTP funcional** con 8 tablas en Oracle

✅ **200 productos reales** con nombres descriptivos (iPhone 14 Pro, Samsung Galaxy S23, Arroz Conejo, etc.)

✅ **IVA configurado:** 100 productos con 15%, 100 productos con 0%

✅ **100,000 pedidos** generados con ~550,000 líneas de detalle

✅ **Data Warehouse dimensional** con modelo estrella de 8 dimensiones

✅ **ETL ejecutado** con datos cargados en FactVentas

✅ **Vistas optimizadas** para consumo desde Power BI

✅ **Datos completos** sin valores NULL en clientes, productos y pedidos

### 9.2 Lecciones Aprendidas

1. **Modelo Estrella vs Copo de Nieve:** La simplicidad del modelo estrella facilita el análisis en Power BI.

2. **Oracle Database:** Excelente rendimiento para operaciones OLAP y soporte robusto para procedimientos.

3. **Datos Realistas:** Usar nombres de productos reales mejora la comprensión en las presentaciones.

### 9.3 Mejoras Futuras

- Implementar dimensiones de cambio lento Tipo 2 (SCD2)
- Agregar particionamiento temporal en FactVentas
- Configurar refresh automático
- Implementar Row-Level Security (RLS)

---

## 📁 ESTRUCTURA DEL PROYECTO

```
Proyecto_OLAP/
├── README.md                     # Este informe técnico
├── docs/
│   └── Guia_Instalacion.md       # Pasos para replicar el proyecto
└── sql/
    ├── oltp/
    │   ├── Tablas.sql            # Esquema OLTP (8 tablas)
    │   └── Datos_Tablas.sql      # Datos de prueba
    └── olap/
        ├── TablaDatosDim.sql     # Esquema estrella
        ├── ETL.sql               # Proceso ETL
        ├── UsuarioOLAP.sql       # Usuario solo lectura
        └── VistasOLAP_PowerBI.sql # Vistas para reportes
```

---

## 📎 GLOSARIO

| Término | Definición |
|---------|------------|
| **OLTP** | Online Transaction Processing - Sistema transaccional |
| **OLAP** | Online Analytical Processing - Sistema analítico |
| **ETL** | Extract, Transform, Load - Proceso de carga de datos |
| **Dimensión** | Tabla de contexto para análisis (Tiempo, Producto, etc.) |
| **Hecho** | Tabla central con métricas cuantificables |
| **Clave Surrogada** | Identificador artificial en el data warehouse |
| **DAX** | Data Analysis Expressions - Lenguaje de Power BI |

---

**Proyecto académico - Base de Datos**  
**Plataforma:** Oracle Database 21c + Power BI  
**Última actualización:** Noviembre 2025
