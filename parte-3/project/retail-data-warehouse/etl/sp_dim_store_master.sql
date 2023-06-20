create or replace procedure etl.store_master()
language sql 
as $$ 
truncate dim.store_master;
insert into dim.store_master 
select * from stg.store_master;
call etl.sp_log(current_date,'dim.store_master' ,'luciano');
$$ 
;
call etl.store_master()
;
/*
ERROR:  no se puede truncar una tabla referida en una llave foránea
DETAIL:  La tabla «inventory» hace referencia a «store_master».
HINT:  Trunque la tabla «inventory» al mismo tiempo, o utilice TRUNCATE ... CASCADE.
CONTEXT:  función SQL «store_master» en la sentencia 1
SQL state: 0A000
*/
