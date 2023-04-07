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
(round((ols.venta+coalesce(ols.descuento,0)+coalesce(ols.creditos,0))/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1))-c1.costo_promedio_usd as mg_dolarizado
from stg.order_line_sale ols 
left join stg.cost c1 on c1.codigo_producto = ols.producto
left join stg.monthly_average_fx_rate mfx on extract(month from mfx.mes) = extract(month from ols.fecha) 
--11) Calcular la cantidad de items distintos de cada subsubcategoria que se llevan por numero de orden.
select 
distinct(ols.orden) as orden,
pm.subcategoria,
count(distinct pm.subsubcategoria) as cant_items
from stg.order_line_sale ols 
left join stg.product_master pm on pm.codigo_producto = ols.producto
group by ols.orden,2
order by 1

--CLASE 4
--1) Crear un backup de la tabla product_master. Utilizar un esquema llamada "bkp" y agregar un prefijo al nombre de la tabla con la fecha del backup en forma de numero entero.
SELECT *,
current_date as bkp_date -- Le agrego fecha bkp
INTO bkp.product_master_20230402
FROM stg.product_master
--2) Hacer un update a la nueva tabla (creada en el punto anterior) de product_master agregando la leyendo "N/A" para los valores null de material y color. Pueden utilizarse dos sentencias.
update bkp.product_master_20230402 
set color = 'N/A'
where color is null
set material = 'N/A'
where material is null
--3) Hacer un update a la tabla del punto anterior, actualizando la columa "is_active", desactivando todos los productos en la subsubcategoria "Control Remoto"
update bkp.product_master_20230402 
set is_Active = 'false'
where subsubcategoria = 'Control remoto'
--4) Agregar una nueva columna a la tabla anterior llamada "is_local" indicando los productos producidos en Argentina y fuera de Argentina.
alter table bkp.product_master_20230402 	
add column is_local boolean;
update bkp.product_master_20230402 	
set is_local = false 
where origen != 'Argentina';
update bkp.product_master_20230402 	
set is_local = true 
where origen = 'Argentina';
--5) Agregar una nueva columna a la tabla de ventas llamada "line_key" que resulte ser la concatenacion de el numero de orden y el codigo de producto.
alter table stg.order_line_sale 	
add column line_key varchar;
update stg.order_line_sale
set line_key = concat(orden,producto)
--6) Eliminar todos los valores de la tabla "order_line_sale" para el POS 1.
delete from stg.order_line_sale
where pos = 1
--7) Crear una tabla llamada "employees" (por el momento vacia) que tenga un id (creado de forma incremental), nombre, apellido, fecha de entrada, fecha salida, telefono, pais, provincia, codigo_tienda, posicion. Decidir cual es el tipo de dato mas acorde
CREATE TABLE stg.employees (
    id serial PRIMARY KEY,
    nombre varchar(255),
    apellido varchar(255),
    fecha_entrada date,
    fecha_salida date,
    telefono varchar(255),
    pais varchar(255),
    provincia varchar(255),
    codigo_tienda varchar(255),
    posicion varchar(255)
)
--8) Crear una tabla llamada "employees" (por el momento vacia) que tenga un id (creado de forma incremental), nombre, apellido, fecha de entrada, fecha salida, telefono, pais, provincia, codigo_tienda, posicion. Decidir cual es el tipo de dato mas acorde
insert into stg.employees (nombre,apellido,fecha_entrada,fecha_salida,telefono,pais,provincia,codigo_tienda,posicion)
values ('Catalina','Garcia','2022-03-01',null,null,'Argentina','Buenos Aires','tienda 2','Representante Comercial'),
 ('Ana','Valdez','2022-02-21','2022-03-01',null,'España','Madrid','tienda 8','Jefe Logistica'),
 ('Fernando','Moralez','2022-04-04',null,null,'España','Valencia','tienda 9','Vendedor'),
 ('Juan','Perez','2022-01-01',null,'+541113869867','Argentina','Santa Fe','tienda 2','Vendedor')
--9)Crear un backup de la tabla "cost" agregandole una columna que se llame "last_updated_ts" que sea el momento exacto en el cual estemos realizando el backup en formato datetime.
select *,
now() as ldast_updated_ts 
INTO bkp.cost_bkp_20230402
FROM stg.cost
--9) El cambio del punto 6 fue un error. ¿Cómo lo desharías?
Por lo que pude investigar se puede:
- ROLLBACK;
- INSERT INTO de los valores eliminados

-- PROYECTO INTEGRADOR -- :
-- # KPIs General
-- |Ventas brutas, netas y margen|
select 
extract(month from ols.fecha) as mes,
sum(round(ols.venta/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1)) as venta_bruta_mes_dolarizada,
sum(round((ols.venta-ols.impuestos+coalesce(ols.descuento,0)+coalesce(ols.creditos,0))/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1)) as venta_neta_mes_dolarizada,
sum((round((ols.venta+coalesce(ols.descuento,0)+coalesce(ols.creditos,0))/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1))-c1.costo_promedio_usd) as mg_dolarizado
from stg.order_line_sale ols 
left join stg.monthly_average_fx_rate mfx on extract(month from mfx.mes) = extract(month from ols.fecha) 
left join stg.cost c1 on c1.codigo_producto = ols.producto
group by extract(month from ols.fecha)
order by 1
-- |Margen por categoria |
select 
extract(month from ols.fecha) as mes,
pm.categoria,
sum(round(ols.venta/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1)) as venta_bruta_mes_dolarizada,
sum(round((ols.venta-ols.impuestos+coalesce(ols.descuento,0)+coalesce(ols.creditos,0))/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1)) as venta_neta_mes_dolarizada,
sum((round((ols.venta+coalesce(ols.descuento,0)+coalesce(ols.creditos,0))/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1))-c1.costo_promedio_usd) as mg_dolarizado
from stg.order_line_sale ols 
left join stg.monthly_average_fx_rate mfx on extract(month from mfx.mes) = extract(month from ols.fecha) 
left join stg.cost c1 on c1.codigo_producto = ols.producto
left join stg.product_master pm on pm.codigo_producto = ols.producto
group by extract(month from ols.fecha),pm.categoria
order by 1

