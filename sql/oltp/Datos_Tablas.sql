-- ============================================================================
-- PROYECTO OLAP - SISTEMA DE PEDIDOS
-- ============================================================================
-- Archivo: Datos_Tablas.sql
-- Descripcion: Insercion masiva de datos de prueba
-- Base de Datos: Azure SQL Database
-- Fecha: Noviembre 2025
-- ============================================================================
-- REQUISITOS CUMPLIDOS (Punto 2):
--   a) 10 Proveedores
--   b) 5 Empleados
--   c) 20 Clientes
--   d) 5 Categorias de productos
--   e) 200 Productos (100 con IVA 15%, 100 con IVA 0%)
--   f) 100,000 Pedidos con fechas entre 01/01/2020 y 31/12/2025
--      Cada pedido tiene 3-10 productos con cantidad 1-50
-- ============================================================================

SET NOCOUNT ON;
GO

PRINT '============================================================================';
PRINT 'INICIANDO CARGA DE DATOS DE PRUEBA';
PRINT '============================================================================';
PRINT '';

-- ============================================================================
-- 1. CATEGORIAS (5 requeridas)
-- ============================================================================

PRINT '[1/7] Insertando Categorias...';

INSERT INTO dbo.Categoria (Codigo, Nombre, Descripcion) VALUES
('CAT01', 'Despensa y Abarrotes', 'Productos de abarrotes y conservas habituales en Supermaxi Ecuador'),
('CAT02', 'Lácteos y Refrigerados', 'Lácteos, embutidos y refrigerados de consumo diario'),
('CAT03', 'Bebidas y Snacks', 'Bebidas sin alcohol, cervezas y snacks vendidos en Supermaxi'),
('CAT04', 'Limpieza del Hogar', 'Detergentes, desinfectantes y artículos de aseo de hogar'),
('CAT05', 'Cuidado Personal y Bebé', 'Higiene personal, cuidado infantil y salud familiar');
GO

PRINT '   5 categorias insertadas.';

-- ============================================================================
-- 2. PROVEEDORES (10 requeridos)
-- ============================================================================

PRINT '[2/7] Insertando Proveedores...';

INSERT INTO dbo.Proveedor (Codigo, Nombre, NombreContacto, Telefono, Email, Ciudad, Pais) VALUES
('PROV01', 'La Fabril S.A.', 'Contacto Comercial', '0991112233', 'ventas@lafabril.com', 'Guayaquil', 'Ecuador'),
('PROV02', 'PRONACA S.A.', 'Mesa de Negocios', '0992345566', 'negocios@pronaca.com', 'Quito', 'Ecuador'),
('PROV03', 'Tonicorp S.A.', 'Canal Moderno', '0993456677', 'comercial@tonicorp.com', 'Guayaquil', 'Ecuador'),
('PROV04', 'Moderna Alimentos S.A.', 'Cuentas Clave', '0994567788', 'clientes@moderna.com.ec', 'Quito', 'Ecuador'),
('PROV05', 'Nestlé Ecuador S.A.', 'Atención Retail', '0995678899', 'retail@ec.nestle.com', 'Quito', 'Ecuador'),
('PROV06', 'Tesalia CBC Cia. Ltda.', 'Equipo Supermercados', '0996789900', 'ventas@tesaliacbc.com', 'Quito', 'Ecuador'),
('PROV07', 'La Universal S.A.', 'Key Account', '0997890011', 'contacto@launiversal.com.ec', 'Guayaquil', 'Ecuador'),
('PROV08', 'Cervecería Nacional CN S.A.', 'Canal Moderno', '0998901122', 'servicio@cn.com.ec', 'Guayaquil', 'Ecuador'),
('PROV09', 'Kimberly-Clark Ecuador S.A.', 'Trade Marketing', '0999012233', 'clientes@kcc.com', 'Guayaquil', 'Ecuador'),
('PROV10', 'Industrias Lácteas Toni S.A.', 'Atención Comercial', '0990123344', 'servicio@toni.com.ec', 'Guayaquil', 'Ecuador');
GO

