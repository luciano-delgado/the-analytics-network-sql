DROP TABLE IF EXISTS fct.inventory;
CREATE TABLE fct.inventory
                 (
					 
                    			 tienda  SMALLINT,
					 sku     VARCHAR(10),
					 fecha   DATE,
					 inicial SMALLINT,
					 final   SMALLINT,
					 CONSTRAINT fk_inventory_sku
					 FOREIGN KEY (sku)
					 REFERENCES dim.product_master,
					 CONSTRAINT fk_inventory_tienda
					 FOREIGN KEY (tienda)
					 REFERENCES dim.store_master
                 )
				 ;
				 
				
