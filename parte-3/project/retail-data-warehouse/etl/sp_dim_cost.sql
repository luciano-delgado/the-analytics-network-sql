/*CREACION DEL SP (EL CUAL SE ALMACENA EN ETL) QUE TOMARÁ LOS DATOS DEL STG Y LLENARÁ DIM 
 Agregado: Se agrega call.log() al final para que deje registro de fecha, tabla modificada y usuario, SP usado y lineas insertadas
 */
create
or replace procedure etl.sp_dim_cost() language plpgsql as $ $ DECLARE usuario varchar(10) := current_user;

BEGIN usuario := current_user;

-- "En caso de no cumplir condicion FK no incluir SKU"
--Respuesta: buscar codigo de producto existente en product_master y traer solo los que existen -> insert basado en la nueva tabla/cte con los codigos que existen unicamente
with validacion as (
	select
		c1.codigo_producto,
		c1.costo_promedio_usd
	from
		stg.cost c1
		inner join stg.product_master pm on pm.codigo_producto = c1.codigo_producto
)
insert into
	dim.cost (product_id, cost_usd)
select
	codigo_producto,
	costo_promedio_usd
from
	validacion on conflict (product_id) -- # Si existe, update registro
	do -- UPSERT
update
set
	cost_usd = excluded.cost_usd;

with validacion as (
	select
		c1.codigo_producto,
		c1.costo_promedio_usd
	from
		stg.cost c1
		inner join stg.product_master pm on pm.codigo_producto = c1.codigo_producto
) call etl.log(current_date, 'dim.cost', usuario);

END;

$ $;

--call etl.sp_dim_cost()
--select * from etl.sp_log