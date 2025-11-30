-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: TablaDatosDim.sql
-- Descripcion: Esquema OLAP con modelo ESTRELLA
-- Base de Datos: Azure SQL Database
-- Fecha: Noviembre 2025
-- ============================================================================
-- MODELO ESTRELLA:
--   Se eligio modelo ESTRELLA sobre copo de nieve por:
--   1. Mejor rendimiento en consultas BI (menos JOINs)
--   2. Simplicidad para herramientas como Tableau/Power BI
--   3. Dimensiones desnormalizadas = consultas mas rapidas
--   4. Ideal para el volumen de datos del proyecto
-- ============================================================================
-- HECHOS OLAP SELECCIONADOS (Punto 3):
--   (a) Producto mas vendido por proveedor, tiempo y ubicacion
--   (b) Forma de pago preferida por tiempo y region
--   (e) Mejor vendedor por categoria, tiempo, ubicacion y modalidad
-- ============================================================================

-- ============================================================================
-- LIMPIEZA DE TABLAS OLAP EXISTENTES
-- ============================================================================

IF OBJECT_ID('dbo.FactVentas', 'U') IS NOT NULL DROP TABLE dbo.FactVentas;
IF OBJECT_ID('dbo.DimProducto', 'U') IS NOT NULL DROP TABLE dbo.DimProducto;
IF OBJECT_ID('dbo.DimCategoria', 'U') IS NOT NULL DROP TABLE dbo.DimCategoria;
IF OBJECT_ID('dbo.DimProveedor', 'U') IS NOT NULL DROP TABLE dbo.DimProveedor;
IF OBJECT_ID('dbo.DimCliente', 'U') IS NOT NULL DROP TABLE dbo.DimCliente;
IF OBJECT_ID('dbo.DimEmpleado', 'U') IS NOT NULL DROP TABLE dbo.DimEmpleado;
IF OBJECT_ID('dbo.DimModalidadPago', 'U') IS NOT NULL DROP TABLE dbo.DimModalidadPago;
IF OBJECT_ID('dbo.DimUbicacion', 'U') IS NOT NULL DROP TABLE dbo.DimUbicacion;
IF OBJECT_ID('dbo.DimTiempo', 'U') IS NOT NULL DROP TABLE dbo.DimTiempo;
GO

PRINT '============================================================================';
PRINT 'CREANDO ESQUEMA OLAP - MODELO ESTRELLA';
PRINT '============================================================================';
PRINT '';

-- ============================================================================
-- DIMENSION: DimTiempo
-- Descripcion: Dimension temporal para analisis por periodo
-- Granularidad: Dia
-- Jerarquia: Anio > Semestre > Trimestre > Mes > Semana > Dia
-- ============================================================================

PRINT '[1/9] Creando DimTiempo...';

CREATE TABLE dbo.DimTiempo (
    TiempoKey           INT PRIMARY KEY,           -- Formato YYYYMMDD
    Fecha               DATE NOT NULL UNIQUE,
    Anio                INT NOT NULL,
    Semestre            INT NOT NULL,              -- 1 o 2
    Trimestre           INT NOT NULL,              -- 1 a 4
    Mes                 INT NOT NULL,              -- 1 a 12
    Semana              INT NOT NULL,              -- 1 a 53
    DiaDelMes           INT NOT NULL,              -- 1 a 31
    DiaSemana           INT NOT NULL,              -- 1 a 7
    DiaDelAnio          INT NOT NULL,              -- 1 a 366
    NombreAnio          NVARCHAR(10) NOT NULL,
    NombreSemestre      NVARCHAR(20) NOT NULL,     -- 'Semestre 1', 'Semestre 2'
    NombreTrimestre     NVARCHAR(10) NOT NULL,     -- 'Q1', 'Q2', 'Q3', 'Q4'
    NombreMes           NVARCHAR(20) NOT NULL,     -- 'Enero', 'Febrero', etc
    NombreMesCorto      NVARCHAR(5) NOT NULL,      -- 'Ene', 'Feb', etc
    NombreDia           NVARCHAR(20) NOT NULL,     -- 'Lunes', 'Martes', etc
    NombreDiaCorto      NVARCHAR(5) NOT NULL,      -- 'Lun', 'Mar', etc
    EsFinDeSemana       BIT NOT NULL,
    EsDiaLaboral        BIT NOT NULL,
    AnioMes             NVARCHAR(10) NOT NULL,     -- '2020-01'
    AnioTrimestre       NVARCHAR(10) NOT NULL      -- '2020-Q1'
);
GO

