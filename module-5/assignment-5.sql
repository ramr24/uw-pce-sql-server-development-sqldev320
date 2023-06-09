/**************************************************
** File: Assignment 5
** Date: 2023-05-15
** Auth: Ramkumar Rajanbabu
***************************************************
** Desc: Module 5 - Assignment 5
***************************************************
** Modification History
***************************************************
** Date			Author				Description 
** ----------	------------------  ---------------
** 2023-05-15	Ramkumar Rajanbabu	Started assignment
** 2023-05-22	Ramkumar Rajanbabu	Completed q1, q2
** 2023-05-23	Ramkumar Rajanbabu	Completed q3, q4, q9
** 2023-05-25	Ramkumar Rajanbabu	Fixed q1, q2, q3
** 2023-05-27	Ramkumar Rajanbabu	Fixed q4. Completed q5
** 2023-05-28	Ramkumar Rajanbabu	Incomplete q6, q10. Completed q7, q8.
**************************************************/

-- Access Database
USE [AdventureWorks2019]
GO

-- **Questions**
-- Question  1: Write a function [dbo].[ColorToSpanish]
-- to 'translate' the color into Spanish.
-- The function takes a single NVARCHAR argument
-- The function returns an NVARCHAR
--
-- Use the following translation chart:
-- Black Negro
-- Blue Azul
-- Grey Gris
-- Red Rojo
-- Silver Plata
-- White Blanco
-- Yellow Amarillo
--
-- For colors not in the list, use 'Indefinido'
-- For NULL value argument return NULL
--
--
-- Test your function
/*
select distinct Color [English], [dbo].[ColorToSpanish](color) [Spanish]
from [Production].[Product]

Produces the following result set:

English Spanish
--------------- ------------
NULL NULL
Black Negro
Blue Azul
Grey Gris
Multi Indefinido
Red Rojo
Silver Plata
Silver/Black Indefinido
White Blanco
Yellow Amarillo
*/
-- Attempt 1
--SELECT DISTINCT
--	[Color] [English],
--	CASE
--		WHEN [Color] IS NULL THEN NULL
--		ELSE
--			CASE [Color]
--				WHEN 'Black' THEN 'Negro'
--				WHEN 'Blue' THEN 'Azul'
--				WHEN 'Grey' THEN 'Gris'
--				WHEN 'Multi' THEN 'Indefinido'
--				WHEN 'Red' THEN 'Rojo'
--				WHEN 'Silver' THEN 'Plata'
--				WHEN 'Silver/Black' THEN 'Indefinido'
--				WHEN 'White' THEN 'Blanco'
--				WHEN 'Yellow' THEN 'Amarillo'
--			END
--	END [Spanish]
--FROM [Production].[Product]
-- Attempt 2
--IF OBJECT_ID (N'[dbo].[ColorToSpanish]') IS NOT NULL
--	DROP FUNCTION [dbo].[ColorToSpanish]
--GO
--CREATE FUNCTION [dbo].[ColorToSpanish] (
--	@Color NVARCHAR(20)
--)
--RETURNS NVARCHAR(20)
--AS
--BEGIN
--	RETURN 
--		CASE
--			WHEN @Color = 'Black' THEN 'Negro'
--		END
--END
--GO
-- Attempt 3: Final Answer
IF OBJECT_ID (N'[dbo].[ColorToSpanish]') IS NOT NULL
	DROP FUNCTION [dbo].[ColorToSpanish]
GO
CREATE FUNCTION [dbo].[ColorToSpanish] (
	@Color NVARCHAR(12)
)
RETURNS NVARCHAR(12)
AS
BEGIN
	RETURN
		CASE
			WHEN @Color IS NULL THEN NULL
			ELSE
				Case @Color
					WHEN 'Black' THEN 'Negro'
					WHEN 'Blue' THEN 'Azul'
					WHEN 'Grey' THEN 'Gris'
					WHEN 'Red' THEN 'Rojo'
					WHEN 'Silver' THEN 'Plata'
					WHEN 'White' THEN 'Blanco'
					WHEN 'Yellow' THEN 'Amarillo'
					ELSE 'Indefinido'
				END
		END
END
GO
SELECT DISTINCT 
	Color [English],
	[dbo].[ColorToSpanish](color) AS [Spanish]
FROM [Production].[Product]
GO

