-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: UsuarioOLAP_Oracle.sql
-- Descripcion: Creacion de usuario de solo lectura para OLAP (ORACLE)
-- Base de Datos: Oracle Database 21c
-- Fecha: Diciembre 2025
-- ============================================================================

SET SERVEROUTPUT ON;

-- ============================================================================
-- CREAR USUARIO OLAP (Ejecutar como SYSDBA o SYSTEM)
-- ============================================================================

DECLARE
    v_count NUMBER;
BEGIN
    -- Verificar si el usuario existe
    SELECT COUNT(*) INTO v_count FROM dba_users WHERE username = 'USUARIO_OLAP';
    
    IF v_count > 0 THEN
        -- Desconectar sesiones activas del usuario
        FOR rec IN (SELECT sid, serial# FROM v$session WHERE username = 'USUARIO_OLAP') LOOP
            EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION ''' || rec.sid || ',' || rec.serial# || ''' IMMEDIATE';
        END LOOP;
        
        -- Eliminar usuario existente
        EXECUTE IMMEDIATE 'DROP USER USUARIO_OLAP CASCADE';
        DBMS_OUTPUT.PUT_LINE('Usuario USUARIO_OLAP eliminado previamente.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Nota: ' || SQLERRM);
END;
/

-- Crear el usuario
CREATE USER USUARIO_OLAP IDENTIFIED BY "OLAPReadOnly2025";

-- Permisos basicos de conexion
GRANT CREATE SESSION TO USUARIO_OLAP;
GRANT CONNECT TO USUARIO_OLAP;

BEGIN
    DBMS_OUTPUT.PUT_LINE('Usuario USUARIO_OLAP creado exitosamente.');
END;
/

-- ============================================================================
-- PERMISOS DE SOLO LECTURA SOBRE TABLAS OLAP
-- ============================================================================

-- Permisos sobre dimensiones (reemplazar SCHEMA_OWNER por el esquema correcto)
-- Por defecto usamos el usuario actual que ejecuta el script

DECLARE
    v_schema VARCHAR2(30);
BEGIN
    SELECT USER INTO v_schema FROM DUAL;
    
    -- Permisos SELECT sobre dimensiones
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.DIMTIEMPO TO USUARIO_OLAP';
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.DIMUBICACION TO USUARIO_OLAP';
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.DIMCATEGORIA TO USUARIO_OLAP';
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.DIMPROVEEDOR TO USUARIO_OLAP';
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.DIMCLIENTE TO USUARIO_OLAP';
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.DIMEMPLEADO TO USUARIO_OLAP';
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.DIMMODALIDADPAGO TO USUARIO_OLAP';
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.DIMPRODUCTO TO USUARIO_OLAP';
    
    -- Permisos sobre tabla de hechos
    EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.FACTVENTAS TO USUARIO_OLAP';
    
    DBMS_OUTPUT.PUT_LINE('Permisos SELECT otorgados sobre tablas OLAP.');
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Nota: Algunas tablas OLAP aun no existen. Ejecutar despues de TablaDatosDim_Oracle.sql');
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- ============================================================================
-- CREAR SINONIMOS PUBLICOS (Opcional - para acceso sin prefijo de esquema)
-- ============================================================================

DECLARE
    v_schema VARCHAR2(30);
BEGIN
    SELECT USER INTO v_schema FROM DUAL;
    
    -- Crear sinonimos para que USUARIO_OLAP acceda sin prefijo
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM DIMTIEMPO FOR ' || v_schema || '.DIMTIEMPO'; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM DIMUBICACION FOR ' || v_schema || '.DIMUBICACION'; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM DIMCATEGORIA FOR ' || v_schema || '.DIMCATEGORIA'; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM DIMPROVEEDOR FOR ' || v_schema || '.DIMPROVEEDOR'; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM DIMCLIENTE FOR ' || v_schema || '.DIMCLIENTE'; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM DIMEMPLEADO FOR ' || v_schema || '.DIMEMPLEADO'; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM DIMMODALIDADPAGO FOR ' || v_schema || '.DIMMODALIDADPAGO'; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM DIMPRODUCTO FOR ' || v_schema || '.DIMPRODUCTO'; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE PUBLIC SYNONYM FACTVENTAS FOR ' || v_schema || '.FACTVENTAS'; EXCEPTION WHEN OTHERS THEN NULL; END;
    
    DBMS_OUTPUT.PUT_LINE('Sinonimos publicos creados (si aplica).');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Nota: No se pudieron crear sinonimos publicos. ' || SQLERRM);
END;
/

-- ============================================================================
-- VERIFICACION
-- ============================================================================

SELECT '============================================================================' AS INFO FROM DUAL;
SELECT 'VERIFICACION DE USUARIO Y PERMISOS' AS INFO FROM DUAL;
SELECT '============================================================================' AS INFO FROM DUAL;

-- Mostrar informacion del usuario
SELECT 
    USERNAME AS NOMBRE_USUARIO,
    ACCOUNT_STATUS AS ESTADO,
    CREATED AS FECHA_CREACION
FROM DBA_USERS 
WHERE USERNAME = 'USUARIO_OLAP';

-- Mostrar permisos otorgados
SELECT 
    GRANTEE AS USUARIO,
    TABLE_NAME AS OBJETO,
    PRIVILEGE AS PERMISO
FROM DBA_TAB_PRIVS 
WHERE GRANTEE = 'USUARIO_OLAP'
ORDER BY TABLE_NAME;

SELECT '============================================================================' AS INFO FROM DUAL;
SELECT 'CONFIGURACION DE USUARIO OLAP COMPLETADA' AS INFO FROM DUAL;
SELECT '============================================================================' AS INFO FROM DUAL;
SELECT 'Datos de conexion para Power BI:' AS INFO FROM DUAL;
SELECT '  Usuario: USUARIO_OLAP' AS INFO FROM DUAL;
SELECT '  Password: OLAPReadOnly2025' AS INFO FROM DUAL;
SELECT '  IMPORTANTE: Cambiar password en produccion!' AS INFO FROM DUAL;
SELECT '============================================================================' AS INFO FROM DUAL;

COMMIT;
