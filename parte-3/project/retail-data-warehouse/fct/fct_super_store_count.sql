DROP TABLE IF EXISTS fct.super_store_count; 
CREATE TABLE fct.super_store_count
( 
id SERIAL PRIMARY KEY -- 23/7: Se corrige de 'auto_id' a 'id'
,tienda SMALLINT
, fecha  VARCHAR(10)
, conteo SMALLINT
, CONSTRAINT fk_tienda FOREIGN KEY (tienda) REFERENCES dim.store_master(codigo_tienda)
);
