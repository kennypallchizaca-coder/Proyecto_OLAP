-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: VistasOLAP_PowerBI.sql
-- Descripcion: Vistas para los 3 analisis requeridos en el proyecto
-- Base de Datos: Oracle Database 21c
-- Fecha: Diciembre 2025
-- ============================================================================
-- ANALISIS SELECCIONADOS:
-- (a) Producto mas vendido por proveedor, tiempo y ubicacion
-- (c) Mejor cliente por tiempo, compras y modalidad de pago  
-- (e) Mejor vendedor por categoria, tiempo, ubicacion y modalidad de pago
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 200;
SET PAGESIZE 100;

-- ============================================================================
-- ELIMINAR VISTAS EXISTENTES
-- ============================================================================

BEGIN EXECUTE IMMEDIATE 'DROP VIEW VW_ANALISIS_A_PRODUCTO_VENDIDO'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW VW_ANALISIS_C_MEJOR_CLIENTE'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW VW_ANALISIS_E_MEJOR_VENDEDOR'; EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW VW_CALENDARIO'; EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE('CREANDO VISTAS OLAP PARA POWER BI');
    DBMS_OUTPUT.PUT_LINE('============================================================================');
END;
/

-- ============================================================================
-- VISTA ANALISIS (a): PRODUCTO MAS VENDIDO POR PROVEEDOR, TIEMPO Y UBICACION
-- Dimensiones: Producto, Proveedor, Tiempo (anio, trimestre, mes, dia semana), Ubicacion
-- ============================================================================

CREATE OR REPLACE VIEW VW_ANALISIS_A_PRODUCTO_VENDIDO AS
SELECT 
    t.ANIO,
    t.NOMBRETRIMESTRE AS TRIMESTRE,
    t.NOMBREMES AS MES,
    t.NOMBREDIA AS DIA_SEMANA,
    t.ANIOMES,
    t.SEMANA,
    p.PRODUCTOKEY,
    p.CODIGO AS CODIGO_PRODUCTO,
    p.NOMBRE AS PRODUCTO,
    p.NOMBRECATEGORIA AS CATEGORIA,
    p.PORCENTAJEIVA AS IVA_PORCENTAJE,
    p.TIPOIVA AS TIPO_IVA,
    prov.PROVEEDORKEY,
    prov.CODIGO AS CODIGO_PROVEEDOR,
    prov.NOMBRE AS PROVEEDOR,
    prov.CIUDAD AS CIUDAD_PROVEEDOR,
    prov.PAIS AS PAIS_PROVEEDOR,
    u.UBICACIONKEY,
    u.CIUDAD AS CIUDAD_CLIENTE,
    u.REGION AS REGION_CLIENTE,
    u.PAIS AS PAIS_CLIENTE,
    COUNT(DISTINCT f.PEDIDOID_OLTP) AS NUMERO_PEDIDOS,
    SUM(f.CANTIDAD) AS UNIDADES_VENDIDAS,
    SUM(f.MONTOSUBTOTAL) AS SUBTOTAL,
    SUM(f.MONTOIVA) AS IVA_TOTAL,
    SUM(f.MONTOTOTAL) AS VENTA_TOTAL,
    ROUND(AVG(f.MONTOTOTAL), 2) AS PROMEDIO_VENTA
FROM FACTVENTAS f
INNER JOIN DIMTIEMPO t ON f.TIEMPOKEY = t.TIEMPOKEY
INNER JOIN DIMPRODUCTO p ON f.PRODUCTOKEY = p.PRODUCTOKEY
INNER JOIN DIMPROVEEDOR prov ON f.PROVEEDORKEY = prov.PROVEEDORKEY
INNER JOIN DIMCLIENTE c ON f.CLIENTEKEY = c.CLIENTEKEY
LEFT JOIN DIMUBICACION u ON c.UBICACIONKEY = u.UBICACIONKEY
GROUP BY 
    t.ANIO, t.NOMBRETRIMESTRE, t.NOMBREMES, t.NOMBREDIA, t.ANIOMES, t.SEMANA,
    p.PRODUCTOKEY, p.CODIGO, p.NOMBRE, p.NOMBRECATEGORIA, p.PORCENTAJEIVA, p.TIPOIVA,
    prov.PROVEEDORKEY, prov.CODIGO, prov.NOMBRE, prov.CIUDAD, prov.PAIS,
    u.UBICACIONKEY, u.CIUDAD, u.REGION, u.PAIS;

BEGIN DBMS_OUTPUT.PUT_LINE('[1/4] Vista VW_ANALISIS_A_PRODUCTO_VENDIDO creada.'); END;
/

