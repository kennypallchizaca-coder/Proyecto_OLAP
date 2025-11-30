-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: UsuarioOLAP.sql
-- Descripcion: Creacion de usuario de solo lectura para OLAP
-- Base de Datos: Azure SQL Database
-- Fecha: Noviembre 2025
-- ============================================================================
-- Este script crea un usuario con permisos de solo lectura sobre las
-- tablas de dimensiones y hechos del esquema OLAP.
-- REQUISITO: Punto 6 del enunciado - Usuario solo lectura
-- ============================================================================

-- ============================================================================
-- NOTA IMPORTANTE PARA AZURE SQL DATABASE:
-- ============================================================================
-- En Azure SQL Database, los usuarios se crean de forma diferente que en
-- SQL Server tradicional. No existe la base de datos master accesible,
-- por lo que se crean usuarios contenidos (contained users).
-- ============================================================================

-- ============================================================================
-- OPCION 1: Crear usuario contenido (Azure SQL Database)
-- ============================================================================
-- Este es el metodo recomendado para Azure SQL Database

-- Verificar si el usuario existe y eliminarlo si es necesario
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'UsuarioOLAP')
BEGIN
    DROP USER [UsuarioOLAP];
    PRINT 'Usuario UsuarioOLAP eliminado previamente.';
END
GO

-- Crear usuario contenido con contrasena
CREATE USER [UsuarioOLAP] WITH PASSWORD = 'OL@P_R3ad0nly2025!';
PRINT 'Usuario UsuarioOLAP creado exitosamente.';
GO

-- ============================================================================
-- ASIGNAR PERMISOS DE SOLO LECTURA
-- ============================================================================

-- Asignar rol de lectura de datos
ALTER ROLE db_datareader ADD MEMBER [UsuarioOLAP];
PRINT 'Rol db_datareader asignado a UsuarioOLAP.';
GO

-- ============================================================================
-- PERMISOS EXPLICITOS SOBRE TABLAS OLAP (Solo lectura)
-- ============================================================================

-- Permisos sobre dimensiones
GRANT SELECT ON dbo.DimTiempo TO [UsuarioOLAP];
GRANT SELECT ON dbo.DimUbicacion TO [UsuarioOLAP];
GRANT SELECT ON dbo.DimCategoria TO [UsuarioOLAP];
GRANT SELECT ON dbo.DimProveedor TO [UsuarioOLAP];
GRANT SELECT ON dbo.DimCliente TO [UsuarioOLAP];
GRANT SELECT ON dbo.DimEmpleado TO [UsuarioOLAP];
GRANT SELECT ON dbo.DimModalidadPago TO [UsuarioOLAP];
GRANT SELECT ON dbo.DimProducto TO [UsuarioOLAP];

-- Permisos sobre tabla de hechos
GRANT SELECT ON dbo.FactVentas TO [UsuarioOLAP];

PRINT 'Permisos SELECT otorgados sobre tablas OLAP.';
GO

-- ============================================================================
-- PERMISOS SOBRE VISTAS OLAP (Para Power BI)
-- ============================================================================

-- Estos permisos se otorgaran despues de crear las vistas
-- GRANT SELECT ON dbo.vw_VentasProductoProveedor TO [UsuarioOLAP];
-- GRANT SELECT ON dbo.vw_VentasModalidadPago TO [UsuarioOLAP];
-- GRANT SELECT ON dbo.vw_VentasEmpleado TO [UsuarioOLAP];
-- GRANT SELECT ON dbo.vw_ResumenVentasAnual TO [UsuarioOLAP];
-- GRANT SELECT ON dbo.vw_AnalisisIVA TO [UsuarioOLAP];

-- ============================================================================
-- DENEGAR PERMISOS DE ESCRITURA EXPLICITAMENTE
-- ============================================================================