-- Question  2: Write a function [dbo].[OrderMargin]
-- to calculate the margin of an Order.
-- The function takes SalesOrderId as the single argument
-- The function returns the calculated margin as a MONEY type value
--
-- Assume cost doesn't change and use the StandardCost value
-- in Production.Product
--
-- Here is the Margin expression I'm using: SUM([LineTotal]) - SUM([OrderQty]*[StandardCost])
--
-- If there is no order that matches the argument return NULL
-- if the argument is NULL return NULL
--
--
-- Test your function
/*
DECLARE @TestOrders TABLE(
SalesOrderID INT
)

INSERT INTO @TestOrders (SalesOrderID) VALUES (NULL), (0), (43659), (43660)

select SalesOrderID, [dbo].[OrderProfit](SalesOrderID) [OrderProfit]
from @TestOrders

SalesOrderID OrderMargin
------------ ---------------------
NULL NULL
0 NULL
43659 1273.8398
43660 -77.162
*/
-- Attempt 1
--SELECT
--	[D].[SalesOrderID],
--	[D].[LineTotal],
--	[D].[OrderQty],
--	[P].[StandardCost]
--FROM [Sales].[SalesOrderDetail] AS D
--INNER JOIN [Production].[Product] AS P
--	ON [D].[ProductID] = [P].[ProductID]
--WHERE [SalesOrderID] = 43659
--GO
-- Attempt 2
--SELECT
--	[D].[SalesOrderID],
--	SUM([LineTotal]) - SUM([OrderQty]*[StandardCost]) AS [OrderMargin]
--FROM [Sales].[SalesOrderDetail] AS D
--INNER JOIN [Production].[Product] AS P
--	ON [D].[ProductID] = [P].[ProductID]
--WHERE [SalesOrderID] = 43659
--GROUP BY [D].[SalesOrderID]
--GO
-- Attempt 3
--DECLARE @SalesOrderID INT = 43659
--SELECT
--	[D].[SalesOrderID],
--	SUM([LineTotal]) - SUM([OrderQty]*[StandardCost]) AS [OrderMargin]
--FROM [Sales].[SalesOrderDetail] AS D
--INNER JOIN [Production].[Product] AS P
--	ON [D].[ProductID] = [P].[ProductID]
--WHERE [SalesOrderID] = @SalesOrderID
--GROUP BY [D].[SalesOrderID]
--GO
-- Attemt 4: Final Answer
IF OBJECT_ID (N'[dbo].[OrderMargin]') IS NOT NULL
	DROP FUNCTION [dbo].[OrderMargin]
GO
CREATE FUNCTION [dbo].[OrderMargin] (
	@SalesOrderID INT
)
RETURNS MONEY
WITH RETURNS NULL ON NULL INPUT
AS
BEGIN
	-- IF (@SalesOrder IS NULL) RETURN NULL
	IF NOT EXISTS (SELECT 1 FROM [Sales].[SalesOrderHeader] WHERE [SalesOrderID] = @SalesOrderID) RETURN NULL
	
	DECLARE @OrderMargin MONEY
	SELECT @OrderMargin = CAST(SUM([LineTotal]) - SUM([OrderQty]*[StandardCost]) AS MONEY)
	FROM [Sales].[SalesOrderDetail] AS D
	INNER JOIN [Production].[Product] AS P
		ON [D].[ProductID] = [P].[ProductID]
	WHERE [SalesOrderID] = @SalesOrderID
RETURN @OrderMargin
END
GO
-- Testing Answer
DECLARE @TestOrders TABLE(
	SalesOrderID INT
)
INSERT INTO @TestOrders (SalesOrderID)
VALUES (NULL), (0), (43659), (43660)
SELECT
	SalesOrderID,
	[dbo].[OrderMargin](SalesOrderID) AS [OrderMargin]
FROM @TestOrders
GO

-- Question  3: Write a function to test if a number is prime [dbo].[TestPrime]
-- Use a BIT data type for the return value
-- if the argument is prime number return 1; else zero (0)
-- If the argument is zero or NULL return NULL
--
-- Use the following code to test your function
/*
INSERT INTO @TestNumbers (N) VALUES (-11), (-8), (-4.99), (-3.5), (-2.1), (-1.0), (NULL), (0), (1), (2), (3.1), (4.5), (5.99), (7), (13), (123)

SELECT N, CAST(N AS INT) [Int part of N], [dbo].[TestPrime](N) [Is Prime]
FROM @TestNumbers


N Int part of N Is Prime
---------------------- ------------- --------
-11 -11 1
-8 -8 0
-4.99 -4 0
-3.5 -3 1
-2.1 -2 1
-1 -1 0
NULL NULL NULL
0 0 NULL
1 1 0
2 2 1
3.1 3 1
4.5 4 0
5.99 5 1
7 7 1
13 13 1
123 123 0
*/
-- Attempt 1: Final Answer
IF OBJECT_ID (N'[dbo].[TestPrime]') IS NOT NULL
	DROP FUNCTION [dbo].[TestPrime]
GO
CREATE FUNCTION [dbo].[TestPrime] (
	@N INT
)
RETURNS BIT
AS
BEGIN
	IF (@N IS NULL OR @N = 0) RETURN NULL
	IF @N < 0 SET @N *= -1

	DECLARE @I INT = 2
	WHILE (@I * @I) <= @N
	BEGIN
		IF(@N % @I) = 0 RETURN 0
		SET @I += 1
	END
	RETURN 1
