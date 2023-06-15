

DROP TABLE IF EXISTS fct.return_movements; 
CREATE TABLE fct.return_movements
                 (
				auto_id SERIAL PRIMARY KEY
				, orden      	VARCHAR(10)
				, envio   		VARCHAR(10)
				, item 	        VARCHAR(10)
				, cantidad   	int
				, id_movimiento int  
				, desde 	        VARCHAR(50)
				, hasta 		VARCHAR(50)
				, recibido_por 	VARCHAR(10)
				, fecha      	date
				, CONSTRAINT fk_item FOREIGN KEY (item) REFERENCES dim.product_master(codigo_producto)
                 );
