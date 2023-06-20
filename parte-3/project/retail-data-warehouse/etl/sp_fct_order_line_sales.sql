create or replace procedure etl.sp_order_line_sales()
language sql 
as $$ 
truncate fct.order_line_sales;
insert into fct.order_line_sales 
select orden, producto, tienda, fecha, cantidad, venta, descuento, impuestos, creditos, moneda, pos, is_walkout --> Especifico columnas ya que la 1ra tiene SERIAL ID
from stg.order_line_sales ols 
/*Hago inner join ya que OLS tiene productos que no estan en product_master*/ 
inner join dim.product_master pm on pm.codigo_producto = ols.producto;
call etl.sp_log(current_date,'fct.order_line_sales' ,'luciano');
$$ 
;
call  etl.sp_order_line_sales()
