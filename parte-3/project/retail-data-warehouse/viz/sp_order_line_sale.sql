-- TP3 - 5.2 - SP order_line_sale (sale del TP2 integrador)
create
or replace procedure viz.sp_order_line_sale() language sql as $ $ truncate viz.order_line_sale;

insert into
    viz.order_line_sale
select
    *
from
    stg.integrador_2_final;

call etl.sp_log(current_date, 'viz.order_line_sale', 'luciano');

$ $;

call viz.sp_order_line_sale();

-- select * from viz.order_line_sale