create
or replace procedure etl.sp_employees() language sql as $ $
insert into
  dim.employees
select
  nombre,
  apellido,
  fecha_entrada,
  fecha_salida,
  telefono,
  pais,
  provincia,
  codigo_tienda,
  posicion,
  case
    when fecha_salida is null then true
    else false
  end,
  -- is_active
  case
    when fecha_salida is null then null
    else cast(
      extract(
        month
        from
          fecha_salida
      ) as int
    ) - cast(
      extract(
        month
        from
          fecha_entrada
      ) as int
    )
  end -- duration
from
  stg.employees on conflict (nombre, apellido) do
update
  -- UPSERT
set
  id = hashtext(concat(excluded.nombre, excluded.apellido)),
  duration = cast(
    extract(
      month
      from
        excluded.fecha_salida
    ) as int
  ) - cast(
    extract(
      month
      from
        excluded.fecha_entrada
    ) as int
  );

call etl.sp_log(current_date, 'dim.employees', 'luciano');

$ $;

-- call etl.sp_employees()
-- select *
-- from dim.employees