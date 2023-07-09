-- TP3 - 5.2 - SP returns 
create
or replace procedure viz.sp_returns() language sql as $ $ truncate viz.returns;

insert into
  viz.returns
select
  ols.orden,
  venta,
  stg.convert_usd('ARS', venta, ols.fecha) as venta_usd,
  producto,
  pm.nombre,
  pm.categoria,
  pm.subcategoria,
  pm.origen,
  pm.material,
  tienda,
  sm.ciudad,
  sm.nombre as nombre_tienda,
  sm.fecha_apertura
from
  fct.order_line_sale ols
  inner join (
    select
      *
    from
      stg.return_movements rm1
    where
      rm1.desde = 'Cliente'
  ) rm on rm.orden = ols.orden
  left join fct.store_master sm on sm.codigo_tienda = ols.tienda
  left join fct.product_master pm on pm.codigo_producto = ols.producto;

call etl.sp_log(current_date, 'viz.returns', 'luciano');

$ $;

call viz.sp_returns() --truncate viz.returns
--select * from viz.returns