END
GO
-- Testing Answer
DECLARE @TestNumbers TABLE(
	N FLOAT
)
INSERT INTO @TestNumbers (N)
VALUES (-11), (-8), (-4.99), (-3.5), (-2.1), (-1.0), (NULL), (0), (1), (2), (3.1), (4.5), (5.99), (7), (13), (123)
SELECT
	N,
	CAST(N AS INT) [Int part of N],
	[dbo].[TestPrime](N) [Is Prime]
FROM @TestNumbers

-- Question  4: Create function [dbo].[DatePartFromString] that returns the DATEPART of a date
-- from a string that matches all or part of the DATEPART argument
-- For the valid DATEPARTs see: https://docs.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql
--
-- !! NOTE: Implement only Year, Quarter, Month, Week, Day

-- If any argument is NULL, return NULL
--
-- Returns an integer value that represents the date part according to the DATEPART function
--
-- The need for this function comes from the following code snippet:
/*
DECLARE @Part NVARCHAR(12) = 'MONTH'

SELECT DATEPART(@Part, sysdatetime())

Msg 1023, Level 15, State 1, Line 3
Invalid parameter 1 specified for datepart.
*/
-- --> the DATEPART function cannot take a variable as first argument
--
-- Use the following code to test your function
/*
DECLARE @TestDates TABLE(
D DATE
)

DECLARE @DateParts TABLE(
[DatePart] NVARCHAR(12)
)

INSERT INTO @TestDates (D) VALUES ('3141-5-9'), ('1011-12-13')
INSERT INTO @DateParts ([DatePart]) VALUES ('Y'), ('Q'), ('M'), ('W'), ('D')

SELECT D, [DatePart] AS [Date part string], [dbo].DatePartFromString([DatePart],D) AS [Date part number]
FROM @TestDates CROSS JOIN @DateParts
ORDER BY D, [DatePart]

D Date part string Date part number
---------- ---------------- ----------------
1011-12-13 D 13
1011-12-13 M 12
1011-12-13 Q 4
1011-12-13 W 50
1011-12-13 Y 1011
3141-05-09 D 9
3141-05-09 M 5
3141-05-09 Q 2
3141-05-09 W 19
3141-05-09 Y 3141
*/
-- Attempt 1: Final Answer
DROP FUNCTION IF EXISTS [dbo].[DatePartFromString]
GO
CREATE FUNCTION [dbo].[DatePartFromString] (
	@DatePart NVARCHAR(12),
	@Date DATE
)
RETURNS INT
AS
BEGIN
	IF @DatePart IS NULL
		OR @Date IS NULL
		RETURN NULL
	DECLARE @Part INT
	SELECT
		@Part = CASE
					WHEN 'Year' LIKE @DatePart + '%' THEN DATEPART(YEAR, @Date)
					WHEN 'Quarter' LIKE @DatePart + '%' THEN DATEPART(QUARTER, @Date)
					WHEN 'Month' LIKE @DatePart + '%' THEN DATEPART(MONTH, @Date)
					WHEN 'Week' LIKE @DatePart + '%' THEN DATEPART(WEEK, @Date)
					WHEN 'Day' LIKE @DatePart + '%' THEN DATEPART(Day, @Date)
					ELSE NULL
				END
	RETURN @Part
END
GO
-- Testing Answer
DECLARE @TestDates TABLE(
D DATE
)
DECLARE @DateParts TABLE(
[DatePart] NVARCHAR(12)
)
INSERT INTO @TestDates (D) VALUES ('3141-5-9'), ('1011-12-13')
INSERT INTO @DateParts ([DatePart]) VALUES ('Y'), ('Q'), ('M'), ('W'), ('D')
SELECT D, [DatePart] AS [Date part string], [dbo].DatePartFromString([DatePart],D) AS [Date part number]
FROM @TestDates CROSS JOIN @DateParts
ORDER BY D, [DatePart]
GO

