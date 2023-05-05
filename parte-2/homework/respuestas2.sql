-- | CLASE 6 | -- 
-- 1) Crear una vista con el resultado del ejercicio de la Parte 1 - Clase 2 - Ejercicio 10, 
donde unimos la cantidad de gente que ingresa a tienda usando los dos sistemas.

create or replace view stg.vw_parte1_clase2_ej10 as 
select tienda, 
cast(cast(fecha as text) as date), 
conteo
from stg.market_count
UNION ALL
select tienda,
cast(fecha as date),
conteo
from stg.super_store_count
-- 2) Recibimos otro archivo con ingresos a tiendas de meses anteriores. Ingestar el archivo y agregarlo a la vista del ejercicio anterior (Ejercicio 1 Clase 6). Cual hubiese sido la diferencia si hubiesemos tenido una tabla? (contestar la ultima pregunta con un texto escrito en forma de comentario)
create or replace view  stg.vw_parte1_clase2_ej10_v2 as
-- (No incluyo en rta comandos de CREATE de las nuevas tablas)
select * from stg.vw_parte1_clase2_ej10 ssc
   union all  
  select 
  cast(tienda as smallint),
  fecha,
  conteo
  from stg.super_store_count_september sscs ;
-- 3) Crear una vista con el resultado del ejercicio de la Parte 1 - Clase 3 - Ejercicio 10, donde calculamos el margen bruto en dolares. 
Agregarle la columna de ventas, descuentos, y creditos en dolares para poder reutilizarla en un futuro.
 SELECT ols.orden,
    ols.producto,
    ols.tienda,
    ols.fecha,
    ols.cantidad,
    ols.venta,
    ols.descuento,
    ols.impuestos,
    ols.creditos,
    ols.moneda,
    ols.pos,
    ols.is_walkout,
    round((ols.venta + COALESCE(ols.descuento, 0::numeric) + COALESCE(ols.creditos, 0::numeric)) /
        CASE
            WHEN ols.moneda::text = 'EUR'::text THEN mfx.cotizacion_usd_eur
            WHEN ols.moneda::text = 'ARS'::text THEN mfx.cotizacion_usd_peso
            WHEN ols.moneda::text = 'URU'::text THEN mfx.cotizacion_usd_uru
            ELSE 0::numeric
        END, 1)::double precision - c1.costo_promedio_usd AS mg_dolarizado,
    round(ols.venta /
        CASE
            WHEN ols.moneda::text = 'EUR'::text THEN mfx.cotizacion_usd_eur
            WHEN ols.moneda::text = 'ARS'::text THEN mfx.cotizacion_usd_peso
            WHEN ols.moneda::text = 'URU'::text THEN mfx.cotizacion_usd_uru
            ELSE 0::numeric
        END, 2) AS venta_usd,
    round(ols.descuento /
        CASE
            WHEN ols.moneda::text = 'EUR'::text THEN mfx.cotizacion_usd_eur
            WHEN ols.moneda::text = 'ARS'::text THEN mfx.cotizacion_usd_peso
            WHEN ols.moneda::text = 'URU'::text THEN mfx.cotizacion_usd_uru
            ELSE 0::numeric
        END, 2) AS descuento_usd,
    round(ols.creditos /
        CASE
            WHEN ols.moneda::text = 'EUR'::text THEN mfx.cotizacion_usd_eur
            WHEN ols.moneda::text = 'ARS'::text THEN mfx.cotizacion_usd_peso
            WHEN ols.moneda::text = 'URU'::text THEN mfx.cotizacion_usd_uru
            ELSE 0::numeric
        END, 2) AS creditos_usd
   FROM stg.order_line_sale ols
     LEFT JOIN stg.cost c1 ON c1.codigo_producto::text = ols.producto::text
     LEFT JOIN stg.monthly_average_fx_rate mfx ON EXTRACT(month FROM mfx.mes) = EXTRACT(month FROM ols.fecha);

-- 4) Generar una query que me sirva para verificar que el nivel de agregacion de la tabla de ventas 
(y de la vista) no se haya afectado. 
Recordas que es el nivel de agregacion/detalle? Lo vimos en la teoria de la parte 1! 
Nota: La orden M999000061 parece tener un problema verdad? Lo vamos a solucionar mas adelante.

select count (*), count (distinct orden)
from stg.vw_parte2_clase1_ej3
--where orden = 'M999000061'
union all
select count(*) , count (distinct orden)
from stg.order_line_sale

-- 5) Calcular el margen bruto a nivel Subcategoria de producto. Usar la vista creada.

select 
subcategoria,
sum(mg_dolarizado) as mg_por_categoria
from stg.vw_parte2_clase1_ej3  vw2
left join stg.product_master pm on pm.codigo_producto = vw2.producto
group by subcategoria

