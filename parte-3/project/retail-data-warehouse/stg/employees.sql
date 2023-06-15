--  Creo tabla empleados
DROP TABLE IF EXISTS dim.employees;
CREATE TABLE dim.employees (
    auto_id SERIAL PRIMARY KEY
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
ADD COLUMN is_active bool
-- QUEDA PENDIENTE SDC PARA UNIR CON FCT

select * from dim.employees
