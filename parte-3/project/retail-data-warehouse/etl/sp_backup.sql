create
or replace procedure etl.sp_backup() language sql as $ $ drop table if exists bkp.cost create table bkp.cost as
select
    *
from
    stg.cost;

drop table if exists bkp.product_master create table bkp.product_master as
select
    *
from
    stg.product_master;

drop table if exists bkp.order_line_sales create table bkp.order_line_sales as
select
    *
from
    stg.order_line_sales;

drop table if exists bkp.inventory create table bkp.inventory as
select
    *
from
    stg.inventory;

drop table if exists bkp.store_master create table bkp.store_master as
select
    *
from
    stg.store_master;

drop table if exists bkp.super_store_count create table bkp.super_store_count as
select
    *
from
    stg.super_store_count;

drop table if exists bkp.monthly_average_fx_rate create table bkp.monthly_average_fx_rate as
select
    *
from
    stg.monthly_average_fx_rate;

drop table if exists bkp.return_movements create table bkp.return_movements as
select
    *
from
    stg.return_movements;

drop table if exists bkp.date create table bkp.date as
select
    *
from
    stg.date;

drop table if exists bkp.suppliers create table bkp.suppliers as
select
    *
from
    stg.suppliers;

drop table if exists bkp.employees create table bkp.employees as
select
    *
from
    stg.employees;

$ $;
