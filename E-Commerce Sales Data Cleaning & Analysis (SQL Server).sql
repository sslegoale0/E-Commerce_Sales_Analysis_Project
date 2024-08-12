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

SELECT *
FROM orders
WHERE [ZIP Code] IS NULL;

UPDATE orders
SET [ZIP Code] = [State]
WHERE [ZIP Code] IS NULL;

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
ALTER COLUMN [Quantity] FLOAT;



SELECT DISTINCT [Product Price]
FROM orders
ORDER BY [Product Price] ASC;

ALTER TABLE orders
ALTER COLUMN [Product Price] FLOAT;



SELECT DISTINCT [Profit Margin]
FROM orders
ORDER BY [Profit Margin] ASC;

SELECT DISTINCT [Profit Margin],
CONVERT(FLOAT, REPLACE([Profit Margin], '%', ''))/100
FROM orders;

UPDATE orders
SET [Profit Margin] = CONVERT(FLOAT, REPLACE([Profit Margin], '%', ''))/100;

ALTER TABLE orders
ALTER COLUMN [Profit Margin] FLOAT;



SELECT DISTINCT [Profit Per Order]
FROM orders
ORDER BY [Profit Per Order] ASC;

EXEC sp_rename 'orders.[Profit Per Order]', 'Profit', 'COLUMN';


ALTER TABLE orders
ALTER COLUMN [Profit] FLOAT;



SELECT DISTINCT [Sales]
FROM orders
ORDER BY [Sales];

ALTER TABLE orders
ALTER COLUMN [Sales] FLOAT;



/* 3. Imputation of null/blank values. */

SELECT DISTINCT [Additional Order items],
[Category]
FROM orders
ORDER BY [Category] ASC;

SELECT DISTINCT [Additional Order items],
[Category]
FROM orders
WHERE [Additional Order items] <> [Category];

UPDATE orders
SET [Additional Order items] = [Category]
WHERE [Additional Order items] = 'NA';



SELECT DISTINCT [City]
FROM orders
ORDER BY [City] ASC;

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



---------------------------------------------------------------------------------------------------------------

/* 1.  Total Sales by Year */

SELECT YEAR([Order Date]) AS "Year",
ROUND(SUM([Sales]), 0) AS "Total Sales"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY YEAR([Order Date])
ORDER BY [Year] DESC;



/* 2. Total Quantity by Year */

SELECT YEAR([Order Date]) AS "Year",
SUM(Quantity) AS "Total Quantity"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY YEAR([Order Date])
ORDER BY [Year] DESC;


/* 3. Total Profit by Year */

SELECT YEAR([Order Date]) AS "Year",
ROUND(SUM([Profit]), 0)  AS "Total Profit"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY YEAR([Order Date])
ORDER BY [Year] DESC;



/* 4. Total Orders by Year */

SELECT YEAR([Order Date]) AS "Year",
COUNT(DISTINCT [Order Id])  AS "Total Orders"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY YEAR([Order Date])
ORDER BY [Year] DESC;



/* 5. Total Customers by Year */

SELECT YEAR([Order Date]) AS "Year",
COUNT(DISTINCT [Customer Id])  AS "Total Customers"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY YEAR([Order Date])
ORDER BY [Year] DESC;



/* 6. Year over Year Change for Sales (2017 vs 2016) */

SELECT DISTINCT ROUND(((
			SELECT SUM([Sales])
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2017)
			-
			(SELECT SUM([Sales])
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016))
			/
			(SELECT SUM([Sales])
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016)*100, 2) AS "YoY Sales (%)"
FROM orders;



/* 7. Year over Year Change for Quantity (2017 vs 2016) */

SELECT DISTINCT ROUND(((
			SELECT SUM([Quantity])
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2017)
			-
			(SELECT SUM([Quantity])
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016))
			/
			(SELECT SUM([Quantity])
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016)*100, 2) AS "YoY Quantity (%)"
FROM orders;



