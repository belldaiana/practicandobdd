-- 1) Empleados
-- a) Crear un SP que liste los apellidos y nombres de los empleados ordenados alfabéticamente.
DELIMITER $$
CREATE PROCEDURE sp_listar()
BEGIN
	SELECT Nombre, Apellido FROM empleados
    ORDER BY Apellido, Nombre;
END $$

-- b) Invocar el SP para verificar el resultado.
CALL sp_listar();

-- 2) Empleados por ciudad
-- a) Crear un SP que reciba el nombre de una ciudad y liste los empleados de esa ciudad.
DELIMITER $$
CREATE PROCEDURE sp_empleadosciudad (IN filtroCiudad VARCHAR(15))
BEGIN
	SELECT Nombre, Apellido, Ciudad FROM empleados
    WHERE Ciudad = filtroCiudad;
END $$

-- b) Invocar al SP para listar los empleados de Seattle.
CALL sp_empleadosciudad('Seattle');

-- 3) Clientes por país
-- a) Crear un SP que reciba el nombre de un país y devuelva la cantidad de clientes en ese país.
DELIMITER $$
CREATE PROCEDURE sp_clientespais (IN filtroPais VARCHAR(15), OUT cantidad INT)
BEGIN
	SELECT COUNT(*) INTO cantidad FROM clientes
    WHERE Pais = filtroPais;
END $$

-- b) Invocar el SP para consultar la cantidad de clientes en Portugal.
CALL sp_clientespais('Portugal', @cant_Portugal);
SELECT @cant_Portugal;

-- 4) Productos sin stock
-- a) Crear un SP que reciba un número y liste los productos cuyo stock está por debajo de ese número. 
-- El resultado debe mostrar el nombre del producto, el stock actual y el nombre de la categoría a la que pertenece el producto.
DELIMITER $$
CREATE PROCEDURE sp_productSinStock (IN numero INT)
BEGIN
	SELECT p.ProductoNombre, p.UnidadesStock, c.CategoriaNombre FROM productos p
    INNER JOIN categorias c ON c.CategoriaID = p.CategoriaID
    WHERE p.UnidadesStock < numero;
END $$

-- b) Listar los productos con menos de 10 unidades en stock.
CALL sp_productSinStock(10);

-- c) Listar los productos sin stock.
CALL sp_productSinStock(1);

-- 5) Ventas con descuento
-- a) Crear un SP que reciba un porcentaje y liste los nombres de los productos que hayan sido vendidos con un descuento igual o superior 
-- al valor indicado, indicando además el nombre del cliente al que se lo vendió.
DELIMITER $$
CREATE PROCEDURE sp_ventasConDescuento (IN porcentaje INT)
BEGIN
	SELECT p.ProductoNombre, c.Contacto, fd.Descuento FROM productos p
    INNER JOIN facturadetalle fd ON fd.ProductoID = p.ProductoID
    INNER JOIN facturas f ON f.FacturaID = fd.FacturaID
    INNER JOIN clientes c ON f.ClienteID = c.ClienteID
    WHERE fd.Descuento >= (porcentaje/100);
END $$

-- b) Listar la información de los productos que hayan sido vendidos con un
-- descuento mayor al 10%.
CALL sp_ventasConDescuento(10);