CREATE DATABASE dev;
-- ## Creo  las tablas
--CREATE DATABASE ceroamessi;
-- Crear schema stg
CREATE SCHEMA IF NOT EXISTS;
/* Crear tabla products
 Maestro de productos que posee la empresa. 
 is_active indica que productos estan actualmente a la venta
 */
DROP TABLE IF EXISTS stg.product_master;
CREATE TABLE stg.product_master (
    codigo_producto VARCHAR(255),
    nombre VARCHAR(255),
    categoria VARCHAR(255),
    subcategoria VARCHAR(255),
    subsubcategoria VARCHAR(255),
    material VARCHAR(255),
    color VARCHAR(255),
    origen VARCHAR(255),
    ean bigint,
    is_active boolean,
    has_bluetooth boolean,
    talle VARCHAR(255)
);
/* Crea tabla cost
 Costo promedio actual por producto
 */
DROP TABLE IF EXISTS stg.cost;
CREATE TABLE stg.cost (
    codigo_producto VARCHAR(10),
    costo_promedio_usd DECIMAL
);
DROP TABLE IF EXISTS stg.inventory;
/* Crea tabla inventory
 Conteo de inventario al inicio y final del dia por fecha, tienda y codigo
 */
CREATE TABLE stg.inventory (
    tienda SMALLINT,
    sku VARCHAR(10),
    fecha DATE,
    inicial SMALLINT,
    final SMALLINT
);
/* Crea tabla market_count
 Proveedor 1 de ingresos a tienda por fecha
 */
DROP TABLE IF EXISTS stg.market_count;
CREATE TABLE stg.market_count (
    tienda SMALLINT,
    fecha INTEGER,
    conteo SMALLINT
);
/* Crea tabla monthly_average_fx_rate
 Promedio de cotizacion mensual de USD a ARS, EUR a ARS y USD a URU
 */
DROP TABLE IF EXISTS stg.monthly_average_fx_rate;
CREATE TABLE stg.monthly_average_fx_rate (
    mes DATE,
    cotizacion_usd_peso DECIMAL,
    cotizacion_usd_eur DECIMAL,
    cotizacion_usd_uru DECIMAL
);
/* Crea tabla store_master
 Tabla maestra de tiendas 
 */
DROP TABLE IF EXISTS stg.store_master;
CREATE TABLE stg.store_master (
    codigo_tienda SMALLINT,
    pais VARCHAR(100),
    provincia VARCHAR(100),
    ciudad VARCHAR(100),
    direccion VARCHAR(255),
    nombre VARCHAR(255),
    tipo VARCHAR(100),
    fecha_apertura DATE,
    latitud DECIMAL(10, 8),
    longitud DECIMAL(11, 8)
);
/* Crea tabla super_store_count
 Proveedor 2 de ingresos a tienda por fecha
 */
DROP TABLE IF EXISTS stg.super_store_count;
CREATE TABLE stg.super_store_count (
    tienda SMALLINT,
    fecha VARCHAR(10),
    conteo SMALLINT
);
/* Crea tabla order_sales_units
 Ventas a nivel numero de orden, item.
 */
DROP TABLE IF EXISTS stg.order_line_sale;
CREATE TABLE stg.order_line_sale (
    orden VARCHAR(10),
    producto VARCHAR(10),
    tienda SMALLINT,
    fecha date,
    cantidad int,
    venta decimal(18, 5),
    descuento decimal(18, 5),
    impuestos decimal(18, 5),
    creditos decimal(18, 5),
    moneda varchar(3),
    pos SMALLINT,
    is_walkout BOOLEAN
);