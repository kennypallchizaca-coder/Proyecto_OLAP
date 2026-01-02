-- ========================================================================
-- SCRIPT: Validacion Post-Recuperacion
-- ========================================================================
-- Ejecutar despues de cualquier recuperacion para verificar integridad
-- ========================================================================

SET SERVEROUTPUT ON
SET LINESIZE 200

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

SELECT 'CATEGORIA' AS Tabla, COUNT(*) AS Registros FROM CATEGORIA
UNION ALL
SELECT 'PROVEEDOR', COUNT(*) FROM PROVEEDOR
UNION ALL
SELECT 'EMPLEADO', COUNT(*) FROM EMPLEADO
UNION ALL
SELECT 'CLIENTE', COUNT(*) FROM CLIENTE
UNION ALL
SELECT 'MODALIDAD_PAGO', COUNT(*) FROM MODALIDAD_PAGO
UNION ALL
SELECT 'PRODUCTO', COUNT(*) FROM PRODUCTO
UNION ALL
SELECT 'PEDIDO', COUNT(*) FROM PEDIDO
UNION ALL
SELECT 'DETALLE_PEDIDO', COUNT(*) FROM DETALLE_PEDIDO;

PROMPT ========================================
PROMPT CONTEO DE REGISTROS - TABLAS OLAP
PROMPT ========================================

SELECT 'DIMTIEMPO' AS Dimension, COUNT(*) AS Registros FROM DIMTIEMPO
UNION ALL
SELECT 'DIMPRODUCTO', COUNT(*) FROM DIMPRODUCTO
UNION ALL
SELECT 'DIMCATEGORIA', COUNT(*) FROM DIMCATEGORIA
UNION ALL
SELECT 'DIMPROVEEDOR', COUNT(*) FROM DIMPROVEEDOR
UNION ALL
SELECT 'DIMCLIENTE', COUNT(*) FROM DIMCLIENTE
UNION ALL
SELECT 'DIMEMPLEADO', COUNT(*) FROM DIMEMPLEADO
UNION ALL
SELECT 'DIMMODALIDADPAGO', COUNT(*) FROM DIMMODALIDADPAGO
UNION ALL
SELECT 'DIMUBICACION', COUNT(*) FROM DIMUBICACION
UNION ALL
SELECT 'FACTVENTAS', COUNT(*) FROM FACTVENTAS;

-- 4. Verificar ultima transaccion recuperada
SELECT 
    'Ultimo pedido recuperado: ' || MAX(NUMEROPEDIDO) AS "Status",
    MAX(FECHACREACION) AS "Fecha/Hora"
FROM PEDIDO;

-- 5. Validar integridad referencial
PROMPT ========================================
PROMPT VALIDANDO INTEGRIDAD REFERENCIAL
PROMPT ========================================

DECLARE
    v_count NUMBER;
BEGIN
    -- Verificar que no haya pedidos huerfanos
    SELECT COUNT(*) INTO v_count
    FROM PEDIDO p
    WHERE NOT EXISTS (SELECT 1 FROM CLIENTE c WHERE c.CLIENTEID = p.CLIENTEID);
    
    IF v_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('[ERROR] Encontrados ' || v_count || ' pedidos sin cliente.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('[OK] Integridad CLIENTE-PEDIDO correcta.');
    END IF;
    
    -- Verificar detalles sin pedidos
    SELECT COUNT(*) INTO v_count
    FROM DETALLE_PEDIDO d
    WHERE NOT EXISTS (SELECT 1 FROM PEDIDO p WHERE p.PEDIDOID = d.PEDIDOID);
    
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
    DBMS_UTILITY.COMPILE_SCHEMA(USER);
END;
/

PROMPT ========================================
PROMPT VALIDACION COMPLETADA
PROMPT Revisar el archivo post_recovery_validation.log
PROMPT ========================================

SPOOL OFF
EXIT;
