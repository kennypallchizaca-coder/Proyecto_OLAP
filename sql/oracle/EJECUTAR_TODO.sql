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
SET LINESIZE 200;
SET PAGESIZE 100;

WHENEVER SQLERROR CONTINUE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================================');
    DBMS_OUTPUT.PUT_LINE('           PROYECTO OLAP - EJECUCION COMPLETA                          ');
    DBMS_OUTPUT.PUT_LINE('           Fecha: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || '                                  ');
    DBMS_OUTPUT.PUT_LINE('========================================================================');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- ============================================================================
-- PASO 1: CREAR TABLAS OLTP
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('=== PASO 1/5: Creando tablas OLTP... ==='); END;
/
@oltp/Tablas.sql

-- ============================================================================
-- PASO 2: INSERTAR DATOS DE PRUEBA
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('=== PASO 2/5: Insertando datos de prueba (10-15 min)... ==='); END;
/
@oltp/Datos_Tablas.sql

-- ============================================================================
-- PASO 3: CREAR MODELO ESTRELLA OLAP
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('=== PASO 3/5: Creando modelo estrella OLAP... ==='); END;
/
@olap/TablaDatosDim.sql

-- ============================================================================
-- PASO 4: EJECUTAR ETL
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('=== PASO 4/5: Ejecutando ETL (5-10 min)... ==='); END;
/
@olap/ETL.sql

-- ============================================================================
-- PASO 5: CREAR VISTAS PARA POWER BI
-- ============================================================================
BEGIN DBMS_OUTPUT.PUT_LINE(''); DBMS_OUTPUT.PUT_LINE('=== PASO 5/5: Creando vistas Power BI... ==='); END;
/
@olap/VistasOLAP_PowerBI.sql

-- ============================================================================
-- VERIFICACION FINAL
-- ============================================================================

SET FEEDBACK ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================================');
    DBMS_OUTPUT.PUT_LINE('                    VERIFICACION FINAL                                 ');
    DBMS_OUTPUT.PUT_LINE('========================================================================');
    DBMS_OUTPUT.PUT_LINE('');
END;
/

-- Contar registros OLTP
SELECT 'CATEGORIA' AS TABLA, COUNT(*) AS REGISTROS FROM CATEGORIA
UNION ALL SELECT 'PROVEEDOR', COUNT(*) FROM PROVEEDOR
UNION ALL SELECT 'EMPLEADO', COUNT(*) FROM EMPLEADO
UNION ALL SELECT 'CLIENTE', COUNT(*) FROM CLIENTE
UNION ALL SELECT 'MODALIDAD_PAGO', COUNT(*) FROM MODALIDAD_PAGO
UNION ALL SELECT 'PRODUCTO', COUNT(*) FROM PRODUCTO
UNION ALL SELECT 'PEDIDO', COUNT(*) FROM PEDIDO
UNION ALL SELECT 'DETALLE_PEDIDO', COUNT(*) FROM DETALLE_PEDIDO;

-- Contar registros OLAP
SELECT 'DIMTIEMPO' AS TABLA, COUNT(*) AS REGISTROS FROM DIMTIEMPO
UNION ALL SELECT 'DIMUBICACION', COUNT(*) FROM DIMUBICACION
UNION ALL SELECT 'DIMCATEGORIA', COUNT(*) FROM DIMCATEGORIA
UNION ALL SELECT 'DIMPROVEEDOR', COUNT(*) FROM DIMPROVEEDOR
UNION ALL SELECT 'DIMCLIENTE', COUNT(*) FROM DIMCLIENTE
UNION ALL SELECT 'DIMEMPLEADO', COUNT(*) FROM DIMEMPLEADO
UNION ALL SELECT 'DIMMODALIDADPAGO', COUNT(*) FROM DIMMODALIDADPAGO
UNION ALL SELECT 'DIMPRODUCTO', COUNT(*) FROM DIMPRODUCTO
UNION ALL SELECT 'FACTVENTAS', COUNT(*) FROM FACTVENTAS;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================================================');
    DBMS_OUTPUT.PUT_LINE('              EJECUCION COMPLETADA EXITOSAMENTE                        ');
    DBMS_OUTPUT.PUT_LINE('              Fecha: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS') || '                                ');
    DBMS_OUTPUT.PUT_LINE('========================================================================');
END;
/

COMMIT;