/* 8. Year over Year Change for Profit (2017 vs 2016) */

SELECT DISTINCT ROUND(((
			SELECT SUM([Profit])
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2017)
			-
			(SELECT SUM([Profit])
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016))
			/
			(SELECT SUM([Profit])
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016)*100, 2) AS "YoY Profit (%)"
FROM orders;



/* 9. Year over Year Change for Orders (2017 vs 2016) */

SELECT DISTINCT ROUND((
			(SELECT CAST(COUNT(DISTINCT [Order Id]) AS FLOAT)
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2017)
			-
			(SELECT CAST(COUNT(DISTINCT [Order Id]) AS FLOAT)
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016))
			/
			(SELECT CAST(COUNT(DISTINCT [Order Id]) AS FLOAT)
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016)*100 , 1) AS "YoY Orders (%)"
FROM orders;



/* 10. Year over Year Change for Customers (2017 vs 2016) */

SELECT DISTINCT ROUND((
			(SELECT CAST(COUNT(DISTINCT [Customer Id]) AS FLOAT)
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2017)
			-
			(SELECT CAST(COUNT(DISTINCT [Customer Id]) AS FLOAT)
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016))
			/
			(SELECT CAST(COUNT(DISTINCT [Customer Id]) AS FLOAT)
			FROM orders
			WHERE [Country] = 'United States' AND [State] != 'HI' AND YEAR([Order Date]) = 2016)*100, 1) AS "YoY Customers (%)"
FROM orders;



/* 11. Sales by Month */

SELECT YEAR([Order Date]) AS "Year",
DATENAME(MONTH, [Order Date]) AS "Month",
ROUND(SUM([Sales]), 0) AS "Total Sales"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY MONTH([Order Date]), DATENAME(MONTH, [Order Date]), YEAR([Order Date])
ORDER BY MONTH([Order Date]), [Year] DESC;



/* 12. Quantity by Month */

SELECT YEAR([Order Date]) AS "Year",
DATENAME(MONTH, [Order Date]) AS "Month",
SUM([Quantity]) AS "Total Quantity"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY MONTH([Order Date]), DATENAME(MONTH, [Order Date]), YEAR([Order Date])
ORDER BY MONTH([Order Date]), [Year] DESC;



/* 13. Profit by Month */

SELECT YEAR([Order Date]) AS "Year",
DATENAME(MONTH, [Order Date]) AS "Month",
ROUND(SUM([Profit]), 0)  AS "Total Profit"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY MONTH([Order Date]), DATENAME(MONTH, [Order Date]), YEAR([Order Date])
ORDER BY MONTH([Order Date]), [Year] DESC;



/* 14. Orders by Month */

SELECT YEAR([Order Date]) AS "Year",
DATENAME(MONTH, [Order Date]) AS "Month",
COUNT(DISTINCT [Order Id]) AS "Total Orders"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY MONTH([Order Date]), DATENAME(MONTH, [Order Date]), YEAR([Order Date])
ORDER BY MONTH([Order Date]), [Year] DESC;



/* 15. Customers by Month */

SELECT YEAR([Order Date]) AS "Year",
DATENAME(MONTH, [Order Date]) AS "Month Name",
COUNT(DISTINCT [Customer Id]) AS "Total Customers"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY MONTH([Order Date]), DATENAME(MONTH, [Order Date]), YEAR([Order Date])
ORDER BY MONTH([Order Date]), [Year] DESC;



/* 16. Sales by State */

SELECT [State],
ROUND(SUM([Sales]), 0) AS "Total Sales"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [State]
ORDER BY [State] ASC;



/* 17. Quantity by State */

SELECT [State],
SUM([Quantity]) AS "Total Quantity"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [State]
ORDER BY [State] ASC;



/* 18. Profit by State */

