
/*Crear tabla de suppliers*/
/*No encontré una PK ya que los registros de codigo_producto y nombre del proveedor aparecen por duplicado.*/
DROP TABLE IF EXISTS dim.suppliers; 
CREATE TABLE dim.suppliers(
	codigo_producto varchar(255),
	nombre varchar(255),
	is_primary boolean
);
 
