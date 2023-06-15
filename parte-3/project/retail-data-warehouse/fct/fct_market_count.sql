DROP TABLE IF EXISTS fct.market_count;
CREATE TABLE fct.market_count
                 (
				auto_id SERIAL PRIMARY KEY,	 
				tienda SMALLINT, 
				fecha  INTEGER, 
				conteo SMALLINT,
				CONSTRAINT fk_tienda FOREIGN KEY (tienda) REFERENCES dim.store_master(codigo_tienda)
                 );
