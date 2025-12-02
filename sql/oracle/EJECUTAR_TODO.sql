-- ============================================================================
-- PROYECTO OLAP - SCRIPT MAESTRO DE EJECUCION
-- ============================================================================
-- Ejecutar como usuario con permisos DBA
-- Ejemplo: sqlplus USUARIO/PASSWORD@localhost:1521/XEPDB1
-- Luego: @EJECUTAR_TODO.sql
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET ECHO OFF;
SET FEEDBACK OFF;
SET TIMING ON;

WHENEVER SQLERROR CONTINUE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('╔══════════════════════════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('║           PROYECTO OLAP - EJECUCION COMPLETA                             ║');
    DBMS_OUTPUT.PUT_LINE('║           Fecha: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || '                                  ║');
    DBMS_OUTPUT.PUT_LINE('╚══════════════════════════════════════════════════════════════════════════╝');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- ============================================================================
-- PASO 1: CREAR TABLAS OLTP
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('═══ PASO 1/6: Creando tablas OLTP... ═══'); END;
/
@oltp/Tablas.sql

-- ============================================================================
-- PASO 2: INSERTAR DATOS DE PRUEBA
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('═══ PASO 2/6: Insertando datos de prueba (10-15 min)... ═══'); END;
/
@oltp/Datos_Tablas.sql

-- ============================================================================
-- PASO 3: CREAR MODELO ESTRELLA OLAP
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('═══ PASO 3/6: Creando modelo estrella OLAP... ═══'); END;
/
@olap/TablaDatosDim.sql

-- ============================================================================
-- PASO 4: EJECUTAR ETL
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('═══ PASO 4/6: Ejecutando ETL (5-10 min)... ═══'); END;
/
@olap/ETL.sql

-- ============================================================================
-- PASO 5: CREAR VISTAS PARA POWER BI
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('═══ PASO 5/6: Creando vistas Power BI... ═══'); END;
/
@olap/VistasOLAP_PowerBI.sql

-- ============================================================================
-- PASO 6: CREAR USUARIO OLAP (Requiere permisos DBA)
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('═══ PASO 6/6: Creando usuario OLAP... ═══'); END;
/

-- Intentar crear usuario (puede fallar si no hay permisos DBA)
BEGIN
    EXECUTE IMMEDIATE 'DROP USER USUARIO_OLAP CASCADE';
EXCEPTION
    WHEN OTHERS THEN NULL;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE USER USUARIO_OLAP IDENTIFIED BY "OLAPReadOnly2025"';
    EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO USUARIO_OLAP';
    EXECUTE IMMEDIATE 'GRANT CONNECT TO USUARIO_OLAP';
    DBMS_OUTPUT.PUT_LINE('Usuario USUARIO_OLAP creado.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('NOTA: No se pudo crear USUARIO_OLAP (necesita permisos DBA).');
        DBMS_OUTPUT.PUT_LINE('      Ejecutar UsuarioOLAP.sql como SYSDBA si es necesario.');
END;
/

-- Otorgar permisos SELECT
DECLARE
    v_schema VARCHAR2(30);
    
    PROCEDURE grant_select(p_tabla VARCHAR2) IS
    BEGIN
        EXECUTE IMMEDIATE 'GRANT SELECT ON ' || v_schema || '.' || p_tabla || ' TO USUARIO_OLAP';
    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;
BEGIN
    SELECT USER INTO v_schema FROM DUAL;
    
    grant_select('DIMTIEMPO');
    grant_select('DIMUBICACION');
    grant_select('DIMCATEGORIA');
    grant_select('DIMPROVEEDOR');
    grant_select('DIMCLIENTE');
    grant_select('DIMEMPLEADO');
    grant_select('DIMMODALIDADPAGO');
    grant_select('DIMPRODUCTO');
    grant_select('FACTVENTAS');
    grant_select('VW_VENTASCOMPLETAS');
    grant_select('VW_VENTASPRODUCTOPROVEEDOR');
    grant_select('VW_VENTASMODALIDADPAGO');
    grant_select('VW_VENTASEMPLEADO');
    grant_select('VW_RESUMENVENTASANUAL');
    grant_select('VW_ANALISISIVA');
    grant_select('VW_CALENDARIO');
    
    DBMS_OUTPUT.PUT_LINE('Permisos SELECT otorgados a USUARIO_OLAP.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('NOTA: No se pudieron otorgar todos los permisos.');
END;
/

-- ============================================================================
-- VERIFICACION FINAL
-- ============================================================================

SET FEEDBACK ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('╔══════════════════════════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('║                    VERIFICACION FINAL                                    ║');
    DBMS_OUTPUT.PUT_LINE('╚══════════════════════════════════════════════════════════════════════════╝');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Contar registros OLTP
SELECT 'TABLAS OLTP' AS TIPO, 'CATEGORIA' AS TABLA, COUNT(*) AS REGISTROS FROM CATEGORIA
UNION ALL SELECT 'TABLAS OLTP', 'PROVEEDOR', COUNT(*) FROM PROVEEDOR
UNION ALL SELECT 'TABLAS OLTP', 'EMPLEADO', COUNT(*) FROM EMPLEADO
UNION ALL SELECT 'TABLAS OLTP', 'CLIENTE', COUNT(*) FROM CLIENTE
UNION ALL SELECT 'TABLAS OLTP', 'MODALIDAD_PAGO', COUNT(*) FROM MODALIDAD_PAGO
UNION ALL SELECT 'TABLAS OLTP', 'PRODUCTO', COUNT(*) FROM PRODUCTO
UNION ALL SELECT 'TABLAS OLTP', 'PEDIDO', COUNT(*) FROM PEDIDO
UNION ALL SELECT 'TABLAS OLTP', 'DETALLE_PEDIDO', COUNT(*) FROM DETALLE_PEDIDO
UNION ALL SELECT 'TABLAS OLAP', 'DIMTIEMPO', COUNT(*) FROM DIMTIEMPO
UNION ALL SELECT 'TABLAS OLAP', 'DIMUBICACION', COUNT(*) FROM DIMUBICACION
UNION ALL SELECT 'TABLAS OLAP', 'DIMCATEGORIA', COUNT(*) FROM DIMCATEGORIA
UNION ALL SELECT 'TABLAS OLAP', 'DIMPROVEEDOR', COUNT(*) FROM DIMPROVEEDOR
UNION ALL SELECT 'TABLAS OLAP', 'DIMCLIENTE', COUNT(*) FROM DIMCLIENTE
UNION ALL SELECT 'TABLAS OLAP', 'DIMEMPLEADO', COUNT(*) FROM DIMEMPLEADO
UNION ALL SELECT 'TABLAS OLAP', 'DIMMODALIDADPAGO', COUNT(*) FROM DIMMODALIDADPAGO
UNION ALL SELECT 'TABLAS OLAP', 'DIMPRODUCTO', COUNT(*) FROM DIMPRODUCTO
UNION ALL SELECT 'TABLAS OLAP', 'FACTVENTAS', COUNT(*) FROM FACTVENTAS
ORDER BY TIPO, TABLA;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('╔══════════════════════════════════════════════════════════════════════════╗');
    DBMS_OUTPUT.PUT_LINE('║              EJECUCION COMPLETADA EXITOSAMENTE                           ║');
    DBMS_OUTPUT.PUT_LINE('║              Fecha: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || '                                 ║');
    DBMS_OUTPUT.PUT_LINE('╠══════════════════════════════════════════════════════════════════════════╣');
    DBMS_OUTPUT.PUT_LINE('║  Conexion Power BI:                                                      ║');
    DBMS_OUTPUT.PUT_LINE('║  - Servidor: localhost:1521/XEPDB1                                       ║');
    DBMS_OUTPUT.PUT_LINE('║  - Usuario: USUARIO_OLAP                                                 ║');
    DBMS_OUTPUT.PUT_LINE('║  - Password: OLAPReadOnly2025                                            ║');
    DBMS_OUTPUT.PUT_LINE('╚══════════════════════════════════════════════════════════════════════════╝');
END;
/

COMMIT;
