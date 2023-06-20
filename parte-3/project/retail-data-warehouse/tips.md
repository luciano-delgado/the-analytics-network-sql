
#TABLAS DIMENSIONALES
### Tablas FCT:
-Se incluyen SERIAL ID (auto id) como PK. No son obligatorios pero se suelen usar
-Se utilizan más que nada las FK.
### Tablas DIM:
Se usan más que nada PK (pudiendo haber FK por ejemplo entre tabla cost y product_master para que no figure el costo de un producto que no está en cartera)

- Subrogate Key en tabla dim.employees como PK (concat + hash + (nombre,apellido))
- UPSERT en etl.sp_employees y dim.cost