PRINT '   10 proveedores insertados.';

-- ============================================================================
-- 3. EMPLEADOS (5 requeridos)
-- ============================================================================

PRINT '[3/7] Insertando Empleados...';

INSERT INTO dbo.Empleado (Codigo, NombreCompleto, Cargo, Email, Telefono) VALUES
('EMP01', 'Fernando Gonzalez Mora', 'Vendedor Senior', 'fgonzalez@empresa.com', '0981111111'),
('EMP02', 'Patricia Villacis Ruiz', 'Vendedor', 'pvillacis@empresa.com', '0982222222'),
('EMP03', 'Ricardo Salazar Luna', 'Vendedor', 'rsalazar@empresa.com', '0983333333'),
('EMP04', 'Monica Paredes Silva', 'Vendedor Junior', 'mparedes@empresa.com', '0984444444'),
('EMP05', 'Andres Cornejo Vega', 'Vendedor Junior', 'acornejo@empresa.com', '0985555555');
GO

PRINT '   5 empleados insertados.';

-- ============================================================================
-- 4. CLIENTES (20 requeridos)
-- ============================================================================

PRINT '[4/7] Insertando Clientes...';

INSERT INTO dbo.Cliente (Codigo, NombreCompleto, TipoDocumento, NumeroDocumento, Email, Telefono, Ciudad, Pais) VALUES
('CLI01', 'Juan Carlos Rodriguez', 'Cedula', '1712345678', 'jcrodriguez@email.com', '0991111111', 'Quito', 'Ecuador'),
('CLI02', 'Maria Elena Suarez', 'Cedula', '1723456789', 'mesuarez@email.com', '0992222222', 'Quito', 'Ecuador'),
('CLI03', 'Pedro Antonio Morales', 'Cedula', '0912345678', 'pamorales@email.com', '0993333333', 'Guayaquil', 'Ecuador'),
('CLI04', 'Ana Lucia Fernandez', 'Cedula', '0923456789', 'alfernandez@email.com', '0994444444', 'Guayaquil', 'Ecuador'),
('CLI05', 'Carlos Eduardo Vega', 'Cedula', '0112345678', 'cevega@email.com', '0995555555', 'Cuenca', 'Ecuador'),
('CLI06', 'Diana Patricia Castro', 'Cedula', '0123456789', 'dpcastro@email.com', '0996666666', 'Cuenca', 'Ecuador'),
('CLI07', 'Roberto Luis Mendez', 'Cedula', '1312345678', 'rlmendez@email.com', '0997777777', 'Manta', 'Ecuador'),
('CLI08', 'Sandra Beatriz Lopez', 'Cedula', '1323456789', 'sblopez@email.com', '0998888888', 'Manta', 'Ecuador'),
('CLI09', 'Miguel Angel Torres', 'Cedula', '1812345678', 'matorres@email.com', '0999999999', 'Loja', 'Ecuador'),
('CLI10', 'Laura Isabel Herrera', 'Cedula', '1823456789', 'liherrera@email.com', '0990000001', 'Loja', 'Ecuador'),
('CLI11', 'Francisco Javier Ruiz', 'RUC', '1791234567001', 'fjruiz@empresa.com', '0990000002', 'Quito', 'Ecuador'),
('CLI12', 'Elena Margarita Paz', 'Cedula', '1734567890', 'empaz@email.com', '0990000003', 'Quito', 'Ecuador'),
('CLI13', 'Oscar Mauricio Silva', 'Cedula', '0934567890', 'omsilva@email.com', '0990000004', 'Guayaquil', 'Ecuador'),
('CLI14', 'Claudia Andrea Reyes', 'Cedula', '0945678901', 'careyes@email.com', '0990000005', 'Guayaquil', 'Ecuador'),
('CLI15', 'Raul Ernesto Medina', 'RUC', '0191234567001', 'remedina@empresa.com', '0990000006', 'Cuenca', 'Ecuador'),
('CLI16', 'Teresa Eugenia Vargas', 'Cedula', '0156789012', 'tevargas@email.com', '0990000007', 'Cuenca', 'Ecuador'),
('CLI17', 'Hector Fabian Rojas', 'Cedula', '1345678901', 'hfrojas@email.com', '0990000008', 'Manta', 'Ecuador'),
('CLI18', 'Gloria Esperanza Nunez', 'Cedula', '1356789012', 'genunez@email.com', '0990000009', 'Manta', 'Ecuador'),
('CLI19', 'Jorge Armando Pena', 'RUC', '1891234567001', 'japena@empresa.com', '0990000010', 'Loja', 'Ecuador'),
('CLI20', 'Beatriz Carolina Soto', 'Cedula', '1867890123', 'bcsoto@email.com', '0990000011', 'Loja', 'Ecuador');
GO

