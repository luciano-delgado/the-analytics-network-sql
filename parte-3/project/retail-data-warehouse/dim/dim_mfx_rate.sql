
/* Crea tabla monthly_average_fx_rate
Promedio de cotizacion mensual de USD a ARS, EUR a ARS y USD a URU
*/

-- DROP TABLE IF EXISTS dim.monthly_average_fx_rate;
    
-- CREATE TABLE dim.monthly_average_fx_rate
--                  (
--                               mes                 DATE PRIMARY KEY
--                             , cotizacion_usd_peso DECIMAL
--                             , cotizacion_usd_eur DECIMAL
--                             , cotizacion_usd_uru  DECIMAL
--                  );
 
-- 23/7: Corrección indicada por Agus el 16/7, 
CREATE TABLE dim.monthly_average_fx_rate
(
    mes DATE,
    cotizacion_usd_peso DECIMAL,
    cotizacion_usd_eur DECIMAL,
    cotizacion_usd_uru DECIMAL,
    PRIMARY KEY (extract(month from mes)) -- Nuevo!
);
