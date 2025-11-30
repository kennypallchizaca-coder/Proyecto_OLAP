-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: ETL.sql
-- Descripcion: Proceso ETL (Extraccion, Transformacion y Carga)
-- Base de Datos: Azure SQL Database
-- Fecha: Noviembre 2025
-- ============================================================================
-- PROCESO ETL:
--   1. Cargar dimension de tiempo (DimTiempo)
--   2. Cargar dimension de ubicacion (DimUbicacion)
--   3. Cargar dimensiones maestras (Categoria, Proveedor, Cliente, etc.)
--   4. Cargar dimension de producto con desnormalizacion
--   5. Cargar tabla de hechos (FactVentas)
-- ============================================================================

SET NOCOUNT ON;
GO

PRINT '============================================================================';
PRINT 'INICIANDO PROCESO ETL';
PRINT 'Fecha y Hora: ' + CONVERT(VARCHAR(25), GETDATE(), 120);
PRINT '============================================================================';
PRINT '';

-- ============================================================================
-- FASE 1: CARGAR DimTiempo (Calendario 2020-2025)
-- ============================================================================

PRINT '[FASE 1/6] Cargando DimTiempo (2020-2025)...';

-- Limpiar dimension de tiempo
DELETE FROM dbo.DimTiempo;

-- Generar calendario
DECLARE @FechaInicio DATE = '2020-01-01';
DECLARE @FechaFin DATE = '2025-12-31';
DECLARE @Fecha DATE = @FechaInicio;

WHILE @Fecha <= @FechaFin
BEGIN
    INSERT INTO dbo.DimTiempo (
        TiempoKey, Fecha, Anio, Semestre, Trimestre, Mes, Semana,
        DiaDelMes, DiaSemana, DiaDelAnio,
        NombreAnio, NombreSemestre, NombreTrimestre, NombreMes, NombreMesCorto,
        NombreDia, NombreDiaCorto, EsFinDeSemana, EsDiaLaboral, AnioMes, AnioTrimestre
    )
    SELECT
        CONVERT(INT, FORMAT(@Fecha, 'yyyyMMdd')),           -- TiempoKey
        @Fecha,                                              -- Fecha
        YEAR(@Fecha),                                        -- Anio
        CASE WHEN MONTH(@Fecha) <= 6 THEN 1 ELSE 2 END,     -- Semestre
        DATEPART(QUARTER, @Fecha),                           -- Trimestre
        MONTH(@Fecha),                                       -- Mes
        DATEPART(WEEK, @Fecha),                              -- Semana
        DAY(@Fecha),                                         -- DiaDelMes
        DATEPART(WEEKDAY, @Fecha),                           -- DiaSemana
        DATEPART(DAYOFYEAR, @Fecha),                         -- DiaDelAnio
        CAST(YEAR(@Fecha) AS NVARCHAR(10)),                  -- NombreAnio
        CASE WHEN MONTH(@Fecha) <= 6 THEN 'Semestre 1' ELSE 'Semestre 2' END, -- NombreSemestre
        'Q' + CAST(DATEPART(QUARTER, @Fecha) AS VARCHAR),    -- NombreTrimestre
        CASE MONTH(@Fecha)
            WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
            WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
            WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre'
            WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
        END,                                                  -- NombreMes
        CASE MONTH(@Fecha)
            WHEN 1 THEN 'Ene' WHEN 2 THEN 'Feb' WHEN 3 THEN 'Mar'
            WHEN 4 THEN 'Abr' WHEN 5 THEN 'May' WHEN 6 THEN 'Jun'
            WHEN 7 THEN 'Jul' WHEN 8 THEN 'Ago' WHEN 9 THEN 'Sep'
            WHEN 10 THEN 'Oct' WHEN 11 THEN 'Nov' WHEN 12 THEN 'Dic'
        END,                                                  -- NombreMesCorto
        CASE DATEPART(WEEKDAY, @Fecha)
            WHEN 1 THEN 'Domingo' WHEN 2 THEN 'Lunes' WHEN 3 THEN 'Martes'
            WHEN 4 THEN 'Miercoles' WHEN 5 THEN 'Jueves' WHEN 6 THEN 'Viernes'
            WHEN 7 THEN 'Sabado'
        END,                                                  -- NombreDia
        CASE DATEPART(WEEKDAY, @Fecha)
            WHEN 1 THEN 'Dom' WHEN 2 THEN 'Lun' WHEN 3 THEN 'Mar'
            WHEN 4 THEN 'Mie' WHEN 5 THEN 'Jue' WHEN 6 THEN 'Vie'
            WHEN 7 THEN 'Sab'
        END,                                                  -- NombreDiaCorto
        CASE WHEN DATEPART(WEEKDAY, @Fecha) IN (1, 7) THEN 1 ELSE 0 END, -- EsFinDeSemana
        CASE WHEN DATEPART(WEEKDAY, @Fecha) IN (2,3,4,5,6) THEN 1 ELSE 0 END, -- EsDiaLaboral
        FORMAT(@Fecha, 'yyyy-MM'),                           -- AnioMes
        CAST(YEAR(@Fecha) AS VARCHAR) + '-Q' + CAST(DATEPART(QUARTER, @Fecha) AS VARCHAR) -- AnioTrimestre
    ;
    
    SET @Fecha = DATEADD(DAY, 1, @Fecha);