PRINT '   20 clientes insertados.';

-- ============================================================================
-- 5. MODALIDADES DE PAGO
-- Efectivo, Transferencia, Tarjeta con diferentes cuotas
-- ============================================================================

PRINT '[5/7] Insertando Modalidades de Pago...';

INSERT INTO dbo.ModalidadPago (Codigo, Descripcion, TipoPago, Cuotas, TasaInteres, RequiereDatos) VALUES
('EFE', 'Efectivo', 'EFECTIVO', 0, 0, 0),
('TRF', 'Transferencia Bancaria', 'TRANSFERENCIA', 0, 0, 0),
('TDB', 'Tarjeta de Debito', 'TARJETA_DEBITO', 0, 0, 1),
('TC01', 'Tarjeta Credito - Corriente', 'TARJETA_CREDITO', 1, 0, 1),
('TC03', 'Tarjeta Credito - 3 Cuotas', 'TARJETA_CREDITO', 3, 5.50, 1),
('TC06', 'Tarjeta Credito - 6 Cuotas', 'TARJETA_CREDITO', 6, 8.00, 1),
('TC12', 'Tarjeta Credito - 12 Cuotas', 'TARJETA_CREDITO', 12, 12.50, 1);
GO

PRINT '   7 modalidades de pago insertadas.';

-- ============================================================================
-- 6. PRODUCTOS (200 requeridos: 100 con IVA 15%, 100 con IVA 0%)
-- ============================================================================

PRINT '[6/7] Insertando Productos (200)...';

-- Variables para generacion
DECLARE @i INT = 1;
DECLARE @CategoriaID INT;
DECLARE @ProveedorID INT;
DECLARE @Precio DECIMAL(18,2);
DECLARE @IVA DECIMAL(5,2);
DECLARE @Codigo NVARCHAR(30);
DECLARE @Nombre NVARCHAR(200);

