-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: Datos_Tablas.sql
-- Descripcion: Insercion masiva de datos de prueba (ORACLE)
-- Base de Datos: Oracle Database 21c
-- Fecha: Diciembre 2025
-- ============================================================================

SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 200;
SET PAGESIZE 100;

DECLARE
    v_msg VARCHAR2(100);
BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE('INICIANDO CARGA DE DATOS DE PRUEBA - ORACLE');
    DBMS_OUTPUT.PUT_LINE('============================================================================');
END;
/

-- ============================================================================
-- 1. CATEGORIAS (5 requeridas)
-- ============================================================================

INSERT INTO CATEGORIA (CODIGO, NOMBRE, DESCRIPCION) VALUES ('CAT01', 'Despensa y Abarrotes', 'Productos de abarrotes y conservas habituales en Supermaxi Ecuador');
INSERT INTO CATEGORIA (CODIGO, NOMBRE, DESCRIPCION) VALUES ('CAT02', 'Lacteos y Refrigerados', 'Lacteos, embutidos y refrigerados de consumo diario');
INSERT INTO CATEGORIA (CODIGO, NOMBRE, DESCRIPCION) VALUES ('CAT03', 'Bebidas y Snacks', 'Bebidas sin alcohol, cervezas y snacks vendidos en Supermaxi');
INSERT INTO CATEGORIA (CODIGO, NOMBRE, DESCRIPCION) VALUES ('CAT04', 'Limpieza del Hogar', 'Detergentes, desinfectantes y articulos de aseo de hogar');
INSERT INTO CATEGORIA (CODIGO, NOMBRE, DESCRIPCION) VALUES ('CAT05', 'Cuidado Personal y Bebe', 'Higiene personal, cuidado infantil y salud familiar');
COMMIT;

BEGIN DBMS_OUTPUT.PUT_LINE('[1/7] 5 categorias insertadas.'); END;
/

-- ============================================================================
-- 2. PROVEEDORES (10 requeridos)
-- ============================================================================

INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV01', 'La Fabril S.A.', 'Contacto Comercial', '0991112233', 'ventas@lafabril.com', 'Km 5.5 Via Daule', 'Guayaquil', 'Ecuador');
INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV02', 'PRONACA S.A.', 'Mesa de Negocios', '0992345566', 'negocios@pronaca.com', 'Av. Eloy Alfaro N74-464 y De los Eucaliptos', 'Quito', 'Ecuador');
INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV03', 'Tonicorp S.A.', 'Canal Moderno', '0993456677', 'comercial@tonicorp.com', 'Km 10 Via Daule', 'Guayaquil', 'Ecuador');
INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV04', 'Moderna Alimentos S.A.', 'Cuentas Clave', '0994567788', 'clientes@moderna.com.ec', 'Panamericana Norte Km 17', 'Quito', 'Ecuador');
INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV05', 'Nestle Ecuador S.A.', 'Atencion Retail', '0995678899', 'retail@ec.nestle.com', 'Av. Gonzalez Suarez 31-108 y Corunia', 'Quito', 'Ecuador');
INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV06', 'Tesalia CBC Cia. Ltda.', 'Equipo Supermercados', '0996789900', 'ventas@tesaliacbc.com', 'Parque Industrial Machachi Lote 4', 'Quito', 'Ecuador');
INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV07', 'La Universal S.A.', 'Key Account', '0997890011', 'contacto@launiversal.com.ec', 'Av. 25 de Julio y Av. Machala', 'Guayaquil', 'Ecuador');
INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV08', 'Cerveceria Nacional CN S.A.', 'Canal Moderno', '0998901122', 'servicio@cn.com.ec', 'Km 16.5 Via Daule', 'Guayaquil', 'Ecuador');
INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV09', 'Kimberly-Clark Ecuador S.A.', 'Trade Marketing', '0999012233', 'clientes@kcc.com', 'Parque Industrial Inmaconsa Km 12', 'Guayaquil', 'Ecuador');
INSERT INTO PROVEEDOR (CODIGO, NOMBRE, NOMBRECONTACTO, TELEFONO, EMAIL, DIRECCION, CIUDAD, PAIS) VALUES ('PROV10', 'Industrias Lacteas Toni S.A.', 'Atencion Comercial', '0990123344', 'servicio@toni.com.ec', 'Km 6.5 Via Daule', 'Guayaquil', 'Ecuador');
COMMIT;

BEGIN DBMS_OUTPUT.PUT_LINE('[2/7] 10 proveedores insertados.'); END;
/

-- ============================================================================
-- 3. EMPLEADOS (5 requeridos)
-- ============================================================================

