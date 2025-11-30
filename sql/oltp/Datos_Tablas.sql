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
('CAT01', 'Electronica', 'Dispositivos electronicos, computadores, celulares y accesorios'),
('CAT02', 'Hogar', 'Articulos para el hogar, muebles y decoracion'),
('CAT03', 'Alimentos', 'Productos alimenticios, bebidas y snacks'),
('CAT04', 'Ropa', 'Vestimenta, calzado y accesorios de moda'),
('CAT05', 'Deportes', 'Articulos deportivos, equipos y accesorios fitness');
GO

PRINT '   5 categorias insertadas.';

-- ============================================================================
-- 2. PROVEEDORES (10 requeridos)
-- ============================================================================

PRINT '[2/7] Insertando Proveedores...';

INSERT INTO dbo.Proveedor (Codigo, Nombre, NombreContacto, Telefono, Email, Ciudad, Pais) VALUES
('PROV01', 'TechDistribuidores S.A.', 'Carlos Mendoza', '0991234567', 'ventas@techdist.com', 'Quito', 'Ecuador'),
('PROV02', 'ElectroImport Cia. Ltda.', 'Maria Garcia', '0992345678', 'info@electroimport.com', 'Guayaquil', 'Ecuador'),
('PROV03', 'Hogar y Decoracion S.A.', 'Juan Perez', '0993456789', 'contacto@hogardeco.com', 'Cuenca', 'Ecuador'),
('PROV04', 'Muebles del Ecuador', 'Ana Torres', '0994567890', 'ventas@mueblesec.com', 'Quito', 'Ecuador'),
('PROV05', 'Alimentos Frescos S.A.', 'Pedro Ramirez', '0995678901', 'pedidos@alimentosfrescos.com', 'Guayaquil', 'Ecuador'),
('PROV06', 'Distribuidora Nacional', 'Laura Sanchez', '0996789012', 'info@distnacional.com', 'Manta', 'Ecuador'),
('PROV07', 'Moda Express Cia. Ltda.', 'Roberto Flores', '0997890123', 'ventas@modaexpress.com', 'Quito', 'Ecuador'),
('PROV08', 'Textiles Andinos S.A.', 'Carmen Lopez', '0998901234', 'comercial@textilesandinos.com', 'Cuenca', 'Ecuador'),
('PROV09', 'DeporTotal S.A.', 'Miguel Herrera', '0999012345', 'info@deportotal.com', 'Guayaquil', 'Ecuador'),
('PROV10', 'Fitness Equipment Cia.', 'Sofia Castillo', '0990123456', 'ventas@fitnessequip.com', 'Quito', 'Ecuador');
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

-- Array de nombres de productos por categoria
DECLARE @NombresElectronica TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresElectronica VALUES 
('Laptop HP ProBook'), ('Laptop Dell Inspiron'), ('Laptop Lenovo ThinkPad'), ('MacBook Air'),
('Monitor Samsung 24"'), ('Monitor LG 27"'), ('Monitor Dell 22"'), ('Monitor Asus 32"'),
('Teclado Logitech'), ('Teclado Razer'), ('Mouse Inalambrico'), ('Mouse Gamer'),
('Audifonos Sony'), ('Audifonos JBL'), ('Parlante Bluetooth'), ('Webcam HD'),
('Disco Duro Externo 1TB'), ('SSD 500GB'), ('Memoria USB 64GB'), ('Hub USB'),
('Tablet Samsung'), ('Tablet iPad'), ('Smartphone Samsung'), ('Smartphone Xiaomi'),
('Cargador Universal'), ('Cable HDMI'), ('Adaptador USB-C'), ('Power Bank 10000mAh'),
('Router WiFi'), ('Switch de Red'), ('Impresora HP'), ('Escaner Epson'),
('Proyector Epson'), ('Camara Web Logitech'), ('Microfono USB'), ('UPS 1000VA'),
('Tarjeta Grafica RTX'), ('Procesador Intel i7'), ('Memoria RAM 16GB'), ('Placa Madre Asus');

DECLARE @NombresHogar TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresHogar VALUES
('Sofa 3 Puestos'), ('Sillon Reclinable'), ('Mesa de Centro'), ('Mesa de Comedor'),
('Silla de Comedor'), ('Cama Queen'), ('Cama King'), ('Colchon Ortopedico'),
('Armario 3 Puertas'), ('Comoda 5 Cajones'), ('Escritorio Ejecutivo'), ('Silla de Oficina'),
('Lampara de Pie'), ('Lampara de Mesa'), ('Cortinas Blackout'), ('Alfombra Grande'),
('Espejo Decorativo'), ('Cuadro Decorativo'), ('Reloj de Pared'), ('Florero Ceramica'),
('Juego de Sabanas'), ('Edredon Queen'), ('Almohada Memory'), ('Toalla Set'),
('Vajilla 24 Piezas'), ('Juego de Ollas'), ('Sarten Antiadherente'), ('Licuadora Oster'),
('Microondas LG'), ('Tostadora'), ('Cafetera Nespresso'), ('Hervidor Electrico'),
('Aspiradora Robot'), ('Plancha de Ropa'), ('Ventilador de Pie'), ('Aire Acondicionado'),
('Organizador Closet'), ('Perchero de Pie'), ('Zapatero'), ('Basurero Automatico');

