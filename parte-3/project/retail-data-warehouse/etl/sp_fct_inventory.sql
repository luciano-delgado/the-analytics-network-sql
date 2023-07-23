create
or replace procedure etl.sp_inventory () language sql as $ $ truncate fct.inventory;

DELETE FROM fct.inventory
WHERE fecha >= current_date -- 23/7: Elimino registros de la fecha de inserción en adelante según corrección de Agus 16/7
    ;

insert into
    fct.inventory (tienda, sku, fecha, inicial, final) --> Especifico columnas ya que fct.market_count tiene la 1er columna SERIAL ID
select
    *
from
    stg.inventory
where
    fecha >= current_date -- ## MODELO INCREMENTAL BASADO EN FECHA, INSERTO A MEDIDA QUE PASAN LOS DÍAS
;

call etl.sp_log (current_date, 'fct.inventory', 'luciano');

$ $;

