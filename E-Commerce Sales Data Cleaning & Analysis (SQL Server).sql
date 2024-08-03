/* E-Commerce Sales Data Cleaning */

CREATE DATABASE ecommerce_sales;



USE ecommerce_sales;



SELECT *
FROM orders;



/* 1. Removal of duplicate rows. */

EXEC sp_columns orders;



SELECT *,
ROW_NUMBER() OVER(
PARTITION BY
[Additional Order items],
[Category Name],
[Customer City],
[Customer Country],
[Customer Fname],
[Customer Id],
[Customer Segment],
[Customer State],
[Customer Zipcode],
[Market],
[Order Customer Id],
[Order Date],
[Order Id],
[Order Region],
[Order Item Total],
[Order Quantity],
[Product Price],
[Profit Margin],
[Profit Per Order],
[Sales]
ORDER BY [Order Id]) AS "Row Number"
FROM orders
ORDER BY [Row Number];

SELECT *
FROM (
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY 
[Additional Order items],
[Category Name],
[Customer City],
[Customer Country],
[Customer Fname],
[Customer Id],
[Customer Segment],
[Customer State],
[Customer Zipcode],
[Market],
[Order Customer Id],
[Order Date],
[Order Id],
[Order Region],
[Order Item Total],
[Order Quantity],
[Product Price],
[Profit Margin],
[Profit Per Order],
[Sales]
ORDER BY [Order Id]) AS "Row Number"
FROM orders) AS duplicate_orders
WHERE [Row Number] > 1;



/* 2. Data formatting & standardisation. */

SELECT DISTINCT [Additional Order items]
FROM orders
ORDER BY [Additional Order items] ASC;



SELECT DISTINCT [Category Name]
FROM orders
ORDER BY [Category Name] ASC;

EXEC sp_rename 'orders.[Category Name]', 'Category', 'COLUMN';

SELECT DISTINCT [Category]
FROM orders
ORDER BY [Category] ASC;



SELECT DISTINCT [Customer City]
FROM orders
ORDER BY [Customer City] ASC;

SELECT *
FROM orders
WHERE [Customer City] = 'CA';

EXEC sp_rename 'orders.[Customer City]', 'City', 'COLUMN';

SELECT DISTINCT [City]
FROM orders
ORDER BY [City] ASC;



SELECT DISTINCT [Customer Country]
FROM orders
ORDER BY [Customer Country] ASC;

EXEC sp_rename 'orders.[Customer Country]', 'Country', 'COLUMN';

SELECT DISTINCT [Country]
FROM orders;



SELECT DISTINCT [Customer Fname]
FROM orders
ORDER BY [Customer Fname] ASC;

EXEC sp_rename 'orders.[Customer Fname]', 'Customer Name', 'COLUMN';

SELECT DISTINCT [Customer Name]
FROM orders
ORDER BY [Customer Name] ASC;



SELECT DISTINCT [Customer Id]
FROM orders
ORDER BY [Customer Id] ASC;



SELECT DISTINCT [Customer Segment]
FROM orders
ORDER BY [Customer Segment] ASC;

EXEC sp_rename 'orders.[Customer Segment]', 'Segment', 'COLUMN';

SELECT DISTINCT [Segment]
FROM orders;




SELECT DISTINCT [Customer State]
FROM orders
ORDER BY [Customer State] ASC;

EXEC sp_rename 'orders.[Customer State]', 'State', 'COLUMN';

SELECT DISTINCT [State]
FROM orders
ORDER BY [State] ASC;



SELECT DISTINCT [Customer Zipcode]
FROM orders
ORDER BY [Customer Zipcode] ASC;

EXEC sp_rename 'orders.[Customer Zipcode]', 'ZIP Code', 'COLUMN';

SELECT DISTINCT [ZIP Code]
FROM orders
ORDER BY [ZIP Code];

SELECT [ZIP Code]
FROM orders
WHERE [ZIP Code] = '';

UPDATE orders
SET [ZIP Code] = [State]
WHERE [ZIP Code] = '';

UPDATE orders
SET [State] = NULL
WHERE [State] IN ('91732', '95758');

UPDATE orders
SET [State] = [City]
WHERE [State] IS NULL;

UPDATE orders
SET [City] = NULL
WHERE [City] = 'CA';



SELECT DISTINCT [Market]
FROM orders
ORDER BY [Market] ASC;



SELECT DISTINCT [Order Customer Id]
FROM orders
ORDER BY [Order Customer Id] ASC;