-- Indice para busquedas por fecha
CREATE NONCLUSTERED INDEX IX_DimTiempo_Fecha ON dbo.DimTiempo(Fecha);
CREATE NONCLUSTERED INDEX IX_DimTiempo_AnioMes ON dbo.DimTiempo(Anio, Mes);
GO

-- ============================================================================
-- DIMENSION: DimUbicacion
-- Descripcion: Ubicaciones geograficas de clientes y proveedores
-- ============================================================================

PRINT '[2/9] Creando DimUbicacion...';

CREATE TABLE dbo.DimUbicacion (
    UbicacionKey        INT IDENTITY(1,1) PRIMARY KEY,
    Pais                NVARCHAR(100) NOT NULL,
    Ciudad              NVARCHAR(100) NOT NULL,
    Region              NVARCHAR(100) NULL,        -- Sierra, Costa, etc.
    
    CONSTRAINT UK_DimUbicacion UNIQUE (Pais, Ciudad)
);
GO

-- ============================================================================
-- DIMENSION: DimCategoria
-- Descripcion: Categorias de productos
-- ============================================================================

PRINT '[3/9] Creando DimCategoria...';

CREATE TABLE dbo.DimCategoria (
    CategoriaKey        INT IDENTITY(1,1) PRIMARY KEY,
    CategoriaID_OLTP    INT NOT NULL,              -- FK al sistema OLTP
    Codigo              NVARCHAR(10) NOT NULL,
    Nombre              NVARCHAR(100) NOT NULL,
    Descripcion         NVARCHAR(500) NULL
);
GO

-- ============================================================================
-- DIMENSION: DimProveedor
-- Descripcion: Proveedores de productos
-- ============================================================================

PRINT '[4/9] Creando DimProveedor...';

CREATE TABLE dbo.DimProveedor (
    ProveedorKey        INT IDENTITY(1,1) PRIMARY KEY,
    ProveedorID_OLTP    INT NOT NULL,
    Codigo              NVARCHAR(20) NOT NULL,
    Nombre              NVARCHAR(200) NOT NULL,
    NombreContacto      NVARCHAR(150) NULL,
    Ciudad              NVARCHAR(100) NOT NULL,
    Pais                NVARCHAR(100) NOT NULL,
    UbicacionKey        INT NULL                   -- FK a DimUbicacion
);
GO

-- ============================================================================
-- DIMENSION: DimCliente
-- Descripcion: Clientes del sistema
-- ============================================================================

PRINT '[5/9] Creando DimCliente...';

CREATE TABLE dbo.DimCliente (
    ClienteKey          INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID_OLTP      INT NOT NULL,
    Codigo              NVARCHAR(20) NOT NULL,
    NombreCompleto      NVARCHAR(200) NOT NULL,
    TipoDocumento       NVARCHAR(20) NOT NULL,
    Email               NVARCHAR(150) NULL,
    Ciudad              NVARCHAR(100) NOT NULL,
    Pais                NVARCHAR(100) NOT NULL,
    UbicacionKey        INT NULL                   -- FK a DimUbicacion
);
GO

-- ============================================================================
-- DIMENSION: DimEmpleado
-- Descripcion: Empleados/Vendedores
-- ============================================================================

PRINT '[6/9] Creando DimEmpleado...';

