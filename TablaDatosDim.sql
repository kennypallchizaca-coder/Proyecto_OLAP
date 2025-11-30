-- 1. Insertar Datos Maestros Estáticos

-- Categorías (5)
INSERT INTO Categoria (Nombre) VALUES ('Electrónica');
INSERT INTO Categoria (Nombre) VALUES ('Hogar');
INSERT INTO Categoria (Nombre) VALUES ('Ropa');
INSERT INTO Categoria (Nombre) VALUES ('Deportes');
INSERT INTO Categoria (Nombre) VALUES ('Juguetes');


-- Modalidades de Pago (Incluyendo cuotas)
INSERT INTO ModalidadPago (Descripcion, Cuotas) VALUES ('Efectivo', 0);
INSERT INTO ModalidadPago (Descripcion, Cuotas) VALUES ('Transferencia', 0);
INSERT INTO ModalidadPago (Descripcion, Cuotas) VALUES ('Tarjeta de Crédito', 1);
INSERT INTO ModalidadPago (Descripcion, Cuotas) VALUES ('Tarjeta de Crédito', 3);
INSERT INTO ModalidadPago (Descripcion, Cuotas) VALUES ('Tarjeta de Crédito', 6);
INSERT INTO ModalidadPago (Descripcion, Cuotas) VALUES ('Tarjeta de Crédito', 12);

-- 2. Insertar Datos Maestros Pequeños (Bucles simples)

-- 10 Proveedores
DECLARE
    -- Lista de 10 nombres de proveedores distintos
    TYPE ListaNombres IS VARRAY(10) OF VARCHAR2(50);
    proveedores ListaNombres := ListaNombres(
        'TecnoGlobal S.A.',
        'Distribuidora Andina',
        'MegaSupply Ecuador',
        'ElectroWorld Import',
        'HogarPlus Distribuciones',
        'ModaExpress Proveedores',
        'SportsLine Corp.',
        'Juguetelandia Importaciones',
        'Proveedora Industrial del Sur',
        'Comercial Multiventas'
    );
BEGIN
    FOR i IN 1..proveedores.COUNT LOOP
        INSERT INTO Proveedor (Nombre, Pais, Ciudad)
        VALUES (
            proveedores(i),
            'Ecuador',
            CASE 
                WHEN MOD(i, 2) = 0 THEN 'Quito'
                ELSE 'Guayaquil'
            END
        );
    END LOOP;
END;
/

-- 5 Empleados
BEGIN
    INSERT INTO Empleado (Nombre, Cargo) VALUES ('Carlos Pérez', 'Asesor Comercial');
    INSERT INTO Empleado (Nombre, Cargo) VALUES ('María Gómez', 'Asesor Comercial');
    INSERT INTO Empleado (Nombre, Cargo) VALUES ('Luis Andrade', 'Asesor Comercial');
    INSERT INTO Empleado (Nombre, Cargo) VALUES ('Fernanda Torres', 'Asesor Comercial');
    INSERT INTO Empleado (Nombre, Cargo) VALUES ('Jorge Castillo', 'Asesor Comercial');
END;
/

