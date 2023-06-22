
/*CREO TABLA DE LOGS*/
CREATE table etl.sp_log
                 (
fecha date
, tabla          VARCHAR(255)
, usuario       VARCHAR(255)
, stored_procedure       VARCHAR(255)
, lineas_insertadas       int
					 
			 );
/*CREO PROCEDURE QUE LLENA LA TABLA EN SCHEMA ETL*/
create or replace procedure etl.log(parametro_fecha date, 
				parametro_tabla varchar(10), 
				parametro_usuario varchar(10),
				parametro_sp varchar(10),
				parametro_lineas int
				   )
language sql as $$
insert into etl.sp_log 
select parametro_fecha, parametro_tabla, parametro_usuario, parametro_sp, parametro_lineas
; 
$$;
-- select * from etl.sp_log
-- call etl.log('2023-05-26','dim.cost','lucho', 'prueba',1)