-- Question  5: Create function [dbo].[GetPeriodRange] that returns the start and end dates
-- of a period for a given date.
-- Period argument is a string that matches all or part of: Year, Quarter, Month, Week, Day
--
-- Hint: use a Multi-Statement Table-Valued type of function
-- to return a single row with StartDate and EndDate columns
--
-- If any argument is NULL, return NULL on both, StartDate and EndDate, columns.
--
-- Use the following code to test your solution
/*
DECLARE @TestDates TABLE(
D DATE
)

DECLARE @DateParts TABLE(
[DatePart] NVARCHAR(12)
)

INSERT INTO @TestDates (D) VALUES ('3141-5-9'), ('1011-12-13')
INSERT INTO @DateParts ([DatePart]) VALUES ('Y'), ('Q'), ('M'), ('W'), ('D')

SELECT D, [DatePart] AS [Date part string], P.[StartDate], P.[EndDate]
FROM @TestDates CROSS JOIN @DateParts CROSS APPLY [dbo].GetPeriodRange([Datepart], D) P
ORDER BY D, [DatePart]

D Date part string StartDate EndDate
---------- ---------------- ---------- ----------
1011-12-13 D 1011-12-13 1011-12-13
1011-12-13 M 1011-12-01 1011-12-31
1011-12-13 Q 1011-10-01 1011-12-31
1011-12-13 W 1011-12-08 1011-12-14
1011-12-13 Y 1011-01-01 1011-12-31
3141-05-09 D 3141-05-09 3141-05-09
3141-05-09 M 3141-05-01 3141-05-31
3141-05-09 Q 3141-04-01 3141-06-30
3141-05-09 W 3141-05-04 3141-05-10
3141-05-09 Y 3141-01-01 3141-12-31
*/
-- Attempt 1
--DROP FUNCTION IF EXISTS [dbo].[GetPeriodRange]
--GO
--CREATE FUNCTION [dbo].[GetPeriodRange] (
--	@DatePart NVARCHAR(1),
--	@Date DATE
--)
--RETURNS @GetPeriodRangeTable TABLE (
--	StartDate DATE,
--	EndDate DATE
--)
--AS
--BEGIN
--	IF @DatePart IS NULL OR @Date IS NULL
--		INSERT INTO @GetPeriodRangeTable VALUES (NULL, NULL)
--	ELSE
--		INSERT INTO @GetPeriodRangeTable
--	SELECT
--		CASE
--			WHEN 'Year' LIKE @DatePart + '%' THEN @Date
--			WHEN 'Quarter' LIKE @DatePart + '%' THEN @Date
--			WHEN 'Month' LIKE @DatePart + '%' THEN @Date
--			WHEN 'Week' LIKE @DatePart + '%' THEN @Date
--			WHEN 'Day' LIKE @DatePart + '%' THEN @Date
--			ELSE NULL
--		END AS [StartDate],
--		CASE
--			WHEN 'Year' LIKE @DatePart + '%' THEN @Date
--			WHEN 'Quarter' LIKE @DatePart + '%' THEN @Date
--			WHEN 'Month' LIKE @DatePart + '%' THEN @Date
--			WHEN 'Week' LIKE @DatePart + '%' THEN @Date
--			WHEN 'Day' LIKE @DatePart + '%' THEN @Date
--			ELSE NULL
--		END AS [EndDate]
--	RETURN
--END
--GO
-- Attempt 2: Final Answer
DROP FUNCTION IF EXISTS [dbo].[GetPeriodRange]
GO
CREATE FUNCTION [dbo].[GetPeriodRange] (
	@DatePart NVARCHAR(1),
	@Date DATE
)
RETURNS @GetPeriodRangeTable TABLE (
	StartDate DATE,
	EndDate DATE
)
AS
BEGIN
	IF @DatePart IS NULL OR @Date IS NULL
		INSERT INTO @GetPeriodRangeTable VALUES (NULL, NULL)
	ELSE
		INSERT INTO @GetPeriodRangeTable
	SELECT
		CASE
			WHEN 'Year' LIKE @DatePart + '%' 
				THEN DATEFROMPARTS(DATEPART(YEAR, @Date), 1, 1)
			WHEN 'Quarter' LIKE @DatePart + '%' 
				THEN DATEFROMPARTS(DATEPART(YEAR, @Date), (DATEPART(QUARTER, @Date)-1)*3 + 1, 1)
			WHEN 'Month' LIKE @DatePart + '%' 
				THEN DATEFROMPARTS(DATEPART(YEAR, @Date), DATEPART(MONTH, @Date), 1)
			WHEN 'Week' LIKE @DatePart + '%' 
				THEN DATEADD(DAY, -DATEPART(WEEKDAY, @Date) + 1, @Date)
			WHEN 'Day' LIKE @DatePart + '%' 
				THEN @Date
			ELSE NULL
		END AS [StartDate],
		CASE
			WHEN 'Year' LIKE @DatePart + '%' 
				THEN DATEFROMPARTS(DATEPART(YEAR, @Date), 12, 31)
			WHEN 'Quarter' LIKE @DatePart + '%' 
				THEN EOMONTH(DATEFROMPARTS(DATEPART(YEAR, @Date), (DATEPART(QUARTER, @Date)-1)*3 + 3, 1))
			WHEN 'Month' LIKE @DatePart + '%' 
				THEN EOMONTH(@Date)
			WHEN 'Week' LIKE @DatePart + '%' 
				THEN DATEADD(DAY, 7 - DATEPART(WEEKDAY, @Date), @Date)
			WHEN 'Day' LIKE @DatePart + '%' 
				THEN @Date
			ELSE NULL
		END AS [EndDate]
	RETURN
