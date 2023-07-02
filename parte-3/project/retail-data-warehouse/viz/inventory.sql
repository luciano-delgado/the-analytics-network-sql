--TP3-P5.1-inventory:  Ver historico de inventario promedio por dia con dimensiones de tienda, producto y costos

-- 1) Creo tabla viz.inventory
create table viz.inventory (
	tienda smallint,
	sku varchar(10),
	costo_usd double presicion,
	inv_fecha date,
	inv_prom bigint,
	t_nombre varchar(255),
	t_tipo varchar(100),
	t_pais varchar(100),
	t_prov varchar(100,
	t_ciudad varchar(100)
)
  
-- 2) Armo Query e inserto datos 
insert into viz.inventory
with cte1 as (
	-- # Inventario oct, nov y dic.
  select * from stg.inventory
  union all
  select * from fct.inventory
  order by tienda, sku, fecha
)
, cte2 as(
	-- # Agrego el promedio por tienda, sku, fecha
  select *,
  sum(inicial+final)/2 as inv_prom
  from cte1  
  -- where sku  = 'p300001' 
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
  left join dim.store_master sm on sm.codigo_tienda = cte2.tienda
  left join dim.cost c1 on c1.codigo_producto = cte2.sku