CREATE TABLE dbo.DimEmpleado (
    EmpleadoKey         INT IDENTITY(1,1) PRIMARY KEY,
    EmpleadoID_OLTP     INT NOT NULL,
    Codigo              NVARCHAR(20) NOT NULL,
    NombreCompleto      NVARCHAR(200) NOT NULL,
    Cargo               NVARCHAR(100) NOT NULL
);
GO

-- ============================================================================
-- DIMENSION: DimModalidadPago
-- Descripcion: Modalidades de pago con cuotas
-- ============================================================================

PRINT '[7/9] Creando DimModalidadPago...';

CREATE TABLE dbo.DimModalidadPago (
    ModalidadKey        INT IDENTITY(1,1) PRIMARY KEY,
    ModalidadID_OLTP    INT NOT NULL,
    Codigo              NVARCHAR(20) NOT NULL,
    Descripcion         NVARCHAR(100) NOT NULL,
    TipoPago            NVARCHAR(50) NOT NULL,
    Cuotas              INT NOT NULL,
    TasaInteres         DECIMAL(5,2) NOT NULL,
    EsTarjeta           BIT NOT NULL,
    DescripcionCompleta NVARCHAR(150) NOT NULL     -- 'Tarjeta Credito - 6 Cuotas'
);
GO

-- ============================================================================
-- DIMENSION: DimProducto
-- Descripcion: Productos del catalogo (desnormalizada con categoria y proveedor)
-- ============================================================================

PRINT '[8/9] Creando DimProducto...';

CREATE TABLE dbo.DimProducto (
    ProductoKey         INT IDENTITY(1,1) PRIMARY KEY,
    ProductoID_OLTP     INT NOT NULL,
    Codigo              NVARCHAR(30) NOT NULL,
    Nombre              NVARCHAR(200) NOT NULL,
    CategoriaKey        INT NOT NULL,              -- FK a DimCategoria
    NombreCategoria     NVARCHAR(100) NOT NULL,    -- Desnormalizado
    ProveedorKey        INT NOT NULL,              -- FK a DimProveedor
    NombreProveedor     NVARCHAR(200) NOT NULL,    -- Desnormalizado
    PrecioUnitario      DECIMAL(18,2) NOT NULL,
    PorcentajeIVA       DECIMAL(5,2) NOT NULL,
    TieneIVA            BIT NOT NULL,              -- 1 si IVA > 0
    TipoIVA             NVARCHAR(20) NOT NULL      -- 'IVA 15%' o 'IVA 0%'
);
GO

-- ============================================================================
-- TABLA DE HECHOS: FactVentas
-- Descripcion: Hechos de ventas a nivel de linea de pedido
-- Granularidad: Una fila por cada linea de detalle de pedido
-- ============================================================================

PRINT '[9/9] Creando FactVentas...';