-- Array de nombres de productos por categoria usando SKUs reales de Supermaxi Ecuador
DECLARE @NombresDespensa TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresDespensa VALUES
('Arroz Favorita 5kg'), ('Azúcar San Carlos 2kg'), ('Aceite Alesol 1L'), ('Aceite Gustadina Girasol 900ml'),
('Sal Cris-Sal 1kg'), ('Fideos La Moderna Spaghetti 500g'), ('Fideos La Moderna Tornillo 500g'), ('Harina YA 1kg'),
('Avena Quaker Tradicional 500g'), ('Atún Real en Agua 170g'), ('Atún Van Camps en Aceite 170g'), ('Sardinas Real 155g'),
('Lenteja Ina 500g'), ('Garbanzo Ina 500g'), ('Frijol Rojo Ina 500g'), ('Maíz Pira Ina 500g'),
('Sopa Maggi Gallina 65g'), ('Caldo de Pollo Maggi 12 cubos'), ('Salsa de Tomate Gustadina 397g'), ('Mayonesa Maggi 380g'),
('Mostaza Ina 200g'), ('Alcaparras Gustadina 100g'), ('Aceitunas Fragata Verdes 300g'), ('Vinagre San Jorge 500ml'),
('Salsa de Soya Kikkoman 150ml'), ('Fideos Orientales Oriental 85g'), ('Galletas Ducales 255g'), ('Galletas Oreo Clásica 432g'),
('Pan de Molde Bimbo Artesano'), ('Cereal Zucaritas 300g'), ('Cereal Choco Krispis 300g'), ('Chocolate en Polvo Milo 400g'),
('Café Nescafé Tradición 200g'), ('Té Hornimans Manzanilla 20u'), ('Achiote La Favorita 120g'), ('Harina de Maíz P.A.N. 1kg'),
('Levadura Fleischmann 10g'), ('Mermelada de Mora Los Andes 454g'), ('Crema de Maní Skippy 340g'), ('Pasta de Tomate Cirio 200g');

DECLARE @NombresLacteos TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresLacteos VALUES
('Leche Toni Entera 1L'), ('Leche Toni Descremada 1L'), ('Leche Parmalat Entera 1L'), ('Yogurt Toni Durazno 1L'),
('Yogurt Toni Frutilla 1L'), ('Yogurt Griego Chobani Natural 500g'), ('Queso Mozzarella El Ordeño 400g'), ('Queso Fresco El Ordeño 400g'),
('Queso Edam Kiosko 400g'), ('Queso Manchego Los Andes 300g'), ('Mantequilla Reina con Sal 200g'), ('Margarina La Favorita 250g'),
('Crema de Leche Nestlé 200g'), ('Queso Crema Philadelphia 226g'), ('Jamón de Pavo Plumrose 250g'), ('Jamón Ahumado Mr. Pollo 250g'),
('Salchicha Vienesa Plumrose 500g'), ('Mortadela Don Diego 500g'), ('Yogurt Toni Griego Mora 500g'), ('Queso Panela Toni 400g'),
('Huevos Kike Docena'), ('Huevos Supermaxi Docena'), ('Mantequilla Gloria Light 200g'), ('Leche Condensada Nestlé 397g'),
('Natilla La Vaquita 200g'), ('Queso Ricotta Los Andes 400g'), ('Yogurt Yogu Yogu Durazno 1L'), ('Bebida de Almendra Silk 946ml'),
('Bebida de Soya Ades Vainilla 946ml'), ('Queso Parmesano Parmalat 100g'), ('Queso Gouda Kiosko 400g'), ('Yogurt Kiosko Natural 1L'),
('Queso Crema Los Andes Light 200g'), ('Leche Deslactosada Toni 1L'), ('Mantequilla Toni sin Sal 200g'), ('Queso Cottage Toni 200g'),
('Crema Agria Toni 200g'), ('Requesón El Ordeño 250g'), ('Yogurt Toni Kids Fresa 4x100g'), ('Queso Doble Crema Kiosko 400g');

