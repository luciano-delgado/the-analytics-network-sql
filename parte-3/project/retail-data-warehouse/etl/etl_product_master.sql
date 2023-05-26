create or replace procedure etl.dim_product_master()
language plpgsql as $$
DECLARE
  usuario varchar(10) := current_user;
BEGIN
  usuario := current_user;
insert into dim.product_master(codigo_producto, nombre, categoria, subcategoria, subsubcategoria, material, color, origen, ean, is_active, has_bluetooth, talle, marca)
SELECT codigo_producto, nombre, categoria, subcategoria, subsubcategoria, material, color, origen, ean, is_active, has_bluetooth, talle, marca
  FROM stg.product_master
  on conflict (codigo_producto)
  do update set
	marca = excluded.marca;
	call etl.log(current_date,'dim.product_master', usuario);
END;
$$;
call etl.dim_product_master() 
select * from etl.log
select * from dim.product_master
select * from stg.product_master