CREATE TABLE dbo.FactVentas (
    FactVentaID             BIGINT IDENTITY(1,1) PRIMARY KEY,
    
    -- Claves foraneas a dimensiones
    TiempoKey               INT NOT NULL,
    ProductoKey             INT NOT NULL,
    CategoriaKey            INT NOT NULL,
    ClienteKey              INT NOT NULL,
    ProveedorKey            INT NOT NULL,
    EmpleadoKey             INT NOT NULL,
    ModalidadKey            INT NOT NULL,
    UbicacionClienteKey     INT NOT NULL,
    UbicacionProveedorKey   INT NULL,
    
    -- Claves degeneradas (para drill-through)
    PedidoID_OLTP           INT NOT NULL,
    DetalleID_OLTP          INT NOT NULL,
    
    -- Medidas/Metricas
    Cantidad                INT NOT NULL,
    PrecioUnitario          DECIMAL(18,2) NOT NULL,
    PorcentajeIVA           DECIMAL(5,2) NOT NULL,
    MontoSubtotal           DECIMAL(18,2) NOT NULL,
    MontoIVA                DECIMAL(18,2) NOT NULL,
    MontoTotal              DECIMAL(18,2) NOT NULL,
    
    -- Constraints
    CONSTRAINT FK_FactVentas_Tiempo FOREIGN KEY (TiempoKey) 
        REFERENCES dbo.DimTiempo(TiempoKey),
    CONSTRAINT FK_FactVentas_Producto FOREIGN KEY (ProductoKey) 
        REFERENCES dbo.DimProducto(ProductoKey),
    CONSTRAINT FK_FactVentas_Categoria FOREIGN KEY (CategoriaKey) 
        REFERENCES dbo.DimCategoria(CategoriaKey),
    CONSTRAINT FK_FactVentas_Cliente FOREIGN KEY (ClienteKey) 
        REFERENCES dbo.DimCliente(ClienteKey),
    CONSTRAINT FK_FactVentas_Proveedor FOREIGN KEY (ProveedorKey) 
        REFERENCES dbo.DimProveedor(ProveedorKey),
    CONSTRAINT FK_FactVentas_Empleado FOREIGN KEY (EmpleadoKey) 
        REFERENCES dbo.DimEmpleado(EmpleadoKey),
    CONSTRAINT FK_FactVentas_Modalidad FOREIGN KEY (ModalidadKey) 
        REFERENCES dbo.DimModalidadPago(ModalidadKey),
    CONSTRAINT FK_FactVentas_UbicacionCliente FOREIGN KEY (UbicacionClienteKey) 
        REFERENCES dbo.DimUbicacion(UbicacionKey)
);
GO

-- Indices para optimizar consultas OLAP
CREATE NONCLUSTERED INDEX IX_FactVentas_Tiempo ON dbo.FactVentas(TiempoKey);
CREATE NONCLUSTERED INDEX IX_FactVentas_Producto ON dbo.FactVentas(ProductoKey);
CREATE NONCLUSTERED INDEX IX_FactVentas_Categoria ON dbo.FactVentas(CategoriaKey);
CREATE NONCLUSTERED INDEX IX_FactVentas_Cliente ON dbo.FactVentas(ClienteKey);
CREATE NONCLUSTERED INDEX IX_FactVentas_Proveedor ON dbo.FactVentas(ProveedorKey);
CREATE NONCLUSTERED INDEX IX_FactVentas_Empleado ON dbo.FactVentas(EmpleadoKey);
CREATE NONCLUSTERED INDEX IX_FactVentas_Modalidad ON dbo.FactVentas(ModalidadKey);
CREATE NONCLUSTERED INDEX IX_FactVentas_UbicacionCliente ON dbo.FactVentas(UbicacionClienteKey);
GO

-- ============================================================================
-- VERIFICACION
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'ESQUEMA OLAP CREADO EXITOSAMENTE';
PRINT '============================================================================';
PRINT '';
PRINT 'Estructura del Modelo Estrella:';
PRINT '';
PRINT '                         DimTiempo';
PRINT '                             |';
PRINT '    DimProducto ----+       |       +---- DimCliente';
PRINT '                    |       |       |';
PRINT '    DimCategoria ---+-- FactVentas -+--- DimEmpleado';
PRINT '                    |       |       |';
PRINT '    DimProveedor ---+       |       +---- DimModalidadPago';
PRINT '                             |';
PRINT '                       DimUbicacion';
PRINT '';

SELECT 
    t.name AS Tabla,
    CASE 
        WHEN t.name LIKE 'Dim%' THEN 'Dimension'
        WHEN t.name LIKE 'Fact%' THEN 'Hechos'
        ELSE 'Otra'
    END AS TipoTabla,
    COUNT(c.column_id) AS Columnas
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
WHERE t.name LIKE 'Dim%' OR t.name LIKE 'Fact%'
GROUP BY t.name
ORDER BY TipoTabla DESC, t.name;

PRINT '';
PRINT '============================================================================';
GO
