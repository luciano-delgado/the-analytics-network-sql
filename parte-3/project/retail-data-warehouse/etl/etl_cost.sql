/*CREACION DEL SP (EL CUAL SE ALMACENA EN ETL) QUE TOMARÁ LOS DATOS DEL STG Y LLENARÁ DIM */
create procedure etl.dim_cost()
language sql as $$
insert into dim.cost (product_id,cost_usd) -- Donde inserto
select codigo_producto, costo_promedio_usd from stg.cost -- Fuente de datos
on conflict (product_id) -- # Si existe, update registro
	do update set
	cost_usd = excluded.cost_usd; 
$$;
/*La idea luego es correr esto. En caso de que actualice el archivo, debería modificar solo los nuevos datos*/
call etl.dim_cost() 
