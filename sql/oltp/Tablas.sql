-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: Tablas.sql
-- Descripcion: Esquema OLTP completo para sistema de pedidos
-- Base de Datos: Azure SQL Database
-- Fecha: Noviembre 2025
-- ============================================================================
-- REQUISITOS CUMPLIDOS:
--   1.a) Modalidad de pago (efectivo, transferencia, tarjeta con cuotas)
--   1.b) IVA por producto (15% o 0%)
--   Relacion con clientes y proveedores
-- ============================================================================

-- ============================================================================
-- LIMPIEZA DE TABLAS EXISTENTES (en orden de dependencias)
-- ============================================================================

IF OBJECT_ID('dbo.DetallePedido', 'U') IS NOT NULL DROP TABLE dbo.DetallePedido;
IF OBJECT_ID('dbo.Pedido', 'U') IS NOT NULL DROP TABLE dbo.Pedido;
IF OBJECT_ID('dbo.Producto', 'U') IS NOT NULL DROP TABLE dbo.Producto;
IF OBJECT_ID('dbo.ModalidadPago', 'U') IS NOT NULL DROP TABLE dbo.ModalidadPago;
IF OBJECT_ID('dbo.Cliente', 'U') IS NOT NULL DROP TABLE dbo.Cliente;
IF OBJECT_ID('dbo.Empleado', 'U') IS NOT NULL DROP TABLE dbo.Empleado;
IF OBJECT_ID('dbo.Proveedor', 'U') IS NOT NULL DROP TABLE dbo.Proveedor;
IF OBJECT_ID('dbo.Categoria', 'U') IS NOT NULL DROP TABLE dbo.Categoria;
GO

-- ============================================================================
-- TABLA: Categoria
-- Descripcion: Categorias de productos (minimo 5 requeridas)
-- ============================================================================

CREATE TABLE dbo.Categoria (
    CategoriaID     INT IDENTITY(1,1) PRIMARY KEY,
    Codigo          NVARCHAR(10) NOT NULL UNIQUE,
    Nombre          NVARCHAR(100) NOT NULL,
    Descripcion     NVARCHAR(500) NULL,
    FechaCreacion   DATETIME2 DEFAULT GETDATE(),
    Activo          BIT DEFAULT 1
);
GO

-- ============================================================================
-- TABLA: Proveedor
-- Descripcion: Proveedores de productos (minimo 10 requeridos)
-- ============================================================================

CREATE TABLE dbo.Proveedor (
    ProveedorID     INT IDENTITY(1,1) PRIMARY KEY,
    Codigo          NVARCHAR(20) NOT NULL UNIQUE,
    Nombre          NVARCHAR(200) NOT NULL,
    NombreContacto  NVARCHAR(150) NULL,
    Telefono        NVARCHAR(20) NULL,
    Email           NVARCHAR(150) NULL,
    Direccion       NVARCHAR(300) NULL,
    Ciudad          NVARCHAR(100) NOT NULL,
    Pais            NVARCHAR(100) NOT NULL DEFAULT 'Ecuador',
    FechaCreacion   DATETIME2 DEFAULT GETDATE(),
    Activo          BIT DEFAULT 1
);
GO

-- ============================================================================
-- TABLA: Empleado
-- Descripcion: Empleados/Vendedores (minimo 5 requeridos)
-- ============================================================================

CREATE TABLE dbo.Empleado (
    EmpleadoID      INT IDENTITY(1,1) PRIMARY KEY,
    Codigo          NVARCHAR(20) NOT NULL UNIQUE,
    NombreCompleto  NVARCHAR(200) NOT NULL,
    Cargo           NVARCHAR(100) NOT NULL DEFAULT 'Vendedor',
    Email           NVARCHAR(150) NULL,
    Telefono        NVARCHAR(20) NULL,
    FechaContratacion DATE NOT NULL DEFAULT GETDATE(),
    Activo          BIT DEFAULT 1
);
GO

-- ============================================================================
-- TABLA: Cliente
-- Descripcion: Clientes del sistema (minimo 20 requeridos)
-- ============================================================================

