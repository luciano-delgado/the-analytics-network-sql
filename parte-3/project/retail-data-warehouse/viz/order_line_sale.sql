# --TP3-P5.1-order_line_sale: Creo la tabla tomando el integrador final del TP2

-- Codigo de la tabla del TP2
-- CREO LA TABLA -- 
create table viz.order_line_sale (
	fecha date,
	producto varchar(10),
	tienda smallint,
	orden varchar(10),
	cantidad int,
	nombre varchar(255),
	pais varchar(100),
	provincia varchar(100),
	categoria varchar(255),
	subcategoria varchar(255),
	subsubcategoria varchar(255),
	dia numeric,
	mes numeric,
	anio numeric,
	fq text,
	fy text,
	ventas numeric,
	descuentos numeric,
	creditos numeric,
	impuestos numeric,
	costo_promedio numeric,
	adjustment_usd numeric,
	qty_returned int
	);

with cte_ajustes as (
select 
	orden,
	producto as producto_cte,
	--count(1) over() as adjustment
	200 / count(1) over() as adjustment
	from stg.order_line_sale ols
left join stg.product_master pm on pm.codigo_producto = ols.producto
where lower(pm.nombre) like '%philips%'
)
, fct_returns as (
select 
	orden, 
	item, 
	min(cantidad) as qty_returned
from fct.return_movements
group by orden,item
)
, obt as (
select 
-- AGREGACION/GRANULARIDAD
ols.fecha, 
producto, 
ols.tienda, 
ols.orden, 
ols.cantidad, 
sm.nombre,
sm.pais,
sm.provincia, 
pm.categoria, 
pm.subcategoria, 
pm.subsubcategoria, 
extract(day from ols.fecha) as dia, -- Dia
extract(month from ols.fecha) as mes, -- Mes
extract(year from ols.fecha) as anio, -- Año
stg.fiscal_quarter(ols.fecha) as fq, -- FQ
stg.fiscal_year(ols.fecha) as fy, -- FY
stg.convert_usd(ols.moneda, ols.venta, ols.fecha) as ventas, 
stg.convert_usd(ols.moneda, ols.descuento, ols.fecha) as descuentos, 
stg.convert_usd(ols.moneda, ols.creditos, ols.fecha) as creditos,
stg.convert_usd(ols.moneda, ols.impuestos, ols.fecha) as impuestos, 
cast(ols.cantidad * c1.costo_promedio_usd as numeric) as costo_promedio,
cast(aj.adjustment as int) as adjustment_usd,
rm.qty_returned
FROM stg.order_line_sale ols
left join dim.store_master sm on sm.codigo_tienda = ols.tienda
left join dim.product_master pm on pm.codigo_producto = ols.producto
left join dim.cost c1 on c1.codigo_producto = ols.producto
left join fct_returns rm on (rm.orden = ols.orden and rm.item = ols.producto) 
left join cte_ajustes aj on (aj.producto_cte = ols.producto and ols.orden = aj.orden)
left join dim.suppliers sp on sp.codigo_producto = ols.producto where sp.is_primary is true 
)
-- Inserto datos en tabla final 
insert into viz.order_line_sale
select * from obt
