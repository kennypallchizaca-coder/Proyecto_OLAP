# 🗃️ PROYECTO OLAP - Sistema de Pedidos

## 📋 Descripción

Sistema OLAP completo para análisis multidimensional de un esquema de pedidos comercial. Implementa un Data Warehouse con modelo estrella sobre Azure SQL Database, con visualización en Power BI.

---

## 🎯 Requisitos del Proyecto Cumplidos

| # | Requisito | Estado |
|---|-----------|--------|
| 1 | Esquema OLTP con ModalidadPago (cuotas 0-12) e IVA | ✅ |
| 2 | Datos: 10 proveedores, 5 empleados, 20 clientes, 5 categorías, 200 productos, 100k pedidos | ✅ |
| 3 | 3 Hechos OLAP con 4+ dimensiones cada uno | ✅ |
| 4 | Azure SQL Database | ✅ |
| 5 | Procedimiento ETL | ✅ |
| 6 | Usuario solo lectura OLAP | ✅ |
| 7 | Power BI con gráficos | ✅ |
| 8 | Informe técnico completo | ✅ |
| 9 | Presentación 15 minutos | 📋 |

---

## 🏗️ Arquitectura

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   CAPA OLTP     │ --> │   CAPA OLAP     │ --> │   POWER BI      │
│   (Tablas)      │ ETL │   (Estrella)    │     │   (Reportes)    │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## 📁 Estructura del Proyecto

```
Proyecto_OLAP/
├── docs/
│   ├── Informe.md              # Informe técnico completo
│   └── PowerBI_Conexion.md     # Guía de conexión Power BI
├── scripts/
│   ├── auto_run.ps1            # Automatización PowerShell
│   └── OLAP_Graficos.py        # Gráficos auxiliares Python
├── sql/
│   ├── oltp/
│   │   ├── Tablas.sql          # [1] Esquema OLTP (8 tablas)
│   │   └── Datos_Tablas.sql    # [2] Generación de datos (100k pedidos)
│   └── olap/
│       ├── TablaDatosDim.sql   # [3] Esquema estrella (8 dims + fact)
│       ├── ETL.sql             # [4] Proceso ETL completo
│       ├── VistasOLAP_PowerBI.sql # [5] 7 vistas para Power BI
│       ├── UsuarioOLAP.sql     # [6] Usuario solo lectura
│       └── VerificacionDatos.sql  # [7] Consultas de verificación
└── README.md
```

---

## 🚀 Orden de Ejecución

1. **sql/oltp/Tablas.sql** - Crear esquema OLTP
2. **sql/oltp/Datos_Tablas.sql** - Insertar datos de prueba
3. **sql/olap/TablaDatosDim.sql** - Crear esquema OLAP
4. **sql/olap/ETL.sql** - Ejecutar proceso ETL
5. **sql/olap/VistasOLAP_PowerBI.sql** - Crear vistas para Power BI
6. **sql/olap/UsuarioOLAP.sql** - Crear usuario de solo lectura
7. **sql/olap/VerificacionDatos.sql** - Verificar datos (opcional)

---

## 📊 Hechos OLAP Implementados

### Hecho (a): Productos por Proveedor, Tiempo y Ubicación
- **Dimensiones:** Producto, Proveedor, Tiempo, Ubicación, Categoría
- **Análisis:** Ventas por proveedor segmentadas geográfica y temporalmente

### Hecho (b): Modalidad de Pago por Tiempo y Región
- **Dimensiones:** ModalidadPago, Tiempo, Ubicación, Cliente
- **Análisis:** Preferencias de pago por región y período

### Hecho (e): Producto Más Vendido (Best Seller)
- **Dimensiones:** Categoría, Tiempo, Ubicación, ModalidadPago, Producto
- **Análisis:** Identificación de productos estrella

---

## 🔗 Conexión Power BI

```
Servidor: [tu-servidor].database.windows.net
Base de Datos: [nombre-base-datos]
Usuario: UsuarioOLAP
Contraseña: OL@P_R3ad0nly2025!
```

Ver guía completa en `docs/PowerBI_Conexion.md`

---

## 📈 Vistas Disponibles para Power BI

| Vista | Descripción |
|-------|-------------|
| `vw_VentasCompletas` | Vista principal con todas las dimensiones |
| `vw_VentasProductoProveedor` | Hecho (a) - Ventas por producto/proveedor |
| `vw_VentasModalidadPago` | Hecho (b) - Ventas por modalidad de pago |
| `vw_VentasEmpleado` | Hecho (e) - Ventas por empleado/vendedor |
| `vw_ResumenVentasAnual` | KPIs y métricas ejecutivas |
| `vw_AnalisisIVA` | Análisis de IVA (0% vs 15%) |
| `vw_Calendario` | Dimensión tiempo para relaciones |

---

## 📝 Documentación

- **Informe Técnico:** `docs/Informe.md` - Documento completo con justificaciones
- **Guía Power BI:** `docs/PowerBI_Conexion.md` - Pasos de conexión

---

## 👥 Requisitos Técnicos

- Azure SQL Database
- Power BI Desktop
- Python 3.x (opcional, para gráficos)
- PowerShell (opcional, para automatización)

---

## 📅 Fecha de Presentación

**26 de Noviembre, 2025** - Presentación de 15 minutos

---

*Proyecto académico - Base de Datos*
