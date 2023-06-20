create or replace procedure etl.sp_super_store_count()
language sql 
as $$ 
truncate fct.super_store_count;
insert into fct.super_store_count
select * 
from stg.super_store_count;
call etl.sp_log(current_date,'fct.super_store_count' ,'luciano');
$$ 
;
call  etl.sp_super_store_count()
select * from fct.super_store_count
