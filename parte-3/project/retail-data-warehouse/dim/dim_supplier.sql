
/*Crear tabla de suppliers*/
DROP TABLE IF EXISTS dim.suppliers; 
CREATE TABLE dim.suppliers(
	codigo_producto varchar(255) PRIMARY KEY,
	nombre varchar(255),
	is_primary boolean
);
 