END
GO
-- Testing Answer
DECLARE @TestDates TABLE(
D DATE
)
DECLARE @DateParts TABLE(
[DatePart] NVARCHAR(12)
)
INSERT INTO @TestDates (D)
VALUES ('3141-5-9'), ('1011-12-13')
INSERT INTO @DateParts ([DatePart])
VALUES ('Y'), ('Q'), ('M'), ('W'), ('D')
SELECT D, [DatePart] AS [Date part string], P.[StartDate], P.[EndDate]
FROM @TestDates CROSS JOIN @DateParts CROSS APPLY [dbo].GetPeriodRange([Datepart], D) P
ORDER BY D, [DatePart]
GO

-- Question  6: Create function[dbo].[GetProductPeriodSales] to
-- get the total sales of product, for the specified period of time,
-- around given date.
-- Periods of time are: All, Year, Quarter, Month, Week, Day
--
-- If any argument is NULL, return NULL
--
-- Use the following code to test your solution
/*

DECLARE @TestDates TABLE(
D DATE
)

DECLARE @DateParts TABLE(
[DatePart] NVARCHAR(12)
)

INSERT INTO @TestDates (D) VALUES ('2012-5-9'), ('2013-12-13')
INSERT INTO @DateParts ([DatePart]) VALUES ('ALL'), ('Y'), ('Q'), ('M'), ('W'), ('D')

SELECT D, [DatePart] AS [Date part string], P.[StartDate], P.[EndDate], [dbo].[GetProductPeriodSales](782, [DatePart], D) TotalSales
FROM @TestDates CROSS JOIN @DateParts CROSS APPLY [dbo].GetPeriodRange([Datepart], D) P
ORDER BY D, [DatePart]

D Date part string StartDate EndDate TotalSales
---------- ---------------- ---------- ---------- ---------------------
2012-05-09 ALL NULL NULL 4400592.8004
2012-05-09 D 2012-05-09 2012-05-09 NULL
2012-05-09 M 2012-05-01 2012-05-31 104094.1869
2012-05-09 Q 2012-04-01 2012-06-30 280726.4491
2012-05-09 W 2012-05-06 2012-05-12 NULL
2012-05-09 Y 2012-01-01 2012-12-31 1142403.3781
2013-12-13 ALL NULL NULL 4400592.8004
2013-12-13 D 2013-12-13 2013-12-13 6884.97
2013-12-13 M 2013-12-01 2013-12-31 216647.056
2013-12-13 Q 2013-10-01 2013-12-31 587058.442
2013-12-13 W 2013-12-08 2013-12-14 16064.93
2013-12-13 Y 2013-01-01 2013-12-31 2212974.7827
*/
-- Attempt 1: Having trouble accessing [dbo].GetPeriodRange()
-- Error Message
--Msg 102, Level 15, State 1, Procedure GetProductPeriodSales, Line 9 [Batch Start Line 568]
--Incorrect syntax near ')'.
--Msg 102, Level 15, State 1, Procedure GetProductPeriodSales, Line 17 [Batch Start Line 568]
--Incorrect syntax near ')'.
DROP FUNCTION IF EXISTS [dbo].[GetProductPeriodSales]
GO
CREATE FUNCTION [dbo].[GetProductPeriodSales] (
	@ProductId INT,
	@Period NVARCHAR(12),
	@Date DATE
)
RETURNS MONEY
AS
BEGIN
	IF @ProductId IS NULL OR @Period IS NULL OR @Date IS NULL) RETURN NULL
	DECLARE @Sales MONEY = 0
	DECLARE @StartDate DATE
	DECLARE @EndDate DATE
	
	IF @Period = 'ALL'
		SELECT 
			@SALES = SUM([LineTotal])
		FROM [Sales].[SalesOrderDetail])
		WHERE [ProductID] = @ProductId
	ELSE
	BEGIN
		SELECT 
			@StartDate = P.[StartDate],
			@EndDate = P.[EndDate]
		FROM [dbo].[GetPeriodRange](@Period, @Date) P
		SELECT 
			@SALES = SUM([LineTotal])
		FROM [Sales].[SalesOrderDetail] D
		INNER JOIN [Sales].[SalesOrderHeader] H
			ON D.[SalesOrderID] = H.[SalesOrderID]
		WHERE [ProductID] = @ProductId
		AND H.[OrderDate]
		BETWEEN @StartDate
		AND @EndDate
	END
	RETURN @Sales
