-- CLASE 1:
--1
select * from stg.product_master
where categoria = 'Electro'
--2
select * from stg.product_master
where origen = 'China'
--3 
select * from stg.product_master
where categoria = 'Electro'
order by nombre 
--4 
select * from stg.product_master
where categoria = 'Electro'
and subcategoria = 'TV'
and is_active = True
order by nombre 
--5 
select * from stg.store_master
where pais = 'Argentina'
order by fecha_apertura 
--6
select * from stg.order_line_sale
order by fecha desc 
limit 5
--7
select * from stg.super_store_count
order by fecha desc
limit 10 
--8
select * from stg.product_master
where categoria = 'Electro'
and subcategoria not in ('TV','Control remoto')
--9
select *
from stg.order_line_sale
where moneda = 'ARS'
and venta > 100000
--10
select *
from stg.order_line_sale
where fecha between '2022-10-01' and '2022-10-30'
--11
select *
from stg.product_master 
where ean is not null
--12
select *
from stg.order_line_sale
where fecha between '2022-10-01' and '2022-11-10'
--CLASE 2:
--1
select distinct pais
from stg.store_master
--2
select  codigo_producto, nombre, subcategoria
from stg.product_master
where is_active is true 
--3
select  *
from stg.order_line_sale
where moneda = 'ARS' and venta > 100000
--4
select  moneda,sum(descuento)
from stg.order_line_sale
where fecha between '2022-11-01' and '2022-11-30'
group by moneda 
--5
select  sum(impuestos)
from stg.order_line_sale
where moneda = 'EUR'
--6
select  count(distinct orden)
from stg.order_line_sale
where creditos is not null
--7
select tienda, sum(descuento)/sum(venta) as dto 
from stg.order_line_sale
group by tienda 
--8
select tienda,fecha, (sum(inicial)+sum(final))/2 as promedio
from stg.inventory
group by tienda, fecha
order by tienda, fecha
--9
select producto, 
sum(venta) as venta, 
sum(descuento)/sum(venta) as dto
from stg.order_line_sale
where moneda = 'ARS'
group by producto
order by dto
--10
select tienda, 
cast(cast(fecha as text) as date), 
conteo
from stg.market_count
UNION ALL
select tienda,
cast(fecha as date),
conteo
from stg.super_store_count
--11
select * from stg.product_master 
where is_active is true
and nombre like ('%Phillips%')
--12
select tienda,
moneda,
sum(venta) as monto
from stg.order_line_sale
group by tienda,moneda 
order by monto desc
--13 -- V2
select producto, moneda, 
round(sum(venta)/sum(cantidad),1)
from stg.order_line_sale
group by producto, moneda
order by producto, moneda
--14
select orden, sum(impuestos)/sum(venta) as tasa
from stg.order_line_sale
group by orden

