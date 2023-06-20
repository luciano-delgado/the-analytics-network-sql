create or replace procedure etl.sp_inventory()
language sql 
as $$ 
truncate fct.inventory;
insert into fct.inventory (tienda, sku, fecha, inicial, final) --> Especifico columnas ya que fct.market_count tiene la 1er columna SERIAL ID
select * from stg.inventory;
call etl.sp_log(current_date,'fct.inventory' ,'luciano');
$$ 
;
call etl.inventory()