END
GO
-- Testing Answer
DECLARE @TestDates TABLE(
D DATE
)
DECLARE @DateParts TABLE(
[DatePart] NVARCHAR(12)
)
INSERT INTO @TestDates (D) VALUES ('2012-5-9'), ('2013-12-13')
INSERT INTO @DateParts ([DatePart]) VALUES ('ALL'), ('Y'), ('Q'), ('M'), ('W'), ('D')
SELECT 
	D,
	[DatePart] AS [Date part string],
	P.[StartDate],
	P.[EndDate],
	[dbo].[GetProductPeriodSales](782, [DatePart], D) TotalSales
FROM @TestDates CROSS JOIN @DateParts CROSS APPLY [dbo].GetPeriodRange([Datepart], D) P
ORDER BY D, [DatePart]
GO

-- Question  7: Create a function [dbo].[TestInventory] to
-- check if there are enough items of a ProductId
-- to fulfill an order of N items (quantity)
--
-- If any argument is NULL, return NULL
-- If the ProductId doesn't exist, return NULL
-- If the requested quantity is negative, return NULL
--
-- If there are enough items to fulfill order return 1;
-- otherwise, return 0
--
-- Use the following code to test your solution

/*
DECLARE @RequestedProducts TABLE(
P INT
)

DECLARE @RequestedQuantity TABLE(
Q INT
)

INSERT INTO @RequestedProducts (P) VALUES (5), (7), (680), (717), (853), (882), (860), (842);
INSERT INTO @RequestedQuantity (Q) VALUES (-1), (5), (50), (500);

WITH InventorySummary AS (
SELECT P.[ProductID], SUM([Quantity]) AS [Available Qty]
FROM [Production].[Product] P
JOIN [Production].[ProductInventory] I ON P.[ProductID] = I.[ProductID]
GROUP BY P.[ProductID]
)
SELECT T.[P] AS [Requested Product], I.[ProductID], Q.[Q] AS [Requested Quantity], I.[Available Qty], [dbo].[TestInventory](T.[P], Q.[Q]) AS [Enough Inventory]
FROM @RequestedQuantity Q CROSS JOIN @RequestedProducts T
LEFT JOIN InventorySummary I ON T.[P] = I.[ProductID]
ORDER BY T.[P], Q.[Q]

Requested Product ProductID Requested Quantity Available Qty Enough Inventory
----------------- ----------- ------------------ ------------- ----------------
5 NULL -1 NULL NULL
5 NULL 5 NULL NULL
5 NULL 50 NULL NULL
5 NULL 500 NULL NULL
7 NULL -1 NULL NULL
7 NULL 5 NULL NULL
7 NULL 50 NULL NULL
7 NULL 500 NULL NULL
680 NULL -1 NULL NULL
680 NULL 5 NULL 0
680 NULL 50 NULL 0
680 NULL 500 NULL 0
717 NULL -1 NULL NULL
717 NULL 5 NULL 0
717 NULL 50 NULL 0
717 NULL 500 NULL 0
842 842 -1 72 NULL
842 842 5 72 1
842 842 50 72 1
842 842 500 72 0
853 853 -1 0 NULL
853 853 5 0 0
853 853 50 0 0
853 853 500 0 0
860 860 -1 36 NULL
860 860 5 36 1
860 860 50 36 0
860 860 500 36 0
882 882 -1 0 NULL
882 882 5 0 0
882 882 50 0 0
882 882 500 0 0
*/
-- Attempt 1
--SELECT
--	[ProductID]
--FROM [Production].[Product]
--GO
-- Attempt 2
--SELECT
--	[ProductID]
--FROM [Production].[Product]
--WHERE [ProductID] = 980
--GO
-- Attempt 3: Final Answer
DROP FUNCTION IF EXISTS [dbo].[TestInventory]
GO
CREATE FUNCTION [dbo].[TestInventory]
(
	@ProductId INT,
	@Quantity INT
)
RETURNS BIT
AS
BEGIN 
	IF (@ProductId IS NULL
		OR @Quantity IS NULL
		OR NOT EXISTS(
			SELECT
				[ProductID]
			FROM [Production].[Product]
			WHERE [ProductID] = @ProductId)
		OR @Quantity < 0)
	RETURN NULL

	DECLARE @Available INT = (
		SELECT
			SUM([Quantity])
		FROM [Production].[ProductInventory]
		WHERE [ProductID] = @ProductId)

	RETURN
		CASE
			WHEN @Available >= @Quantity
				THEN 1
			ELSE 0
		END
END
GO
-- Testing Answer
DECLARE @RequestedProducts TABLE(
P INT
)
DECLARE @RequestedQuantity TABLE(
Q INT
)
INSERT INTO @RequestedProducts (P)
	VALUES (5), (7), (680), (717), (853), (882), (860), (842);
INSERT INTO @RequestedQuantity (Q)
	VALUES (-1), (5), (50), (500);