INSERT INTO EMPLEADO (CODIGO, NOMBRECOMPLETO, CARGO, EMAIL, TELEFONO) VALUES ('EMP01', 'Fernando Gonzalez Mora', 'Vendedor Senior', 'fgonzalez@empresa.com', '0981111111');
INSERT INTO EMPLEADO (CODIGO, NOMBRECOMPLETO, CARGO, EMAIL, TELEFONO) VALUES ('EMP02', 'Patricia Villacis Ruiz', 'Vendedor', 'pvillacis@empresa.com', '0982222222');
INSERT INTO EMPLEADO (CODIGO, NOMBRECOMPLETO, CARGO, EMAIL, TELEFONO) VALUES ('EMP03', 'Ricardo Salazar Luna', 'Vendedor', 'rsalazar@empresa.com', '0983333333');
INSERT INTO EMPLEADO (CODIGO, NOMBRECOMPLETO, CARGO, EMAIL, TELEFONO) VALUES ('EMP04', 'Monica Paredes Silva', 'Vendedor Junior', 'mparedes@empresa.com', '0984444444');
INSERT INTO EMPLEADO (CODIGO, NOMBRECOMPLETO, CARGO, EMAIL, TELEFONO) VALUES ('EMP05', 'Andres Cornejo Vega', 'Vendedor Junior', 'acornejo@empresa.com', '0985555555');
COMMIT;

BEGIN DBMS_OUTPUT.PUT_LINE('[3/7] 5 empleados insertados.'); END;
/

-- ============================================================================
-- 4. CLIENTES (20 requeridos)
-- ============================================================================

INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI01', 'Juan Carlos Rodriguez', 'Cedula', '1712345678', 'jcrodriguez@email.com', '0991111111', 'Av. Republica E7-123 y Almagro', 'Quito', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI02', 'Maria Elena Suarez', 'Cedula', '1723456789', 'mesuarez@email.com', '0992222222', 'Calle Amazonas N24-56 y Colon', 'Quito', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI03', 'Pedro Antonio Morales', 'Cedula', '0912345678', 'pamorales@email.com', '0993333333', 'Av. 9 de Octubre 1520 y Boyaca', 'Guayaquil', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI04', 'Ana Lucia Fernandez', 'Cedula', '0923456789', 'alfernandez@email.com', '0994444444', 'Malecon Simon Bolivar 800 y Junin', 'Guayaquil', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI05', 'Carlos Eduardo Vega', 'Cedula', '0112345678', 'cevega@email.com', '0995555555', 'Av. Solano 4-25 y Remigio Crespo', 'Cuenca', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI06', 'Diana Patricia Castro', 'Cedula', '0123456789', 'dpcastro@email.com', '0996666666', 'Calle Larga 8-50 y Benigno Malo', 'Cuenca', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI07', 'Roberto Luis Mendez', 'Cedula', '1312345678', 'rlmendez@email.com', '0997777777', 'Av. Malecon de Manta 215', 'Manta', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI08', 'Sandra Beatriz Lopez', 'Cedula', '1323456789', 'sblopez@email.com', '0998888888', 'Calle 15 y Av. 24 Centro', 'Manta', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI09', 'Miguel Angel Torres', 'Cedula', '1812345678', 'matorres@email.com', '0999999999', 'Av. Universitaria y Mercadillo', 'Loja', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI10', 'Laura Isabel Herrera', 'Cedula', '1823456789', 'liherrera@email.com', '0990000001', 'Calle Bolivar 10-45 y Bernardo Valdivieso', 'Loja', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI11', 'Francisco Javier Ruiz', 'RUC', '1791234567001', 'fjruiz@empresa.com', '0990000002', 'Av. Naciones Unidas E10-45 y Amazonas', 'Quito', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI12', 'Elena Margarita Paz', 'Cedula', '1734567890', 'empaz@email.com', '0990000003', 'Calle Veintimilla E8-90 y 6 de Diciembre', 'Quito', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI13', 'Oscar Mauricio Silva', 'Cedula', '0934567890', 'omsilva@email.com', '0990000004', 'Av. Francisco de Orellana Norte Mz 111', 'Guayaquil', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI14', 'Claudia Andrea Reyes', 'Cedula', '0945678901', 'careyes@email.com', '0990000005', 'Ciudadela Kennedy Norte Mz 45 Villa 12', 'Guayaquil', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI15', 'Raul Ernesto Medina', 'RUC', '0191234567001', 'remedina@empresa.com', '0990000006', 'Av. Ordoniez Lasso 5-89 y Del Estadio', 'Cuenca', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI16', 'Teresa Eugenia Vargas', 'Cedula', '0156789012', 'tevargas@email.com', '0990000007', 'Calle Gran Colombia 15-20 y Tarqui', 'Cuenca', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI17', 'Hector Fabian Rojas', 'Cedula', '1345678901', 'hfrojas@email.com', '0990000008', 'Av. 4 de Noviembre y Calle 108', 'Manta', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI18', 'Gloria Esperanza Nunez', 'Cedula', '1356789012', 'genunez@email.com', '0990000009', 'Barrio Tarqui Calle 120 y Av. 115', 'Manta', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI19', 'Jorge Armando Pena', 'RUC', '1891234567001', 'japena@empresa.com', '0990000010', 'Av. Manuel Aguirre 12-34 y Rocafuerte', 'Loja', 'Ecuador');
INSERT INTO CLIENTE (CODIGO, NOMBRECOMPLETO, TIPODOCUMENTO, NUMERODOCUMENTO, EMAIL, TELEFONO, DIRECCION, CIUDAD, PAIS) VALUES ('CLI20', 'Beatriz Carolina Soto', 'Cedula', '1867890123', 'bcsoto@email.com', '0990000011', 'Calle 18 de Noviembre 08-56 y Colon', 'Loja', 'Ecuador');
COMMIT;