DECLARE @NombresBebidasSnacks TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresBebidasSnacks VALUES
('Agua Güitig 1.5L'), ('Agua Cielo 2L'), ('Gaseosa Coca-Cola 2.5L'), ('Gaseosa Fanta Naranja 2L'),
('Gaseosa Sprite 2L'), ('Gaseosa Tropical Manzana 2L'), ('Jugo Tampico Naranja 2L'), ('Jugo Del Valle Durazno 1L'),
('Néctar Levité Durazno 1.5L'), ('Gatorade Cool Blue 1L'), ('Bebida Isotónica Sporade Uva 600ml'), ('Té Helado Fuze Tea Limón 600ml'),
('Té Lipton Durazno 1.5L'), ('Bebida Energética Vive100 473ml'), ('Bebida Energética Monster Verde 473ml'), ('Bebida Energética Red Bull 250ml'),
('Cerveza Pilsener Six Pack'), ('Cerveza Club Verde Six Pack'), ('Vino Santa Carolina Reservado 750ml'), ('Ron San Miguel Añejo 750ml'),
('Chips Doritos Queso 170g'), ('Chips Ruffles Original 160g'), ('Papas Fritas Lays Clásicas 150g'), ('Chifles Inalecsa 150g'),
('Tortolines Naturales 140g'), ('Maní Japonés Gauchitos 200g'), ('Galletas Amor Fresa 150g'), ('Galletas Festival Vainilla 150g'),
('Chocolate Pacari 70% 50g'), ('Barra de Cereal Nature Valley Avena'), ('Canguil Act II Mantequilla 3pack'), ('Rosquitas Inalecsa 130g'),
('Galletas Salti Noel 300g'), ('Nachos Mission Triangulares 300g'), ('Mix de Nueces Kirkland 1kg'), ('Galletas Cracker Field Integral 225g'),
('Canguil Gourmet Gauchitos 200g'), ('Galletas ChocoChips Nestlé 180g'), ('Palomitas Popcorn Popetas 100g'), ('Pan de Yuca Listo Amalie 12u');

DECLARE @NombresLimpieza TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresLimpieza VALUES
('Detergente Deja Floral 3kg'), ('Detergente Ariel Revitacolor 2.7kg'), ('Detergente OMO Matic 2.7kg'), ('Jabón Líquido Persil 3L'),
('Suavizante Downy Brisa 1.8L'), ('Suavizante Ensueño Primavera 1.8L'), ('Quitamanchas Vanish Pink 900g'), ('Blanqueador Clorox Tradicional 1L'),
('Lavavajilla Axion Limón 800g'), ('Lavavajilla Salvo Limón 1L'), ('Esponja Scotch-Brite Doble Acción 3u'), ('Paño Scott Duramax 6u'),
('Toallas de Cocina Scott 2u'), ('Bolsas de Basura Glad 30L 20u'), ('Desinfectante Lysol Aerosol 360ml'), ('Limpiador Fabuloso Lavanda 1.8L'),
('Limpiador Mr. Músculo Baño 500ml'), ('Limpiador Cif Crema 500ml'), ('Insecticida Baygon Mata Mosquitos 360ml'), ('Repelente OFF! Family 200ml'),
('Ambientador Glade Gel Manzana 70g'), ('Ambientador Glade PlugIn Vainilla'), ('Papel Higiénico Familia 12 rollos'), ('Papel Higiénico Suave 18 rollos'),
('Servilletas Elite 200u'), ('Toalla de Cocina Elite MegaRoll'), ('Guantes de Limpieza Mapa Talla M'), ('Trapero Vileda Microfiber'),
('Balde Plástico Supermaxi 12L'), ('Escoba Virutex Suave'), ('Recogedor Plástico Mango Largo'), ('Cepillo para Baño Virutex'),
('Limpiador Vidrios Windex 500ml'), ('Pastillas Desinfectantes Pato Tanque 2u'), ('Desinfectante Pinesol Original 1.2L'), ('Ambientador Air Wick Aerosol 345ml'),
('Frazada Multiuso Virutex 3u'), ('Paños Húmedos Desinfectantes Clorox 30u'), ('Limpiador de Piso Poett Lavanda 900ml'), ('Purificador de Aire Glade Auto Sport');

