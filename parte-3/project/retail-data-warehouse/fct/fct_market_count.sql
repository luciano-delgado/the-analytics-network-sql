DROP TABLE IF EXISTS fct.market_count;
CREATE TABLE fct.market_count
                 ( 
				id SERIAL PRIMARY KEY,	  -- 23/7: Se corrige de 'auto_id' a 'id'
				tienda SMALLINT, 
				fecha  INTEGER, 
				conteo SMALLINT,
				CONSTRAINT fk_tienda FOREIGN KEY (tienda) REFERENCES dim.store_master(codigo_tienda)
                 );