END;

PRINT '   ' + CAST((SELECT COUNT(*) FROM dbo.DimTiempo) AS VARCHAR) + ' fechas generadas.';

-- ============================================================================
-- FASE 2: CARGAR DimUbicacion
-- ============================================================================

PRINT '[FASE 2/6] Cargando DimUbicacion...';

DELETE FROM dbo.DimUbicacion;

-- Insertar ubicaciones unicas de clientes y proveedores
INSERT INTO dbo.DimUbicacion (Pais, Ciudad, Region)
SELECT DISTINCT 
    Pais, 
    Ciudad,
    CASE Ciudad
        WHEN 'Quito' THEN 'Sierra'
        WHEN 'Cuenca' THEN 'Sierra'
        WHEN 'Loja' THEN 'Sierra'
        WHEN 'Guayaquil' THEN 'Costa'
        WHEN 'Manta' THEN 'Costa'
        ELSE 'Otras'
    END AS Region
FROM (
    SELECT Pais, Ciudad FROM dbo.Cliente
    UNION
    SELECT Pais, Ciudad FROM dbo.Proveedor
) AS Ubicaciones;

PRINT '   ' + CAST((SELECT COUNT(*) FROM dbo.DimUbicacion) AS VARCHAR) + ' ubicaciones cargadas.';

-- ============================================================================
-- FASE 3: CARGAR DIMENSIONES MAESTRAS
-- ============================================================================

PRINT '[FASE 3/6] Cargando dimensiones maestras...';

-- DimCategoria
DELETE FROM dbo.DimCategoria;
INSERT INTO dbo.DimCategoria (CategoriaID_OLTP, Codigo, Nombre, Descripcion)
SELECT CategoriaID, Codigo, Nombre, Descripcion
FROM dbo.Categoria;
PRINT '   DimCategoria: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros.';

-- DimProveedor
DELETE FROM dbo.DimProveedor;
INSERT INTO dbo.DimProveedor (ProveedorID_OLTP, Codigo, Nombre, NombreContacto, Ciudad, Pais, UbicacionKey)
SELECT 
    p.ProveedorID, p.Codigo, p.Nombre, p.NombreContacto, p.Ciudad, p.Pais,
    u.UbicacionKey
FROM dbo.Proveedor p
LEFT JOIN dbo.DimUbicacion u ON p.Ciudad = u.Ciudad AND p.Pais = u.Pais;
PRINT '   DimProveedor: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros.';

