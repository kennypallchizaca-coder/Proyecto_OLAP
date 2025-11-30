-- ==========================================================
-- PARTE 2: ESQUEMA TRANSACCIONAL (OLTP) - SISTEMA DE PEDIDOS
-- ==========================================================

CREATE TABLE Categoria (
    CategoriaID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nombre VARCHAR2(100)
);

CREATE TABLE Proveedor (
    ProveedorID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nombre      VARCHAR2(100),
    Pais        VARCHAR2(50),
    Ciudad      VARCHAR2(50)
);

CREATE TABLE Empleado (
    EmpleadoID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nombre     VARCHAR2(100),
    Cargo      VARCHAR2(50)
);

CREATE TABLE Cliente (
    ClienteID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nombre    VARCHAR2(100),
    Pais      VARCHAR2(50),
    Ciudad    VARCHAR2(50),
    Email     VARCHAR2(100)
);

CREATE TABLE ModalidadPago (
    ModalidadPagoID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Descripcion     VARCHAR2(50),  -- Efectivo, Transferencia, Tarjeta
    Cuotas          NUMBER DEFAULT 0
);

CREATE TABLE Producto (
    ProductoID    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Nombre        VARCHAR2(100),
    Precio        NUMBER(10,2),
    PorcentajeIVA NUMBER(5,2) CHECK (PorcentajeIVA IN (0, 15)),
    CategoriaID   NUMBER,
    ProveedorID   NUMBER,
    CONSTRAINT fk_producto_categoria FOREIGN KEY (CategoriaID)
        REFERENCES Categoria(CategoriaID),
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (ProveedorID)
        REFERENCES Proveedor(ProveedorID)
);

CREATE TABLE Pedido (
    PedidoID        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Fecha           DATE CHECK (Fecha BETWEEN DATE '2020-01-01' AND DATE '2025-12-31'),
    ClienteID       NUMBER,
    EmpleadoID      NUMBER,
    ModalidadPagoID NUMBER,
    
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (ClienteID)
        REFERENCES Cliente(ClienteID),
    CONSTRAINT fk_pedido_empleado FOREIGN KEY (EmpleadoID)
        REFERENCES Empleado(EmpleadoID),
    CONSTRAINT fk_pedido_modalidad FOREIGN KEY (ModalidadPagoID)
        REFERENCES ModalidadPago(ModalidadPagoID)
);


CREATE TABLE DetallePedido (
    DetalleID      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    PedidoID       NUMBER,
    ProductoID     NUMBER,
    Cantidad       NUMBER CHECK (Cantidad BETWEEN 1 AND 50),
    PrecioUnitario NUMBER(10,2),
    MontoIVA       NUMBER(10,2),

    CONSTRAINT fk_detalle_pedido FOREIGN KEY (PedidoID)
        REFERENCES Pedido(PedidoID),

    CONSTRAINT fk_detalle_producto FOREIGN KEY (ProductoID)
        REFERENCES Producto(ProductoID)
);