-- 20 Clientes
BEGIN
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Carlos Pérez',     'Ecuador', 'Quito',      'carlos.perez@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('María González',   'Ecuador', 'Guayaquil',  'maria.gonzalez@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Luis Torres',      'Ecuador', 'Cuenca',     'luis.torres@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Fernanda López',   'Ecuador', 'Quito',      'fernanda.lopez@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('José Andrade',     'Ecuador', 'Guayaquil',  'jose.andrade@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Ana Castillo',     'Ecuador', 'Cuenca',     'ana.castillo@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Pedro Romero',     'Ecuador', 'Quito',      'pedro.romero@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Diana Cárdenas',   'Ecuador', 'Guayaquil',  'diana.cardenas@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Jorge Mena',       'Ecuador', 'Cuenca',     'jorge.mena@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Verónica Silva',   'Ecuador', 'Quito',      'veronica.silva@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Ricardo Paredes',  'Ecuador', 'Guayaquil',  'ricardo.paredes@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Andrea Molina',    'Ecuador', 'Cuenca',     'andrea.molina@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Daniel Vargas',    'Ecuador', 'Quito',      'daniel.vargas@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Gabriela Reyes',   'Ecuador', 'Guayaquil',  'gabriela.reyes@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Esteban Salazar',  'Ecuador', 'Cuenca',     'esteban.salazar@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Paola Almeida',    'Ecuador', 'Quito',      'paola.almeida@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Felipe Morales',   'Ecuador', 'Guayaquil',  'felipe.morales@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Sofía Rivas',      'Ecuador', 'Cuenca',     'sofia.rivas@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Héctor Cabrera',   'Ecuador', 'Quito',      'hector.cabrera@mail.com');
    INSERT INTO Cliente (Nombre, Pais, Ciudad, Email) VALUES ('Lorena Medina',    'Ecuador', 'Guayaquil',  'lorena.medina@mail.com');
END;
/


-- ===========================
-- LISTA DE LOS 200 PRODUCTOS
-- ===========================
DECLARE
    TYPE lista_productos IS TABLE OF VARCHAR2(200);
    productos lista_productos := lista_productos(
        'Arroz Supremo 1kg',
        'Azúcar Refinada 1kg',
        'Aceite de Girasol 900ml',
        'Fideos Spaghetti Clásicos',
        'Atún en Agua 140g',
        'Leche Entera UHT 1L',
        'Café Molido Premium 200g',
        'Té Negro en Sobres',
        'Galletas de Chocolate',
        'Pan de Molde Integral',
        'Yogurt Natural 1L',
        'Queso Mozzarella 250g',
        'Mantequilla Tradicional',
        'Jamón de Pavo 200g',
        'Sal Refinada 1kg',
        'Harina de Trigo 1kg',
        'Cereal de Maíz',
        'Jugo de Naranja 1L',
        'Agua Mineral 500ml',
        'Chocolate Negro 70%',
        'Salsa de Tomate 400g',
        'Mayonesa Clásica 200g',
        'Mostaza Americana',
        'Avena Instantánea',
        'Frijoles Negros 400g',
        'Gaseosa Cola 1.5L',
        'Bebida Energética 473ml',
        'Mermelada de Fresa',
        'Galletas de Sal',
        'Chicles de Menta',
        'Papas Fritas Clásicas',
        'Cacahuates Tostados',
        'Barras de Granola',
        'Sopas Instantáneas',
        'Vinagre Blanco 1L',
        'Sazonador Universal',
        'Helado de Vainilla 1L',
        'Salsa BBQ Original',
        'Snacks de Queso',
        'Galletas de Avena',
        'Mouse Óptico USB',
        'Teclado Mecánico Gamer',
        'Audífonos Bluetooth',
        'Memoria USB 32GB',
        'Disco SSD 480GB',
        'Monitor LED 24"',
        'Cargador Universal USB',
        'Cable HDMI 2m',
        'Parlante Bluetooth Portátil',
        'Power Bank 10,000mAh',
        'Router WiFi Doble Banda',
        'Adaptador USB WiFi',
        'Cámara Web HD',
        'Teclado Inalámbrico',
        'Mouse Gamer RGB',
        'Bocinas Multimedia 2.1',
        'Lámpara LED USB',
        'Smartwatch Deportivo',
        'Audífonos In-Ear',
        'Teclado para Tablet',
        'Protector de Pantalla',
        'Memoria SD 64GB',
        'Mouse Pad Antideslizante',
        'Hub USB 4 Puertos',
        'Soporte para Laptop',
        'Ventilador USB',
        'Mini Proyector Portátil',
        'Cable USB-C 1m',
        'Cargador Rápido 20W',
        'Auriculares Over-Ear',
        'Repetidor WiFi',
        'Lámpara Inteligente',
        'Webcam Full HD',
        'Disco Duro Externo 1TB',
        'Mini Parlante USB',
        'Mouse Inalámbrico',
        'Calculadora Científica',
        'Teclado para Smart TV',
        'Adaptador de Corriente',
        'Linterna LED Recargable',
        'Detergente Líquido 1L',
        'Jabón para Platos 500ml',
        'Suavizante de Ropa 1L',
        'Ambientador de Lavanda',
        'Escoba de Cerdas Suaves',
        'Trapeador Microfibra',
        'Cubeta Plástica 10L',
        'Guantes de Limpieza',
        'Bolsa para Basura 30L',
        'Esponja Antigrasa',
        'Limpiavidrios 500ml',
        'Limpiador Multiusos',
        'Cloro Desinfectante 1L',
        'Toallas de Cocina',
        'Detergente en Polvo 1kg',
        'Cepillo de Baño',
        'Jabón Líquido 400ml',
        'Shampoo Familiar 1L',
        'Pasta Dental 100ml',
        'Enjuague Bucal 500ml',
        'Protector Solar SPF50',
        'Crema Humectante',
        'Papel Higiénico 12 rollos',
        'Pañuelos Descartables',
        'Afeitadora Desechable',
        'Esponja de Baño',
        'Desodorante en Barra',
        'Alcohol Antiséptico 70%',
        'Algodón Hidrófilo',
        'Termómetro Digital',
        'Toallas Húmedas',
        'Servilletas Blancas',
        'Cepillo para Botellas',
        'Repelente de Insectos',
        'Incienso de Sándalo',
        'Foco LED 10W',
        'Extensión Eléctrica 3m',
        'Cortina de Baño',
        'Almohada Ortopédica',
        'Juego de Sábanas Queen',
        'Martillo de Acero',
        'Destornillador de Estrella',
        'Llave Ajustable 10"',
        'Cinta Métrica 5m',
        'Caja de Tornillos',
        'Taladro Eléctrico',
        'Llave Allen Set',
        'Sierra Manual',
        'Pegamento Instantáneo',
        'Cinta Aislante Negra',
        'Brochas para Pintura',
        'Lija de Agua 120',
        'Pintura Blanca 1 Galón',
        'Masilla Profesional',
        'Guantes de Seguridad',
        'Lentes Protectores',
        'Mascarilla Industrial',
        'Cutter Profesional',
        'Caja de Herramientas',
        'Alicates de Corte',
        'Llave de Tubo',
        'Pistola de Silicona',
        'Silicona Transparente',
        'Tornillos para Madera',
        'Clavos de Acero',
        'Taladro Inalámbrico',
        'Brocas para Metal',
        'Flexómetro 3m',
        'Cuchilla de Repuesto',
        'Nivel de Burbuja',
        'Cuaderno Universitario',
        'Lápiz HB',
        'Esfero Azul',
        'Marcador Permanente',
        'Corrector Líquido',
        'Regla de 30cm',
        'Carpeta de Cartón',
        'Archivador Metálico',
        'Tijeras Escolares',
        'Pegamento en Barra',
        'Resaltadores Fluorescentes',
        'Hoja Bond A4 500 hojas',
        'Libreta de Notas',
        'Rotulador Negro',
        'Juego de Colores',
        'Papel Lustre',
        'Cinta Scotch',
        'Clips Metálicos',
        'Grapas Universales',
        'Perforadora 2 Huecos',
        'Engrapadora Metálica',
        'Témperas Escolares',
        'Cartulina Blanca',
        'Pinceles Finos',
        'Tinta para Impresora',
        'Carpeta Plástica',
        'Borrador Blanco',
        'Lápiz de Color Rojo',
        'Fólder Manila',
        'Marcador de Pizarra Azul',
        'Libro de Actas',
        'Bloc de Dibujo',
        'Calculadora Básica',
        'Notas Adhesivas',
        'Sobre de Papel',
        'Agenda 2025',
        'Sellador de Bolsas',
        'Regla Metálica',
        'Separadores de Cartón',
        'Folder con Broche'
    );
BEGIN
    FOR i IN 1..productos.COUNT LOOP
        INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID)
        VALUES (
            productos(i),
            TRUNC(DBMS_RANDOM.VALUE(5, 120), 2),
            CASE WHEN i <= 100 THEN 15 ELSE 0 END,
            TRUNC(DBMS_RANDOM.VALUE(1, 6)),
            TRUNC(DBMS_RANDOM.VALUE(1, 11))
        );
    END LOOP;