-- Denegar cualquier modificacion en tablas OLAP
DENY INSERT, UPDATE, DELETE ON dbo.DimTiempo TO [UsuarioOLAP];
DENY INSERT, UPDATE, DELETE ON dbo.DimUbicacion TO [UsuarioOLAP];
DENY INSERT, UPDATE, DELETE ON dbo.DimCategoria TO [UsuarioOLAP];
DENY INSERT, UPDATE, DELETE ON dbo.DimProveedor TO [UsuarioOLAP];
DENY INSERT, UPDATE, DELETE ON dbo.DimCliente TO [UsuarioOLAP];
DENY INSERT, UPDATE, DELETE ON dbo.DimEmpleado TO [UsuarioOLAP];
DENY INSERT, UPDATE, DELETE ON dbo.DimModalidadPago TO [UsuarioOLAP];
DENY INSERT, UPDATE, DELETE ON dbo.DimProducto TO [UsuarioOLAP];
DENY INSERT, UPDATE, DELETE ON dbo.FactVentas TO [UsuarioOLAP];

PRINT 'Permisos de escritura denegados explicitamente.';
GO

-- ============================================================================
-- DENEGAR ACCESO A TABLAS OLTP (Solo pueden ver OLAP)
-- ============================================================================

DENY SELECT ON dbo.Categoria TO [UsuarioOLAP];
DENY SELECT ON dbo.Proveedor TO [UsuarioOLAP];
DENY SELECT ON dbo.Empleado TO [UsuarioOLAP];
DENY SELECT ON dbo.Cliente TO [UsuarioOLAP];
DENY SELECT ON dbo.ModalidadPago TO [UsuarioOLAP];
DENY SELECT ON dbo.Producto TO [UsuarioOLAP];
DENY SELECT ON dbo.Pedido TO [UsuarioOLAP];
DENY SELECT ON dbo.DetallePedido TO [UsuarioOLAP];

PRINT 'Acceso a tablas OLTP denegado.';
GO

-- ============================================================================
-- VERIFICACION DE PERMISOS
-- ============================================================================

PRINT '';
PRINT '============================================================================';
PRINT 'VERIFICACION DE USUARIO Y PERMISOS';
PRINT '============================================================================';

-- Mostrar informacion del usuario
SELECT 
    name AS NombreUsuario,
    type_desc AS TipoUsuario,
    authentication_type_desc AS TipoAutenticacion,
    create_date AS FechaCreacion
FROM sys.database_principals 
WHERE name = 'UsuarioOLAP';

-- Mostrar roles asignados
SELECT 
    dp.name AS Usuario,
    r.name AS Rol
FROM sys.database_role_members drm
JOIN sys.database_principals dp ON drm.member_principal_id = dp.principal_id
JOIN sys.database_principals r ON drm.role_principal_id = r.principal_id
WHERE dp.name = 'UsuarioOLAP';

-- Mostrar permisos explicitos
SELECT 
    dp.name AS Usuario,
    o.name AS Objeto,
    perm.permission_name AS Permiso,
    perm.state_desc AS Estado
FROM sys.database_permissions perm
JOIN sys.database_principals dp ON perm.grantee_principal_id = dp.principal_id
LEFT JOIN sys.objects o ON perm.major_id = o.object_id
WHERE dp.name = 'UsuarioOLAP'
ORDER BY o.name, perm.permission_name;

PRINT '';
PRINT '============================================================================';
PRINT 'CONFIGURACION DE USUARIO OLAP COMPLETADA';
PRINT '============================================================================';
PRINT '';
PRINT '>> Datos de conexion para Power BI/Tableau:';
PRINT '   Servidor: [TU_SERVIDOR].database.windows.net';
PRINT '   Base de Datos: [TU_BASE_DE_DATOS]';
PRINT '   Usuario: UsuarioOLAP';
PRINT '   Contrasena: OL@P_R3ad0nly2025!';
PRINT '';
PRINT '>> IMPORTANTE: Cambiar la contrasena en produccion!';
PRINT '============================================================================';
GO

-- ============================================================================
-- OPCION 2: Script alternativo para SQL Server On-Premises
-- ============================================================================
-- Descomentar y usar si se trabaja con SQL Server local en lugar de Azure

/*
-- Crear login a nivel de servidor
USE [master]
GO
CREATE LOGIN [UsuarioOLAP] WITH PASSWORD = 'OL@P_R3ad0nly2025!',
    DEFAULT_DATABASE = [TuBaseDeDatos],
    CHECK_EXPIRATION = OFF,
    CHECK_POLICY = ON;
GO

-- Crear usuario en la base de datos
USE [TuBaseDeDatos]
GO
CREATE USER [UsuarioOLAP] FOR LOGIN [UsuarioOLAP];
GO

-- Luego ejecutar los mismos GRANT/DENY del script principal
*/
