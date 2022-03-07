CREATE DATABASE CASOII;
USE CASOII;

-- IMPORTAMOS LOS CSV

-- CREAMOS LA SIGUIENTE VISTA
CREATE VIEW detalle AS
	SELECT P.product_id,V.sku,P.name,P.price,
	macro.name AS Macro_category,sub.name AS Sub_category,micro.name AS Micro_category
	FROM product_product as P INNER JOIN product_variant AS v
	ON P.product_id=v.product_id
	INNER JOIN product_category AS micro
	ON P.Category_id=micro.Id
	INNER JOIN product_category as sub 
	ON micro.parent_id=sub.id
	INNER JOIN product_category AS macro ON
	sub.parent_id=macro.id;
    
    
SELECT * FROM detalle;


CREATE VIEW detalle2 AS
SELECT Macro_category,Sub_category,sku,price FROM detalle 
ORDER BY Macro_category,Sub_Category,price DESC,sku;

SELECT * FROM detalle2;

SELECT Macro_category,Sub_category,Sku,MAX(price) FROM detalle2 GROUP BY Sub_category,price
ORDER BY Macro_category,Sub_Category,price DESC,sku;