DECLARE @NombresAlimentos TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresAlimentos VALUES
('Arroz Premium 5kg'), ('Azucar Blanca 2kg'), ('Aceite Vegetal 1L'), ('Sal de Mesa 1kg'),
('Fideos Spaghetti 500g'), ('Fideos Tornillo 500g'), ('Harina de Trigo 1kg'), ('Avena 500g'),
('Leche Entera 1L'), ('Leche Descremada 1L'), ('Yogurt Natural 1L'), ('Queso Fresco 500g'),
('Mantequilla 250g'), ('Huevos Docena'), ('Pan de Molde'), ('Galletas Surtidas'),
('Cafe Molido 500g'), ('Te Verde Caja'), ('Chocolate en Polvo'), ('Cereal Integral'),
('Atun en Lata'), ('Sardinas en Lata'), ('Pollo Entero'), ('Carne Molida 1kg'),
('Jamon de Pavo'), ('Salchichas'), ('Mortadela'), ('Queso Mozzarella'),
('Manzanas 1kg'), ('Bananas 1kg'), ('Naranjas 1kg'), ('Papas 2kg'),
('Tomates 1kg'), ('Cebolla 1kg'), ('Pimiento'), ('Zanahoria 1kg'),
('Agua Mineral 6L'), ('Gaseosa 3L'), ('Jugo Natural 1L'), ('Cerveza Pack 6');

DECLARE @NombresRopa TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresRopa VALUES
('Camisa Formal Hombre'), ('Camisa Casual Hombre'), ('Camiseta Basica'), ('Polo Deportivo'),
('Pantalon Jean Hombre'), ('Pantalon Formal'), ('Bermuda Casual'), ('Short Deportivo'),
('Blusa Mujer'), ('Vestido Casual'), ('Falda Midi'), ('Pantalon Jean Mujer'),
('Chaqueta Cuero'), ('Chompa Lana'), ('Sudadera Con Capucha'), ('Chaleco Acolchado'),
('Zapatos Formales'), ('Zapatos Casuales'), ('Zapatillas Deportivas'), ('Sandalias'),
('Cinturon Cuero'), ('Corbata Seda'), ('Bufanda'), ('Gorra Deportiva'),
('Cartera Mujer'), ('Mochila Escolar'), ('Maleta de Viaje'), ('Bolso Deportivo'),
('Ropa Interior Hombre'), ('Ropa Interior Mujer'), ('Medias Pack'), ('Pijama'),
('Traje Formal'), ('Vestido de Noche'), ('Abrigo Invierno'), ('Impermeable'),
('Gafas de Sol'), ('Reloj Casual'), ('Pulsera'), ('Collar');

DECLARE @NombresDeportes TABLE (ID INT IDENTITY(1,1), Nombre NVARCHAR(100));
INSERT INTO @NombresDeportes VALUES
('Balon de Futbol'), ('Balon de Basquet'), ('Balon de Voleibol'), ('Raqueta de Tenis'),
('Pesas 5kg Par'), ('Pesas 10kg Par'), ('Mancuernas Ajustables'), ('Barra Olimpica'),
('Banco de Pesas'), ('Caminadora Electrica'), ('Bicicleta Estatica'), ('Eliptica'),
('Colchoneta Yoga'), ('Banda Elastica Set'), ('Cuerda de Saltar'), ('Rueda Abdominal'),
('Guantes de Boxeo'), ('Saco de Boxeo'), ('Vendas Boxeo'), ('Protector Bucal'),
('Bicicleta Montana'), ('Casco Ciclismo'), ('Guantes Ciclismo'), ('Luces Bicicleta'),
('Carpa Camping 4P'), ('Sleeping Bag'), ('Linterna LED'), ('Termo 1L'),
('Pelota de Golf Set'), ('Palos de Golf'), ('Raqueta Badminton'), ('Red Voleibol'),
('Patines Linea'), ('Patineta'), ('Scooter'), ('Protecciones Set'),
('Cronometro Digital'), ('Pulsera Fitness'), ('Botella Deportiva'), ('Toalla Gym');

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
        WHEN 1 THEN (SELECT Nombre FROM @NombresElectronica WHERE ID = ((@i - 1) % 40) + 1)
        WHEN 2 THEN (SELECT Nombre FROM @NombresHogar WHERE ID = ((@i - 1) % 40) + 1)
        WHEN 3 THEN (SELECT Nombre FROM @NombresAlimentos WHERE ID = ((@i - 1) % 40) + 1)
        WHEN 4 THEN (SELECT Nombre FROM @NombresRopa WHERE ID = ((@i - 1) % 40) + 1)
        WHEN 5 THEN (SELECT Nombre FROM @NombresDeportes WHERE ID = ((@i - 1) % 40) + 1)
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