BEGIN DBMS_OUTPUT.PUT_LINE('[4/7] 20 clientes insertados.'); END;
/

-- ============================================================================
-- 5. MODALIDADES DE PAGO
-- ============================================================================

INSERT INTO MODALIDAD_PAGO (CODIGO, DESCRIPCION, TIPOPAGO, CUOTAS, TASAINTERES, REQUIEREDATOS) VALUES ('EFE', 'Efectivo', 'EFECTIVO', 0, 0, 0);
INSERT INTO MODALIDAD_PAGO (CODIGO, DESCRIPCION, TIPOPAGO, CUOTAS, TASAINTERES, REQUIEREDATOS) VALUES ('TRF', 'Transferencia Bancaria', 'TRANSFERENCIA', 0, 0, 0);
INSERT INTO MODALIDAD_PAGO (CODIGO, DESCRIPCION, TIPOPAGO, CUOTAS, TASAINTERES, REQUIEREDATOS) VALUES ('TDB', 'Tarjeta de Debito', 'TARJETA_DEBITO', 0, 0, 1);
INSERT INTO MODALIDAD_PAGO (CODIGO, DESCRIPCION, TIPOPAGO, CUOTAS, TASAINTERES, REQUIEREDATOS) VALUES ('TC01', 'Tarjeta Credito - Corriente', 'TARJETA_CREDITO', 1, 0, 1);
INSERT INTO MODALIDAD_PAGO (CODIGO, DESCRIPCION, TIPOPAGO, CUOTAS, TASAINTERES, REQUIEREDATOS) VALUES ('TC03', 'Tarjeta Credito - 3 Cuotas', 'TARJETA_CREDITO', 3, 5.50, 1);
INSERT INTO MODALIDAD_PAGO (CODIGO, DESCRIPCION, TIPOPAGO, CUOTAS, TASAINTERES, REQUIEREDATOS) VALUES ('TC06', 'Tarjeta Credito - 6 Cuotas', 'TARJETA_CREDITO', 6, 8.00, 1);
INSERT INTO MODALIDAD_PAGO (CODIGO, DESCRIPCION, TIPOPAGO, CUOTAS, TASAINTERES, REQUIEREDATOS) VALUES ('TC12', 'Tarjeta Credito - 12 Cuotas', 'TARJETA_CREDITO', 12, 12.50, 1);
COMMIT;

BEGIN DBMS_OUTPUT.PUT_LINE('[5/7] 7 modalidades de pago insertadas.'); END;
/

-- ============================================================================
-- 6. PRODUCTOS (200 requeridos: 100 con IVA 15%, 100 con IVA 0%)
-- ============================================================================

DECLARE
    TYPE t_nombres IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    v_nombres_despensa t_nombres;
    v_nombres_lacteos t_nombres;
    v_nombres_bebidas t_nombres;
    v_nombres_limpieza t_nombres;
    v_nombres_cuidado t_nombres;
    
    TYPE t_descripciones IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
    v_desc_categoria t_descripciones;
    
    v_categoria NUMBER;
    v_proveedor NUMBER;
    v_precio NUMBER(18,2);
    v_iva NUMBER(5,2);
    v_codigo VARCHAR2(30);
    v_nombre VARCHAR2(200);
    v_descripcion VARCHAR2(500);
    v_idx NUMBER;