DECLARE @NombresCuidado TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresCuidado VALUES
('Shampoo Sedal Ceramidas 400ml'), ('Acondicionador Sedal Ceramidas 400ml'), ('Shampoo Pantene Micelar 400ml'), ('Gel de Ducha Dove Original 500ml'),
('Jabón de Barra Rexona Cotton 3x90g'), ('Pasta Dental Colgate Total 12 150g'), ('Cepillo Dental Oral-B Indicator 2u'), ('Hilo Dental Oral-B Essential 50m'),
('Enjuague Bucal Listerine Cool Mint 500ml'), ('Desodorante Rexona Clinical 48g'), ('Desodorante Dove Original 50ml'), ('Crema Corporal Nivea Soft 200ml'),
('Bloqueador Solar Nivea Sun FPS50 125ml'), ('Crema Facial Pond''s Rejuveness 100g'), ('Maquinillas Gillette Prestobarba3 4u'), ('Espuma de Afeitar Gillette 250ml'),
('Toallas Sanitarias Kotex Nocturna 10u'), ('Toallas Sanitarias Always Ultrafina 12u'), ('Protectores Diarios Carefree 40u'), ('Shampoo Johnson''s Baby Manzanilla 400ml'),
('Jabón Líquido Huggies Recién Nacido 400ml'), ('Pañales Huggies Natural Care G 40u'), ('Pañales Pampers Premium Care M 40u'), ('Toallitas Húmedas Huggies Aloe 96u'),
('Crema Protectora Desitin 57g'), ('Talco Johnson''s Baby 200g'), ('Aceite Johnson''s Baby 200ml'), ('Gel Antibacterial Lifebuoy 250ml'),
('Alcohol Antiséptico Superior 500ml'), ('Vendas Nexcare 10u'), ('Vitaminas Centrum Hombre 60u'), ('Vitaminas Centrum Mujer 60u'),
('Termómetro Digital Omron MC246'), ('Mascarilla KN95 Pack 10u'), ('Toallas Húmedas Kleenex Antibacterial 60u'), ('Crema de Manos Neutrogena 56g'),
('Bálsamo Labial Chapstick Cereza 4g'), ('Tinte para Cabello L''Oreal Casting 5.0'), ('Removedor de Esmalte Vogue 120ml'), ('Esmalte de Uñas Valmy Rojo 10ml');

-- Insertar 200 productos (40 por categoria)
WHILE @i <= 200
BEGIN
    -- Determinar categoria (40 productos por categoria)
    SET @CategoriaID = ((@i - 1) / 40) + 1;
    IF @CategoriaID > 5 SET @CategoriaID = 5;
    
    -- Proveedor aleatorio entre 1 y 10
    SET @ProveedorID = ((@i % 10) + 1);
    
    -- Precio aleatorio entre 5 y 500
    SET @Precio = CAST(5 + (RAND(CHECKSUM(NEWID())) * 495) AS DECIMAL(18,2));
    
    -- IVA: primeros 100 productos con 15%, siguientes 100 con 0%
    SET @IVA = CASE WHEN @i <= 100 THEN 15.00 ELSE 0.00 END;
    
    -- Codigo del producto
    SET @Codigo = 'PROD' + RIGHT('000' + CAST(@i AS VARCHAR), 3);
    
    -- Nombre segun categoria
    SET @Nombre = CASE @CategoriaID
        WHEN 1 THEN (SELECT Nombre FROM @NombresDespensa WHERE ID = ((@i - 1) % 40) + 1)
        WHEN 2 THEN (SELECT Nombre FROM @NombresLacteos WHERE ID = ((@i - 1) % 40) + 1)
        WHEN 3 THEN (SELECT Nombre FROM @NombresBebidasSnacks WHERE ID = ((@i - 1) % 40) + 1)
        WHEN 4 THEN (SELECT Nombre FROM @NombresLimpieza WHERE ID = ((@i - 1) % 40) + 1)
        WHEN 5 THEN (SELECT Nombre FROM @NombresCuidado WHERE ID = ((@i - 1) % 40) + 1)
    END;
    
    -- Agregar sufijo si es necesario para evitar duplicados
    IF @i > 40 
        SET @Nombre = @Nombre + ' v' + CAST((@i / 40) + 1 AS VARCHAR);
    
    INSERT INTO dbo.Producto (Codigo, Nombre, CategoriaID, ProveedorID, PrecioUnitario, PorcentajeIVA, Stock)
    VALUES (@Codigo, @Nombre, @CategoriaID, @ProveedorID, @Precio, @IVA, 1000);
    
    SET @i = @i + 1;
