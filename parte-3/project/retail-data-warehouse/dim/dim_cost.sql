-- Tabla: dim.cost
DROP TABLE IF EXISTS dim.cost;
CREATE TABLE IF NOT EXISTS dim.cost( 
product_id varchar(10) PRIMARY KEY,
cost_usd numeric
);

### ver si debe llevar FK con respecto a la product_master. ¿Puedo tener costo de un producto que no esté en maestro?

