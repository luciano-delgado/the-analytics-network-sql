create or replace procedure etl.inventory()
language sql 
as $$ 
truncate fct.inventory;
insert into fct.inventory 
select * from stg.inventory 
$$
;
-- call etl.inventory()

