CREATE SCHEMA ETL
Acá van los STORED PROCEDURES que son los encargados de mover la data de stg a dim/fct

Tablas FCT:

- Se incluyen SERIAL ID (auto id) como PK. No son obligatorios pero se suelen usar
- Se utilizan más que nada las FK.

Tablas DIM:

- Se usan más que nada PK (pudiendo haber FK por ejemplo entre tabla cost y product_master para que no figure el costo de un producto que no está en cartera, pero no es obligatorio depende de la restricción que yo quiera poner

ETL

- Se incluye SP de back up
- Una buena practica es comenzar con todas las columnas VARCHAR y luego transformarlos en la siguiente capa: STG --> VARCHAR - DIM/ETL --> El dato correspondiente

Testing:
Cada proyecto debe tener restricciones de niveles de agregación y agregar segpun corresponda PK/FK