SELECT DISTINCT [Order Date]
FROM orders
ORDER BY [Order Date] ASC;

SELECT DISTINCT [Order Date],
CONVERT(DATE, [Order Date], 105)
FROM orders
ORDER BY [Order Date];

UPDATE orders
SET [Order Date] = CONVERT(DATE, [Order Date], 105);

ALTER TABLE orders
ALTER COLUMN [Order Date] DATE;



SELECT DISTINCT [Order Id]
FROM orders
ORDER BY [Order Id] ASC;



SELECT DISTINCT [Order Region]
FROM orders
ORDER BY [Order Region] ASC;

EXEC sp_rename 'orders.[Order Region]', 'Region', 'COLUMN';

SELECT DISTINCT [Region]
FROM orders
ORDER BY [Region];


SELECT DISTINCT [Market],
[Region]
FROM orders
ORDER BY [Market] ASC;

UPDATE orders
SET [Market] = 'North America'
WHERE [Market] = 'USCA';

UPDATE orders
SET [Market] = 'Asia'
WHERE [Market] = 'Pacific Asia';

UPDATE orders
SET [Market] = 'Latin America'
WHERE [Market] = 'LATAM';



SELECT DISTINCT [Order Item Total]
FROM orders
ORDER BY [Order Item Total] ASC;

ALTER TABLE orders
ALTER COLUMN [Order Item Total] FLOAT;



SELECT DISTINCT [Order Quantity]
FROM orders
ORDER BY [Order Quantity] ASC;

EXEC sp_rename 'orders.[Order Quantity]', 'Quantity', 'COLUMN';

SELECT DISTINCT [Quantity]
FROM orders
ORDER BY [Quantity] ASC;

ALTER TABLE orders
ALTER COLUMN [Quantity] INT;



SELECT DISTINCT [Product Price]
FROM orders
ORDER BY [Product Price] ASC;

ALTER TABLE orders
ALTER COLUMN [Product Price] FLOAT;



SELECT DISTINCT [Profit Margin]
FROM orders
ORDER BY [Profit Margin] ASC;

SELECT [Profit Margin],
CONVERT(FLOAT, REPLACE([Profit Margin], '%', ''))/100
FROM orders;

UPDATE orders
SET [Profit Margin] = CONVERT(FLOAT, REPLACE([Profit Margin], '%', ''))/100;

ALTER TABLE orders
ALTER COLUMN [Profit Margin] FLOAT;



SELECT DISTINCT [Profit Per Order]
FROM orders
ORDER BY [Profit Per Order] ASC;

ALTER TABLE orders
ALTER COLUMN [Profit Per Order] FLOAT;



SELECT DISTINCT [Sales]
FROM orders
ORDER BY [Sales];

ALTER TABLE orders
ALTER COLUMN [Sales] FLOAT;



/* 3. Imputation of null/blank values. */

SELECT DISTINCT [Additional Order items],
[Category]
FROM orders
ORDER BY [Category];

SELECT DISTINCT [Additional Order items],
[Category]
FROM orders
WHERE [Additional Order items] <> [Category];

UPDATE orders
SET [Additional Order items] = [Category]
WHERE [Additional Order items] = 'NA';



SELECT DISTINCT [City]
FROM orders
ORDER BY [City];

SELECT DISTINCT [City]
FROM orders
WHERE [ZIP Code] IN ('91732', '95758');

SELECT DISTINCT ord1.[City],
ord2.[City],
ord1.[ZIP Code]
FROM orders ord1
JOIN orders ord2
ON ord1.[ZIP Code] = ord2.[ZIP Code]
WHERE ord1.[City] IS NULL AND ord2.[City] IS NOT NULL;

UPDATE ord1
SET ord1.[City] = ord2.[City]
FROM orders ord1
INNER JOIN orders ord2
ON ord1.[ZIP Code] = ord2.[ZIP Code]
WHERE ord1.[City] IS NULL AND ord2.[City] IS NOT NULL;



/* 4. Removal of redundant/irrelevant columns. */

SELECT [Additional Order items],
[Category]
FROM orders
WHERE [Additional Order items] <> [Category];



SELECT [Customer Id],
[Order Customer Id]
FROM orders
WHERE [Customer Id] <> [Order Customer Id];



ALTER TABLE orders
DROP COLUMN [Additional Order items];

ALTER TABLE orders
DROP COLUMN [Order Customer Id];