WITH InventorySummary AS (
SELECT P.[ProductID], SUM([Quantity]) AS [Available Qty]
FROM [Production].[Product] P
JOIN [Production].[ProductInventory] I ON P.[ProductID] = I.[ProductID]
GROUP BY P.[ProductID]
)
SELECT
	T.[P] AS [Requested Product],
	I.[ProductID], Q.[Q] AS [Requested Quantity],
	I.[Available Qty],
	[dbo].[TestInventory](T.[P], Q.[Q]) AS [Enough Inventory]
FROM @RequestedQuantity Q CROSS JOIN @RequestedProducts T
LEFT JOIN InventorySummary I ON T.[P] = I.[ProductID]
ORDER BY T.[P], Q.[Q]
GO

-- Question  8: Create a stored procedure [dbo].[TopNProductsInPeriod]
-- that returns the top N products sold during the specified period of time,
-- around given date.
--
-- Periods of time are: All, Year, Quarter, Month, Week, Day
-- Attempt 1: Final Answer
DROP PROCEDURE IF EXISTS [dbo].[TopNProductsInPeriod]
GO
CREATE OR ALTER PROCEDURE [dbo].[TopNProductsInPeriod]
	@TopN INT,
	@Period NVARCHAR(12),
	@Date DATE
AS
	DECLARE @StartDate DATE
	DECLARE @EndDate DATE
	SELECT 
		@StartDate = R.[StartDate],
		@EndDate = R.[EndDate]
	FROM [dbo].[GetPeriodRange](@Period, @Date) R;

	WITH TopNProducts AS (
		SELECT 
			TOP (@TopN) D.[ProductID],
			SUM(D.[LineTotal]) AS [Sales Total]
		FROM [Sales].[SalesOrderDetail] D
		INNER JOIN [Sales].[SalesOrderHeader] H
			ON D.[SalesOrderID] = H.[SalesOrderID]
		WHERE CAST(H.[OrderDate] AS DATE)
			BETWEEN @StartDate
			AND @EndDate
		GROUP BY D.[ProductID]
		ORDER BY SUM(D.[LineTotal]) DESC
	)
	SELECT 
		P.[ProductID],
		P.[Name],
		T.[Sales Total]
	FROM [Production].[Product] P
	INNER JOIN TopNProducts T
		ON P.[ProductID] = T.[ProductID]
GO
EXEC [dbo].[TopNProductsInPeriod] @TopN=4, @Period='Q', @Date='2013-12-13'
GO

-- Question  9: Create a stored procedure to insert a detail
-- line in [Sales].[SalesOrderDetail], for a
-- given order.
--
-- Validate the requested quantity of product is
-- available in inventory.
-- Use list price value, in product information,
-- as the unit price.
-- Use return code -1 to indicate not enough inventory
-- Use return code 0 to indicate detail inserted; there
-- is enough inventory.
-- Attempt 1: Final Answer
CREATE PROCEDURE [dbo].[InsertSalesOrderDetail]
	@OrderID INT,
	@TrackingNum NVARCHAR(25) = NULL,
	@OrderQuantity INT,
	@prodID INT,
	@promo INT = 1,
	@UnitPriceDiscount MONEY = 0.00
AS
	DECLARE @ModifiedDate DATETIME = GETDATE()
	DECLARE @UnitPrice MONEY = (
		SELECT pd.ListPrice
		FROM Production.Product as PD
		WHERE PD.ProductID = @prodID
	)
	DECLARE @avalability INT = (
		SELECT SUM(PINV.Quantity)
		FROM Production.ProductInventory AS PINV
		WHERE PINV.ProductID = @prodID
	)

	IF @avalability < @OrderQuantity RETURN -1 
	IF @UnitPrice IS NULL RETURN -2
	IF NOT EXISTS (
		SELECT
			1
		FROM [Sales].[SalesOrderHeader]
		WHERE [SalesOrderID] = @OrderID
	)
	RETURN -3
	IF EXISTS (
		SELECT
			1
		FROM [Sales].[SalesOrderDetail]
		WHERE [SalesOrderID] = @OrderID
		AND [ProductID] = @prodID
	)
	RETURN -4


	BEGIN TRAN
	INSERT INTO [Sales].[SalesOrderDetail] (
		[SalesOrderID],
		[CarrierTrackingNumber],
		[OrderQty],
		[ProductID],
		[SpecialOfferID],
		[UnitPrice],
		[UnitPriceDiscount],
		[rowguid],
		[ModifiedDate]
	)
	VALUES (
		@OrderID,
		@TrackingNum,
		@OrderQuantity,
		@prodID,
		@promo,
		@UnitPrice,
		@UnitPriceDiscount,
		NEWID(),
		@ModifiedDate
	)

	DECLARE @QuanitityAtLocation INT
	DECLARE @LocationID SMALLINT
		WHILE @OrderQuantity > 0
		BEGIN
			SELECT TOP 1 @QuanitityAtLocation = [Quantity], @LocationID = [LocationID]
				FROM [Production].[ProductInventory]
				WHERE [ProductID] = @prodID
				ORDER BY [Quantity] DESC
			IF @QuanitityAtLocation >= @OrderQuantity
			BEGIN
				UPDATE [Production].[ProductInventory]
					SET [Quantity] -= @OrderQuantity
					WHERE [ProductID] = @prodID
					AND [LocationID] = @LocationID
				SET @OrderQuantity = 0
			END
			ELSE
			BEGIN
				UPDATE [Production].[ProductInventory]
					SET [Quantity] = 0
					WHERE [ProductID] = @prodID
					AND [LocationID] = @LocationID
				SET @OrderQuantity -= @QuanitityAtLocation
			END
		END
	COMMIT
