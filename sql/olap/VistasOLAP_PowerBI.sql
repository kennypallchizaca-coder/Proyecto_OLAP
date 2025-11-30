-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: VistasOLAP_PowerBI.sql
-- Descripcion: Vistas optimizadas para conexion con Power BI
-- Base de Datos: Azure SQL Database
-- Fecha: Noviembre 2025
-- ============================================================================
-- Estas vistas simplifican las consultas para Power BI y estan optimizadas
-- para los 3 hechos OLAP seleccionados:
--   a) Ventas por producto, proveedor, tiempo, ubicacion
--   b) Ventas por modalidad de pago, tiempo, region
--   e) Mejores vendedores por categoria, tiempo, ubicacion, modalidad
-- ============================================================================

-- ============================================================================
-- VISTA 1: Ventas Completas (Vista Principal)
-- Dimension: Todas las dimensiones
-- ============================================================================

IF OBJECT_ID('dbo.vw_VentasCompletas', 'V') IS NOT NULL
    DROP VIEW dbo.vw_VentasCompletas;
GO

CREATE VIEW dbo.vw_VentasCompletas AS
SELECT 
    -- Claves
    f.VentaKey,
    f.PedidoID_OLTP AS PedidoID,
    
    -- Dimension Tiempo
    t.Fecha,
    t.Anio,
    t.NombreSemestre AS Semestre,
    t.NombreTrimestre AS Trimestre,
    t.NombreMes AS Mes,
    t.Semana,
    t.NombreDia AS DiaSemana,
    t.EsFinDeSemana,
    t.EsDiaLaboral,
    t.AnioMes,
    t.AnioTrimestre,
    
    -- Dimension Producto
    p.Codigo AS CodigoProducto,
    p.Nombre AS Producto,
    p.NombreCategoria AS Categoria,
    p.NombreProveedor AS Proveedor,
    p.PrecioUnitario AS PrecioLista,
    p.PorcentajeIVA,
    p.TipoIVA,
    
    -- Dimension Cliente
    c.Codigo AS CodigoCliente,
    c.NombreCompleto AS Cliente,
    c.Ciudad AS CiudadCliente,
    c.Pais AS PaisCliente,
    uc.Region AS RegionCliente,
    
    -- Dimension Proveedor (ubicacion)
    prov.Ciudad AS CiudadProveedor,
    prov.Pais AS PaisProveedor,
    uprov.Region AS RegionProveedor,
    
    -- Dimension Empleado
    e.Codigo AS CodigoEmpleado,
    e.NombreCompleto AS Empleado,
    e.Cargo AS CargoEmpleado,
    
    -- Dimension Modalidad de Pago
    mp.Descripcion AS ModalidadPago,
    mp.TipoPago,
    mp.Cuotas,
    mp.DescripcionCompleta AS ModalidadPagoDetalle,
    mp.EsTarjeta,
    
    -- Metricas
    f.Cantidad,
    f.PrecioUnitario AS PrecioVenta,
    f.MontoSubtotal AS Subtotal,
    f.MontoIVA AS IVA,
    f.MontoTotal AS Total

FROM dbo.FactVentas f
JOIN dbo.DimTiempo t ON f.TiempoKey = t.TiempoKey
JOIN dbo.DimProducto p ON f.ProductoKey = p.ProductoKey
JOIN dbo.DimCliente c ON f.ClienteKey = c.ClienteKey
JOIN dbo.DimUbicacion uc ON c.UbicacionKey = uc.UbicacionKey
JOIN dbo.DimProveedor prov ON f.ProveedorKey = prov.ProveedorKey
JOIN dbo.DimUbicacion uprov ON prov.UbicacionKey = uprov.UbicacionKey
JOIN dbo.DimEmpleado e ON f.EmpleadoKey = e.EmpleadoKey
JOIN dbo.DimModalidadPago mp ON f.ModalidadKey = mp.ModalidadKey;
GO

PRINT 'Vista vw_VentasCompletas creada.';

-- ============================================================================
-- VISTA 2: Hecho (a) - Ventas por Producto, Proveedor, Tiempo, Ubicacion
-- ============================================================================

IF OBJECT_ID('dbo.vw_VentasProductoProveedor', 'V') IS NOT NULL
    DROP VIEW dbo.vw_VentasProductoProveedor;
GO

