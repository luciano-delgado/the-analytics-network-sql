create or replace procedure etl.sp_backup() 
language sql as $$ 
create table bkp.cost as 
select * from stg.cost
;
create table bkp.product_master as 
select * from stg.product_master
;
create table bkp.order_line_sales as 
select * from stg.order_line_sales
;
create table bkp.inventory as 
select * from stg.inventory
;
create table bkp.store_master as 
select * from stg.store_master
;
create table bkp.super_store_count as 
select * from stg.super_store_count
;
create table bkp.monthly_average_fx_rate as 
select * from stg.monthly_average_fx_rate
;
create table bkp.return_movements as 
select * from stg.return_movements
;
create table bkp.date as 
select * from stg.date
;
create table bkp.suppliers as 
select * from stg.suppliers
;
create table bkp.employees as 
select * from stg.employees
;
$$
;
-- call etl.sp_backup()