GO

-- Question  10: Write SQL stored procedure that allows you to
-- update the cost value of a product, as a percental change,
-- when you are given:
-- > The cost change as a percent of increment
-- (to be applied to all products mentioned above)
--
-- > a table variable with Product Ids
--
-- > a table variable with Product Sub-Category Ids
-- (understanding that all products under those
-- Sub-Categories are to be updated)
--
-- > a table variable with Category Ids
-- (understanding that all products under those
-- Categories are to be updated)
--
-- !! Business Rules
-- + Existing cost information must be archived in ProductCostHIstory table
--
-- + Existing open cost history needs to be properly closed
--
-- + All records need to be stamped with modified date
--
-- > Handle the case when all table variables are correctly defined,
-- but might not have rows in them
--
-- > Make the stored precedure in such way that it can recover
-- from errors; no changes are final, until the entire operation
-- is successful.
--
-- Test your store procedure using the following input:
--
/*
USE AdventureWorks2014
GO


DECLARE @ProductIdInput [IdsType]

DECLARE @ProductSubcategoryIDInput [IdsType]

DECLARE @ProductCategoryIDInput [IdsType]

DECLARE @CostChange decimal(5,2)


--! #########################################################
--! Assume the user is giving you the all of following input
--! [ProductID]s: 1, 3, 317
--! [ProductSubcategoryID]s: 7, 11, 13
--! [ProductCategoryID]s: 1, 4
--! Cost Change: 5.5 (as percent)
INSERT INTO @ProductIdInput (Id) VALUES (1), (3), (317)

INSERT INTO @ProductSubcategoryIDInput (Id) VALUES (7), (11)

INSERT INTO @ProductCategoryIDInput (Id) VALUES (4)

SET @CostChange = 5.5


BEGIN TRAN
EXECUTE [dbo].[UpdateCost] @ProductIdInput, @ProductSubcategoryIDInput, @ProductCategoryIDInput, @CostChange
ROLLBACK
GO

ProductCategoryID ProductSubcategoryID ProductID StandardCost OldStandardCost CostStartDate CostOldStartDate ModifiedDate
----------------- -------------------- ----------- --------------------- --------------------- ----------------------- ----------------------- -----------------------
NULL NULL 1 0.00 0.00 2018-05-04 00:03:56.237 NULL 2018-05-04 00:03:56.237
NULL NULL 3 0.00 0.00 2018-05-04 00:03:56.237 NULL 2018-05-04 00:03:56.237
NULL NULL 317 0.00 0.00 2018-05-04 00:03:56.237 NULL 2018-05-04 00:03:56.237
2 7 952 9.4809 8.9866 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
2 11 805 16.02 15.1848 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
2 11 806 47.9147 45.4168 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
2 11 807 58.426 55.3801 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 26 876 47.3484 44.88 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 27 879 62.7366 59.466 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 28 870 1.9689 1.8663 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 28 871 3.9418 3.7363 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 28 872 3.5472 3.3623 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 29 877 3.1368 2.9733 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 30 878 8.6726 8.2205 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 31 707 13.806 13.0863 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 31 708 13.806 13.0863 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 31 711 13.806 13.0863 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 32 880 21.6974 20.5663 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 33 846 6.0883 5.7709 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 33 847 15.2272 14.4334 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 33 848 19.5791 18.5584 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 34 843 10.8797 10.3125 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 35 842 54.3984 51.5625 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 36 844 8.6994 8.2459 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 36 845 10.8754 10.3084 2018-05-04 00:03:56.237 2012-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 873 0.9036 0.8565 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 921 1.9689 1.8663 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 922 1.5744 1.4923 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 923 1.9689 1.8663 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 928 9.8603 9.3463 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 929 11.8332 11.2163 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 930 13.81 13.09 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 931 8.4794 8.0373 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 932 9.8603 9.3463 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 933 12.863 12.1924 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
4 37 934 11.4386 10.8423 2018-05-04 00:03:56.237 2013-05-30 00:00:00.000 2018-05-04 00:03:56.237
*/
-- Attempt 1: Unsure?