CREATE VIEW dbo.vw_VentasProductoProveedor AS
SELECT 
    t.Anio,
    t.NombreTrimestre AS Trimestre,
    t.NombreMes AS Mes,
    t.AnioMes,
    
    p.Nombre AS Producto,
    p.Codigo AS CodigoProducto,
    p.NombreCategoria AS Categoria,
    
    prov.Nombre AS Proveedor,
    prov.Ciudad AS CiudadProveedor,
    u.Region AS RegionProveedor,
    u.Pais AS PaisProveedor,
    
    COUNT(DISTINCT f.PedidoID_OLTP) AS NumeroPedidos,
    SUM(f.Cantidad) AS UnidadesVendidas,
    SUM(f.MontoSubtotal) AS Subtotal,
    SUM(f.MontoIVA) AS IVA,
    SUM(f.MontoTotal) AS VentaTotal,
    AVG(f.MontoTotal) AS PromedioVenta

FROM dbo.FactVentas f
JOIN dbo.DimTiempo t ON f.TiempoKey = t.TiempoKey
JOIN dbo.DimProducto p ON f.ProductoKey = p.ProductoKey
JOIN dbo.DimProveedor prov ON f.ProveedorKey = prov.ProveedorKey
JOIN dbo.DimUbicacion u ON prov.UbicacionKey = u.UbicacionKey
GROUP BY 
    t.Anio, t.Trimestre, t.NombreTrimestre, t.Mes, t.NombreMes, t.AnioMes,
    p.Nombre, p.Codigo, p.NombreCategoria,
    prov.Nombre, prov.Ciudad, u.Region, u.Pais;
GO

PRINT 'Vista vw_VentasProductoProveedor creada.';

-- ============================================================================
-- VISTA 3: Hecho (b) - Ventas por Modalidad de Pago, Tiempo, Region
-- ============================================================================

IF OBJECT_ID('dbo.vw_VentasModalidadPago', 'V') IS NOT NULL
    DROP VIEW dbo.vw_VentasModalidadPago;
GO

CREATE VIEW dbo.vw_VentasModalidadPago AS
SELECT 
    t.Anio,
    t.NombreTrimestre AS Trimestre,
    t.NombreMes AS Mes,
    t.AnioMes,
    t.EsFinDeSemana,
    
    mp.Descripcion AS ModalidadPago,
    mp.TipoPago,
    mp.Cuotas,
    mp.DescripcionCompleta AS ModalidadDetalle,
    mp.EsTarjeta,
    
    u.Region AS RegionCliente,
    u.Ciudad AS CiudadCliente,
    u.Pais AS PaisCliente,
    
    COUNT(DISTINCT f.PedidoID_OLTP) AS NumeroPedidos,
    COUNT(DISTINCT f.ClienteKey) AS ClientesUnicos,
    SUM(f.Cantidad) AS UnidadesVendidas,
    SUM(f.MontoSubtotal) AS Subtotal,
    SUM(f.MontoIVA) AS IVA,
    SUM(f.MontoTotal) AS VentaTotal,
    AVG(f.MontoTotal) AS TicketPromedio

FROM dbo.FactVentas f
JOIN dbo.DimTiempo t ON f.TiempoKey = t.TiempoKey
JOIN dbo.DimModalidadPago mp ON f.ModalidadKey = mp.ModalidadKey
JOIN dbo.DimCliente c ON f.ClienteKey = c.ClienteKey
JOIN dbo.DimUbicacion u ON c.UbicacionKey = u.UbicacionKey
GROUP BY 
    t.Anio, t.Trimestre, t.NombreTrimestre, t.Mes, t.NombreMes, t.AnioMes, t.EsFinDeSemana,
    mp.Descripcion, mp.TipoPago, mp.Cuotas, mp.DescripcionCompleta, mp.EsTarjeta,
    u.Region, u.Ciudad, u.Pais;
GO

PRINT 'Vista vw_VentasModalidadPago creada.';

-- ============================================================================
-- VISTA 4: Hecho (e) - Mejores Vendedores por Categoria, Tiempo, Ubicacion
-- ============================================================================

IF OBJECT_ID('dbo.vw_VentasEmpleado', 'V') IS NOT NULL
    DROP VIEW dbo.vw_VentasEmpleado;
GO

