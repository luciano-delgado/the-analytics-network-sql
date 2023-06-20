create or replace procedure etl.sp_return_movements()
language sql  
as $$ 
truncate fct.return_movements;
insert into fct.return_movements (orden, envio, item, cantidad, id_movimiento, desde, hasta, recibido_por, fecha) --> Especifico ya que la 1er col es el SERIAL ID
select * from stg.return_movements;
call etl.sp_log(current_date,'fct.return_movements' ,'luciano');
$$ 
;
call etl.sp_return_movements()
;
