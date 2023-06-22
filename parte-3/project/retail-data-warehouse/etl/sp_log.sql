/*CREO TABLA DE LOGS*/
CREATE OR REPLACE TABLE etl.log
                 (
                              fecha date
                            , tabla          VARCHAR(255)
                            , usuario       VARCHAR(255)
					 )
/*CREO PROCEDURE QUE LLENA LA TABLA EN SCHEMA ETL*/
create or replace procedure etl.log(parametro_fecha date, parametro_tabla varchar(10), parametro_usuario varchar(10))
language sql as $$
insert into etl.log (fecha,tabla,usuario) 
select parametro_fecha, parametro_tabla, parametro_usuario
; 
$$;
--call etl.log('2023-05-26','dim.cost','lucho')
--select * from etl.log
