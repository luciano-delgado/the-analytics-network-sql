-- 1 Crear una vista con el resultado del ejercicio de la Parte 1 - Clase 2 - Ejercicio 10, 
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
-- 2 Recibimos otro archivo con ingresos a tiendas de meses anteriores. Ingestar el archivo y agregarlo a la vista del ejercicio anterior (Ejercicio 1 Clase 6). Cual hubiese sido la diferencia si hubiesemos tenido una tabla? (contestar la ultima pregunta con un texto escrito en forma de comentario)
-- 3 Crear una vista con el resultado del ejercicio de la Parte 1 - Clase 3 - Ejercicio 10, donde calculamos el margen bruto en dolares. Agregarle la columna de ventas, descuentos, y creditos en dolares para poder reutilizarla en un futuro.
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