-- DimCliente
DELETE FROM dbo.DimCliente;
INSERT INTO dbo.DimCliente (ClienteID_OLTP, Codigo, NombreCompleto, TipoDocumento, Email, Ciudad, Pais, UbicacionKey)
SELECT 
    c.ClienteID, c.Codigo, c.NombreCompleto, c.TipoDocumento, c.Email, c.Ciudad, c.Pais,
    u.UbicacionKey
FROM dbo.Cliente c
LEFT JOIN dbo.DimUbicacion u ON c.Ciudad = u.Ciudad AND c.Pais = u.Pais;
PRINT '   DimCliente: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros.';

-- DimEmpleado
DELETE FROM dbo.DimEmpleado;
INSERT INTO dbo.DimEmpleado (EmpleadoID_OLTP, Codigo, NombreCompleto, Cargo)
SELECT EmpleadoID, Codigo, NombreCompleto, Cargo
FROM dbo.Empleado;
PRINT '   DimEmpleado: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros.';

-- DimModalidadPago
DELETE FROM dbo.DimModalidadPago;
INSERT INTO dbo.DimModalidadPago (ModalidadID_OLTP, Codigo, Descripcion, TipoPago, Cuotas, TasaInteres, EsTarjeta, DescripcionCompleta)
SELECT 
    ModalidadPagoID, 
    Codigo, 
    Descripcion, 
    TipoPago, 
    Cuotas, 
    TasaInteres,
    CASE WHEN TipoPago IN ('TARJETA_CREDITO', 'TARJETA_DEBITO') THEN 1 ELSE 0 END,
    CASE 
        WHEN Cuotas > 1 THEN Descripcion + ' (' + CAST(Cuotas AS VARCHAR) + ' cuotas)'
        ELSE Descripcion
    END
FROM dbo.ModalidadPago;
PRINT '   DimModalidadPago: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros.';

-- ============================================================================
-- FASE 4: CARGAR DimProducto (Desnormalizada)
-- ============================================================================

PRINT '[FASE 4/6] Cargando DimProducto (desnormalizada)...';

DELETE FROM dbo.DimProducto;

INSERT INTO dbo.DimProducto (
    ProductoID_OLTP, Codigo, Nombre, 
    CategoriaKey, NombreCategoria,
    ProveedorKey, NombreProveedor,
    PrecioUnitario, PorcentajeIVA, TieneIVA, TipoIVA
)
SELECT 
    p.ProductoID,
    p.Codigo,
    p.Nombre,
    dc.CategoriaKey,
    dc.Nombre AS NombreCategoria,
    dprov.ProveedorKey,
    dprov.Nombre AS NombreProveedor,
    p.PrecioUnitario,
    p.PorcentajeIVA,
    CASE WHEN p.PorcentajeIVA > 0 THEN 1 ELSE 0 END,
    CASE WHEN p.PorcentajeIVA = 15 THEN 'IVA 15%' ELSE 'IVA 0%' END
FROM dbo.Producto p
JOIN dbo.DimCategoria dc ON p.CategoriaID = dc.CategoriaID_OLTP
JOIN dbo.DimProveedor dprov ON p.ProveedorID = dprov.ProveedorID_OLTP;

PRINT '   DimProducto: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros.';

-- ============================================================================
-- FASE 5: CARGAR FactVentas
-- ============================================================================

PRINT '[FASE 5/6] Cargando FactVentas...';
PRINT '   Este proceso puede tardar varios minutos...';

-- Limpiar tabla de hechos
TRUNCATE TABLE dbo.FactVentas;

-- Insertar hechos de ventas
INSERT INTO dbo.FactVentas (
    TiempoKey,
    ProductoKey,
    CategoriaKey,
    ClienteKey,
    ProveedorKey,
    EmpleadoKey,
    ModalidadKey,
    UbicacionClienteKey,
    UbicacionProveedorKey,
    PedidoID_OLTP,
    DetalleID_OLTP,
    Cantidad,
    PrecioUnitario,
    PorcentajeIVA,
    MontoSubtotal,
    MontoIVA,
    MontoTotal
)
SELECT 
    dt.TiempoKey,
    dprod.ProductoKey,
    dprod.CategoriaKey,
    dcli.ClienteKey,
    dprod.ProveedorKey,
    demp.EmpleadoKey,
    dmod.ModalidadKey,
    dcli.UbicacionKey,
    dprov.UbicacionKey,
    ped.PedidoID,
    det.DetalleID,
    det.Cantidad,
    det.PrecioUnitario,
    det.PorcentajeIVA,
    det.Subtotal,
    det.MontoIVA,
    det.Total
