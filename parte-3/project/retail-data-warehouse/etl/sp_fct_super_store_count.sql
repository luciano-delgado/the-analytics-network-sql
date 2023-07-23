create or replace procedure etl.sp_super_store_count()
language sql 
as $$ 
truncate fct.super_store_count;
insert into fct.super_store_count (tienda, fecha, conteo) --> Especifico ya que la 1er columna es SERIAL ID
select * 
from stg.super_store_count;
call etl.sp_log(current_date,'fct.super_store_count' ,'luciano');
$$ 
;

