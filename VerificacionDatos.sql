SELECT COUNT(*) FROM Dim_Tiempo;

SELECT COUNT(*) FROM Dim_Cliente;

SELECT COUNT(*) FROM Dim_Producto;

SELECT COUNT(*) FROM Dim_Empleado;

SELECT COUNT(*) FROM Dim_ModalidadPago;

SELECT COUNT(*) FROM Dim_Ubicacion;

SELECT COUNT(*) FROM Fact_Ventas;

SELECT *
FROM Fact_Ventas
WHERE UbicacionClienteID IS NULL
   OR UbicacionProveedorID IS NULL
   OR ProductoKey IS NULL
   OR ClienteKey IS NULL
   OR EmpleadoKey IS NULL
   OR ModalidadKey IS NULL;
   
SELECT 
    Cantidad, 
    MontoTotal, 
    MontoIVA, 
    MontoFinal
FROM Fact_Ventas
FETCH FIRST 10 ROWS ONLY;

