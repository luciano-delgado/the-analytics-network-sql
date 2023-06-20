create or replace procedure etl.inventory()
language sql 
as $$ 
truncate fct.inventory;
insert into fct.inventory 
select * from stg.inventory;
call etl.sp_log(current_date,'fct.inventory' ,'luciano');
$$ 
;
-- call etl.inventory()

