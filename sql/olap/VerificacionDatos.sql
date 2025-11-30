-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: VerificacionDatos.sql
-- Descripcion: Consultas de verificacion de datos y metricas OLAP
-- Base de Datos: Azure SQL Database
-- Fecha: Noviembre 2025
-- ============================================================================
-- HECHOS OLAP SELECCIONADOS (con 4+ dimensiones cada uno):
--   a) Ventas por producto, proveedor, tiempo, ubicacion
--   b) Ventas por modalidad de pago, tiempo, region cliente
--   e) Mejores vendedores por categoria, tiempo, ubicacion, modalidad pago
-- ============================================================================

-- ============================================================================
-- SECCION 1: VERIFICACION DE DIMENSIONES
-- ============================================================================

PRINT '============================================================================';
PRINT 'VERIFICACION DE DIMENSIONES OLAP';
PRINT '============================================================================';
PRINT '';

-- Conteo de registros por dimension
SELECT 'CONTEO DE DIMENSIONES' AS Seccion;
SELECT 
    'DimTiempo' AS Dimension, COUNT(*) AS Registros FROM dbo.DimTiempo
UNION ALL SELECT 'DimUbicacion', COUNT(*) FROM dbo.DimUbicacion
UNION ALL SELECT 'DimCategoria', COUNT(*) FROM dbo.DimCategoria
UNION ALL SELECT 'DimProveedor', COUNT(*) FROM dbo.DimProveedor
UNION ALL SELECT 'DimCliente', COUNT(*) FROM dbo.DimCliente
UNION ALL SELECT 'DimEmpleado', COUNT(*) FROM dbo.DimEmpleado
UNION ALL SELECT 'DimModalidadPago', COUNT(*) FROM dbo.DimModalidadPago
UNION ALL SELECT 'DimProducto', COUNT(*) FROM dbo.DimProducto
ORDER BY Dimension;

-- Verificar dimension de tiempo
SELECT 'DIMENSION TIEMPO - Cobertura' AS Seccion;
SELECT 
    MIN(Fecha) AS FechaInicio,
    MAX(Fecha) AS FechaFin,
    COUNT(DISTINCT Anio) AS Anios,
    COUNT(DISTINCT AnioMes) AS Meses
FROM dbo.DimTiempo;

-- ============================================================================
-- SECCION 2: VERIFICACION DE TABLA DE HECHOS
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'VERIFICACION DE TABLA DE HECHOS';
PRINT '============================================================================';
PRINT '';

SELECT 'ESTADISTICAS DE FACTVENTES' AS Seccion;
SELECT 
    COUNT(*) AS TotalRegistros,
    COUNT(DISTINCT PedidoID_OLTP) AS TotalPedidos,
    COUNT(DISTINCT ProductoKey) AS ProductosVendidos,
    COUNT(DISTINCT ClienteKey) AS ClientesActivos,
    COUNT(DISTINCT TiempoKey) AS DiasConVentas
FROM dbo.FactVentas;

SELECT 'METRICAS FINANCIERAS' AS Seccion;
SELECT 
    SUM(Cantidad) AS UnidadesTotales,
    FORMAT(SUM(MontoSubtotal), 'N2') AS SubtotalUSD,
    FORMAT(SUM(MontoIVA), 'N2') AS IVATotal,
    FORMAT(SUM(MontoTotal), 'N2') AS VentaTotal,
    FORMAT(AVG(MontoTotal), 'N2') AS PromedioLineaVenta
FROM dbo.FactVentas;

-- ============================================================================
-- SECCION 3: HECHO (A) - VENTAS POR PRODUCTO, PROVEEDOR, TIEMPO, UBICACION
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'HECHO A: Ventas por Producto, Proveedor, Tiempo, Ubicacion';
PRINT '============================================================================';
PRINT '';

-- Top 10 productos mas vendidos
SELECT 'TOP 10 PRODUCTOS MAS VENDIDOS' AS Seccion;
SELECT TOP 10
    p.Nombre AS Producto,
    p.NombreProveedor AS Proveedor,
    p.NombreCategoria AS Categoria,
    SUM(f.Cantidad) AS UnidadesVendidas,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal
FROM dbo.FactVentas f
JOIN dbo.DimProducto p ON f.ProductoKey = p.ProductoKey
GROUP BY p.Nombre, p.NombreProveedor, p.NombreCategoria
ORDER BY SUM(f.MontoTotal) DESC;

-- Ventas por proveedor y ubicacion
SELECT 'VENTAS POR PROVEEDOR Y UBICACION' AS Seccion;
SELECT 
    prov.Nombre AS Proveedor,
    prov.Ciudad AS CiudadProveedor,
    u.Region,
    COUNT(DISTINCT f.PedidoID_OLTP) AS Pedidos,
    SUM(f.Cantidad) AS Unidades,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal
FROM dbo.FactVentas f
JOIN dbo.DimProveedor prov ON f.ProveedorKey = prov.ProveedorKey
JOIN dbo.DimUbicacion u ON prov.UbicacionKey = u.UbicacionKey
GROUP BY prov.Nombre, prov.Ciudad, u.Region
ORDER BY SUM(f.MontoTotal) DESC;

