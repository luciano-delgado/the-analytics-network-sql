DROP TABLE IF EXISTS fct.order_line_sale;
CREATE TABLE fct.order_line_sale
                 (
			      auto_id SERIAL PRIMARY KEY 
                            , orden      VARCHAR(10)
                            , producto   VARCHAR(10)
                            , tienda     SMALLINT
                            , fecha      date
                            , cantidad   int
                            , venta      decimal(18,5)
                            , descuento  decimal(18,5)
                            , impuestos  decimal(18,5)
                            , creditos   decimal(18,5)
                            , moneda     varchar(3)
                            , pos        SMALLINT
                            , is_walkout BOOLEAN
					         , CONSTRAINT fk_producto FOREIGN KEY (producto) REFERENCES dim.product_master(codigo_producto)
                 	 , CONSTRAINT fk_tienda FOREIGN KEY (tienda) REFERENCES dim.store_master(codigo_tienda)
				 );	
