--  Creo tabla empleados
DROP TABLE IF EXISTS dim.employees;
CREATE TABLE dim.employees (
    nombre varchar(255),
    apellido varchar(255),
    fecha_entrada date,
    fecha_salida date,
    telefono varchar(255),
    pais varchar(255),
    provincia varchar(255),
    codigo_tienda varchar(255),
    posicion varchar(255)
)
;
-- Altero tabla para que soporte SDC
ALTER TABLE dim.employees
ADD COLUMN is_active bool, duration int
update dim.employees 
set duration = case when fecha_salida is null then null else cast(extract(month from fecha_salida) as int)-cast(extract(month from fecha_entrada) as int) end
;
update dim.employees 
set is_active = case when fecha_salida is null true else false end
;
select * from dim.employees