-- Ventas por anio y trimestre (evolucion temporal)
SELECT 'VENTAS POR ANIO Y TRIMESTRE' AS Seccion;
SELECT 
    t.Anio,
    t.NombreTrimestre AS Trimestre,
    COUNT(DISTINCT f.PedidoID_OLTP) AS Pedidos,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal
FROM dbo.FactVentas f
JOIN dbo.DimTiempo t ON f.TiempoKey = t.TiempoKey
GROUP BY t.Anio, t.Trimestre, t.NombreTrimestre
ORDER BY t.Anio, t.Trimestre;

-- ============================================================================
-- SECCION 4: HECHO (B) - VENTAS POR MODALIDAD DE PAGO, TIEMPO, REGION
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'HECHO B: Ventas por Modalidad de Pago, Tiempo, Region';
PRINT '============================================================================';
PRINT '';

-- Ventas por modalidad de pago
SELECT 'VENTAS POR MODALIDAD DE PAGO' AS Seccion;
SELECT 
    mp.Descripcion AS ModalidadPago,
    mp.TipoPago,
    mp.Cuotas,
    COUNT(DISTINCT f.PedidoID_OLTP) AS Pedidos,
    SUM(f.Cantidad) AS Unidades,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal,
    FORMAT(SUM(f.MontoTotal) * 100.0 / SUM(SUM(f.MontoTotal)) OVER(), 'N2') + '%' AS Participacion
FROM dbo.FactVentas f
JOIN dbo.DimModalidadPago mp ON f.ModalidadKey = mp.ModalidadKey
GROUP BY mp.Descripcion, mp.TipoPago, mp.Cuotas
ORDER BY SUM(f.MontoTotal) DESC;

-- Ventas por region del cliente y modalidad de pago
SELECT 'VENTAS POR REGION Y MODALIDAD DE PAGO' AS Seccion;
SELECT 
    u.Region AS RegionCliente,
    mp.DescripcionCompleta AS ModalidadPago,
    COUNT(DISTINCT f.PedidoID_OLTP) AS Pedidos,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal
FROM dbo.FactVentas f
JOIN dbo.DimCliente c ON f.ClienteKey = c.ClienteKey
JOIN dbo.DimUbicacion u ON c.UbicacionKey = u.UbicacionKey
JOIN dbo.DimModalidadPago mp ON f.ModalidadKey = mp.ModalidadKey
GROUP BY u.Region, mp.DescripcionCompleta
ORDER BY u.Region, SUM(f.MontoTotal) DESC;

-- Evolucion mensual por tipo de pago
SELECT 'EVOLUCION MENSUAL POR TIPO DE PAGO' AS Seccion;
SELECT 
    t.AnioMes,
    mp.TipoPago,
    COUNT(DISTINCT f.PedidoID_OLTP) AS Pedidos,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal
FROM dbo.FactVentas f
JOIN dbo.DimTiempo t ON f.TiempoKey = t.TiempoKey
JOIN dbo.DimModalidadPago mp ON f.ModalidadKey = mp.ModalidadKey
WHERE t.Anio >= 2023
GROUP BY t.AnioMes, mp.TipoPago
ORDER BY t.AnioMes, mp.TipoPago;

-- ============================================================================
-- SECCION 5: HECHO (E) - MEJORES VENDEDORES POR CATEGORIA, TIEMPO, UBICACION
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'HECHO E: Mejores Vendedores por Categoria, Tiempo, Ubicacion, Pago';
PRINT '============================================================================';
PRINT '';

-- Ranking de vendedores (empleados)
SELECT 'RANKING DE VENDEDORES (EMPLEADOS)' AS Seccion;
SELECT 
    e.NombreCompleto AS Empleado,
    e.Cargo,
    COUNT(DISTINCT f.PedidoID_OLTP) AS TotalPedidos,
    SUM(f.Cantidad) AS UnidadesVendidas,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal,
    RANK() OVER (ORDER BY SUM(f.MontoTotal) DESC) AS Ranking
FROM dbo.FactVentas f
JOIN dbo.DimEmpleado e ON f.EmpleadoKey = e.EmpleadoKey
GROUP BY e.NombreCompleto, e.Cargo
ORDER BY SUM(f.MontoTotal) DESC;

-- Ventas por empleado y categoria
SELECT 'VENTAS POR EMPLEADO Y CATEGORIA' AS Seccion;
SELECT 
    e.NombreCompleto AS Empleado,
    c.Nombre AS Categoria,
    SUM(f.Cantidad) AS Unidades,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal
FROM dbo.FactVentas f
JOIN dbo.DimEmpleado e ON f.EmpleadoKey = e.EmpleadoKey
JOIN dbo.DimCategoria c ON f.CategoriaKey = c.CategoriaKey
GROUP BY e.NombreCompleto, c.Nombre
ORDER BY e.NombreCompleto, SUM(f.MontoTotal) DESC;