BEGIN
    -- Nombres Despensa (40)
    v_nombres_despensa(1) := 'Arroz Favorita 5kg';
    v_nombres_despensa(2) := 'Azucar San Carlos 2kg';
    v_nombres_despensa(3) := 'Aceite Alesol 1L';
    v_nombres_despensa(4) := 'Aceite Gustadina Girasol 900ml';
    v_nombres_despensa(5) := 'Sal Cris-Sal 1kg';
    v_nombres_despensa(6) := 'Fideos La Moderna Spaghetti 500g';
    v_nombres_despensa(7) := 'Fideos La Moderna Tornillo 500g';
    v_nombres_despensa(8) := 'Harina YA 1kg';
    v_nombres_despensa(9) := 'Avena Quaker Tradicional 500g';
    v_nombres_despensa(10) := 'Atun Real en Agua 170g';
    v_nombres_despensa(11) := 'Atun Van Camps en Aceite 170g';
    v_nombres_despensa(12) := 'Sardinas Real 155g';
    v_nombres_despensa(13) := 'Lenteja Ina 500g';
    v_nombres_despensa(14) := 'Garbanzo Ina 500g';
    v_nombres_despensa(15) := 'Frijol Rojo Ina 500g';
    v_nombres_despensa(16) := 'Maiz Pira Ina 500g';
    v_nombres_despensa(17) := 'Sopa Maggi Gallina 65g';
    v_nombres_despensa(18) := 'Caldo de Pollo Maggi 12 cubos';
    v_nombres_despensa(19) := 'Salsa de Tomate Gustadina 397g';
    v_nombres_despensa(20) := 'Mayonesa Maggi 380g';
    v_nombres_despensa(21) := 'Mostaza Ina 200g';
    v_nombres_despensa(22) := 'Alcaparras Gustadina 100g';
    v_nombres_despensa(23) := 'Aceitunas Fragata Verdes 300g';
    v_nombres_despensa(24) := 'Vinagre San Jorge 500ml';
    v_nombres_despensa(25) := 'Salsa de Soya Kikkoman 150ml';
    v_nombres_despensa(26) := 'Fideos Orientales Oriental 85g';
    v_nombres_despensa(27) := 'Galletas Ducales 255g';
    v_nombres_despensa(28) := 'Galletas Oreo Clasica 432g';
    v_nombres_despensa(29) := 'Pan de Molde Bimbo Artesano';
    v_nombres_despensa(30) := 'Cereal Zucaritas 300g';
    v_nombres_despensa(31) := 'Cereal Choco Krispis 300g';
    v_nombres_despensa(32) := 'Chocolate en Polvo Milo 400g';
    v_nombres_despensa(33) := 'Cafe Nescafe Tradicion 200g';
    v_nombres_despensa(34) := 'Te Hornimans Manzanilla 20u';
    v_nombres_despensa(35) := 'Achiote La Favorita 120g';
    v_nombres_despensa(36) := 'Harina de Maiz PAN 1kg';
    v_nombres_despensa(37) := 'Levadura Fleischmann 10g';
    v_nombres_despensa(38) := 'Mermelada de Mora Los Andes 454g';
    v_nombres_despensa(39) := 'Crema de Mani Skippy 340g';
    v_nombres_despensa(40) := 'Pasta de Tomate Cirio 200g';
    
    -- Nombres Lacteos (40)
    v_nombres_lacteos(1) := 'Leche Toni Entera 1L';
    v_nombres_lacteos(2) := 'Leche Toni Descremada 1L';
    v_nombres_lacteos(3) := 'Leche Parmalat Entera 1L';
    v_nombres_lacteos(4) := 'Yogurt Toni Durazno 1L';
    v_nombres_lacteos(5) := 'Yogurt Toni Frutilla 1L';
    v_nombres_lacteos(6) := 'Yogurt Griego Chobani Natural 500g';
    v_nombres_lacteos(7) := 'Queso Mozzarella El Ordeno 400g';
    v_nombres_lacteos(8) := 'Queso Fresco El Ordeno 400g';
    v_nombres_lacteos(9) := 'Queso Edam Kiosko 400g';
    v_nombres_lacteos(10) := 'Queso Manchego Los Andes 300g';
    v_nombres_lacteos(11) := 'Mantequilla Reina con Sal 200g';
    v_nombres_lacteos(12) := 'Margarina La Favorita 250g';
    v_nombres_lacteos(13) := 'Crema de Leche Nestle 200g';
    v_nombres_lacteos(14) := 'Queso Crema Philadelphia 226g';
    v_nombres_lacteos(15) := 'Jamon de Pavo Plumrose 250g';
    v_nombres_lacteos(16) := 'Jamon Ahumado Mr. Pollo 250g';
    v_nombres_lacteos(17) := 'Salchicha Vienesa Plumrose 500g';
    v_nombres_lacteos(18) := 'Mortadela Don Diego 500g';
    v_nombres_lacteos(19) := 'Yogurt Toni Griego Mora 500g';
    v_nombres_lacteos(20) := 'Queso Panela Toni 400g';
    v_nombres_lacteos(21) := 'Huevos Kike Docena';
    v_nombres_lacteos(22) := 'Huevos Supermaxi Docena';
    v_nombres_lacteos(23) := 'Mantequilla Gloria Light 200g';
    v_nombres_lacteos(24) := 'Leche Condensada Nestle 397g';
    v_nombres_lacteos(25) := 'Natilla La Vaquita 200g';
    v_nombres_lacteos(26) := 'Queso Ricotta Los Andes 400g';
    v_nombres_lacteos(27) := 'Yogurt Yogu Yogu Durazno 1L';
    v_nombres_lacteos(28) := 'Bebida de Almendra Silk 946ml';
    v_nombres_lacteos(29) := 'Bebida de Soya Ades Vainilla 946ml';
    v_nombres_lacteos(30) := 'Queso Parmesano Parmalat 100g';
    v_nombres_lacteos(31) := 'Queso Gouda Kiosko 400g';
    v_nombres_lacteos(32) := 'Yogurt Kiosko Natural 1L';
    v_nombres_lacteos(33) := 'Queso Crema Los Andes Light 200g';
    v_nombres_lacteos(34) := 'Leche Deslactosada Toni 1L';
    v_nombres_lacteos(35) := 'Mantequilla Toni sin Sal 200g';
    v_nombres_lacteos(36) := 'Queso Cottage Toni 200g';
    v_nombres_lacteos(37) := 'Crema Agria Toni 200g';
    v_nombres_lacteos(38) := 'Requeson El Ordeno 250g';
    v_nombres_lacteos(39) := 'Yogurt Toni Kids Fresa 4x100g';
    v_nombres_lacteos(40) := 'Queso Doble Crema Kiosko 400g';
    
    -- Nombres Bebidas y Snacks (40)
    v_nombres_bebidas(1) := 'Agua Guitig 1.5L';
    v_nombres_bebidas(2) := 'Agua Cielo 2L';
    v_nombres_bebidas(3) := 'Gaseosa Coca-Cola 2.5L';
    v_nombres_bebidas(4) := 'Gaseosa Fanta Naranja 2L';
    v_nombres_bebidas(5) := 'Gaseosa Sprite 2L';
    v_nombres_bebidas(6) := 'Gaseosa Tropical Manzana 2L';
    v_nombres_bebidas(7) := 'Jugo Tampico Naranja 2L';
    v_nombres_bebidas(8) := 'Jugo Del Valle Durazno 1L';
    v_nombres_bebidas(9) := 'Nectar Levite Durazno 1.5L';
    v_nombres_bebidas(10) := 'Gatorade Cool Blue 1L';
    v_nombres_bebidas(11) := 'Bebida Isotonica Sporade Uva 600ml';
    v_nombres_bebidas(12) := 'Te Helado Fuze Tea Limon 600ml';
    v_nombres_bebidas(13) := 'Te Lipton Durazno 1.5L';
    v_nombres_bebidas(14) := 'Bebida Energetica Vive100 473ml';
    v_nombres_bebidas(15) := 'Bebida Energetica Monster Verde 473ml';
    v_nombres_bebidas(16) := 'Bebida Energetica Red Bull 250ml';
    v_nombres_bebidas(17) := 'Cerveza Pilsener Six Pack';
    v_nombres_bebidas(18) := 'Cerveza Club Verde Six Pack';
    v_nombres_bebidas(19) := 'Vino Santa Carolina Reservado 750ml';
    v_nombres_bebidas(20) := 'Ron San Miguel Anejo 750ml';
    v_nombres_bebidas(21) := 'Chips Doritos Queso 170g';
    v_nombres_bebidas(22) := 'Chips Ruffles Original 160g';
    v_nombres_bebidas(23) := 'Papas Fritas Lays Clasicas 150g';
    v_nombres_bebidas(24) := 'Chifles Inalecsa 150g';
    v_nombres_bebidas(25) := 'Tortolines Naturales 140g';
    v_nombres_bebidas(26) := 'Mani Japones Gauchitos 200g';
    v_nombres_bebidas(27) := 'Galletas Amor Fresa 150g';
    v_nombres_bebidas(28) := 'Galletas Festival Vainilla 150g';
    v_nombres_bebidas(29) := 'Chocolate Pacari 70% 50g';
    v_nombres_bebidas(30) := 'Barra de Cereal Nature Valley Avena';
    v_nombres_bebidas(31) := 'Canguil Act II Mantequilla 3pack';
    v_nombres_bebidas(32) := 'Rosquitas Inalecsa 130g';
    v_nombres_bebidas(33) := 'Galletas Salti Noel 300g';
    v_nombres_bebidas(34) := 'Nachos Mission Triangulares 300g';
    v_nombres_bebidas(35) := 'Mix de Nueces Kirkland 1kg';
    v_nombres_bebidas(36) := 'Galletas Cracker Field Integral 225g';
    v_nombres_bebidas(37) := 'Canguil Gourmet Gauchitos 200g';
    v_nombres_bebidas(38) := 'Galletas ChocoChips Nestle 180g';
    v_nombres_bebidas(39) := 'Palomitas Popcorn Popetas 100g';
    v_nombres_bebidas(40) := 'Pan de Yuca Listo Amalie 12u';
    
    -- Nombres Limpieza (40)
    v_nombres_limpieza(1) := 'Detergente Deja Floral 3kg';
    v_nombres_limpieza(2) := 'Detergente Ariel Revitacolor 2.7kg';
    v_nombres_limpieza(3) := 'Detergente OMO Matic 2.7kg';
    v_nombres_limpieza(4) := 'Jabon Liquido Persil 3L';
    v_nombres_limpieza(5) := 'Suavizante Downy Brisa 1.8L';
    v_nombres_limpieza(6) := 'Suavizante Ensueno Primavera 1.8L';
    v_nombres_limpieza(7) := 'Quitamanchas Vanish Pink 900g';
    v_nombres_limpieza(8) := 'Blanqueador Clorox Tradicional 1L';
    v_nombres_limpieza(9) := 'Lavavajilla Axion Limon 800g';
    v_nombres_limpieza(10) := 'Lavavajilla Salvo Limon 1L';
    v_nombres_limpieza(11) := 'Esponja Scotch-Brite Doble Accion 3u';
    v_nombres_limpieza(12) := 'Pano Scott Duramax 6u';
    v_nombres_limpieza(13) := 'Toallas de Cocina Scott 2u';
    v_nombres_limpieza(14) := 'Bolsas de Basura Glad 30L 20u';
    v_nombres_limpieza(15) := 'Desinfectante Lysol Aerosol 360ml';
    v_nombres_limpieza(16) := 'Limpiador Fabuloso Lavanda 1.8L';
    v_nombres_limpieza(17) := 'Limpiador Mr. Musculo Bano 500ml';
    v_nombres_limpieza(18) := 'Limpiador Cif Crema 500ml';
    v_nombres_limpieza(19) := 'Insecticida Baygon Mata Mosquitos 360ml';
    v_nombres_limpieza(20) := 'Repelente OFF! Family 200ml';
    v_nombres_limpieza(21) := 'Ambientador Glade Gel Manzana 70g';
    v_nombres_limpieza(22) := 'Ambientador Glade PlugIn Vainilla';
    v_nombres_limpieza(23) := 'Papel Higienico Familia 12 rollos';
    v_nombres_limpieza(24) := 'Papel Higienico Suave 18 rollos';
    v_nombres_limpieza(25) := 'Servilletas Elite 200u';
    v_nombres_limpieza(26) := 'Toalla de Cocina Elite MegaRoll';
    v_nombres_limpieza(27) := 'Guantes de Limpieza Mapa Talla M';
    v_nombres_limpieza(28) := 'Trapero Vileda Microfiber';
    v_nombres_limpieza(29) := 'Balde Plastico Supermaxi 12L';
    v_nombres_limpieza(30) := 'Escoba Virutex Suave';
    v_nombres_limpieza(31) := 'Recogedor Plastico Mango Largo';
    v_nombres_limpieza(32) := 'Cepillo para Bano Virutex';
    v_nombres_limpieza(33) := 'Limpiador Vidrios Windex 500ml';
    v_nombres_limpieza(34) := 'Pastillas Desinfectantes Pato Tanque 2u';
    v_nombres_limpieza(35) := 'Desinfectante Pinesol Original 1.2L';
    v_nombres_limpieza(36) := 'Ambientador Air Wick Aerosol 345ml';
    v_nombres_limpieza(37) := 'Frazada Multiuso Virutex 3u';
    v_nombres_limpieza(38) := 'Panos Humedos Desinfectantes Clorox 30u';
    v_nombres_limpieza(39) := 'Limpiador de Piso Poett Lavanda 900ml';
    v_nombres_limpieza(40) := 'Purificador de Aire Glade Auto Sport';
    
    -- Nombres Cuidado Personal (40)
    v_nombres_cuidado(1) := 'Shampoo Sedal Ceramidas 400ml';
    v_nombres_cuidado(2) := 'Acondicionador Sedal Ceramidas 400ml';
    v_nombres_cuidado(3) := 'Shampoo Pantene Micelar 400ml';
    v_nombres_cuidado(4) := 'Gel de Ducha Dove Original 500ml';
    v_nombres_cuidado(5) := 'Jabon de Barra Rexona Cotton 3x90g';
    v_nombres_cuidado(6) := 'Pasta Dental Colgate Total 12 150g';
    v_nombres_cuidado(7) := 'Cepillo Dental Oral-B Indicator 2u';
    v_nombres_cuidado(8) := 'Hilo Dental Oral-B Essential 50m';
    v_nombres_cuidado(9) := 'Enjuague Bucal Listerine Cool Mint 500ml';
    v_nombres_cuidado(10) := 'Desodorante Rexona Clinical 48g';
    v_nombres_cuidado(11) := 'Desodorante Dove Original 50ml';
    v_nombres_cuidado(12) := 'Crema Corporal Nivea Soft 200ml';
    v_nombres_cuidado(13) := 'Bloqueador Solar Nivea Sun FPS50 125ml';
    v_nombres_cuidado(14) := 'Crema Facial Ponds Rejuveness 100g';
    v_nombres_cuidado(15) := 'Maquinillas Gillette Prestobarba3 4u';
    v_nombres_cuidado(16) := 'Espuma de Afeitar Gillette 250ml';
    v_nombres_cuidado(17) := 'Toallas Sanitarias Kotex Nocturna 10u';
    v_nombres_cuidado(18) := 'Toallas Sanitarias Always Ultrafina 12u';
    v_nombres_cuidado(19) := 'Protectores Diarios Carefree 40u';
    v_nombres_cuidado(20) := 'Shampoo Johnsons Baby Manzanilla 400ml';
    v_nombres_cuidado(21) := 'Jabon Liquido Huggies Recien Nacido 400ml';
    v_nombres_cuidado(22) := 'Panales Huggies Natural Care G 40u';
    v_nombres_cuidado(23) := 'Panales Pampers Premium Care M 40u';
    v_nombres_cuidado(24) := 'Toallitas Humedas Huggies Aloe 96u';
    v_nombres_cuidado(25) := 'Crema Protectora Desitin 57g';
    v_nombres_cuidado(26) := 'Talco Johnsons Baby 200g';
    v_nombres_cuidado(27) := 'Aceite Johnsons Baby 200ml';
    v_nombres_cuidado(28) := 'Gel Antibacterial Lifebuoy 250ml';
    v_nombres_cuidado(29) := 'Alcohol Antiseptico Superior 500ml';
    v_nombres_cuidado(30) := 'Vendas Nexcare 10u';
    v_nombres_cuidado(31) := 'Vitaminas Centrum Hombre 60u';
    v_nombres_cuidado(32) := 'Vitaminas Centrum Mujer 60u';
    v_nombres_cuidado(33) := 'Termometro Digital Omron MC246';
    v_nombres_cuidado(34) := 'Mascarilla KN95 Pack 10u';
    v_nombres_cuidado(35) := 'Toallas Humedas Kleenex Antibacterial 60u';
    v_nombres_cuidado(36) := 'Crema de Manos Neutrogena 56g';
    v_nombres_cuidado(37) := 'Balsamo Labial Chapstick Cereza 4g';
    v_nombres_cuidado(38) := 'Tinte para Cabello LOreal Casting 5.0';
    v_nombres_cuidado(39) := 'Removedor de Esmalte Vogue 120ml';
    v_nombres_cuidado(40) := 'Esmalte de Unas Valmy Rojo 10ml';
    
    -- Descripciones por categoria
    v_desc_categoria(1) := 'Producto de despensa y abarrotes de alta calidad para el hogar ecuatoriano';
    v_desc_categoria(2) := 'Producto lacteo o refrigerado fresco, ideal para consumo diario';
    v_desc_categoria(3) := 'Bebida o snack refrescante para toda la familia';
    v_desc_categoria(4) := 'Producto de limpieza eficaz para mantener tu hogar impecable';
    v_desc_categoria(5) := 'Producto de cuidado personal para tu bienestar y el de tu familia';
    
    -- Insertar 200 productos
    FOR i IN 1..200 LOOP
        -- Categoria (40 productos por categoria)
        v_categoria := TRUNC((i - 1) / 40) + 1;
        IF v_categoria > 5 THEN v_categoria := 5; END IF;
        
        -- Proveedor rotativo
        v_proveedor := MOD(i - 1, 10) + 1;
        
        -- Precio aleatorio entre 5 y 500
        v_precio := ROUND(5 + DBMS_RANDOM.VALUE * 495, 2);
        
        -- IVA: primeros 100 con 15%, siguientes 100 con 0%
        IF i <= 100 THEN v_iva := 15.00; ELSE v_iva := 0.00; END IF;
        
        -- Codigo
        v_codigo := 'PROD' || LPAD(TO_CHAR(i), 3, '0');
        
        -- Nombre segun categoria
        v_idx := MOD(i - 1, 40) + 1;
        CASE v_categoria
            WHEN 1 THEN v_nombre := v_nombres_despensa(v_idx);
            WHEN 2 THEN v_nombre := v_nombres_lacteos(v_idx);
            WHEN 3 THEN v_nombre := v_nombres_bebidas(v_idx);
            WHEN 4 THEN v_nombre := v_nombres_limpieza(v_idx);
            WHEN 5 THEN v_nombre := v_nombres_cuidado(v_idx);
        END CASE;
        
        -- Agregar sufijo si es necesario
        IF i > 40 THEN
            v_nombre := v_nombre || ' v' || TO_CHAR(TRUNC(i / 40) + 1);
        END IF;
        
        -- Generar descripcion con nombre del producto
        v_descripcion := v_nombre || '. ' || v_desc_categoria(v_categoria);
        
        INSERT INTO PRODUCTO (CODIGO, NOMBRE, DESCRIPCION, CATEGORIAID, PROVEEDORID, PRECIOUNITARIO, PORCENTAJEIVA, STOCK)
        VALUES (v_codigo, v_nombre, v_descripcion, v_categoria, v_proveedor, v_precio, v_iva, 1000);
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[6/7] 200 productos insertados (100 con IVA 15%, 100 con IVA 0%).');
END;
/

