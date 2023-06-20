create or replace procedure etl.sp_employees()
language sql 
as $$ 
truncate dim.employees;
insert into dim.employees 
select nombre, apellido, fecha_entrada, fecha_salida, telefono, pais, provincia, codigo_tienda, posicion,
case when fecha_salida is null then true else false end
from stg.employees
call etl.sp_log(current_date,'dim.employees' ,'luciano');
$$ 
;
call etl.sp_employees()
