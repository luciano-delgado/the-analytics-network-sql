-- Tabla: dim.cost
DROP TABLE IF EXISTS dim.cost;
CREATE TABLE IF NOT EXISTS dim.cost(
    product_id varchar(10) PRIMARY KEY,
    cost_usd numeric
);
### ver si debe llevar FK con respecto a la product_master. ¿Puedo tener costo de un producto que no esté en maestro?
"No tiene mucho sentido PK a tablas fact, se suele agregar una columna identidad autogenerada pero no es obligatorio
Tema dim_cost si efectivamente puede que tenga PK y FK. 

Todo depende de cuanto querramos restringir la presencia de datos no correctos. Lo mas probable es que tu fuente sea la dim_product y la dim_cost sea un left join en todo momento. Por lo tanto no tendrias problemas. 

Pero se puede agregar la constraint de FK."