CREATE VIEW dbo.vw_VentasEmpleado AS
SELECT 
    t.Anio,
    t.NombreTrimestre AS Trimestre,
    t.NombreMes AS Mes,
    t.AnioMes,
    
    e.Codigo AS CodigoEmpleado,
    e.NombreCompleto AS Empleado,
    e.Cargo,
    
    cat.Nombre AS Categoria,
    
    u.Region AS RegionCliente,
    u.Ciudad AS CiudadCliente,
    
    mp.TipoPago,
    mp.Descripcion AS ModalidadPago,
    
    COUNT(DISTINCT f.PedidoID_OLTP) AS NumeroPedidos,
    COUNT(DISTINCT f.ClienteKey) AS ClientesAtendidos,
    SUM(f.Cantidad) AS UnidadesVendidas,
    SUM(f.MontoSubtotal) AS Subtotal,
    SUM(f.MontoIVA) AS IVA,
    SUM(f.MontoTotal) AS VentaTotal

FROM dbo.FactVentas f
JOIN dbo.DimTiempo t ON f.TiempoKey = t.TiempoKey
JOIN dbo.DimEmpleado e ON f.EmpleadoKey = e.EmpleadoKey
JOIN dbo.DimCategoria cat ON f.CategoriaKey = cat.CategoriaKey
JOIN dbo.DimCliente c ON f.ClienteKey = c.ClienteKey
JOIN dbo.DimUbicacion u ON c.UbicacionKey = u.UbicacionKey
JOIN dbo.DimModalidadPago mp ON f.ModalidadKey = mp.ModalidadKey
GROUP BY 
    t.Anio, t.Trimestre, t.NombreTrimestre, t.Mes, t.NombreMes, t.AnioMes,
    e.Codigo, e.NombreCompleto, e.Cargo,
    cat.Nombre,
    u.Region, u.Ciudad,
    mp.TipoPago, mp.Descripcion;
GO

PRINT 'Vista vw_VentasEmpleado creada.';

-- ============================================================================
-- VISTA 5: Resumen Anual de Ventas (KPIs)
-- ============================================================================

IF OBJECT_ID('dbo.vw_ResumenVentasAnual', 'V') IS NOT NULL
    DROP VIEW dbo.vw_ResumenVentasAnual;
GO

CREATE VIEW dbo.vw_ResumenVentasAnual AS
SELECT 
    t.Anio,
    t.NombreTrimestre AS Trimestre,
    t.NombreMes AS Mes,
    
    COUNT(DISTINCT f.PedidoID_OLTP) AS TotalPedidos,
    COUNT(DISTINCT f.ClienteKey) AS ClientesActivos,
    COUNT(DISTINCT f.ProductoKey) AS ProductosVendidos,
    SUM(f.Cantidad) AS UnidadesTotales,
    SUM(f.MontoSubtotal) AS Subtotal,
    SUM(f.MontoIVA) AS IVARecaudado,
    SUM(f.MontoTotal) AS VentaTotal,
    AVG(f.MontoTotal) AS TicketPromedio,
    
    -- KPIs adicionales
    SUM(f.MontoTotal) / NULLIF(COUNT(DISTINCT f.PedidoID_OLTP), 0) AS VentaPromedioPorPedido,
    SUM(f.Cantidad) / NULLIF(COUNT(DISTINCT f.PedidoID_OLTP), 0) AS UnidadesPromedioPorPedido

FROM dbo.FactVentas f
JOIN dbo.DimTiempo t ON f.TiempoKey = t.TiempoKey
GROUP BY 
    t.Anio, t.Trimestre, t.NombreTrimestre, t.Mes, t.NombreMes;
GO

PRINT 'Vista vw_ResumenVentasAnual creada.';

-- ============================================================================
-- VISTA 6: Analisis de IVA
-- ============================================================================

IF OBJECT_ID('dbo.vw_AnalisisIVA', 'V') IS NOT NULL
    DROP VIEW dbo.vw_AnalisisIVA;
GO

