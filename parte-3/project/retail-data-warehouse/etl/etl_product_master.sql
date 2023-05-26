create or replace procedure etl.dim_product_master()
language plpgsql as $$
DECLARE
  usuario varchar(10) := current_user ;
BEGIN
  usuario := current_user;
  with cte as (
  select *,
	    CASE 
        WHEN lower(nombre) LIKE '%samsung%' THEN 'Samsung'
        WHEN lower(nombre) LIKE '%philips%' THEN 'Phillips'
        WHEN lower(nombre) LIKE 'levi%' THEN 'Levis'
        WHEN lower(nombre) LIKE 'jbl%' THEN 'JBL'
        WHEN lower(nombre) LIKE '%motorola%' THEN 'Motorola'
        WHEN lower(nombre) LIKE 'tommy%' THEN 'TH'
        ELSE 'Unknown' end as marca
	  from stg.product_master
  )
insert into dim.product_master(codigo_producto, nombre, categoria, subcategoria, subsubcategoria, material, color, origen, ean, is_active, has_bluetooth, talle, marca)
SELECT * from cte
  on conflict (codigo_producto)
  do update set
	marca = excluded.marca;
	call etl.log(current_date,'dim.product_master' ,usuario);
END;$$;
call etl.dim_product_master() 
select * from etl.log
select * from dim.product_master
select * from stg.product_master