-- Ventas por empleado, ubicacion cliente y modalidad pago
SELECT 'VENTAS POR EMPLEADO, UBICACION Y MODALIDAD PAGO' AS Seccion;
SELECT 
    e.NombreCompleto AS Empleado,
    u.Ciudad AS CiudadCliente,
    mp.TipoPago,
    COUNT(DISTINCT f.PedidoID_OLTP) AS Pedidos,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal
FROM dbo.FactVentas f
JOIN dbo.DimEmpleado e ON f.EmpleadoKey = e.EmpleadoKey
JOIN dbo.DimCliente c ON f.ClienteKey = c.ClienteKey
JOIN dbo.DimUbicacion u ON c.UbicacionKey = u.UbicacionKey
JOIN dbo.DimModalidadPago mp ON f.ModalidadKey = mp.ModalidadKey
GROUP BY e.NombreCompleto, u.Ciudad, mp.TipoPago
ORDER BY e.NombreCompleto, SUM(f.MontoTotal) DESC;

-- Evolucion anual de ventas por empleado
SELECT 'EVOLUCION ANUAL POR EMPLEADO' AS Seccion;
SELECT 
    e.NombreCompleto AS Empleado,
    t.Anio,
    COUNT(DISTINCT f.PedidoID_OLTP) AS Pedidos,
    FORMAT(SUM(f.MontoTotal), 'N2') AS VentaTotal
FROM dbo.FactVentas f
JOIN dbo.DimEmpleado e ON f.EmpleadoKey = e.EmpleadoKey
JOIN dbo.DimTiempo t ON f.TiempoKey = t.TiempoKey
GROUP BY e.NombreCompleto, t.Anio
ORDER BY e.NombreCompleto, t.Anio;

-- ============================================================================
-- SECCION 6: ANALISIS DE IVA
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'ANALISIS DE IVA (0% vs 15%)';
PRINT '============================================================================';
PRINT '';

SELECT 'VENTAS POR TIPO DE IVA' AS Seccion;
SELECT 
    p.TipoIVA,
    COUNT(DISTINCT f.PedidoID_OLTP) AS Pedidos,
    SUM(f.Cantidad) AS Unidades,
    FORMAT(SUM(f.MontoSubtotal), 'N2') AS Subtotal,
    FORMAT(SUM(f.MontoIVA), 'N2') AS IVA,
    FORMAT(SUM(f.MontoTotal), 'N2') AS Total
FROM dbo.FactVentas f
JOIN dbo.DimProducto p ON f.ProductoKey = p.ProductoKey
GROUP BY p.TipoIVA
ORDER BY SUM(f.MontoTotal) DESC;

-- Productos IVA 15% por categoria
SELECT 'TOP 5 PRODUCTOS IVA 15% POR CATEGORIA' AS Seccion;
SELECT TOP 5
    p.Nombre AS Producto,
    p.NombreCategoria AS Categoria,
    p.PorcentajeIVA,
    SUM(f.Cantidad) AS Unidades,
    FORMAT(SUM(f.MontoIVA), 'N2') AS IVARecaudado
FROM dbo.FactVentas f
JOIN dbo.DimProducto p ON f.ProductoKey = p.ProductoKey
WHERE p.PorcentajeIVA = 15
GROUP BY p.Nombre, p.NombreCategoria, p.PorcentajeIVA
ORDER BY SUM(f.MontoIVA) DESC;

-- ============================================================================
-- SECCION 7: INTEGRIDAD REFERENCIAL OLTP vs OLAP
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'VERIFICACION DE INTEGRIDAD OLTP vs OLAP';
PRINT '============================================================================';
PRINT '';

SELECT 'COMPARACION OLTP vs OLAP' AS Seccion;

-- Comparar totales
SELECT 'OLTP' AS Origen, 
    COUNT(*) AS TotalDetalles,
    FORMAT(SUM(Total), 'N2') AS VentaTotal
FROM dbo.DetallePedido
UNION ALL
SELECT 'OLAP', 
    COUNT(*),
    FORMAT(SUM(MontoTotal), 'N2')
FROM dbo.FactVentas;

-- Verificar que no hay perdida de datos
SELECT 'PEDIDOS - COMPARACION' AS Seccion;
SELECT 
    (SELECT COUNT(DISTINCT PedidoID) FROM dbo.Pedido) AS Pedidos_OLTP,
    (SELECT COUNT(DISTINCT PedidoID_OLTP) FROM dbo.FactVentas) AS Pedidos_OLAP,
    CASE 
        WHEN (SELECT COUNT(DISTINCT PedidoID) FROM dbo.Pedido) = 
             (SELECT COUNT(DISTINCT PedidoID_OLTP) FROM dbo.FactVentas)
        THEN 'OK - Sin perdida de datos'
        ELSE 'ALERTA - Revisar integridad'
    END AS Estado;

PRINT '';
PRINT '============================================================================';
PRINT 'VERIFICACION COMPLETADA';
PRINT '============================================================================';
GO
