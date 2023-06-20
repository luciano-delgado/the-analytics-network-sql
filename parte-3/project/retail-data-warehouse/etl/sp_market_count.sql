create or replace procedure etl.sp_market_count()
language sql 
as $$ 
truncate fct.market_count;
insert into fct.market_count (tienda, fecha, conteo) --> Especifico columnas ya que fct.market_count tiene la 1er columna SERIAL ID
select * from stg.market_count; 
call etl.sp_log(current_date,'fct.market_count' ,'luciano');
$$ 
;
call etl.sp_market_count()
;