-- ============================================================================
-- 7. PEDIDOS Y DETALLES (100,000 pedidos con 3-10 productos cada uno)
-- ============================================================================

DECLARE
    v_pedido_id NUMBER;
    v_num_pedido VARCHAR2(20);
    v_fecha_pedido DATE;
    v_cliente_id NUMBER;
    v_empleado_id NUMBER;
    v_modalidad_id NUMBER;
    v_num_productos NUMBER;
    v_subtotal_pedido NUMBER(18,2);
    v_iva_pedido NUMBER(18,2);
    v_total_pedido NUMBER(18,2);
    
    v_producto_id NUMBER;
    v_cantidad NUMBER;
    v_precio_unit NUMBER(18,2);
    v_iva_prod NUMBER(5,2);
    v_subtotal_det NUMBER(18,2);
    v_iva_det NUMBER(18,2);
    v_total_det NUMBER(18,2);
    
    v_fecha_inicio DATE := TO_DATE('2020-01-01', 'YYYY-MM-DD');
    v_fecha_fin DATE := TO_DATE('2025-12-31', 'YYYY-MM-DD');
    v_dias_rango NUMBER;
    v_contador NUMBER := 0;
    v_lote NUMBER := 10000;
    
    -- Coleccion de productos
    TYPE t_producto IS RECORD (
        producto_id NUMBER,
        precio NUMBER(18,2),
        iva NUMBER(5,2)
    );
    TYPE t_productos_arr IS TABLE OF t_producto INDEX BY PLS_INTEGER;
    v_productos t_productos_arr;
    v_prod_idx NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('[7/7] Insertando 100,000 pedidos y detalles...');
    DBMS_OUTPUT.PUT_LINE('   Este proceso tomara varios minutos...');
    
    v_dias_rango := v_fecha_fin - v_fecha_inicio;
    
    -- Cargar productos en memoria
    FOR rec IN (SELECT PRODUCTOID, PRECIOUNITARIO, PORCENTAJEIVA FROM PRODUCTO) LOOP
        v_productos(rec.PRODUCTOID).producto_id := rec.PRODUCTOID;
        v_productos(rec.PRODUCTOID).precio := rec.PRECIOUNITARIO;
        v_productos(rec.PRODUCTOID).iva := rec.PORCENTAJEIVA;
    END LOOP;
    
    FOR i IN 1..100000 LOOP
        -- Generar datos aleatorios
        v_num_pedido := 'PED' || LPAD(TO_CHAR(i), 6, '0');
        v_fecha_pedido := v_fecha_inicio + TRUNC(DBMS_RANDOM.VALUE * v_dias_rango);
        v_cliente_id := TRUNC(DBMS_RANDOM.VALUE * 20) + 1;
        v_empleado_id := TRUNC(DBMS_RANDOM.VALUE * 5) + 1;
        v_modalidad_id := TRUNC(DBMS_RANDOM.VALUE * 7) + 1;
        v_num_productos := 3 + TRUNC(DBMS_RANDOM.VALUE * 8);
        
        -- Insertar cabecera
        INSERT INTO PEDIDO (NUMEROPEDIDO, FECHA, CLIENTEID, EMPLEADOID, MODALIDADPAGOID, ESTADO)
        VALUES (v_num_pedido, v_fecha_pedido, v_cliente_id, v_empleado_id, v_modalidad_id, 'COMPLETADO')
        RETURNING PEDIDOID INTO v_pedido_id;
        
        v_subtotal_pedido := 0;
        v_iva_pedido := 0;
        v_total_pedido := 0;
        
        -- Insertar detalles
        FOR j IN 1..v_num_productos LOOP
            v_producto_id := TRUNC(DBMS_RANDOM.VALUE * 200) + 1;
            v_cantidad := 1 + TRUNC(DBMS_RANDOM.VALUE * 50);
            
            v_precio_unit := v_productos(v_producto_id).precio;
            v_iva_prod := v_productos(v_producto_id).iva;
            
            v_subtotal_det := v_precio_unit * v_cantidad;
            v_iva_det := v_subtotal_det * (v_iva_prod / 100);
            v_total_det := v_subtotal_det + v_iva_det;
            
            INSERT INTO DETALLE_PEDIDO (PEDIDOID, PRODUCTOID, CANTIDAD, PRECIOUNITARIO, PORCENTAJEIVA, SUBTOTAL, MONTOIVA, TOTAL)
            VALUES (v_pedido_id, v_producto_id, v_cantidad, v_precio_unit, v_iva_prod, v_subtotal_det, v_iva_det, v_total_det);
            
            v_subtotal_pedido := v_subtotal_pedido + v_subtotal_det;
            v_iva_pedido := v_iva_pedido + v_iva_det;
            v_total_pedido := v_total_pedido + v_total_det;
        END LOOP;
        
        -- Actualizar totales
        UPDATE PEDIDO 
        SET SUBTOTAL = v_subtotal_pedido,
            TOTALIVA = v_iva_pedido,
            TOTAL = v_total_pedido
        WHERE PEDIDOID = v_pedido_id;
        
        v_contador := v_contador + 1;
        
        -- Commit cada lote
        IF MOD(v_contador, v_lote) = 0 THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('   Procesados: ' || v_contador || ' pedidos...');
        END IF;
    END LOOP;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('   100,000 pedidos insertados con sus detalles.');
