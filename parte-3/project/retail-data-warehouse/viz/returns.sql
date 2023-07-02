--TP3-P5.1-returns
-- ## Funcion MFX rate -- ## 
create function stg.convert_usd(moneda varchar(3),valor decimal(18,5), fecha date) returns decimal(18,5) 
as $$
select 
coalesce(round(valor/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),2),0) as valor_usd
from dim.monthly_average_fx_rate mfx 
where extract(month from mfx.mes) = extract(month from fecha)
;

-- ## Creo tabla Returns en VIZ e inserto datos -- ##
create table viz.returns(
	orden varchar(10),
	venta numeric(18,5),
	venta_usd numeric,
	producto varchar(10),
	nombre varchar(255),
	categoria varchar(255),
	subcategoria varchar(255),
	origen varchar(255),
	material varchar(255),
	tienda smallint, 
	ciudad varchar(255),
	nombre_tienda varchar(255),
	fecha_apertura date
)
;
select * from viz.returns
;
insert into viz.returns
select 
  ols.orden, 
  venta,
  stg.convert_usd('ARS',venta, ols.fecha) as venta_usd,
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
from fct.order_line_sale ols
  inner join (select * from stg.return_movements rm1 where rm1.desde = 'Cliente' ) rm on rm.orden = ols.orden  
  left  join fct.store_master sm on sm.codigo_tienda = ols.tienda
  left join fct.product_master pm on pm.codigo_producto = ols.producto