CREATE TABLE dbo.Cliente (
    ClienteID       INT IDENTITY(1,1) PRIMARY KEY,
    Codigo          NVARCHAR(20) NOT NULL UNIQUE,
    NombreCompleto  NVARCHAR(200) NOT NULL,
    TipoDocumento   NVARCHAR(20) NOT NULL DEFAULT 'Cedula',
    NumeroDocumento NVARCHAR(20) NULL,
    Email           NVARCHAR(150) NULL,
    Telefono        NVARCHAR(20) NULL,
    Direccion       NVARCHAR(300) NULL,
    Ciudad          NVARCHAR(100) NOT NULL,
    Pais            NVARCHAR(100) NOT NULL DEFAULT 'Ecuador',
    FechaRegistro   DATETIME2 DEFAULT GETDATE(),
    Activo          BIT DEFAULT 1
);
GO

-- ============================================================================
-- TABLA: ModalidadPago
-- Descripcion: Formas de pago disponibles
-- REQUISITO 1.a: Efectivo, Transferencia, Tarjeta de Credito con cuotas
-- ============================================================================

CREATE TABLE dbo.ModalidadPago (
    ModalidadPagoID INT IDENTITY(1,1) PRIMARY KEY,
    Codigo          NVARCHAR(20) NOT NULL UNIQUE,
    Descripcion     NVARCHAR(100) NOT NULL,
    TipoPago        NVARCHAR(50) NOT NULL,  -- EFECTIVO, TRANSFERENCIA, TARJETA_CREDITO
    Cuotas          INT NOT NULL DEFAULT 0, -- Numero de cuotas (0 = sin cuotas)
    TasaInteres     DECIMAL(5,2) DEFAULT 0, -- Tasa de interes para cuotas
    RequiereDatos   BIT DEFAULT 0,          -- Si requiere datos adicionales
    Activo          BIT DEFAULT 1,
    
    CONSTRAINT CK_ModalidadPago_Cuotas CHECK (Cuotas >= 0 AND Cuotas <= 24),
    CONSTRAINT CK_ModalidadPago_TipoPago CHECK (TipoPago IN ('EFECTIVO', 'TRANSFERENCIA', 'TARJETA_CREDITO', 'TARJETA_DEBITO'))
);
GO

-- ============================================================================
-- TABLA: Producto
-- Descripcion: Productos del catalogo (minimo 200 requeridos)
-- REQUISITO 1.b: IVA 15% o 0% por producto
-- ============================================================================

CREATE TABLE dbo.Producto (
    ProductoID      INT IDENTITY(1,1) PRIMARY KEY,
    Codigo          NVARCHAR(30) NOT NULL UNIQUE,
    Nombre          NVARCHAR(200) NOT NULL,
    Descripcion     NVARCHAR(500) NULL,
    CategoriaID     INT NOT NULL,
    ProveedorID     INT NOT NULL,
    PrecioUnitario  DECIMAL(18,2) NOT NULL,
    PorcentajeIVA   DECIMAL(5,2) NOT NULL DEFAULT 15.00, -- 15% o 0%
    Stock           INT NOT NULL DEFAULT 0,
    StockMinimo     INT NOT NULL DEFAULT 10,
    FechaCreacion   DATETIME2 DEFAULT GETDATE(),
    Activo          BIT DEFAULT 1,
    
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (CategoriaID) 
        REFERENCES dbo.Categoria(CategoriaID),
    CONSTRAINT FK_Producto_Proveedor FOREIGN KEY (ProveedorID) 
        REFERENCES dbo.Proveedor(ProveedorID),
    CONSTRAINT CK_Producto_Precio CHECK (PrecioUnitario > 0),
    CONSTRAINT CK_Producto_IVA CHECK (PorcentajeIVA IN (0, 15))
);
GO

-- Indices para busquedas por categoria y proveedor
CREATE NONCLUSTERED INDEX IX_Producto_Categoria ON dbo.Producto(CategoriaID);
CREATE NONCLUSTERED INDEX IX_Producto_Proveedor ON dbo.Producto(ProveedorID);
GO

-- ============================================================================
-- TABLA: Pedido
-- Descripcion: Cabecera de pedidos (100,000 requeridos)
-- Relacionado con Cliente, Empleado y ModalidadPago
-- ============================================================================