--6) Calcular la contribucion de las ventas brutas de cada producto al total de la orden. Por esta vez, si necesitas usar una subquery, podes utilizarla.

select 
orden, 
producto,
round(venta/
	(select sum(venta) from stg.vw_parte2_clase1_ej3 ),4)*100 as contribucion_por_producto -- SUBQUERY PARA TRAERME EL TOTAL DE SUM(VENTA)
--subcategoria,
--sum(mg_dolarizado) as mg_por_categoria
from stg.vw_parte2_clase1_ej3  vw2
left join stg.product_master pm on pm.codigo_producto = vw2.producto
group by orden, producto, venta


-- 7) Calcular las ventas por proveedor, para eso cargar la tabla de proveedores por producto. Agregar el nombre el proveedor en la vista del punto 3.
-- Ventas por proveedor 
select nombre, sum(venta_usd) as ventas_usd_proveedor
from stg.vw_parte2_clase1_ej3 vw -- where producto = 'p100015'
left join stg.suppliers sup on sup.codigo_producto = vw.producto 
where is_primary is true
group by nombre
-- Agrego proveedores a la vista del ej3 :"vw_parte2_clase1_ej3"
select * from stg.vw_parte2_clase1_ej3 vw -- where producto = 'p100015'
left join stg.suppliers sup on sup.codigo_producto = vw.producto 
where is_primary is true

--8)Verificar que el nivel de detalle de la vista anterior no se haya modificado, en caso contrario que se deberia ajustar? Que decision tomarias para que no se genereren duplicados?
--Se pide correr la query de validacion.
--Crear una nueva query que no genere duplicacion.
--Explicar brevemente (con palabras escrito tipo comentario) que es lo que sucedia.

-- VERIFICACION DUPLICADOS 1: con CTE
with cte as (
select * from stg.vw_parte2_clase1_ej3  vw
left join stg.suppliers sup on sup.codigo_producto = vw.producto 
where is_primary is true --and producto = 'p200087'
)
select orden, producto,count(1)
from cte
group by orden, producto
having count(1)>1 -- "p200087"/"M999000061" Unica orden realmente duplicada viene x 3 en tabla original. Abría que sacarla de la data base
-- VERIFICACION DUPLICADOS 2: con ROW_NUMBER()
with cte as (
select * from stg.vw_parte2_clase1_ej3  vw
left join stg.suppliers sup on sup.codigo_producto = vw.producto 
where is_primary is true --and producto = 'p200087'
)
select orden, row_number() over (partition by orden, producto) as prueba 
from cte
order by 2 desc -- "p200087"/"M999000061" Unica orden realmente duplicada viene x 3 en tabla original. Abría que sacarla de la data base

-- | CLASE 7 | -- 
-- 1) Calcular el porcentaje de valores null de la tabla stg.order_line_sale para la columna creditos y descuentos. (porcentaje de nulls en cada columna)
select 
round(((select count(orden) from stg.order_line_sale ols where ols.descuento is null))*1.00/(count(venta))*1.00,3) as descuento_null,
round(((select count(orden) from stg.order_line_sale ols where ols.creditos is null))*1.00/(count(venta))*1.00,3) as creditos_null
from stg.order_line_sale ols

-- 2) La columna "is_walkout" se refiere a los clientes que llegaron a la tienda y se fueron con el producto en la mano (es decia habia stock disponible). Responder en una misma query:
Cuantas ordenes fueron "walkout" por tienda?
Cuantas ventas brutas en USD fueron "walkout" por tienda?
Cual es el porcentaje de las ventas brutas "walkout" sobre el total de ventas brutas por tienda?
with t1 as (
select tienda, count(orden) as ordenes_waltout,
sum(round(ols.venta/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1)) as vta_walkout_dolarizada
from stg.order_line_sale ols
left join stg.monthly_average_fx_rate mfx on extract(month from mfx.mes) = extract(month from ols.fecha) 
where is_walkout is true
group by tienda)
select t1.*, 
round(vta_walkout_dolarizada /(sum(round(ols.venta/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1))),3) as porcentaje_walkout
from stg.order_line_sale ols left join t1 on t1.tienda = ols.tienda
left join stg.monthly_average_fx_rate mfx on extract(month from mfx.mes) = extract(month from ols.fecha)
group by 1,2,3

--3) Siguiendo el nivel de detalle de la tabla ventas, hay una orden que no parece cumplirlo. Como identificarias duplicados utilizando una windows function? Nota: Esto hace referencia a la orden M999000061. Tenes que generar una forma de excluir los casos duplicados, para este caso particular y a nivel general, si llegan mas ordenes con duplicaciones.
with cte as (
select * from stg.vw_parte2_clase1_ej3  vw
left join stg.suppliers sup on sup.codigo_producto = vw.producto 
where is_primary is true 
),
filtrado as (
select orden, row_number() over (partition by orden, producto) as validacion
from cte
order by 2 desc)
select * from filtrado 
where validacion >1    ---> Esto limpiará cualquier dato nuevo que ingrese duplicado 

