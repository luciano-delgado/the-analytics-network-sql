-- Tabla: dim.cost
DROP TABLE IF EXISTS dim.cost;
CREATE TABLE IF NOT EXISTS dim.cost(
product_id varchar(10) PRIMARY KEY,
cost_usd numeric
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