CREATE VIEW dbo.vw_AnalisisIVA AS
SELECT 
    t.Anio,
    t.NombreTrimestre AS Trimestre,
    t.NombreMes AS Mes,
    
    p.TipoIVA,
    p.PorcentajeIVA,
    p.NombreCategoria AS Categoria,
    
    COUNT(DISTINCT f.PedidoID_OLTP) AS NumeroPedidos,
    SUM(f.Cantidad) AS UnidadesVendidas,
    SUM(f.MontoSubtotal) AS BaseImponible,
    SUM(f.MontoIVA) AS IVARecaudado,
    SUM(f.MontoTotal) AS Total,
    
    -- Porcentaje de participacion
    CAST(SUM(f.MontoIVA) * 100.0 / NULLIF(SUM(SUM(f.MontoIVA)) OVER (PARTITION BY t.Anio), 0) AS DECIMAL(5,2)) AS PorcentajeIVAAnual

FROM dbo.FactVentas f
JOIN dbo.DimTiempo t ON f.TiempoKey = t.TiempoKey
JOIN dbo.DimProducto p ON f.ProductoKey = p.ProductoKey
GROUP BY 
    t.Anio, t.Trimestre, t.NombreTrimestre, t.Mes, t.NombreMes,
    p.TipoIVA, p.PorcentajeIVA, p.NombreCategoria;
GO

PRINT 'Vista vw_AnalisisIVA creada.';

-- ============================================================================
-- VISTA 7: Calendario (Para relaciones en Power BI)
-- ============================================================================

IF OBJECT_ID('dbo.vw_Calendario', 'V') IS NOT NULL
    DROP VIEW dbo.vw_Calendario;
GO

CREATE VIEW dbo.vw_Calendario AS
SELECT 
    TiempoKey,
    Fecha,
    Anio,
    NombreSemestre AS Semestre,
    NombreTrimestre AS Trimestre,
    Mes AS NumeroMes,
    NombreMes AS Mes,
    NombreMesCorto AS MesCorto,
    Semana,
    DiaDelMes AS Dia,
    NombreDia AS DiaSemana,
    NombreDiaCorto AS DiaSemanaCorto,
    DiaDelAnio,
    EsFinDeSemana,
    EsDiaLaboral,
    AnioMes,
    AnioTrimestre
FROM dbo.DimTiempo;
GO

PRINT 'Vista vw_Calendario creada.';

-- ============================================================================
-- ASIGNAR PERMISOS A USUARIO OLAP SOBRE LAS VISTAS
-- ============================================================================

-- Otorgar permisos de lectura al usuario OLAP sobre todas las vistas
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'UsuarioOLAP')
BEGIN
    GRANT SELECT ON dbo.vw_VentasCompletas TO [UsuarioOLAP];
    GRANT SELECT ON dbo.vw_VentasProductoProveedor TO [UsuarioOLAP];
    GRANT SELECT ON dbo.vw_VentasModalidadPago TO [UsuarioOLAP];
    GRANT SELECT ON dbo.vw_VentasEmpleado TO [UsuarioOLAP];
    GRANT SELECT ON dbo.vw_ResumenVentasAnual TO [UsuarioOLAP];
    GRANT SELECT ON dbo.vw_AnalisisIVA TO [UsuarioOLAP];
    GRANT SELECT ON dbo.vw_Calendario TO [UsuarioOLAP];
    PRINT 'Permisos SELECT otorgados a UsuarioOLAP sobre todas las vistas.';
END
GO

-- ============================================================================
-- VERIFICACION DE VISTAS CREADAS
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'VISTAS OLAP PARA POWER BI - RESUMEN';
PRINT '============================================================================';

SELECT 
    name AS Vista,
    create_date AS FechaCreacion,
    modify_date AS UltimaModificacion
FROM sys.views
WHERE name LIKE 'vw_%'
ORDER BY name;

PRINT '';
PRINT '>> Vistas disponibles para Power BI:';
PRINT '   1. vw_VentasCompletas - Vista principal con todas las dimensiones';
PRINT '   2. vw_VentasProductoProveedor - Hecho (a) agregado';
PRINT '   3. vw_VentasModalidadPago - Hecho (b) agregado';
PRINT '   4. vw_VentasEmpleado - Hecho (e) agregado';
PRINT '   5. vw_ResumenVentasAnual - KPIs por periodo';
PRINT '   6. vw_AnalisisIVA - Analisis fiscal';
PRINT '   7. vw_Calendario - Dimension tiempo para relaciones';
PRINT '';
PRINT '============================================================================';
PRINT 'VISTAS CREADAS EXITOSAMENTE';
PRINT '============================================================================';
GO
