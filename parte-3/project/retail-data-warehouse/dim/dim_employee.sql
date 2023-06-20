
CREATE TABLE dim.employees (
    id SERIAL PRIMARY KEY,
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
# Aplico SDC y actualizo el valor según si el empleado está activo y la duration en meses # 
ALTER TABLE dim.employees
ADD COLUMN is_active bool; duration int

