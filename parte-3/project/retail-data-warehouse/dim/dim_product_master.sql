
 
-- Tabla: dim.product_master
CREATE TABLE dim.product_master
                 (
                              codigo_producto VARCHAR(255)
                            , nombre          VARCHAR(255)
                            , categoria       VARCHAR(255)
                            , subcategoria    VARCHAR(255)
                            , subsubcategoria VARCHAR(255)
                            , material        VARCHAR(255)
                            , color           VARCHAR(255)
                            , origen          VARCHAR(255)
                            , ean             bigint
                            , is_active       boolean
                            , has_bluetooth   boolean
                            , talle           VARCHAR(255)
                 );
		 
		 
/*Intento 1: Me dio error "ERROR:  no hay restricción unique que coincida con las columnas dadas en la tabla referida «product_master»"
Entonces agrego la restricción de UNIQUE con ayuda del ALTER TABLE*/
ALTER TABLE dim.product_master
ADD CONSTRAINT unique_codigo_producto UNIQUE (codigo_producto);
-- Tabla: dim.cost con PK y FK
DROP TABLE IF EXISTS dim.cost;
CREATE TABLE IF NOT EXISTS dim.cost(
product_id varchar(10) PRIMARY KEY, -- PK
cost_usd numeric,
	-- FK: Cada valor que aparezca en dim.cost debe estar en dim.product_master
	CONSTRAINT fk_product_id_cost
	FOREIGN KEY (product_id)
	REFERENCES dim.product_master(codigo_producto)
);

/*Con la relación establecida ya puedo generar ERD y descargar pdf*/