END;
/

-- ============================================================================
-- VERIFICACION FINAL
-- ============================================================================

BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE('RESUMEN DE DATOS INSERTADOS');
    DBMS_OUTPUT.PUT_LINE('============================================================================');
END;
/

SELECT 'CATEGORIA' AS TABLA, COUNT(*) AS REGISTROS FROM CATEGORIA
UNION ALL SELECT 'PROVEEDOR', COUNT(*) FROM PROVEEDOR
UNION ALL SELECT 'EMPLEADO', COUNT(*) FROM EMPLEADO
UNION ALL SELECT 'CLIENTE', COUNT(*) FROM CLIENTE
UNION ALL SELECT 'MODALIDAD_PAGO', COUNT(*) FROM MODALIDAD_PAGO
UNION ALL SELECT 'PRODUCTO', COUNT(*) FROM PRODUCTO
UNION ALL SELECT 'PEDIDO', COUNT(*) FROM PEDIDO
UNION ALL SELECT 'DETALLE_PEDIDO', COUNT(*) FROM DETALLE_PEDIDO;

BEGIN DBMS_OUTPUT.PUT_LINE('Distribucion de Productos por IVA:'); END;
/

SELECT CASE WHEN PORCENTAJEIVA = 15 THEN 'IVA 15%' ELSE 'IVA 0%' END AS TIPOIVA, COUNT(*) AS CANTIDAD FROM PRODUCTO GROUP BY PORCENTAJEIVA;

BEGIN DBMS_OUTPUT.PUT_LINE('Rango de Fechas de Pedidos:'); END;
/

SELECT MIN(FECHA) AS FECHA_MIN, MAX(FECHA) AS FECHA_MAX FROM PEDIDO;

BEGIN
    DBMS_OUTPUT.PUT_LINE('============================================================================');
    DBMS_OUTPUT.PUT_LINE('CARGA DE DATOS COMPLETADA EXITOSAMENTE');
    DBMS_OUTPUT.PUT_LINE('============================================================================');
END;
/

COMMIT;