END;
GO

PRINT '   200 productos insertados (100 con IVA 15%, 100 con IVA 0%).';

-- ============================================================================
-- 7. PEDIDOS Y DETALLES (100,000 pedidos con 3-10 productos cada uno)
-- ============================================================================

PRINT '[7/7] Insertando Pedidos y Detalles (100,000 pedidos)...';
PRINT '   Este proceso tomara varios minutos...';

-- Crear tabla temporal para productos
SELECT ProductoID, PrecioUnitario, PorcentajeIVA 
INTO #TempProductos 
FROM dbo.Producto;

-- Variables para el bucle
DECLARE @PedidoID INT;
DECLARE @NumPedido NVARCHAR(20);
DECLARE @FechaPedido DATE;
DECLARE @ClienteID INT;
DECLARE @EmpleadoID INT;
DECLARE @ModalidadID INT;
DECLARE @NumProductos INT;
DECLARE @SubtotalPedido DECIMAL(18,2);
DECLARE @IVAPedido DECIMAL(18,2);
DECLARE @TotalPedido DECIMAL(18,2);

DECLARE @j INT;
DECLARE @ProductoID INT;
DECLARE @Cantidad INT;
DECLARE @PrecioUnit DECIMAL(18,2);
DECLARE @IVAProd DECIMAL(5,2);
DECLARE @SubtotalDet DECIMAL(18,2);
DECLARE @IVADet DECIMAL(18,2);
DECLARE @TotalDet DECIMAL(18,2);

-- Fechas limite
DECLARE @FechaInicio DATE = '2020-01-01';
DECLARE @FechaFin DATE = '2025-12-31';
DECLARE @DiasRango INT = DATEDIFF(DAY, @FechaInicio, @FechaFin);

-- Contadores para progreso
DECLARE @Contador INT = 0;
DECLARE @Lote INT = 10000;

SET @i = 1;
WHILE @i <= 100000
BEGIN
    -- Generar datos aleatorios para el pedido
    SET @NumPedido = 'PED' + RIGHT('000000' + CAST(@i AS VARCHAR), 6);
    SET @FechaPedido = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % @DiasRango, @FechaInicio);
    SET @ClienteID = (ABS(CHECKSUM(NEWID())) % 20) + 1;
    SET @EmpleadoID = (ABS(CHECKSUM(NEWID())) % 5) + 1;
    SET @ModalidadID = (ABS(CHECKSUM(NEWID())) % 7) + 1;
    SET @NumProductos = 3 + (ABS(CHECKSUM(NEWID())) % 8); -- 3 a 10 productos
    
    -- Insertar cabecera del pedido
    INSERT INTO dbo.Pedido (NumeroPedido, Fecha, ClienteID, EmpleadoID, ModalidadPagoID, Estado)
    VALUES (@NumPedido, @FechaPedido, @ClienteID, @EmpleadoID, @ModalidadID, 'COMPLETADO');
    
    SET @PedidoID = SCOPE_IDENTITY();
    
    -- Inicializar totales
    SET @SubtotalPedido = 0;
    SET @IVAPedido = 0;
    SET @TotalPedido = 0;
    
    -- Insertar detalles del pedido
    SET @j = 1;
    WHILE @j <= @NumProductos
    BEGIN
        -- Seleccionar producto aleatorio
        SET @ProductoID = (ABS(CHECKSUM(NEWID())) % 200) + 1;
        SET @Cantidad = 1 + (ABS(CHECKSUM(NEWID())) % 50); -- 1 a 50 unidades
        
        -- Obtener precio e IVA del producto
        SELECT @PrecioUnit = PrecioUnitario, @IVAProd = PorcentajeIVA
        FROM #TempProductos WHERE ProductoID = @ProductoID;
        
        -- Calcular montos
        SET @SubtotalDet = @PrecioUnit * @Cantidad;
        SET @IVADet = @SubtotalDet * (@IVAProd / 100);
        SET @TotalDet = @SubtotalDet + @IVADet;
        
        -- Insertar detalle
        INSERT INTO dbo.DetallePedido (PedidoID, ProductoID, Cantidad, PrecioUnitario, PorcentajeIVA, Subtotal, MontoIVA, Total)
        VALUES (@PedidoID, @ProductoID, @Cantidad, @PrecioUnit, @IVAProd, @SubtotalDet, @IVADet, @TotalDet);
        
        -- Acumular totales
        SET @SubtotalPedido = @SubtotalPedido + @SubtotalDet;
        SET @IVAPedido = @IVAPedido + @IVADet;
        SET @TotalPedido = @TotalPedido + @TotalDet;
        
        SET @j = @j + 1;
    END;
    
    -- Actualizar totales del pedido
    UPDATE dbo.Pedido 
    SET Subtotal = @SubtotalPedido,
        TotalIVA = @IVAPedido,
        Total = @TotalPedido
    WHERE PedidoID = @PedidoID;
    
    -- Mostrar progreso cada 10,000 registros
    SET @Contador = @Contador + 1;
    IF @Contador % @Lote = 0
        PRINT '   Procesados: ' + CAST(@Contador AS VARCHAR) + ' pedidos...';
    
    SET @i = @i + 1;