CREATE TABLE dbo.Pedido (
    PedidoID        INT IDENTITY(1,1) PRIMARY KEY,
    NumeroPedido    NVARCHAR(20) NOT NULL UNIQUE,
    Fecha           DATE NOT NULL,
    ClienteID       INT NOT NULL,
    EmpleadoID      INT NOT NULL,
    ModalidadPagoID INT NOT NULL,
    Subtotal        DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalIVA        DECIMAL(18,2) NOT NULL DEFAULT 0,
    Total           DECIMAL(18,2) NOT NULL DEFAULT 0,
    Estado          NVARCHAR(20) NOT NULL DEFAULT 'COMPLETADO',
    Observaciones   NVARCHAR(500) NULL,
    FechaCreacion   DATETIME2 DEFAULT GETDATE(),
    
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (ClienteID) 
        REFERENCES dbo.Cliente(ClienteID),
    CONSTRAINT FK_Pedido_Empleado FOREIGN KEY (EmpleadoID) 
        REFERENCES dbo.Empleado(EmpleadoID),
    CONSTRAINT FK_Pedido_ModalidadPago FOREIGN KEY (ModalidadPagoID) 
        REFERENCES dbo.ModalidadPago(ModalidadPagoID),
    CONSTRAINT CK_Pedido_Estado CHECK (Estado IN ('PENDIENTE', 'PROCESANDO', 'COMPLETADO', 'CANCELADO'))
);
GO

-- Indices para optimizar consultas
CREATE NONCLUSTERED INDEX IX_Pedido_Fecha ON dbo.Pedido(Fecha);
CREATE NONCLUSTERED INDEX IX_Pedido_Cliente ON dbo.Pedido(ClienteID);
CREATE NONCLUSTERED INDEX IX_Pedido_Empleado ON dbo.Pedido(EmpleadoID);
CREATE NONCLUSTERED INDEX IX_Pedido_ModalidadPago ON dbo.Pedido(ModalidadPagoID);
GO

-- ============================================================================
-- TABLA: DetallePedido
-- Descripcion: Lineas de detalle de cada pedido (3-10 productos por pedido)
-- ============================================================================

CREATE TABLE dbo.DetallePedido (
    DetalleID       INT IDENTITY(1,1) PRIMARY KEY,
    PedidoID        INT NOT NULL,
    ProductoID      INT NOT NULL,
    Cantidad        INT NOT NULL,
    PrecioUnitario  DECIMAL(18,2) NOT NULL,
    PorcentajeIVA   DECIMAL(5,2) NOT NULL,
    Subtotal        DECIMAL(18,2) NOT NULL,
    MontoIVA        DECIMAL(18,2) NOT NULL,
    Total           DECIMAL(18,2) NOT NULL,
    
    CONSTRAINT FK_DetallePedido_Pedido FOREIGN KEY (PedidoID) 
        REFERENCES dbo.Pedido(PedidoID) ON DELETE CASCADE,
    CONSTRAINT FK_DetallePedido_Producto FOREIGN KEY (ProductoID) 
        REFERENCES dbo.Producto(ProductoID),
    CONSTRAINT CK_DetallePedido_Cantidad CHECK (Cantidad >= 1 AND Cantidad <= 50)
);
GO

-- Indices para optimizar consultas
CREATE NONCLUSTERED INDEX IX_DetallePedido_Pedido ON dbo.DetallePedido(PedidoID);
CREATE NONCLUSTERED INDEX IX_DetallePedido_Producto ON dbo.DetallePedido(ProductoID);
GO

-- ============================================================================
-- VERIFICACION DE CREACION
-- ============================================================================

PRINT '============================================================================';
PRINT 'ESQUEMA OLTP CREADO EXITOSAMENTE';
PRINT '============================================================================';
PRINT '';

SELECT 
    t.name AS Tabla,
    COUNT(c.column_id) AS Columnas
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
WHERE t.schema_id = SCHEMA_ID('dbo')
  AND t.name IN ('Categoria', 'Proveedor', 'Empleado', 'Cliente', 
                 'ModalidadPago', 'Producto', 'Pedido', 'DetallePedido')
GROUP BY t.name
ORDER BY t.name;

PRINT '';
PRINT 'Tablas creadas: Categoria, Proveedor, Empleado, Cliente,';
PRINT '                ModalidadPago, Producto, Pedido, DetallePedido';
PRINT '============================================================================';
GO