SELECT [State],
ROUND(SUM([Profit]), 0) AS "Total Profit"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [State]
ORDER BY [State] ASC;



/* 19. Orders by State */

SELECT [State],
COUNT(DISTINCT [Order Id]) AS "Total Orders"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [State]
ORDER BY [State] ASC;



/* 20. Customers by State */

SELECT [State],
COUNT(DISTINCT [Customer Id]) AS "Total Customers"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [State]
ORDER BY [State] ASC;



/* 21. Sales by Category */

SELECT [Category],
ROUND(SUM([Sales]), 0) AS "Total Sales"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Category]
ORDER BY [Total Sales] DESC;



/* 22. Quantity by Category */

SELECT [Category],
SUM([Quantity]) AS "Total Quantity"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Category]
ORDER BY [Total Quantity] DESC;



/* 23. Profit by Category */

SELECT [Category],
ROUND(SUM([Profit]), 0) AS "Total Profit"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Category]
ORDER BY [Total Profit] DESC;



/* 24. Orders by Category */

SELECT [Category],
COUNT(DISTINCT [Order Id]) AS "Total Orders"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Category]
ORDER BY [Total Orders] DESC;



/* 25. Customers by Category */

SELECT [Category],
COUNT(DISTINCT [Customer Id]) AS "Total Customers"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Category]
ORDER BY [Total Customers] DESC;



/* 26. Sales by Market */

SELECT [Market],
ROUND(SUM([Sales]), 0) AS "Total Sales"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Market]
ORDER BY [Total Sales] DESC;



/* 27. Quantity by Market */

SELECT [Market],
SUM([Quantity]) AS "Total Quantity"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Market]
ORDER BY [Total Quantity] DESC;



/* 28. Profit by Market */

SELECT [Market],
ROUND(SUM([Profit]), 0) AS "Total Profit"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Market]
ORDER BY [Total Profit] DESC;



/* 29. Orders by Market */

SELECT [Market],
COUNT(DISTINCT [Order Id]) AS "Total Orders"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Market]
ORDER BY [Total Orders] DESC;



/* 30. Customers by Market */

SELECT [Market],
COUNT(DISTINCT [Customer Id]) AS "Total Customers"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Market]
ORDER BY [Total Customers] DESC;



/* 31. Sales by Region */

SELECT [Region],
ROUND(SUM([Sales]), 0) AS "Total Sales"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Region]
ORDER BY [Total Sales] DESC;



/* 32. Quantity by Region */

SELECT [Region],
SUM([Quantity]) AS "Total Quantity"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Region]
ORDER BY [Total Quantity] DESC;



/* 33. Profit by Region */

SELECT [Region],
ROUND(SUM([Profit]), 0) AS "Total Profit"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Region]
ORDER BY [Total Profit] DESC;



/* 34. Orders by Region */

SELECT [Region],
COUNT(DISTINCT [Order Id]) AS "Total Orders"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Region]
ORDER BY [Total Orders] DESC;



/* 35. Customers by Region */

SELECT [Region],
COUNT(DISTINCT [Customer Id]) AS "Total Customers"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Region]
ORDER BY [Total Customers] DESC;



/* 36. Sales by Segment */

SELECT [Segment],
ROUND(SUM([Sales]), 0) AS "Total Sales"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Segment];



/* 37. Quantity by Segment */

SELECT [Segment],
SUM([Quantity]) AS "Total Quantity"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Segment];



/* 38. Profit by Segment */

SELECT [Segment],
ROUND(SUM([Profit]), 0) AS "Total Profit"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Segment];



/* 39. Orders by Segment */

SELECT [Segment],
COUNT(DISTINCT [Order Id]) AS "Total Orders"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Segment];



/* 40. Customers by Segment */

SELECT [Segment],
COUNT(DISTINCT [Customer Id]) AS "Total Customers"
FROM orders
WHERE [Country] = 'United States' AND [State] != 'HI'
GROUP BY [Segment];