END;

-- Limpiar tabla temporal
DROP TABLE #TempProductos;
GO

PRINT '   100,000 pedidos insertados con sus detalles.';
PRINT '';

-- ============================================================================
-- VERIFICACION FINAL DE DATOS
-- ============================================================================

PRINT '============================================================================';
PRINT 'RESUMEN DE DATOS INSERTADOS';
PRINT '============================================================================';
PRINT '';

SELECT 'Categoria' AS Tabla, COUNT(*) AS Registros FROM dbo.Categoria
UNION ALL SELECT 'Proveedor', COUNT(*) FROM dbo.Proveedor
UNION ALL SELECT 'Empleado', COUNT(*) FROM dbo.Empleado
UNION ALL SELECT 'Cliente', COUNT(*) FROM dbo.Cliente
UNION ALL SELECT 'ModalidadPago', COUNT(*) FROM dbo.ModalidadPago
UNION ALL SELECT 'Producto', COUNT(*) FROM dbo.Producto
UNION ALL SELECT 'Pedido', COUNT(*) FROM dbo.Pedido
UNION ALL SELECT 'DetallePedido', COUNT(*) FROM dbo.DetallePedido
ORDER BY Tabla;

PRINT '';
PRINT '>> Distribucion de Productos por IVA:';
SELECT 
    CASE WHEN PorcentajeIVA = 15 THEN 'IVA 15%' ELSE 'IVA 0%' END AS TipoIVA,
    COUNT(*) AS Cantidad
FROM dbo.Producto
GROUP BY PorcentajeIVA;

PRINT '';
PRINT '>> Rango de Fechas de Pedidos:';
SELECT 
    MIN(Fecha) AS FechaMinima, 
    MAX(Fecha) AS FechaMaxima,
    COUNT(DISTINCT YEAR(Fecha)) AS AniosDiferentes
FROM dbo.Pedido;

PRINT '';
PRINT '>> Promedio de productos por pedido:';
SELECT 
    AVG(CAST(NumProductos AS DECIMAL(10,2))) AS PromedioProductosPorPedido
FROM (
    SELECT PedidoID, COUNT(*) AS NumProductos
    FROM dbo.DetallePedido
    GROUP BY PedidoID
) t;

PRINT '';
PRINT '============================================================================';
PRINT 'CARGA DE DATOS COMPLETADA EXITOSAMENTE';
PRINT '============================================================================';
GO
