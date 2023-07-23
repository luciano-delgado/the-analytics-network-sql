create or replace procedure etl.sp_monthly_average_fx_rate()
language sql 
as $$ 
truncate dim.monthly_average_fx_rate;
insert into dim.monthly_average_fx_rate 
select * from stg.monthly_average_fx_rate;
call etl.sp_log(current_date,'dim.monthly_average_fx_rate' ,'luciano');
$$ 
;

