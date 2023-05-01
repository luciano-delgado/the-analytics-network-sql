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
having count(1)>1 -- "p200087"/"M999000061" Unica orden realmente duplicada
-- VERIFICACION DUPLICADOS 2: con ROW_NUMBER()
with cte as (
select * from stg.vw_parte2_clase1_ej3  vw
left join stg.suppliers sup on sup.codigo_producto = vw.producto 
where is_primary is true --and producto = 'p200087'
)
select orden, row_number() over (partition by orden, producto) as prueba 
from cte
order by 2 desc -- "p200087"/"M999000061" Unica orden realmente duplicada viene x 3 

-- | CLASE 7 | -- 