-- 4)  Obtener las ventas totales en USD de productos que NO sean de la categoria "TV" NI esten en tiendas de Argentina.
select 
producto,
sum(round(ols.venta/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),1)) as venta
from stg.order_line_sale ols
left join stg.product_master p on p.codigo_producto = ols.producto
left join stg.monthly_average_fx_rate mfx on extract(month from mfx.mes) = extract(month from ols.fecha)
where moneda != 'ARS' and subcategoria != 'TV'
group by producto
--5) El gerente de ventas quiere ver el total de unidades vendidas por dia junto con otra columna con la cantidad de unidades vendidas una semana atras y la diferencia entre ambos. Nota: resolver en dos querys usando en una CTEs y en la otra windows functions.
SELECT 
  fecha,
  SUM(venta) AS total_venta_por_dia,
  (SELECT SUM(venta) FROM stg.order_line_sale WHERE fecha = ols.fecha - INTERVAL '7 days') AS total_venta_semana_anterior
FROM 
  stg.order_line_sale ols
GROUP BY 
  fecha
ORDER BY 
  fecha;
  --------------- Otra opcion con CTE y usando cantidades --------------
  WITH cte as (
	select fecha,
	sum(cantidad) as cant_7_dias_atras_suma
	from stg.order_line_sale ols
	group by fecha
)
SELECT 
  ols.fecha,
  cte.fecha as fecha_hace_una_semana,
  coalesce(cant_7_dias_atras_suma,0),
  SUM(cantidad) AS unidades_por_dia,
  SUM(cantidad) - coalesce(cant_7_dias_atras_suma,0)
FROM 
  stg.order_line_sale ols
  left join cte on cte.fecha  = ols.fecha - INTERVAL '7 days' 
GROUP BY 
  ols.fecha,cte.fecha, cant_7_dias_atras_suma
ORDER BY ols.fecha;
  
  --6) Crear una vista de inventario con la cantidad de inventario por dia, tienda y producto,
create or replace view vw_parte2_clase7_ej8 as 
with inv as (
select 
fecha,
tienda,
sku, (inicial + final )/2 as inv_por_dia
from stg.inventory i -- 1887 filas totales
),
pre_final as (
select 
i.fecha,
i.tienda,
i.sku,
i.inv_por_dia as inv_prom,
(i.inv_por_dia * c1.costo_promedio_usd) as costo,
pm.nombre as nombre_producto, 
pm.categoria,
sm.pais,
sm.nombre,
case when i.fecha = (select max(fecha) from stg.inventory) then true else false end as last_snapshot,
avg(cantidad) over (partition by i.fecha,i.tienda,i.sku order by ols.fecha rows between 6 preceding and current row) as inv7dias
from inv i 
left join stg.product_master pm on pm.codigo_producto = i.sku
left join stg.store_master sm on sm.codigo_tienda = i.tienda
left join stg.cost c1 on c1.codigo_producto = i.sku
left join stg.order_line_sale ols on ols.producto = i.sku and ols.fecha = i.fecha and ols.tienda = i.tienda
order by fecha asc)
select *,
(inv_prom *1.00)/(inv7dias*1.00) as DOH
from pre_final

-- | CLASE 8 |--
--1) Realizar el Ejercicio 5 (corrección -> 6) de la clase 6 donde calculabamos la contribucion de las ventas brutas de cada producto utilizando una window function.
select orden, 
producto,
fecha,
venta,
sum((venta+coalesce(descuento,0)+coalesce(creditos,0))
	 /CASE WHEN vw2.moneda = 'EUR' THEN mfx.cotizacion_usd_eur
WHEN vw2.moneda = 'ARS' THEN mfx.cotizacion_usd_peso
WHEN vw2.moneda = 'URU' THEN mfx.cotizacion_usd_uru ELSE 0 END  - c1.costo_promedio_usd)
	over (partition by producto,orden,fecha,tienda order by producto) as margen
from stg.vw_parte2_clase1_ej3  vw2
LEFT JOIN stg.monthly_average_fx_rate mfx ON EXTRACT(month FROM mfx.mes) = EXTRACT(month FROM vw2.fecha)
LEFT JOIN stg.cost c1 ON c1.codigo_producto = vw2.producto

--2) La regla de pareto nos dice que aproximadamente un 20% de los productos generan un 80% de las ventas. Armar una vista a nivel sku donde se pueda identificar por orden de contribucion, ese 20% aproximado de SKU mas importantes. 
(Nota: En este ejercicios estamos construyendo una tabla que muestra la regla de Pareto)
CREATE OR REPLACE VIEW stg.vw_contribucion_producto as (
with cont as (
-- POR SIMPLIFICACION NO DOLARIZO LAS VENTAS...
SELECT
  distinct (producto),
  SUM(venta) OVER (PARTITION BY producto) / SUM(venta) OVER () AS contribucion
FROM stg.order_line_sale)
select 
producto,
round(contribucion,3) 
from cont
order by contribucion desc
	)
