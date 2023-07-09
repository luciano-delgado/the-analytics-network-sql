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
    posicion varchar(255),
    duration int,
    hashtext(concat(nombre, apellido)) varchar(255) PRIMARY KEY --> Creo una SUBROGATE KEY 
);
-- Hago nombre y apellido UNIQUE para concatenarlos + hashearlos + hacerlos PK (SUBROGATE KEY)
ALTER TABLE dim.employees
ADD CONSTRAINT nombre_apellido_unique UNIQUE (nombre, apellido);
;
-- Esquema SCD
ALTER TABLE dim.employees
ADD COLUMN is_active BOOLEAN;
;
ALTER TABLE dim.employees
ADD COLUMN duration int;
;