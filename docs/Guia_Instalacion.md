# 📖 GUÍA DE INSTALACIÓN Y MIGRACIÓN

## Sistema OLAP de Pedidos - Oracle Database 21c

Esta guía detalla los pasos para replicar el proyecto OLAP completo en Oracle Database.

---

## 📋 REQUISITOS PREVIOS

### Software Necesario

| Software | Versión | Uso |
|----------|---------|-----|
| Oracle Database | 21c o superior | Base de datos principal |
| SQL Developer / SQLcl | Última versión | Ejecutar scripts SQL |
| Power BI Desktop | Última versión | Visualización de datos |
| Oracle Instant Client | 21c | Conexión Power BI → Oracle |

### Credenciales Oracle

- Usuario administrador con permisos para crear usuarios
- Acceso a la instancia de Oracle

---

## 🚀 PASO 1: CREAR USUARIO EN ORACLE

### 1.1 Conectarse como SYSDBA

```sql
-- Conectarse a Oracle como administrador
sqlplus / as sysdba
```

### 1.2 Crear el Usuario del Proyecto

```sql
-- Crear usuario para el proyecto OLAP
CREATE USER alexis3 IDENTIFIED BY tu_password_seguro;

-- Otorgar permisos necesarios
GRANT CONNECT, RESOURCE TO alexis3;
GRANT CREATE SESSION TO alexis3;
GRANT CREATE TABLE TO alexis3;
GRANT CREATE VIEW TO alexis3;
GRANT CREATE PROCEDURE TO alexis3;
GRANT CREATE SEQUENCE TO alexis3;
GRANT UNLIMITED TABLESPACE TO alexis3;

-- Confirmar
COMMIT;
```

### 1.3 Conectarse con el Nuevo Usuario

```sql
CONNECT alexis3/tu_password_seguro
```

---

## 🗃️ PASO 2: CREAR ESQUEMA OLTP

### 2.1 Ejecutar Script de Tablas

Ejecutar el archivo `sql/oltp/Tablas.sql` que crea las 8 tablas transaccionales:

```sql
-- Las tablas se crean en este orden por dependencias:
-- 1. Categoria
-- 2. Proveedor
-- 3. Empleado
-- 4. Cliente
-- 5. ModalidadPago
-- 6. Producto (depende de Categoria y Proveedor)
-- 7. Pedido (depende de Cliente, Empleado, ModalidadPago)
-- 8. DetallePedido (depende de Pedido y Producto)
```

**Tablas Creadas:**

| Tabla | Descripción |
|-------|-------------|
| `Categoria` | Categorías de productos (5 registros) |
| `Proveedor` | Proveedores (10 registros) |
| `Empleado` | Empleados/Vendedores (5 registros) |
| `Cliente` | Clientes con datos completos (20 registros) |
| `ModalidadPago` | Formas de pago con cuotas 0-12 (6 registros) |
| `Producto` | Productos con IVA 0% y 15% (200 registros) |
| `Pedido` | Encabezados de pedido (100,000 registros) |
| `DetallePedido` | Líneas de detalle (~550,000 registros) |

### 2.2 Cargar Datos de Prueba

Ejecutar el archivo `sql/oltp/Datos_Tablas.sql`:

```sql
-- Este script inserta:
-- • 5 Categorías (Electrónica, Ropa, Hogar, Deportes, Alimentos)
-- • 10 Proveedores
-- • 5 Empleados
-- • 20 Clientes (con nombre, email, teléfono, dirección)
-- • 6 Modalidades de pago (Efectivo, Transferencia, Tarjeta 3/6/12 cuotas)
-- • 200 Productos con nombres reales
-- • 100,000 Pedidos con fechas 2020-2025
-- • ~550,000 líneas de DetallePedido
```

**⚠️ IMPORTANTE:** La generación de 100,000 pedidos puede tomar varios minutos.

---

## 📊 PASO 3: CREAR ESQUEMA OLAP

### 3.1 Ejecutar Script de Dimensiones y Hechos

Ejecutar el archivo `sql/olap/TablaDatosDim.sql`:

```sql
-- Crea el modelo estrella:
-- Dimensiones:
-- • DimTiempo (calendario 2020-2025)
-- • DimUbicacion (ciudades)
-- • DimCategoria
-- • DimProveedor
-- • DimCliente
-- • DimEmpleado
-- • DimModalidadPago
-- • DimProducto (desnormalizada)

-- Tabla de Hechos:
-- • FactVentas
```

### 3.2 Ejecutar Proceso ETL

Ejecutar el archivo `sql/olap/ETL.sql`:

```sql
-- El ETL realiza:
-- 1. Genera DimTiempo (2,192 días)
-- 2. Carga DimUbicacion desde Cliente
-- 3. Carga dimensiones desde tablas OLTP
-- 4. Carga FactVentas con cálculos de Subtotal, IVA y Total
```