--CLASE 3
--1) Mostrar nombre y codigo de producto, categoria y color para todos los productos de la marca Philips y Samsung, mostrando la leyenda "Unknown" cuando no hay un color disponible
select 
codigo_producto, 
nombre,
case when color is null then 'Unknown' else color end as color2
from stg.product_master
where nombre like ('%PHILIPS%') 
or nombre like ('%Samsung%') 
--2) Calcular las ventas brutas y los impuestos pagados por pais y provincia en la moneda correspondiente.
select 
pais, 
provincia,
case when ols.moneda is null and pais = 'Argentina' then 'ARS' 
when ols.moneda is null and pais = 'Uruguay' then 'URU' 
when ols.moneda is null and pais = 'España' then 'EUR' 
else moneda
END AS MON,
round(sum(cast(coalesce(venta,0) as numeric)),1) as venta_pais_prov,
round(sum(cast(coalesce(impuestos,0) as numeric)),1) imp_pais_prov
from stg.store_master  sm
left join stg.order_line_sale ols on ols.tienda = sm.codigo_tienda
group by pais, provincia,ols.moneda
--3) Calcular las ventas totales por subcategoria de producto para cada moneda ordenados por subcategoria y moneda.
select moneda,pm.subcategoria, 
round(sum(venta),1) as vta_subcat_moneda
from stg.order_line_sale ols
left join stg.product_master pm on pm.codigo_producto =  ols.producto
group by moneda,pm.subcategoria
order by moneda
--4) Calcular las unidades vendidas por subcategoria de producto y la concatenacion de pais, provincia; usar guion como separador y usarla para ordernar el resultado.
select 
pm.subcategoria, 
concat(sm.pais,'-',sm.provincia),
round(sum(cantidad),0) as unidades_vendidas
from stg.order_line_sale ols
left join stg.product_master pm on pm.codigo_producto =  ols.producto
left join stg.store_master sm on sm.codigo_tienda = ols.tienda
group by pm.subcategoria, sm.pais, sm.provincia
order by concat(sm.pais,'-',sm.provincia)
--5) Mostrar una vista donde sea vea el nombre de tienda y la cantidad de entradas de personas que hubo desde la fecha de apertura }para el sistema "super_store".
select 
sm.nombre, 
coalesce(round(sum(conteo),0),0) as cant_personas
from stg.store_master sm
left join stg.super_store_count ss on ss.tienda = sm.codigo_tienda
group by sm.nombre
--6) Cual es el nivel de inventario promedio en cada mes a nivel de codigo de producto y tienda; mostrar el resultado con el nombre de la tienda
select 
sm.codigo_tienda,
sm.nombre, 
i.sku,
--i.fecha,
--extract(month from i.fecha) as mes, --> No lo puedo mostrar sino me pide meterlo en GROUP BY y me explota la data por día
coalesce(round((sum(inicial)+sum(final))/2,0),0) as inventario_prom_mes
from stg.store_master sm
left join stg.inventory i on i.tienda = sm.codigo_tienda
group by sm.nombre,i.sku, sm.codigo_tienda
order by sm.codigo_tienda, i.sku
--7) Calcular la cantidad de unidades vendidas por material. Para los productos que no tengan material usar 'Unknown', homogeneizar los textos si es necesario.
select 
case when lower(pm.material) is null then 'Unknown' else lower(pm.material) end as material,
sum(cantidad) as vta_cant_material
from stg.product_master pm
left join stg.order_line_sale ols on ols.producto = pm.codigo_producto
group by lower(pm.material)
--8) Mostrar la tabla order_line_sales agregando una columna que represente el valor de venta bruta en cada linea convertido a dolares usando la tabla de tipo de cambio.
select 
ols.*,
case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0
	end as cotizacion,
round(ols.venta/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1) as vta_bruta_dolarizada
from stg.order_line_sale ols 
left join stg.monthly_average_fx_rate mfx on extract(month from mfx.mes) = extract(month from ols.fecha) 
--9) Calcular cantidad de ventas totales de la empresa en dolares.
select 
sum(round(ols.venta/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1)) as vta_bruta_dolarizada_total
from stg.order_line_sale ols 
left join stg.monthly_average_fx_rate mfx on extract(month from mfx.mes) = extract(month from ols.fecha) 
--10) Mostrar en la tabla de ventas el margen de venta por cada linea. Siendo margen = (venta - promociones) - costo expresado en dolares.
select 
ols.*,
round(ols.venta+coalesce(ols.descuento,0)+coalesce(ols.creditos,0),2) as mg_moneda_local,
round((ols.venta+coalesce(ols.descuento,0)+coalesce(ols.creditos,0))/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1) as mg_dolarizado
from stg.order_line_sale ols 
left join stg.cost c1 on c1.codigo_producto = ols.producto
left join stg.monthly_average_fx_rate mfx on extract(month from mfx.mes) = extract(month from ols.fecha) 
--11) Calcular la cantidad de items distintos de cada subsubcategoria que se llevan por numero de orden.
select 
distinct(ols.orden) as orden,
count(distinct pm.subsubcategoria) as cant_items
from stg.order_line_sale ols 
left join stg.product_master pm on pm.codigo_producto = ols.producto
group by ols.orden
order by 1

--CLASE 4