-- ============================================================================
-- VISTA ANALISIS (c): MEJOR CLIENTE POR TIEMPO, COMPRAS Y MODALIDAD DE PAGO
-- Dimensiones: Cliente, Tiempo, Modalidad de Pago, Ubicacion
-- ============================================================================

CREATE OR REPLACE VIEW VW_ANALISIS_C_MEJOR_CLIENTE AS
SELECT 
    t.ANIO,
    t.NOMBRETRIMESTRE AS TRIMESTRE,
    t.NOMBREMES AS MES,
    t.ANIOMES,
    c.CLIENTEKEY,
    c.CODIGO AS CODIGO_CLIENTE,
    c.NOMBRECOMPLETO AS CLIENTE,
    c.TIPODOCUMENTO,
    c.CIUDAD AS CIUDAD_CLIENTE,
    c.PAIS AS PAIS_CLIENTE,
    u.REGION AS REGION_CLIENTE,
    mp.MODALIDADKEY,
    mp.DESCRIPCION AS MODALIDAD_PAGO,
    mp.TIPOPAGO AS TIPO_PAGO,
    mp.CUOTAS,
    mp.DESCRIPCIONCOMPLETA AS DETALLE_PAGO,
    mp.ESTARJETA AS ES_TARJETA,
    COUNT(DISTINCT f.PEDIDOID_OLTP) AS NUMERO_COMPRAS,
    SUM(f.CANTIDAD) AS UNIDADES_COMPRADAS,
    SUM(f.MONTOSUBTOTAL) AS VALOR_SUBTOTAL,
    SUM(f.MONTOIVA) AS VALOR_IVA,
    SUM(f.MONTOTOTAL) AS VALOR_TOTAL_COMPRAS,
    ROUND(AVG(f.MONTOTOTAL), 2) AS TICKET_PROMEDIO,
    COUNT(DISTINCT f.PRODUCTOKEY) AS PRODUCTOS_DISTINTOS
FROM FACTVENTAS f
INNER JOIN DIMTIEMPO t ON f.TIEMPOKEY = t.TIEMPOKEY
INNER JOIN DIMCLIENTE c ON f.CLIENTEKEY = c.CLIENTEKEY
INNER JOIN DIMMODALIDADPAGO mp ON f.MODALIDADKEY = mp.MODALIDADKEY
LEFT JOIN DIMUBICACION u ON c.UBICACIONKEY = u.UBICACIONKEY
GROUP BY 
    t.ANIO, t.NOMBRETRIMESTRE, t.NOMBREMES, t.ANIOMES,
    c.CLIENTEKEY, c.CODIGO, c.NOMBRECOMPLETO, c.TIPODOCUMENTO, c.CIUDAD, c.PAIS,
    u.REGION,
    mp.MODALIDADKEY, mp.DESCRIPCION, mp.TIPOPAGO, mp.CUOTAS, mp.DESCRIPCIONCOMPLETA, mp.ESTARJETA;

BEGIN DBMS_OUTPUT.PUT_LINE('[2/4] Vista VW_ANALISIS_C_MEJOR_CLIENTE creada.'); END;
/

-- ============================================================================
-- VISTA ANALISIS (e): MEJOR VENDEDOR POR CATEGORIA, TIEMPO, UBICACION Y MODALIDAD
-- Dimensiones: Empleado, Categoria, Tiempo, Ubicacion, Modalidad de Pago
-- ============================================================================

CREATE OR REPLACE VIEW VW_ANALISIS_E_MEJOR_VENDEDOR AS
SELECT 
    t.ANIO,
    t.NOMBRETRIMESTRE AS TRIMESTRE,
    t.NOMBREMES AS MES,
    t.ANIOMES,
    e.EMPLEADOKEY,
    e.CODIGO AS CODIGO_EMPLEADO,
    e.NOMBRECOMPLETO AS VENDEDOR,
    e.CARGO,
    cat.CATEGORIAKEY,
    cat.CODIGO AS CODIGO_CATEGORIA,
    cat.NOMBRE AS CATEGORIA,
    u.UBICACIONKEY,
    u.CIUDAD AS CIUDAD_CLIENTE,
    u.REGION AS REGION_CLIENTE,
    u.PAIS AS PAIS_CLIENTE,
    mp.MODALIDADKEY,
    mp.DESCRIPCION AS MODALIDAD_PAGO,
    mp.TIPOPAGO AS TIPO_PAGO,
    mp.CUOTAS,
    COUNT(DISTINCT f.PEDIDOID_OLTP) AS NUMERO_VENTAS,
    COUNT(DISTINCT f.CLIENTEKEY) AS CLIENTES_ATENDIDOS,
    SUM(f.CANTIDAD) AS UNIDADES_VENDIDAS,
    SUM(f.MONTOSUBTOTAL) AS SUBTOTAL_VENTAS,
    SUM(f.MONTOIVA) AS IVA_GENERADO,
    SUM(f.MONTOTOTAL) AS TOTAL_VENTAS,
    ROUND(AVG(f.MONTOTOTAL), 2) AS PROMEDIO_POR_VENTA
