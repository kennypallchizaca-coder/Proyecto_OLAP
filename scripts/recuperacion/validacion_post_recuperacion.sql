-- ========================================================================
-- SCRIPT: Validacion Post-Recuperacion
-- ========================================================================
-- Ejecutar despues de cualquier recuperacion para verificar integridad
-- ========================================================================

SET SERVEROUTPUT ON

SET LINESIZE 200
ALTER SESSION SET CONTAINER = XEPDB1;

SPOOL post_recovery_validation.log

PROMPT ========================================
PROMPT VALIDACION POST-RECUPERACION
PROMPT ========================================

-- 1. Verificar estado de la base de datos
SELECT 
    name AS "Base de Datos",
    open_mode AS "Modo",
    database_role AS "Rol"
FROM v$database;

-- 2. Verificar tablespaces
SELECT 
    tablespace_name,
    status,
    ROUND(SUM(bytes)/1024/1024, 2) AS "Size MB"
FROM dba_data_files
GROUP BY tablespace_name, status
ORDER BY tablespace_name;

-- 3. Contar registros en tablas criticas
PROMPT ========================================
PROMPT CONTEO DE REGISTROS - TABLAS OLTP
PROMPT ========================================

SELECT 'CATEGORIA' AS Tabla, COUNT(*) AS Registros FROM ALEXIS3.CATEGORIA
UNION ALL
SELECT 'PROVEEDOR', COUNT(*) FROM ALEXIS3.PROVEEDOR
UNION ALL
SELECT 'EMPLEADO', COUNT(*) FROM ALEXIS3.EMPLEADO
UNION ALL
SELECT 'CLIENTE', COUNT(*) FROM ALEXIS3.CLIENTE
UNION ALL
SELECT 'MODALIDAD_PAGO', COUNT(*) FROM ALEXIS3.MODALIDAD_PAGO
UNION ALL
SELECT 'PRODUCTO', COUNT(*) FROM ALEXIS3.PRODUCTO
UNION ALL
SELECT 'PEDIDO', COUNT(*) FROM ALEXIS3.PEDIDO
UNION ALL
SELECT 'DETALLE_PEDIDO', COUNT(*) FROM ALEXIS3.DETALLE_PEDIDO;

PROMPT ========================================
PROMPT CONTEO DE REGISTROS - TABLAS OLAP
PROMPT ========================================

SELECT 'DIMTIEMPO' AS Dimension, COUNT(*) AS Registros FROM ALEXIS3.DIMTIEMPO
UNION ALL
SELECT 'DIMPRODUCTO', COUNT(*) FROM ALEXIS3.DIMPRODUCTO
UNION ALL
SELECT 'DIMCATEGORIA', COUNT(*) FROM ALEXIS3.DIMCATEGORIA
UNION ALL
SELECT 'DIMPROVEEDOR', COUNT(*) FROM ALEXIS3.DIMPROVEEDOR
UNION ALL
SELECT 'DIMCLIENTE', COUNT(*) FROM ALEXIS3.DIMCLIENTE
UNION ALL
SELECT 'DIMEMPLEADO', COUNT(*) FROM ALEXIS3.DIMEMPLEADO
UNION ALL
SELECT 'DIMMODALIDADPAGO', COUNT(*) FROM ALEXIS3.DIMMODALIDADPAGO
UNION ALL
SELECT 'DIMUBICACION', COUNT(*) FROM ALEXIS3.DIMUBICACION
UNION ALL
SELECT 'FACTVENTAS', COUNT(*) FROM ALEXIS3.FACTVENTAS;

-- 4. Verificar ultima transaccion recuperada
SELECT 
    'Ultimo pedido recuperado: ' || MAX(NUMEROPEDIDO) AS "Status",
    MAX(FECHACREACION) AS "Fecha/Hora"
FROM ALEXIS3.PEDIDO;

-- 5. Validar integridad referencial
PROMPT ========================================
PROMPT VALIDANDO INTEGRIDAD REFERENCIAL
PROMPT ========================================

DECLARE
    v_count NUMBER;
BEGIN
    -- Verificar que no haya pedidos huerfanos
    SELECT COUNT(*) INTO v_count
    FROM ALEXIS3.PEDIDO p
    WHERE NOT EXISTS (SELECT 1 FROM ALEXIS3.CLIENTE c WHERE c.CLIENTEID = p.CLIENTEID);
    
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] Encontrados ' || v_count || ' pedidos sin cliente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[OK] Integridad CLIENTE-PEDIDO correcta.');
    END IF;
    
    -- Verificar detalles sin pedidos
    SELECT COUNT(*) INTO v_count
    FROM ALEXIS3.DETALLE_PEDIDO d
    WHERE NOT EXISTS (SELECT 1 FROM ALEXIS3.PEDIDO p WHERE p.PEDIDOID = d.PEDIDOID);
    
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] Encontrados ' || v_count || ' detalles sin pedido.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[OK] Integridad PEDIDO-DETALLE correcta.');
    END IF;
END;
/

-- 6. Verificar objetos invalidos
SELECT 
    object_type,
    object_name,
    status
FROM dba_objects
WHERE status = 'INVALID'
AND owner = USER;

-- Si hay objetos invalidos, recompilarlos
BEGIN
    DBMS_UTILITY.COMPILE_SCHEMA('ALEXIS3');
END;
/

PROMPT ========================================
PROMPT VALIDACION COMPLETADA
PROMPT Revisar el archivo post_recovery_validation.log
PROMPT ========================================

SPOOL OFF
EXIT;