FROM dbo.DetallePedido det
JOIN dbo.Pedido ped ON det.PedidoID = ped.PedidoID
JOIN dbo.DimTiempo dt ON dt.Fecha = ped.Fecha
JOIN dbo.DimProducto dprod ON det.ProductoID = dprod.ProductoID_OLTP
JOIN dbo.DimCliente dcli ON ped.ClienteID = dcli.ClienteID_OLTP
JOIN dbo.DimProveedor dprov ON dprod.ProveedorKey = dprov.ProveedorKey
JOIN dbo.DimEmpleado demp ON ped.EmpleadoID = demp.EmpleadoID_OLTP
JOIN dbo.DimModalidadPago dmod ON ped.ModalidadPagoID = dmod.ModalidadID_OLTP;

PRINT '   FactVentas: ' + CAST(@@ROWCOUNT AS VARCHAR) + ' registros cargados.';

-- ============================================================================
-- FASE 6: VERIFICACION Y ESTADISTICAS
-- ============================================================================

PRINT '[FASE 6/6] Verificacion final...';
PRINT '';

PRINT '============================================================================';
PRINT 'RESUMEN DEL PROCESO ETL';
PRINT '============================================================================';
PRINT '';

SELECT 
    'DimTiempo' AS Tabla, COUNT(*) AS Registros FROM dbo.DimTiempo
UNION ALL SELECT 'DimUbicacion', COUNT(*) FROM dbo.DimUbicacion
UNION ALL SELECT 'DimCategoria', COUNT(*) FROM dbo.DimCategoria
UNION ALL SELECT 'DimProveedor', COUNT(*) FROM dbo.DimProveedor
UNION ALL SELECT 'DimCliente', COUNT(*) FROM dbo.DimCliente
UNION ALL SELECT 'DimEmpleado', COUNT(*) FROM dbo.DimEmpleado
UNION ALL SELECT 'DimModalidadPago', COUNT(*) FROM dbo.DimModalidadPago
UNION ALL SELECT 'DimProducto', COUNT(*) FROM dbo.DimProducto
UNION ALL SELECT 'FactVentas', COUNT(*) FROM dbo.FactVentas
ORDER BY Tabla;

PRINT '';
PRINT '>> Estadisticas de Ventas:';

SELECT 
    COUNT(DISTINCT PedidoID_OLTP) AS TotalPedidos,
    COUNT(*) AS TotalLineas,
    SUM(Cantidad) AS UnidadesTotales,
    FORMAT(SUM(MontoSubtotal), 'C', 'es-EC') AS Subtotal,
    FORMAT(SUM(MontoIVA), 'C', 'es-EC') AS IVA,
    FORMAT(SUM(MontoTotal), 'C', 'es-EC') AS Total
FROM dbo.FactVentas;

PRINT '';
PRINT '>> Ventas por Anio:';

SELECT 
    dt.Anio,
    COUNT(DISTINCT f.PedidoID_OLTP) AS Pedidos,
    FORMAT(SUM(f.MontoTotal), 'C', 'es-EC') AS Ventas
FROM dbo.FactVentas f
JOIN dbo.DimTiempo dt ON f.TiempoKey = dt.TiempoKey
GROUP BY dt.Anio
ORDER BY dt.Anio;

PRINT '';
PRINT '============================================================================';
PRINT 'ETL COMPLETADO EXITOSAMENTE';
PRINT 'Fecha y Hora: ' + CONVERT(VARCHAR(25), GETDATE(), 120);
PRINT '============================================================================';
GO
