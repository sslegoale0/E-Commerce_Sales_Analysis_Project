SET sql_safe_updates = 0;

SET sql_mode = "Traditional";

---------------------------------------------------------------------------------------------------------------------------------------------

-- E-Commerce Sales Data Cleaning.

CREATE DATABASE ecommerce_sales;



-- Imported E-Commerce Sales data into MySQL using SQLAlchemy.



USE ecommerce_sales;



SELECT *
FROM orders;



DESCRIBE orders;



-- 1. Removal of duplicate rows.

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Id`) AS "Row Number"
FROM orders;

WITH duplicate_orders AS (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Id`) AS "Row Number"
FROM orders
)
SELECT *
FROM duplicate_orders
WHERE `Row Number` > 1;



-- 2. Data formatting & standardisation.

SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;



SELECT DISTINCT 
FROM calls
ORDER BY ASC;





-- 3. Imputation of null/blank values.




-- 4. Removal of redundant/irrelevant rows.




