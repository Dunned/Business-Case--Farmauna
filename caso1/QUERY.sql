CREATE DATABASE CASOI; -- CREACION DE BASE DE DATOS PARA EL PRIMER CASO
USE CASOI; -- USAMOS LA PRIMERA BASE DE DATOS

CREATE TABLE warehouses(
	warehouse CHAR(1),
    latitude DOUBLE,
    longitude DOUBLE,
    PRIMARY KEY (warehouse)
);

CREATE TABLE transacciones(
	order_id INT(11),
    month TINYINT,
    created DATETIME,
    warehouse CHAR(1),
    latitude DOUBLE,
    longitude DOUBLE,
    delivery_fee INT,
    PRIMARY KEY(order_id),
    FOREIGN KEY(warehouse) REFERENCES warehouses(warehouse)
);

-- IMPORTAMOS DE CSV ....
 
-- CREAMOS FUNCION DE HAVERSINE
DELIMITER //
CREATE FUNCTION haversine(lat1 DOUBLE,lon1 DOUBLE,lat2 DOUBLE,lon2 DOUBLE) RETURNS DOUBLE DETERMINISTIC
BEGIN
	DECLARE vlat DOUBLE;
    DECLARE vlon DOUBLE;
    DECLARE a DOUBLE;
    DECLARE r DOUBLE;
    DECLARE c DOUBLE;
    SET vlat=RADIANS(lat1-lat2);
    SET vlon=RADIANS(lon1-lon2);
    SET r=6370;
    SET a = POW( SIN(vlat/2) , 2 )  + COS(RADIANS(lat1))*COS(RADIANS(lat2))*POW( SIN(vlon/2), 2 );
    SET c=r*2*ATAN2( SQRT(a) , SQRT(1-a) );
    RETURN TRUNCATE(c,6);
END //
DELIMITER ;

-- WAREHOUSE GENERAL,  # PEDISO DE CADA MES Y LA DISTANCIA EN PROMEDIO DE ESE MES 
SELECT W.warehouse,COUNT(*) AS "#PEDIDOS",
AVG(haversine(W.latitude,W.longitude,T.latitude,T.longitude)) AS DISTANCIA_PROM,
SUM(T.delivery_fee) AS INGRESO_DELIVERY
FROM warehouses AS W INNER JOIN transacciones AS T
ON W.warehouse=T.warehouse
GROUP BY W.warehouse
ORDER BY DISTANCIA_PROM,INGRESO_DELIVERY;

-- WAREHOUSE POR CADA MES , EN # PEDISO DE CADA MES Y LA DISTANCIA EN PROMEDIO EN ESE MES 
SELECT W.warehouse,T.month,COUNT(*) AS "#PEDIDOS",
AVG(haversine(W.latitude,W.longitude,T.latitude,T.longitude)) AS DISTANCIA_PROM
FROM warehouses AS W INNER JOIN transacciones AS T
ON W.warehouse=T.warehouse
GROUP BY W.warehouse,T.month
ORDER BY W.warehouse,T.month;

-- WAREHOUSE , MES , #PEDIDOS EN ESE MES , # INGRESOS POR DELIVERY Y LA DISTANCIA EN PROMEDIO EN ESE MES 
SELECT W.warehouse,T.month,COUNT(*) AS "#PEDIDOS",SUM(T.delivery_fee) AS MONTO_DELIVERY,
AVG(haversine(W.latitude,W.longitude,T.latitude,T.longitude)) AS DISTANCIA_PROM
FROM warehouses AS W INNER JOIN transacciones AS T
ON W.warehouse=T.warehouse
GROUP BY W.warehouse,T.month
ORDER BY W.warehouse,T.month;



-- DISTANCIA MINIMA EJEMPLO APLICATIVO
SELECT haversine(-11.95,15.25,-7.2,17.61) AS DISTANCIA 
UNION
SELECT haversine(-11.95,15.25,-14.95,19.61)
UNION
SELECT haversine(-11.95,15.25,-19.95,11.21)
ORDER BY DISTANCIA;



	








