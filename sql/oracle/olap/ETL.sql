-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: ETL.sql
-- Descripcion: Proceso ETL (Extraccion, Transformacion y Carga) - ORACLE
-- Base de Datos: Oracle Database 21c
-- Fecha: Diciembre 2025
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 200;
SET PAGESIZE 100;

BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE('INICIANDO PROCESO ETL - ORACLE');
    DBMS_OUTPUT.PUT_LINE('Fecha y Hora: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('============================================================================');
END;
/

-- ============================================================================
-- FASE 1: CARGAR DimTiempo (Calendario 2020-2025)
-- ============================================================================

BEGIN DBMS_OUTPUT.PUT_LINE('[FASE 1/6] Cargando DimTiempo (2020-2025)...'); END;
/

DELETE FROM DIMTIEMPO;
COMMIT;

DECLARE
    v_fecha_inicio DATE := TO_DATE('2020-01-01', 'YYYY-MM-DD');
    v_fecha_fin DATE := TO_DATE('2025-12-31', 'YYYY-MM-DD');
    v_fecha DATE;
    v_tiempo_key NUMBER;
    v_anio NUMBER;
    v_mes NUMBER;
    v_dia_semana NUMBER;
    v_nombre_mes VARCHAR2(20);
    v_nombre_mes_corto VARCHAR2(5);
    v_nombre_dia VARCHAR2(20);
    v_nombre_dia_corto VARCHAR2(5);
    v_contador NUMBER := 0;
BEGIN
    v_fecha := v_fecha_inicio;
    
    WHILE v_fecha <= v_fecha_fin LOOP
        v_tiempo_key := TO_NUMBER(TO_CHAR(v_fecha, 'YYYYMMDD'));
        v_anio := EXTRACT(YEAR FROM v_fecha);
        v_mes := EXTRACT(MONTH FROM v_fecha);
        v_dia_semana := TO_NUMBER(TO_CHAR(v_fecha, 'D')); -- 1=Dom, 7=Sab
        
        -- Nombre del mes
        v_nombre_mes := CASE v_mes
            WHEN 1 THEN 'Enero' WHEN 2 THEN 'Febrero' WHEN 3 THEN 'Marzo'
            WHEN 4 THEN 'Abril' WHEN 5 THEN 'Mayo' WHEN 6 THEN 'Junio'
            WHEN 7 THEN 'Julio' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Septiembre'
            WHEN 10 THEN 'Octubre' WHEN 11 THEN 'Noviembre' WHEN 12 THEN 'Diciembre'
        END;
        
        v_nombre_mes_corto := CASE v_mes
            WHEN 1 THEN 'Ene' WHEN 2 THEN 'Feb' WHEN 3 THEN 'Mar'
            WHEN 4 THEN 'Abr' WHEN 5 THEN 'May' WHEN 6 THEN 'Jun'
            WHEN 7 THEN 'Jul' WHEN 8 THEN 'Ago' WHEN 9 THEN 'Sep'
            WHEN 10 THEN 'Oct' WHEN 11 THEN 'Nov' WHEN 12 THEN 'Dic'
        END;
        
        v_nombre_dia := CASE v_dia_semana
            WHEN 1 THEN 'Domingo' WHEN 2 THEN 'Lunes' WHEN 3 THEN 'Martes'
            WHEN 4 THEN 'Miercoles' WHEN 5 THEN 'Jueves' WHEN 6 THEN 'Viernes'
            WHEN 7 THEN 'Sabado'
        END;
        
        v_nombre_dia_corto := CASE v_dia_semana
            WHEN 1 THEN 'Dom' WHEN 2 THEN 'Lun' WHEN 3 THEN 'Mar'
            WHEN 4 THEN 'Mie' WHEN 5 THEN 'Jue' WHEN 6 THEN 'Vie'
            WHEN 7 THEN 'Sab'
        END;
        
        INSERT INTO DIMTIEMPO (
            TIEMPOKEY, FECHA, ANIO, SEMESTRE, TRIMESTRE, MES, SEMANA,
            DIADELMES, DIASEMANA, DIADELANIO,
            NOMBREANIO, NOMBRESEMESTRE, NOMBRETRIMESTRE, NOMBREMES, NOMBREMESCORTO,
            NOMBREDIA, NOMBREDIACORTO, ESFINDESEMANA, ESDIALABORAL, ANIOMES, ANIOTRIMESTRE
        ) VALUES (
            v_tiempo_key,
            v_fecha,
            v_anio,
            CASE WHEN v_mes <= 6 THEN 1 ELSE 2 END,
            CEIL(v_mes / 3),
            v_mes,
            TO_NUMBER(TO_CHAR(v_fecha, 'IW')),
            EXTRACT(DAY FROM v_fecha),
            v_dia_semana,
            TO_NUMBER(TO_CHAR(v_fecha, 'DDD')),
            TO_CHAR(v_anio),
            CASE WHEN v_mes <= 6 THEN 'Semestre 1' ELSE 'Semestre 2' END,
            'Q' || CEIL(v_mes / 3),
            v_nombre_mes,
            v_nombre_mes_corto,
            v_nombre_dia,
            v_nombre_dia_corto,
            CASE WHEN v_dia_semana IN (1, 7) THEN 1 ELSE 0 END,
            CASE WHEN v_dia_semana IN (2,3,4,5,6) THEN 1 ELSE 0 END,
            TO_CHAR(v_fecha, 'YYYY-MM'),
            v_anio || '-Q' || CEIL(v_mes / 3)
        );
        
        v_fecha := v_fecha + 1;
        v_contador := v_contador + 1;
        
        -- Commit cada 500 registros
        IF MOD(v_contador, 500) = 0 THEN
            COMMIT;
        END IF;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('   ' || v_contador || ' fechas generadas.');
END;
/

-- ============================================================================
-- FASE 2: CARGAR DimUbicacion
-- ============================================================================

BEGIN DBMS_OUTPUT.PUT_LINE('[FASE 2/6] Cargando DimUbicacion...'); END;
/

DELETE FROM DIMUBICACION;
COMMIT;

INSERT INTO DIMUBICACION (PAIS, CIUDAD, REGION)
SELECT DISTINCT 
    PAIS, 
    CIUDAD,
    CASE CIUDAD
        WHEN 'Quito' THEN 'Sierra'
        WHEN 'Cuenca' THEN 'Sierra'
        WHEN 'Loja' THEN 'Sierra'
        WHEN 'Guayaquil' THEN 'Costa'
        WHEN 'Manta' THEN 'Costa'
        ELSE 'Otras'
    END AS REGION
FROM (
    SELECT PAIS, CIUDAD FROM CLIENTE
    UNION
    SELECT PAIS, CIUDAD FROM PROVEEDOR
);
COMMIT;

DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM DIMUBICACION;
    DBMS_OUTPUT.PUT_LINE('   ' || v_count || ' ubicaciones cargadas.');
END;
/

-- ============================================================================
-- FASE 3: CARGAR DIMENSIONES MAESTRAS
-- ============================================================================

BEGIN DBMS_OUTPUT.PUT_LINE('[FASE 3/6] Cargando dimensiones maestras...'); END;
/

-- DimCategoria
DELETE FROM DIMCATEGORIA;
INSERT INTO DIMCATEGORIA (CATEGORIAID_OLTP, CODIGO, NOMBRE, DESCRIPCION)
SELECT CATEGORIAID, CODIGO, NOMBRE, DESCRIPCION FROM CATEGORIA;
COMMIT;

DECLARE v_count NUMBER;
BEGIN SELECT COUNT(*) INTO v_count FROM DIMCATEGORIA; DBMS_OUTPUT.PUT_LINE('   DimCategoria: ' || v_count || ' registros.'); END;
/

-- DimProveedor
DELETE FROM DIMPROVEEDOR;
INSERT INTO DIMPROVEEDOR (PROVEEDORID_OLTP, CODIGO, NOMBRE, NOMBRECONTACTO, CIUDAD, PAIS, UBICACIONKEY)
SELECT 
    p.PROVEEDORID, p.CODIGO, p.NOMBRE, p.NOMBRECONTACTO, p.CIUDAD, p.PAIS,
    u.UBICACIONKEY
FROM PROVEEDOR p
LEFT JOIN DIMUBICACION u ON p.CIUDAD = u.CIUDAD AND p.PAIS = u.PAIS;
COMMIT;

DECLARE v_count NUMBER;
BEGIN SELECT COUNT(*) INTO v_count FROM DIMPROVEEDOR; DBMS_OUTPUT.PUT_LINE('   DimProveedor: ' || v_count || ' registros.'); END;
/

-- DimCliente
DELETE FROM DIMCLIENTE;
INSERT INTO DIMCLIENTE (CLIENTEID_OLTP, CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, EMAIL, CIUDAD, PAIS, UBICACIONKEY)
SELECT 
    c.CLIENTEID, c.CODIGO, c.NOMBRECOMPLETO, c.TIPODOCUMENTO, c.EMAIL, c.CIUDAD, c.PAIS,
    u.UBICACIONKEY
FROM CLIENTE c
LEFT JOIN DIMUBICACION u ON c.CIUDAD = u.CIUDAD AND c.PAIS = u.PAIS;
COMMIT;

DECLARE v_count NUMBER;
BEGIN SELECT COUNT(*) INTO v_count FROM DIMCLIENTE; DBMS_OUTPUT.PUT_LINE('   DimCliente: ' || v_count || ' registros.'); END;
/

-- DimEmpleado
DELETE FROM DIMEMPLEADO;
INSERT INTO DIMEMPLEADO (EMPLEADOID_OLTP, CODIGO, NOMBRECOMPLETO, CARGO)
SELECT EMPLEADOID, CODIGO, NOMBRECOMPLETO, CARGO FROM EMPLEADO;
COMMIT;

DECLARE v_count NUMBER;
BEGIN SELECT COUNT(*) INTO v_count FROM DIMEMPLEADO; DBMS_OUTPUT.PUT_LINE('   DimEmpleado: ' || v_count || ' registros.'); END;
/

-- DimModalidadPago
DELETE FROM DIMMODALIDADPAGO;
INSERT INTO DIMMODALIDADPAGO (MODALIDADID_OLTP, CODIGO, DESCRIPCION, TIPOPAGO, CUOTAS, TASAINTERES, ESTARJETA, DESCRIPCIONCOMPLETA)
SELECT 
    MODALIDADPAGOID, 
    CODIGO, 
    DESCRIPCION, 
    TIPOPAGO, 
    CUOTAS, 
    TASAINTERES,
    CASE WHEN TIPOPAGO IN ('TARJETA_CREDITO', 'TARJETA_DEBITO') THEN 1 ELSE 0 END,
    CASE 
        WHEN CUOTAS > 1 THEN DESCRIPCION || ' (' || CUOTAS || ' cuotas)'
        ELSE DESCRIPCION
    END
FROM MODALIDAD_PAGO;
COMMIT;

DECLARE v_count NUMBER;
BEGIN SELECT COUNT(*) INTO v_count FROM DIMMODALIDADPAGO; DBMS_OUTPUT.PUT_LINE('   DimModalidadPago: ' || v_count || ' registros.'); END;
/

-- ============================================================================
-- FASE 4: CARGAR DimProducto (Desnormalizada)
-- ============================================================================

BEGIN DBMS_OUTPUT.PUT_LINE('[FASE 4/6] Cargando DimProducto (desnormalizada)...'); END;
/

DELETE FROM DIMPRODUCTO;

INSERT INTO DIMPRODUCTO (
    PRODUCTOID_OLTP, CODIGO, NOMBRE, 
    CATEGORIAKEY, NOMBRECATEGORIA,
    PROVEEDORKEY, NOMBREPROVEEDOR,
    PRECIOUNITARIO, PORCENTAJEIVA, TIENEIVA, TIPOIVA
)
SELECT 
    p.PRODUCTOID,
    p.CODIGO,
    p.NOMBRE,
    dc.CATEGORIAKEY,
    dc.NOMBRE,
    dprov.PROVEEDORKEY,
    dprov.NOMBRE,
    p.PRECIOUNITARIO,
    p.PORCENTAJEIVA,
    CASE WHEN p.PORCENTAJEIVA > 0 THEN 1 ELSE 0 END,
    CASE WHEN p.PORCENTAJEIVA = 15 THEN 'IVA 15%' ELSE 'IVA 0%' END
FROM PRODUCTO p
JOIN DIMCATEGORIA dc ON p.CATEGORIAID = dc.CATEGORIAID_OLTP
JOIN DIMPROVEEDOR dprov ON p.PROVEEDORID = dprov.PROVEEDORID_OLTP;
COMMIT;

DECLARE v_count NUMBER;
BEGIN SELECT COUNT(*) INTO v_count FROM DIMPRODUCTO; DBMS_OUTPUT.PUT_LINE('   DimProducto: ' || v_count || ' registros.'); END;
/

-- ============================================================================
-- FASE 5: CARGAR FactVentas
-- ============================================================================

BEGIN 
    DBMS_OUTPUT.PUT_LINE('[FASE 5/6] Cargando FactVentas...');
    DBMS_OUTPUT.PUT_LINE('   Este proceso puede tardar varios minutos...');
END;
/

-- Limpiar tabla de hechos
DELETE FROM FACTVENTAS;
COMMIT;

-- Insertar hechos de ventas
INSERT INTO FACTVENTAS (
    TIEMPOKEY,
    PRODUCTOKEY,
    CATEGORIAKEY,
    CLIENTEKEY,
    PROVEEDORKEY,
    EMPLEADOKEY,
    MODALIDADKEY,
    UBICACIONCLIENTEKEY,
    UBICACIONPROVEEDORKEY,
    PEDIDOID_OLTP,
    DETALLEID_OLTP,
    CANTIDAD,
    PRECIOUNITARIO,
    PORCENTAJEIVA,
    MONTOSUBTOTAL,
    MONTOIVA,
    MONTOTOTAL
)
SELECT 
    dt.TIEMPOKEY,
    dprod.PRODUCTOKEY,
    dprod.CATEGORIAKEY,
    dcli.CLIENTEKEY,
    dprod.PROVEEDORKEY,
    demp.EMPLEADOKEY,
    dmod.MODALIDADKEY,
    dcli.UBICACIONKEY,
    dprov.UBICACIONKEY,
    ped.PEDIDOID,
    det.DETALLEID,
    det.CANTIDAD,
    det.PRECIOUNITARIO,
    det.PORCENTAJEIVA,
    det.SUBTOTAL,
    det.MONTOIVA,
    det.TOTAL
FROM DETALLE_PEDIDO det
JOIN PEDIDO ped ON det.PEDIDOID = ped.PEDIDOID
JOIN DIMTIEMPO dt ON dt.FECHA = ped.FECHA
JOIN DIMPRODUCTO dprod ON det.PRODUCTOID = dprod.PRODUCTOID_OLTP
JOIN DIMCLIENTE dcli ON ped.CLIENTEID = dcli.CLIENTEID_OLTP
JOIN DIMPROVEEDOR dprov ON dprod.PROVEEDORKEY = dprov.PROVEEDORKEY
JOIN DIMEMPLEADO demp ON ped.EMPLEADOID = demp.EMPLEADOID_OLTP
JOIN DIMMODALIDADPAGO dmod ON ped.MODALIDADPAGOID = dmod.MODALIDADID_OLTP;

COMMIT;

DECLARE v_count NUMBER;
BEGIN SELECT COUNT(*) INTO v_count FROM FACTVENTAS; DBMS_OUTPUT.PUT_LINE('   FactVentas: ' || v_count || ' registros cargados.'); END;
/

-- ============================================================================
-- FASE 6: VERIFICACION Y ESTADISTICAS
-- ============================================================================

BEGIN DBMS_OUTPUT.PUT_LINE('[FASE 6/6] Verificacion final...'); END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE('RESUMEN DEL PROCESO ETL');
    DBMS_OUTPUT.PUT_LINE('============================================================================');
END;
/

SELECT 'DIMTIEMPO' AS TABLA, COUNT(*) AS REGISTROS FROM DIMTIEMPO
UNION ALL SELECT 'DIMUBICACION', COUNT(*) FROM DIMUBICACION
UNION ALL SELECT 'DIMCATEGORIA', COUNT(*) FROM DIMCATEGORIA
UNION ALL SELECT 'DIMPROVEEDOR', COUNT(*) FROM DIMPROVEEDOR
UNION ALL SELECT 'DIMCLIENTE', COUNT(*) FROM DIMCLIENTE
UNION ALL SELECT 'DIMEMPLEADO', COUNT(*) FROM DIMEMPLEADO
UNION ALL SELECT 'DIMMODALIDADPAGO', COUNT(*) FROM DIMMODALIDADPAGO
UNION ALL SELECT 'DIMPRODUCTO', COUNT(*) FROM DIMPRODUCTO
UNION ALL SELECT 'FACTVENTAS', COUNT(*) FROM FACTVENTAS;

BEGIN DBMS_OUTPUT.PUT_LINE('Estadisticas de Ventas:'); END;
/

SELECT COUNT(DISTINCT PEDIDOID_OLTP) AS PEDIDOS, COUNT(*) AS LINEAS, SUM(CANTIDAD) AS UNIDADES FROM FACTVENTAS;

BEGIN DBMS_OUTPUT.PUT_LINE('Ventas por Anio:'); END;
/

SELECT dt.ANIO, COUNT(DISTINCT f.PEDIDOID_OLTP) AS PEDIDOS, SUM(f.MONTOTOTAL) AS VENTAS
FROM FACTVENTAS f JOIN DIMTIEMPO dt ON f.TIEMPOKEY = dt.TIEMPOKEY
GROUP BY dt.ANIO ORDER BY dt.ANIO;

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE('ETL COMPLETADO EXITOSAMENTE');
    DBMS_OUTPUT.PUT_LINE('Fecha y Hora: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE('============================================================================');
END;
/

COMMIT;