**Verificar carga exitosa:**

```sql
-- Verificar conteos
SELECT 'DimTiempo' as Tabla, COUNT(*) as Registros FROM DimTiempo
UNION ALL SELECT 'DimProducto', COUNT(*) FROM DimProducto
UNION ALL SELECT 'DimCliente', COUNT(*) FROM DimCliente
UNION ALL SELECT 'FactVentas', COUNT(*) FROM FactVentas;
```

**Resultado esperado:**
- DimTiempo: 2,192
- DimProducto: 200
- DimCliente: 20
- FactVentas: ~550,000

---

## 👤 PASO 4: CREAR USUARIO DE SOLO LECTURA

### 4.1 Ejecutar Script de Usuario OLAP

Ejecutar el archivo `sql/olap/UsuarioOLAP.sql`:

```sql
-- Crear usuario de solo lectura para Power BI
CREATE USER usuario_olap IDENTIFIED BY OL@P_R3ad0nly2025;

GRANT CONNECT TO usuario_olap;
GRANT SELECT ON alexis3.DimTiempo TO usuario_olap;
GRANT SELECT ON alexis3.DimUbicacion TO usuario_olap;
GRANT SELECT ON alexis3.DimCategoria TO usuario_olap;
GRANT SELECT ON alexis3.DimProveedor TO usuario_olap;
GRANT SELECT ON alexis3.DimCliente TO usuario_olap;
GRANT SELECT ON alexis3.DimEmpleado TO usuario_olap;
GRANT SELECT ON alexis3.DimModalidadPago TO usuario_olap;
GRANT SELECT ON alexis3.DimProducto TO usuario_olap;
GRANT SELECT ON alexis3.FactVentas TO usuario_olap;
-- Permisos para vistas
```

---

## 📈 PASO 5: CREAR VISTAS PARA POWER BI

### 5.1 Ejecutar Script de Vistas

Ejecutar el archivo `sql/olap/VistasOLAP_PowerBI.sql`:

```sql
-- Vistas creadas:
-- • vw_VentasCompletas - Vista principal con todas las dimensiones
-- • vw_VentasProductoProveedor - Hecho (a)
-- • vw_VentasModalidadPago - Hecho (b)
-- • vw_ProductoMasVendido - Hecho (e)
-- • vw_Dashboard_KPIs - Métricas ejecutivas
```

---

## 🔌 PASO 6: CONECTAR POWER BI A ORACLE

### 6.1 Instalar Oracle Instant Client

1. Descargar Oracle Instant Client desde: https://www.oracle.com/database/technologies/instant-client.html
2. Seleccionar versión 21c para Windows 64-bit
3. Descargar paquete "Basic" o "Basic Light"
4. Extraer en `C:\oracle\instantclient_21_X`
5. Agregar al PATH del sistema

### 6.2 Configurar TNSNAMES (Opcional)

Crear archivo `tnsnames.ora` en la carpeta de Instant Client:

```
MI_ORACLE =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = tu_servidor)(PORT = 1521))
    (CONNECT_DATA =
      (SERVICE_NAME = tu_servicio)
    )
  )
```

### 6.3 Conectar desde Power BI

1. Abrir **Power BI Desktop**
2. Ir a **Inicio → Obtener datos → Base de datos → Base de datos de Oracle**
3. En "Servidor" ingresar: `tu_servidor:1521/servicio` o usar el nombre TNS
4. Seleccionar **Modo de conectividad: Import**
5. Ingresar credenciales:
   - Usuario: `usuario_olap`
   - Contraseña: `OL@P_R3ad0nly2025`
6. Seleccionar las tablas/vistas a importar:
   - ✅ `ALEXIS3.FACTVENTAS`
   - ✅ `ALEXIS3.DIMTIEMPO`
   - ✅ `ALEXIS3.DIMPRODUCTO`
   - ✅ `ALEXIS3.DIMCLIENTE`
   - ✅ `ALEXIS3.DIMPROVEEDOR`
   - ✅ `ALEXIS3.DIMCATEGORIA`
   - ✅ `ALEXIS3.DIMMODALIDADPAGO`
   - ✅ `ALEXIS3.DIMEMPLEADO`
   - ✅ `ALEXIS3.DIMUBICACION`
7. Clic en **Cargar**

### 6.4 Configurar Relaciones en Power BI

Power BI detectará automáticamente las relaciones. Verificar:

| Tabla Origen | Campo | Tabla Destino | Campo |
|--------------|-------|---------------|-------|
| FactVentas | TiempoKey | DimTiempo | TiempoKey |
| FactVentas | ProductoKey | DimProducto | ProductoKey |
| FactVentas | ClienteKey | DimCliente | ClienteKey |
| FactVentas | ProveedorKey | DimProveedor | ProveedorKey |
| FactVentas | CategoriaKey | DimCategoria | CategoriaKey |
| FactVentas | EmpleadoKey | DimEmpleado | EmpleadoKey |
| FactVentas | ModalidadPagoKey | DimModalidadPago | ModalidadPagoKey |
| FactVentas | UbicacionKey | DimUbicacion | UbicacionKey |

---

## 📊 PASO 7: CREAR VISUALIZACIONES

### 7.1 Medidas DAX Sugeridas

```dax
-- Total Ventas
Total Ventas = SUM(FactVentas[Total])

-- Cantidad Total
Cantidad Total = SUM(FactVentas[Cantidad])

-- Ticket Promedio
Ticket Promedio = DIVIDE([Total Ventas], DISTINCTCOUNT(FactVentas[PedidoID]))

-- Ventas con IVA
Ventas IVA 15% = 
    CALCULATE([Total Ventas], DimProducto[PorcentajeIVA] = 15)

-- Ventas sin IVA
Ventas IVA 0% = 
    CALCULATE([Total Ventas], DimProducto[PorcentajeIVA] = 0)
```

### 7.2 Visualizaciones Recomendadas

| Tipo | Uso | Campos |
|------|-----|--------|
| **Tarjeta** | KPIs | Total Ventas, Cantidad, Ticket Promedio |
| **Gráfico de Barras** | Top Productos | Producto, Total Ventas |
| **Gráfico de Líneas** | Tendencia | Fecha, Total Ventas |
| **Gráfico Circular** | Distribución | Modalidad Pago, Total Ventas |
| **Matriz** | Análisis Cruzado | Categoría, Año, Total Ventas |
| **Mapa** | Geográfico | Ciudad, Total Ventas |

---

## ✅ VERIFICACIÓN FINAL

### Ejecutar Consultas de Verificación

```sql
-- Verificar volumen de datos
SELECT 
    'OLTP - Pedidos' as Tabla, COUNT(*) as Registros FROM Pedido
UNION ALL
SELECT 'OLTP - DetallePedido', COUNT(*) FROM DetallePedido
UNION ALL
SELECT 'OLAP - FactVentas', COUNT(*) FROM FactVentas
UNION ALL
SELECT 'OLAP - DimProducto', COUNT(*) FROM DimProducto;

-- Verificar productos por IVA
SELECT PorcentajeIVA, COUNT(*) as Productos
FROM Producto
GROUP BY PorcentajeIVA;

-- Verificar modalidades de pago usadas
SELECT m.Nombre, COUNT(p.PedidoID) as Pedidos
FROM Pedido p
JOIN ModalidadPago m ON p.ModalidadPagoID = m.ModalidadPagoID
GROUP BY m.Nombre;

-- Verificar top productos
SELECT NombreProducto, SUM(Total) as VentaTotal
FROM FactVentas f
JOIN DimProducto p ON f.ProductoKey = p.ProductoKey
GROUP BY NombreProducto
ORDER BY 2 DESC
FETCH FIRST 10 ROWS ONLY;
```

---

## 🔧 SOLUCIÓN DE PROBLEMAS

### Error: "ORA-01017: invalid username/password"
- Verificar credenciales
- Confirmar que el usuario fue creado correctamente

### Error: Power BI no encuentra Oracle
- Instalar Oracle Instant Client
- Agregar ruta al PATH del sistema
- Reiniciar Power BI

### Error: "ORA-00942: table or view does not exist"
- Verificar permisos del usuario
- Confirmar que las tablas fueron creadas con el usuario correcto

### ETL muy lento
- Ejecutar en horarios de baja carga
- Considerar hacer COMMIT cada 10,000 registros

---

## 📞 INFORMACIÓN DE CONEXIÓN

| Parámetro | Valor |
|-----------|-------|
| **Servidor** | [tu_servidor]:1521/[servicio] |
| **Usuario OLTP** | alexis3 |
| **Usuario OLAP** | usuario_olap |
| **Password OLAP** | OL@P_R3ad0nly2025 |

---

## 📅 ORDEN DE EJECUCIÓN RESUMIDO

```
1. sql/oltp/Tablas.sql          → Crear tablas OLTP
2. sql/oltp/Datos_Tablas.sql    → Insertar datos de prueba
3. sql/olap/TablaDatosDim.sql   → Crear tablas OLAP
4. sql/olap/ETL.sql             → Ejecutar proceso ETL
5. sql/olap/VistasOLAP_PowerBI.sql → Crear vistas
6. sql/olap/UsuarioOLAP.sql     → Crear usuario lectura
7. Conectar Power BI           → Crear reportes
```

---

**Guía de Instalación - Proyecto OLAP**  
**Plataforma:** Oracle Database 21c + Power BI  
**Última actualización:** Noviembre 2025
