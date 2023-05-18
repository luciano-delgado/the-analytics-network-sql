CREATE TABLE stg.date (
	fecha_ts timestamp,
    fecha DATE PRIMARY KEY,
    mes INTEGER,
    anio INTEGER,
    dia_semana TEXT,
    is_weekend BOOLEAN,
    mes_text TEXT,
    anio_fiscal TEXT,
    anio_fiscal_text TEXT,
    trimestre_fiscal TEXT,
    fecha_anio_anterior DATE
)
;