FROM FACTVENTAS f
INNER JOIN DIMTIEMPO t ON f.TIEMPOKEY = t.TIEMPOKEY
INNER JOIN DIMEMPLEADO e ON f.EMPLEADOKEY = e.EMPLEADOKEY
INNER JOIN DIMCATEGORIA cat ON f.CATEGORIAKEY = cat.CATEGORIAKEY
INNER JOIN DIMCLIENTE c ON f.CLIENTEKEY = c.CLIENTEKEY
LEFT JOIN DIMUBICACION u ON c.UBICACIONKEY = u.UBICACIONKEY
INNER JOIN DIMMODALIDADPAGO mp ON f.MODALIDADKEY = mp.MODALIDADKEY
GROUP BY 
    t.ANIO, t.NOMBRETRIMESTRE, t.NOMBREMES, t.ANIOMES,
    e.EMPLEADOKEY, e.CODIGO, e.NOMBRECOMPLETO, e.CARGO,
    cat.CATEGORIAKEY, cat.CODIGO, cat.NOMBRE,
    u.UBICACIONKEY, u.CIUDAD, u.REGION, u.PAIS,
    mp.MODALIDADKEY, mp.DESCRIPCION, mp.TIPOPAGO, mp.CUOTAS;

BEGIN DBMS_OUTPUT.PUT_LINE('[3/4] Vista VW_ANALISIS_E_MEJOR_VENDEDOR creada.'); END;
/

-- ============================================================================
-- VISTA CALENDARIO (Para filtros de tiempo en Power BI)
-- ============================================================================

CREATE OR REPLACE VIEW VW_CALENDARIO AS
SELECT 
    TIEMPOKEY,
    FECHA,
    ANIO,
    NOMBRESEMESTRE AS SEMESTRE,
    NOMBRETRIMESTRE AS TRIMESTRE,
    MES AS NUMERO_MES,
    NOMBREMES AS MES,
    NOMBREMESCORTO AS MES_CORTO,
    SEMANA,
    DIADELMES AS DIA,
    NOMBREDIA AS DIA_SEMANA,
    NOMBREDIACORTO AS DIA_SEMANA_CORTO,
    DIADELANIO,
    ESFINDESEMANA AS ES_FIN_SEMANA,
    ESDIALABORAL AS ES_DIA_LABORAL,
    ANIOMES,
    ANIOTRIMESTRE
FROM DIMTIEMPO;

BEGIN DBMS_OUTPUT.PUT_LINE('[4/4] Vista VW_CALENDARIO creada.'); END;
/

-- ============================================================================
-- VERIFICACION
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE('VISTAS OLAP CREADAS EXITOSAMENTE');
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Vistas disponibles para Power BI:');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  VW_ANALISIS_A_PRODUCTO_VENDIDO');
    DBMS_OUTPUT.PUT_LINE('    -> Producto mas vendido por proveedor, tiempo y ubicacion');
    DBMS_OUTPUT.PUT_LINE('    -> Dimensiones: Producto, Proveedor, Tiempo, Ubicacion');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  VW_ANALISIS_C_MEJOR_CLIENTE');
    DBMS_OUTPUT.PUT_LINE('    -> Mejor cliente por compras, tiempo y modalidad de pago');
    DBMS_OUTPUT.PUT_LINE('    -> Dimensiones: Cliente, Tiempo, ModalidadPago, Ubicacion');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  VW_ANALISIS_E_MEJOR_VENDEDOR');
    DBMS_OUTPUT.PUT_LINE('    -> Mejor vendedor por categoria, tiempo, ubicacion y pago');
    DBMS_OUTPUT.PUT_LINE('    -> Dimensiones: Empleado, Categoria, Tiempo, Ubicacion, ModalidadPago');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('  VW_CALENDARIO');
    DBMS_OUTPUT.PUT_LINE('    -> Dimension tiempo para filtros');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('============================================================================');
END;
/

SELECT VIEW_NAME AS VISTA FROM USER_VIEWS WHERE VIEW_NAME LIKE 'VW_%' ORDER BY VIEW_NAME;

COMMIT;
