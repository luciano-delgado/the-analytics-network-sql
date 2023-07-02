
-- MFX rate
create function stg.convert_usd(moneda varchar(3),valor decimal(18,5), fecha date) returns decimal(18,5)
as $$
select 
coalesce(round(valor/(case 
	when moneda = 'EUR' then mfx.cotizacion_usd_eur
	when moneda = 'ARS' then mfx.cotizacion_usd_peso
	when moneda = 'URU' then mfx.cotizacion_usd_uru
	else 0 end),2),0) as valor_usd
from stg.monthly_average_fx_rate mfx 
where extract(month from mfx.mes) = extract(month from fecha)
;
$$ language sql;

-- Fiscal Year
create function stg.fiscal_quarter(fecha date) returns varchar(10)
as $$
select 
concat('Q', 
	   case when extract(month from fecha) in ('1','2','3','4') 
	   then '1' when extract(month from fecha) in ('5','6','7','8') 
	   then '2'when extract(month from fecha) in ('9','10','11','12') 
	   then '3' end)  
	   as fiscal_quarter
;
$$ language sql;

select stg.fiscal_quarter('2022-10-10')

-- Fiscal Quarter
create function stg.fiscal_quarter(fecha date) returns varchar(10)
as $$
select 
concat('Q', 
	   case when extract(month from fecha) in ('1','2','3','4') 
	   then '1' when extract(month from fecha) in ('5','6','7','8') 
	   then '2'when extract(month from fecha) in ('9','10','11','12') 
	   then '3' end)  
	   as fiscal_quarter
;
$$ language sql;

select stg.fiscal_quarter('2022-10-10')
