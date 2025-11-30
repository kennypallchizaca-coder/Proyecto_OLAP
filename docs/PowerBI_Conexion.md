# 📊 Guía de Conexión Power BI - Proyecto OLAP

## 📋 Requisitos Previos

- ✅ Power BI Desktop instalado ([Descargar](https://powerbi.microsoft.com/))
- ✅ Credenciales de acceso a Azure SQL Database
- ✅ Haber ejecutado todos los scripts SQL del proyecto
- ✅ Usuario `usuario_olap` creado (UsuarioOLAP.sql)

---

## 🔗 Pasos para Conectar Power BI a Azure SQL

### Paso 1: Abrir Power BI Desktop

1. Iniciar Power BI Desktop
2. Ir a **Inicio** → **Obtener datos** → **Base de datos** → **Azure SQL Database**

### Paso 2: Configurar Conexión

```
Servidor: [tu-servidor].database.windows.net
Base de datos: [nombre-base-datos]
Modo de conectividad: Import (recomendado)
```

### Paso 3: Autenticación

- Seleccionar **"Base de datos"**
- **Usuario:** `usuario_olap`
- **Contraseña:** `OlapSecure2025!`

### Paso 4: Seleccionar Vistas a Importar

#### Vistas Principales (Hechos OLAP):

| Vista | Descripción | Uso |
|-------|-------------|-----|
| `vw_OLAP_ProductoPorProveedorTiempoUbicacion` | Hecho (a) | Productos por proveedor |
| `vw_OLAP_ModalidadPagoPorTiempoRegion` | Hecho (b) | Formas de pago |
| `vw_OLAP_ProductoMasVendido` | Hecho (e) | Best sellers |

#### Vistas de Dashboard:

| Vista | Descripción |
|-------|-------------|
| `vw_Dashboard_KPIs` | Métricas ejecutivas |
| `vw_Dashboard_VentasPorMes` | Tendencias temporales |
| `vw_Dashboard_VentasPorRegion` | Análisis geográfico |
| `vw_Dashboard_RankingProductos` | Top productos |

---

## 📐 Modelo de Datos Alternativo

Si prefieres importar el modelo estrella completo:

### Tablas a Importar:

```
Tabla de Hechos:
- FactVentas

Dimensiones:
- DimTiempo
- DimProducto
- DimCategoria
- DimCliente
- DimProveedor
- DimEmpleado
- DimModalidadPago
- DimUbicacion
```

### Relaciones (Power BI las detecta automáticamente):

```
FactVentas[TiempoKey] → DimTiempo[TiempoKey]
FactVentas[ProductoKey] → DimProducto[ProductoKey]
FactVentas[CategoriaKey] → DimCategoria[CategoriaKey]
FactVentas[ClienteKey] → DimCliente[ClienteKey]
FactVentas[ProveedorKey] → DimProveedor[ProveedorKey]
FactVentas[EmpleadoKey] → DimEmpleado[EmpleadoKey]
FactVentas[ModalidadKey] → DimModalidadPago[ModalidadKey]
FactVentas[UbicacionClienteKey] → DimUbicacion[UbicacionKey]
```

---

## 📈 Medidas DAX Sugeridas

```dax
// Ventas Totales
Ventas Totales = SUM(FactVentas[MontoTotal])

// Unidades Vendidas
Unidades Vendidas = SUM(FactVentas[Cantidad])

// IVA Recaudado
IVA Recaudado = SUM(FactVentas[MontoIVA])

// Ticket Promedio
Ticket Promedio = 
DIVIDE(
    [Ventas Totales],
    DISTINCTCOUNT(FactVentas[PedidoID_OLTP]),
    0
)

// Número de Pedidos
Num Pedidos = DISTINCTCOUNT(FactVentas[PedidoID_OLTP])

// Clientes Únicos
Clientes Unicos = DISTINCTCOUNT(FactVentas[ClienteKey])

// Ventas Año Anterior
Ventas Año Anterior = 
CALCULATE(
    [Ventas Totales],
    SAMEPERIODLASTYEAR(DimTiempo[Fecha])
)

// Crecimiento YoY (%)
Crecimiento YoY = 
VAR VentasAnterior = [Ventas Año Anterior]
RETURN
DIVIDE(
    [Ventas Totales] - VentasAnterior,
    VentasAnterior,
    0
) * 100

// Ventas Acumuladas YTD
Ventas YTD = 
TOTALYTD(
    [Ventas Totales],
    DimTiempo[Fecha]
)
```

---

## 🎨 Dashboards Sugeridos

### Dashboard 1: Resumen Ejecutivo

**Componentes:**
- **Tarjetas KPI:** Ventas Totales, Pedidos, IVA, Ticket Promedio
- **Gráfico de líneas:** Tendencia de ventas por mes
- **Gráfico de barras:** Top 10 productos
- **Mapa:** Ventas por ciudad/región

### Dashboard 2: Hecho (a) - Productos por Proveedor

**Componentes:**
- **Matriz:** Productos × Proveedores con Unidades
- **Gráfico de barras apiladas:** Ventas por categoría y proveedor
- **Segmentadores:** Año, Trimestre, Mes, Ciudad
- **Tabla:** Detalle de productos más vendidos

### Dashboard 3: Hecho (b) - Modalidades de Pago

**Componentes:**
- **Gráfico de torta:** Distribución por modalidad
- **Gráfico de barras:** Ventas por modalidad y región
- **Línea de tiempo:** Evolución del uso de cuotas
- **Tabla:** Detalle de cuotas (tarjeta de crédito)

### Dashboard 4: Hecho (e) - Productos Best Seller

**Componentes:**
- **Ranking:** Top productos por categoría
- **Treemap:** Productos por ventas
- **Matriz:** Producto × Ciudad × Modalidad
- **Gráfico de barras:** Comparación entre productos

---

## 🔄 Configuración de Actualización

### Para Modo Import (Recomendado):

1. Publicar el informe en Power BI Service
2. Configurar credenciales del origen de datos
3. Programar actualización (diaria, semanal)

### Para DirectQuery:

- Cambiar modo de conectividad al importar
- Requiere Azure SQL con suficiente capacidad
- Datos siempre actualizados

---

## ⚠️ Solución de Problemas

### Error de conexión:

- ✅ Verificar que el firewall de Azure SQL permita tu IP
- ✅ Confirmar credenciales del usuario `usuario_olap`
- ✅ Verificar nombre del servidor y base de datos

### Datos no aparecen:

- ✅ Confirmar que se ejecutó el ETL (`sp_ETL_CargarOLAP`)
- ✅ Verificar permisos SELECT del usuario
- ✅ Actualizar datos en Power BI (Ctrl + F5)

### Rendimiento lento:

- ✅ Usar modo Import en lugar de DirectQuery
- ✅ Limitar el rango de fechas con filtros
- ✅ Usar las vistas agregadas (vw_Dashboard_*)

---

## 🔗 Cadena de Conexión ODBC (Alternativa)

```
Driver={ODBC Driver 18 for SQL Server};
Server=[tu-servidor].database.windows.net;
Database=[nombre-base-datos];
Uid=usuario_olap;
Pwd=OlapSecure2025!;
Encrypt=yes;
TrustServerCertificate=no;
```

---

*Guía actualizada - Proyecto OLAP*
