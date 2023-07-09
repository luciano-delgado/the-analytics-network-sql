create
or replace procedure etl.sp_store_master() language sql as $ $ truncate dim.store_master;

insert into
    dim.store_master
select
    *
from
    stg.store_master;

call etl.sp_log(current_date, 'dim.store_master', 'luciano');

$ $;

call etl.store_master();

/*
 ERROR:  no se puede truncar una tabla referida en una llave foránea
 DETAIL:  La tabla «inventory» hace referencia a «store_master».
 HINT:  Trunque la tabla «inventory» al mismo tiempo, o utilice TRUNCATE ... CASCADE.
 CONTEXT:  función SQL «store_master» en la sentencia 1
 SQL state: 0A000
 */
/*Comentario de Agus
 agusvelazquez — 25/06/2023 06:31
 Lucho, pásala a un modelo Upsert. El error que te tira tiene sentido y no es posible hacer un truncate cuando hay FK.
 En la próxima versión voy a ver cómo lo manejamos, ya que ahora en la práctica se usa mucho truncate
 */
/* ------- CORRECCION ----------- */
create
or replace procedure etl.sp_store_master() language sql as $ $ -- truncate dim.store_master;
insert into
    dim.store_master
select
    *
from
    stg.store_master on conflict (codigo_tienda) do
update
set
    codigo_tienda = excluded.codigo_tienda,
    pais = excluded.pais,
    provincia = excluded.provincia,
    ciudad = excluded.ciudad,
    direccion = excluded.direccion;

call etl.sp_log(current_date, 'dim.store_master', 'luciano');

$ $;

call etl.store_master();