create or replace procedure etl.sp_suppliers()
language sql 
as $$ 
truncate dim.suppliers;
insert into dim.suppliers 
select * from stg.suppliers where is_primary = true ;
call etl.sp_log(current_date,'dim.suppliers' ,'luciano');
$$ 
;
call  etl.suppliers()
;
select * from dim.suppliers