END;
/

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Café Instantáneo Premium 100g', 12.50, 15, 2, 3);

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Teclado Retroiluminado USB', 28.90, 15, 4, 7);

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Jabón Antibacterial 500ml', 3.80, 15, 5, 1);

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Cereal Integral con Miel 500g', 5.60, 15, 1, 4);

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Audífonos Inalámbricos Sport', 34.99, 15, 4, 6);

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Botella Deportiva 1L', 4.50, 0, 3, 8);

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Salsa Picante Extra Fuerte 150ml', 2.30, 15, 1, 2);

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Lampara LED de Escritorio Recargable', 16.90, 15, 4, 5);

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Peluche de Blaziken pequeño', 6.25, 15, 5, 9);

INSERT INTO Producto (Nombre, Precio, PorcentajeIVA, CategoriaID, ProveedorID) VALUES
('Toallas Faciales de Microfibra', 3.99, 15, 2, 10);



-- 4. Generación Masiva de 100,000 Pedidos

DECLARE
    v_total_pedidos   NUMBER := 100000;
    v_pedido_id       NUMBER;
    v_num_productos   NUMBER;
    v_fecha           DATE;
    v_prod_id         NUMBER;
    v_cant            NUMBER;
    v_precio          NUMBER(10,2);
    v_iva_pct         NUMBER(5,2);
