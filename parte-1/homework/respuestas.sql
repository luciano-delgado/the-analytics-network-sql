-- CLASE 1:
--1
select * from stg.product_master
where categoria = 'Electro'
--2
select * from stg.product_master
where origen = 'China'
--3 
select * from stg.product_master
where categoria = 'Electro'
order by nombre 
--4 
select * from stg.product_master
where categoria = 'Electro'
and subcategoria = 'TV'
and is_active = True
order by nombre 
--5 
select * from stg.store_master
where pais = 'Argentina'
order by fecha_apertura 
--6
select * from stg.order_line_sale
order by fecha desc 
limit 5
--7
select * from stg.super_store_count
order by fecha desc
limit 10 
--8
select * from stg.product_master
where categoria = 'Electro'
and subcategoria not in ('TV','Control remoto')
--9
select *
from stg.order_line_sale
where moneda = 'ARS'
and venta > 100000
--10
select *
from stg.order_line_sale
where fecha between '2022-10-01' and '2022-10-30'
--11
select *
from stg.product_master 
where ean is not null
--12
select *
from stg.order_line_sale
where fecha between '2022-10-01' and '2022-11-10'
--CLASE 2:
--1
select distinct pais
from stg.store_master
--2
select  codigo_producto, nombre, subcategoria
from stg.product_master
where is_active is true 
--3
select  *
from stg.order_line_sale
where moneda = 'ARS' and venta > 100000
--4
select  moneda,sum(descuento)
from stg.order_line_sale
where fecha between '2022-11-01' and '2022-11-30'
group by moneda 
--5
select  sum(impuestos)
from stg.order_line_sale
where moneda = 'EUR'
--6
select  count(distinct orden)
from stg.order_line_sale
where creditos is not null
--7
select tienda, sum(descuento)/sum(venta) as dto 
from stg.order_line_sale
group by tienda 
--8
select tienda,fecha, (sum(inicial)+sum(final))/2 as promedio
from stg.inventory
group by tienda, fecha
order by tienda, fecha
--9
select producto, 
sum(venta) as venta, 
sum(descuento)/sum(venta) as dto
from stg.order_line_sale
where moneda = 'ARS'
group by producto
order by dto
--10
select tienda, 
cast(cast(fecha as text) as date), 
conteo
from stg.market_count
UNION ALL
select tienda,
cast(fecha as date),
conteo
from stg.super_store_count
--11
select * from stg.product_master 
where is_active is true
and nombre like ('%Phillips%')
--12
select tienda,
moneda,
sum(venta) as monto
from stg.order_line_sale
group by tienda,moneda 
order by monto desc
--13 -- VER
select producto, moneda, 
avg(venta)
from stg.order_line_sale
group by producto, moneda
order by producto, moneda
--14
select orden, sum(impuestos)/sum(venta) as tasa
from stg.order_line_sale
group by orden

--CLASE 3
--1
select 
codigo_producto, 
nombre,
case when color is null then 'Unknown' else color end as color2
from stg.product_master
where nombre like ('%PHILIPS%') 
or nombre like ('%Samsung%') 