-- |ROI por categoria de producto. ROI = Valor promedio de inventario / ventas netas|
WITH inventario_prom AS (
  SELECT 
    i.sku,
    COALESCE(ROUND((SUM(inicial) + SUM(final)) / 2, 0), 0) AS inventario_prom_mes
  FROM stg.inventory i
  JOIN stg.store_master sm ON i.tienda = sm.codigo_tienda
  GROUP BY i.sku
),
ventas  as (
select 
	producto,
	sum(venta) as venta
	from stg.order_line_sale ols
	group by producto
),
pre_proceso as (
SELECT 
  pm.categoria,
  coalesce(round((CAST(c1.costo_promedio_usd AS NUMERIC) * ip.inventario_prom_mes)/(sum(venta)),2),0) as ROI_usd
FROM inventario_prom ip
left join stg.cost c1 ON ip.sku = c1.codigo_producto
left join ventas v on v.producto = ip.sku
left join stg.product_master pm on pm.codigo_producto = ip.sku
GROUP BY c1.costo_promedio_usd,ip.inventario_prom_mes,pm.categoria
ORDER BY 1,2 desc)
select categoria, sum(roi_usd)
from pre_proceso
group by categoria

-- |AOV: Valor promedio de la orden|
select orden,
round(sum(venta)/sum(cantidad),2) as valor_prom_orden
from stg.order_line_sale ols
group by orden
order by 1

-- # Contabilidad
-- |Impuestos pagados |
select
sum(impuestos) as impuestos_pagados
from stg.order_line_sale ols
-- |Tasa de impuesto. Impuestos / Ventas netas|
select
sum(impuestos) as impuestos_pagados,
sum(venta+creditos+descuento),
sum(impuestos)/sum(venta+creditos+descuento) as tasa_impuestos
from stg.order_line_sale ols
--|Cantidad de creditos otorgados|
select
sum(creditos) 
from stg.order_line_sale ols
-- |Valor pagado final por order de linea. Valor pagado: Venta - descuento + impuesto - credito|
select
orden, 
coalesce(sum(venta+coalesce(creditos,0)+coalesce(descuento,0)-coalesce(impuestos,0)),0) valor_por_orden
from stg.order_line_sale ols
group by orden
order by 1
--# Supply Chain
-- |Costo de inventario promedio por tienda|
select 
	i.tienda,
	(sum(inicial)+sum(final))/2 as inv_prom,
	((sum(inicial)+sum(final))/2) * max(c1.costo_promedio_usd)
	from stg.inventory i
	left join stg.cost c1 on c1.codigo_producto = i.sku
	--where sku = 'p100014'
	group by i.tienda
	order by i.tienda

-- |Costo del stock de productos que no se vendieron por tienda|
with no_vendidos as (
select distinct codigo_producto as pnv
from stg.product_master pm 
left join stg.order_line_sale ols on ols.producto = pm.codigo_producto
where ols.venta is null),
stock as (
select 
	i.sku,
	(sum(inicial)+sum(final))/2 as stock
	from stg.inventory i 
	group by i.sku)
select 
codigo_producto,
stock * c1.costo_promedio_usd
from stg.cost c1 
left join no_vendidos nv on nv.pnv = c1.codigo_producto
left join stock s on s.sku = c1.codigo_producto
where nv.pnv is not null
-- |Cantidad y costo de devoluciones|
CREATE TABLE stg.return_movements
                 (
                              orden      	VARCHAR(10)
                            , envio   		VARCHAR(10)
			    , item 	        VARCHAR(10)
                            , cantidad   	int
			    , id_movimiento int  
			    , desde 	        VARCHAR(50)
			    , hasta 		VARCHAR(50)
			    , recibido_por 	VARCHAR(10)
                            , fecha      	date
                 );
select sum(r.cantidad) cantidad_devoluciones,
sum(c1.costo_promedio_usd) as costo_devo
from stg.return_movements r
left join stg.cost c1 on c1.codigo_producto = r.item

--# Tiendas
-- |Ratio de conversion. Cantidad de ordenes generadas / Cantidad de gente que entra|
-- |Ratio de conversion. Cantidad de ordenes generadas / Cantidad de gente que entra|
with or_generadas as (
select tienda, 
count (distinct orden) as ordenes_por_tienda
from stg.order_line_sale ols 
group by tienda
),
gente_entra as  (
select tienda, 
round(coalesce(avg(conteo),0),2) as entradas_avg
from stg.super_store_count
	group by tienda
)
------ Consulta Final -------
select 
coalesce(og.tienda,0) as tiendas_con_ordenes,
coalesce (ge.tienda,0) as tiendas_con_entradas,
coalesce(entradas_avg,0) as entradas_avg,
coalesce(ordenes_por_tienda,0) as ordenes_generadas,
round(coalesce(ordenes_por_tienda/entradas_avg,0),5) as ratio_ordenes_gente
from gente_entra ge
full outer join or_generadas og on og.tienda = ge.tienda
order by ge.tienda

		


