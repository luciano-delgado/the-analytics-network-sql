CREATE TABLE stg.return_movements
                 ( 
                              orden      	VARCHAR(10)
                            , envio   		VARCHAR(10)
			    , item 	        VARCHAR(10)
                            , cantidad   	int
			    , id_movimiento int  
			    , desde 	        VARCHAR(50)
			    , hasta 		VARCHAR(50)
			    , recibido_por 	VARCHAR(10)
                            , fecha      	date
                 );
