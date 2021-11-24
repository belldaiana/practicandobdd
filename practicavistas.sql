-- Vistas - Parte I
-- Clientes
-- 1. Crear una vista con los siguientes datos de los clientes: ID, contacto, y el Fax. En caso de que no tenga Fax, 
-- colocar el teléfono, pero aclarándolo. Por ejemplo: “TEL: (01) 123-4567”.
CREATE VIEW v_clientes AS
SELECT ClienteID, contacto,
CASE
WHEN Fax = "" THEN CONCAT("TEL: ",Telefono)
ELSE Fax
END AS Fax
 FROM clientes;
-- 2. Se necesita listar los números de teléfono de los clientes que no tengan fax. Hacerlo de dos formas distintas:
-- a. Consultando la tabla de clientes.
SELECT * FROM clientes
WHERE Fax = "";
-- b. Consultando la vista de clientes.
SELECT * FROM v_clientes
WHERE Fax LIKE "T%";

-- Proveedores
-- 1. Crear una vista con los siguientes datos de los proveedores: ID, contacto, compañía y dirección. Para la dirección tomar la dirección,
-- ciudad, código postal y país.
CREATE VIEW v_proveedores AS
SELECT ProveedorID, Contacto, Compania, CONCAT(Direccion, ", ", Ciudad, ", ", CodigoPostal, ", ", Pais) AS Direccion FROM proveedores;
-- 2. Listar los proveedores que vivan en la calle Americanas en Brasil. Hacerlo de dos formas distintas:
-- a. Consultando la tabla de proveedores.
SELECT * FROM proveedores
WHERE Direccion LIKE '%Americanas%';
-- b. Consultando la vista de proveedores.
SELECT * FROM v_proveedores
WHERE Direccion LIKE '%Americanas%';

-- Vistas - Parte II
-- 1. Crear una vista de productos que se usará para control de stock. Incluir el ID
-- y nombre del producto, el precio unitario redondeado sin decimales, las
-- unidades en stock y las unidades pedidas. Incluir además una nueva
-- columna PRIORIDAD con los siguientes valores:
-- ■ BAJA: si las unidades pedidas son cero.
-- ■ MEDIA: si las unidades pedidas son menores que las unidades
-- en stock.
-- ■ URGENTE: si las unidades pedidas no duplican el número de
-- unidades.
-- ■ SUPER URGENTE: si las unidades pedidas duplican el número
-- de unidades en caso contrario.
CREATE VIEW v_productos AS
SELECT ProductoID ID, ProductoNombre Nombre, ROUND(PrecioUnitario) Precio_Unitario, UnidadesStock, UnidadesPedidas,
CASE
WHEN UnidadesPedidas = 0 THEN 'BAJA'
WHEN UnidadesPedidas < UnidadesStock THEN 'MEDIA'
WHEN UnidadesPedidas < 2*UnidadesStock THEN 'URGENTE'
ELSE 'SUPER URGENTE'
END AS Prioridad
FROM productos;

-- 2. Se necesita un reporte de productos para identificar problemas de stock.
-- Para cada prioridad indicar cuántos productos hay y su precio promedio.
-- No incluir las prioridades para las que haya menos de 5 productos.
SELECT Prioridad, COUNT(Nombre) AS 'Cantidad Productos', AVG(Precio_Unitario) 'Precio Promedio' FROM v_productos
GROUP BY Prioridad
HAVING COUNT(Nombre) > 5;