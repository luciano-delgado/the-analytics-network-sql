-- TP3-5.2- SP inventory
create or replace procedure viz.inventory()
language sql as $$ 
truncate viz.inventory
;
insert into viz.inventory
with cte1 as (
  select * from bkp.inventory_20230526
  union all
  select * from fct.inventory
  order by tienda, sku, fecha
)
, cte2 as(
  select *,
  sum(inicial+final)/2 as inv_prom
  from cte1  
  group by 1,2,3,4,5
	)
select
  tienda, 
  sku,
  costo_promedio_usd as costo_usd,
  fecha as inv_fecha,
  inv_prom,
  sm.nombre as t_nombre,
  sm.tipo as t_tipo,
  sm.pais as t_pais,
  sm.provincia as t_prov, 
  sm.ciudad as t_ciudad
from cte2
  left join stg.store_master sm on sm.codigo_tienda = cte2.tienda
  left join stg.cost c1 on c1.codigo_producto = cte2.sku
  ;
call etl.sp_log(current_date,'viz.inventory' ,'luciano')
;
$$
;
-- call viz.inventory()
-- select * from viz.inventory
