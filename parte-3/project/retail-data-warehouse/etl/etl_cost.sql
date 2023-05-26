/*CREACION DEL SP (EL CUAL SE ALMACENA EN ETL) QUE TOMARÁ LOS DATOS DEL STG Y LLENARÁ DIM 
Agregado: Se agrega call.log() al final para que deje registro de fecha, tabla modificada y usuario
*/
create or replace procedure etl.dim_cost()
language plpgsql as $$
DECLARE
  usuario varchar(10) := current_user ;
BEGIN
  usuario := current_user;
-- buscar codigo de producto existente en product_master y traer solo los que existen -> insert basado en la nueva tabla/cte con los codigos que existen unicamente
with validacion as (
select c1.codigo_producto, c1.costo_promedio_usd 
from stg.cost c1
inner join stg.product_master pm on pm.codigo_producto = c1.codigo_producto
)
insert into dim.cost (product_id,cost_usd) -- Donde inserto
select codigo_producto, costo_promedio_usd from validacion  -- Fuente de datos
on conflict (product_id) -- # Si existe, update registro
	do update set
	cost_usd = excluded.cost_usd; 
	call etl.log(current_date,'dim.cost' ,usuario);
END;
$$;
/*
La idea luego es correr esto. En caso de que actualice el archivo, debería modificar solo los nuevos datos
Agregado: Se ajusta SP para que solo inserte/modifique sí o sólo sí existe en dim.product_master
*/
call etl.dim_cost() 