-- 3) Calcular el crecimiento de ventas por tienda mes a mes, con el valor nominal y el valor % de crecimiento.

with ventas_tienda_mes as (
select 
tienda,
extract (month from fecha) as mes,
sum(venta) as venta_mes
from stg.order_line_sale 
-- where tienda  = '3'
group by tienda, extract (month from fecha)
order by extract (month from fecha)
	) 
, datos as (select 
vtm.tienda,
vtm.mes,
coalesce((select sum(coalesce(venta_mes,0)) from ventas_tienda_mes where vtm.tienda = tienda and mes = vtm.mes -1 group by tienda,mes),0) AS vta_mes_ant,
venta_mes
from ventas_tienda_mes vtm
order by tienda,mes)
select 
*,
venta_mes - vta_mes_ant as crecimiento_nominal,
(venta_mes - vta_mes_ant)/venta_mes as crecimiento_porcentual
from datos

-- 4) Crear una vista a partir de la tabla "return_movements" que este a nivel Orden de venta, item y que contenga las siguientes columnas:
select
distinct (rm.orden),
rm.item,
sum(rm.cantidad) over (partition by item) unidades,
coalesce((select round(sum(venta)/sum(cantidad),0) from stg.order_line_sale sub_ols where sub_ols.orden = rm.orden and sub_ols.producto = rm.item),0) as valor,
pm.nombre,
first_value(desde) over(partition by rm.orden, rm.item order by rm.id_movimiento asc) as primera_locacion,
--last_value(hasta) over(partition by rm.orden, rm.item order by rm.id_movimiento asc) as ultima_locacion
last_value(hasta) over(partition by rm.orden, rm.item) as ultima_locacion
from stg.return_movements rm
left join stg.order_line_sale ols on ols.orden = rm.orden and ols.producto = rm.item
left join stg.product_master pm on pm.codigo_producto = rm.item

--5) Crear tabla calendario:

CREATE TABLE stg.date1 (
	fecha_ts timestamp,
    fecha DATE PRIMARY KEY,
    mes INTEGER,
    anio INTEGER,
    dia_semana TEXT,
    is_weekend BOOLEAN,
    mes_text TEXT,
    anio_fiscal TEXT,
    anio_fiscal_text TEXT,
    trimestre_fiscal TEXT,
    fecha_anio_anterior DATE
);
-- Traigo datos con query
with fechas as(
select cast('2022-01-01' as date) + (n || 'day'):: interval   as fecha
from generate_series(0,365) n),
 datos as 
(select 
fecha,
date_trunc('day', fecha)::date as fecha,
cast(extract(month from date_trunc('day', fecha)::date) as int) as mes,
extract(year from date_trunc('day', fecha)::date) as anio,
to_char(date_trunc('day', fecha)::date,'day') as dia_semana,
case when extract(dow from fecha) in (0,6) then true else false end as is_weeken,
to_char(date_trunc('day', fecha)::date,'month') as mes,
concat('FY', case when extract(month from fecha) >= 2 then extract(year from fecha) + 1 else extract(year from fecha) end)  as anio_fiscal_texto,
concat('Q', case when extract(month from fecha) in ('1','2','3','4') then '1' 
	  			 when extract(month from fecha) in ('5','6','7','8') then '2'
	   			when extract(month from fecha) in ('9','10','11','12') then '3' end)  as trimestre_fiscal,
fecha - interval '1 year' as fecha_anio_anterior
from fechas)
-- Actualizar los campos de la tabla con la información requerida
insert into stg.date1 
select * from datos
-- Verifico que se haya insertado todo
select * from date1

-- | CLASE 9 | --

-- 1) Calcular el crecimiento de ventas por tienda mes a mes, con el valor nominal y el valor % de crecimiento. Utilizar self join.
with ventas_tienda_mes as (
select 
tienda,
extract (month from fecha) as mes,
sum(venta) as venta_mes
from stg.order_line_sale 
group by tienda, extract (month from fecha)
order by extract (month from fecha)
	) 
select vtm.*,
coalesce(vtm2.venta_mes,0) as vta_mes_ant,
vtm.venta_mes - coalesce(vtm2.venta_mes,0) as crecimiento,
(vtm.venta_mes - coalesce(vtm2.venta_mes,0))/vtm.venta_mes as porcentual
from ventas_tienda_mes vtm 
left join ventas_tienda_mes vtm2 on vtm2.tienda = vtm.tienda AND vtm2.mes = vtm.mes - 1
order by vtm.tienda 