BEGIN
    FOR i IN 1..100000 LOOP
        
        v_fecha :=
            DATE '2020-01-01' +
            TRUNC(DBMS_RANDOM.VALUE(0, 2190));

        INSERT INTO Pedido (Fecha, ClienteID, EmpleadoID, ModalidadPagoID)
        VALUES (
            v_fecha,
            TRUNC(DBMS_RANDOM.VALUE(1, 21)),
            TRUNC(DBMS_RANDOM.VALUE(1, 6)),
            TRUNC(DBMS_RANDOM.VALUE(1, 7))
        )
        RETURNING PedidoID INTO v_pedido_id;

        v_num_productos := TRUNC(DBMS_RANDOM.VALUE(3, 11));

        FOR p IN 1..v_num_productos LOOP
            
            -- Obtener PRODUCTO ALEATORIO válido
            SELECT ProductoID
            INTO v_prod_id
            FROM (
                SELECT ProductoID 
                FROM Producto
                ORDER BY DBMS_RANDOM.VALUE
            )
            WHERE ROWNUM = 1;

            v_cant := TRUNC(DBMS_RANDOM.VALUE(1, 51));

            SELECT Precio, PorcentajeIVA 
            INTO v_precio, v_iva_pct
            FROM Producto
            WHERE ProductoID = v_prod_id;

            INSERT INTO DetallePedido (PedidoID, ProductoID, Cantidad, PrecioUnitario, MontoIVA)
            VALUES (
                v_pedido_id,
                v_prod_id,
                v_cant,
                v_precio,
                (v_precio * v_cant) * (v_iva_pct / 100)
            );

        END LOOP;

        IF MOD(i, 10000) = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Pedidos generados: ' || i);
        END IF;

    END LOOP;

END;
/
