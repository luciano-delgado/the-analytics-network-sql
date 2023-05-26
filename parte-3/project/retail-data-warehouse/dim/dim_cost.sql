-- Tabla: dim.cost
DROP TABLE IF EXISTS dim.cost;
CREATE TABLE IF NOT EXISTS dim.cost(
product_id varchar(10) PRIMARY KEY,
cost_usd numeric
);

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
		 
		 
-- Tabla: dim.cost con PK y FK: Una vez que tenga dim.product_master
DROP TABLE IF EXISTS dim.cost;
CREATE TABLE IF NOT EXISTS dim.cost(
product_id varchar(10) PRIMARY KEY, -- PK
cost_usd numeric,
	-- FK
	CONSTRAINT fk_product_id_cost
	FOREIGN KEY (product_id)
	REFERENCES dim.product_master(codigo_producto)
);
