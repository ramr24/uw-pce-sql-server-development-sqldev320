/**************************************************
** File: Assignment 4
** Date: 2023-05-12
** Auth: Ramkumar Rajanbabu
***************************************************
** Desc: Module 4 - Assignment 4
***************************************************
** Modification History
***************************************************
** Date			Author				Description 
** ----------	------------------  ---------------
** 2023-05-12	Ramkumar Rajanbabu	Completed questions 1, 2, 3
** 2023-05-15	Ramkumar Rajanbabu	Completed questions 4, 6, 7, 9
**************************************************/

-- Access Database
USE [AdventureWorks2019]
GO

-- **Questions**
-- Question  1: In the [Production].[Product] table find all products
-- with no color defined
-- Attempt 1
--SELECT
--	[ProductID],
--	[Color]
--FROM [Production].[Product]
--GO
-- Attempt 2: Final Answer
SELECT
	[ProductID],
	[Color]
FROM [Production].[Product]
WHERE [Color] IS NULL
GO

-- Question  2: Write a query that will display 'Undefined color')
-- when no color is defined in the [Production].[Product] table,
-- otherwise report the color
-- Attempt 1
--SELECT
--	[ProductID],
--	[Color]
--FROM [Production].[Product]
--WHERE [Color] IS NULL
--GO 
-- Attempt 2: Final Answer
SELECT
	[ProductID],
	CASE
		WHEN [Color] IS NULL THEN 'Undefined color'
		ELSE [Color]
	END AS [Color]
FROM [Production].[Product]
GO
-- Attempt 3: Final Answer (2nd Method)
SELECT
	[ProductID],
	COALESCE([Color], 'Undefined color')
FROM [Production].[Product]
GO
-- Attempt 4: Final Answer (3rd Method)
SELECT
	[ProductID],
	ISNULL([Color], 'Undefined color')
FROM [Production].[Product]
GO

-- Question  3: Find the average value of a Sales Order
-- and return those orders that are less than the average
-- Attempt 1
--SELECT
--	[SalesOrderID],
--	[SubTotal]
--FROM [Sales].[SalesOrderHeader]
--GO
-- Attempt 2: Final Answer
WITH AverageValue AS (
	SELECT
		AVG([SubTotal]) AS [Average Subtotal]
	FROM [Sales].[SalesOrderHeader]
)
SELECT
	[SalesOrderID],
	[SubTotal]
FROM [Sales].[SalesOrderHeader], AverageValue
WHERE [SubTotal] < AverageValue.[Average Subtotal]
GO

-- Question  4: Using the information from Question  3,
-- find the percentage of Sales
-- that are less than the average value of a sale
-- Attempt 1
--WITH AverageValue AS (
--	SELECT
--		AVG([SubTotal]) AS [Average Subtotal]
--	FROM [Sales].[SalesOrderHeader]
--)
--SELECT
--	[SalesOrderID],
--	[SubTotal]
--FROM [Sales].[SalesOrderHeader], AverageValue
--WHERE [SubTotal] < AverageValue.[Average Subtotal]
--GO
-- Attempt 2
--WITH AverageValue AS (
--	SELECT
--		AVG([SubTotal]) AS [Average Subtotal]
--	FROM [Sales].[SalesOrderHeader]
--)
--SELECT
--	COUNT(*) AS [Sales below Average]
--FROM [Sales].[SalesOrderHeader], AverageValue
--WHERE [SubTotal] < AverageValue.[Average Subtotal]
--GO
-- Attempt 3: Final Answer (Incomplete for Pct Column)
WITH AverageValue AS (
	SELECT
		AVG([SubTotal]) AS [Average Subtotal]
	FROM [Sales].[SalesOrderHeader]
),
SalesBelowAverage AS (
	SELECT
		COUNT(*) AS [Sales below Average]
	FROM [Sales].[SalesOrderHeader], AverageValue
	WHERE [SubTotal] < AverageValue.[Average Subtotal]
)
SELECT
	COUNT(*) AS [Total Sales],
	SalesBelowAverage.[Sales below Average],
	([Sales below Average] / COUNT(*)) * 100 AS [Pct Sales below Average]
FROM [Sales].[SalesOrderHeader], SalesBelowAverage
GROUP BY [Sales below Average]
GO

-- Question  5: Write a script that creates index [SalesOrderDetail_CarrierTracking]
-- on [Sales].[SalesOrderDetail]
-- For [CarrierTrackingNumber], [SalesOrderID], [SalesOrderDetailID]
-- Make sure the index does not exist before attemping to create it
-- Hint: drop the index, if the index exists, before creating it
-- Hint: Get the table id first; either get it from [sys].[tables] or use the OBJECT_ID() function
-- Hint: check in [sys].[indexes] if the index exists
-- Attempt 1
SELECT 
	[SalesOrderID],
	[SalesOrderDetailID],
	[CarrierTrackingNumber]
FROM [Sales].[SalesOrderDetail]
GO

IF OBJECT_ID('dbo.IfTest', 'U') IS NOT NULL
	BEGIN
		DROP TABLE [dbo].[IfTest]
		PRINT 'Table dropped'
	END

CREATE TABLE [dbo].[IfTest] (
	COL1 INT NOT NULL PRIMARY KEY
)

-- Question  6: Check which numbers between 101 and 200 are primes
-- Attempt 1
--DECLARE @PRange INT = 200
--DECLARE @X INT = 101
--DECLARE @Y INT = 101
-- Attempt 2
--DECLARE @PRange INT = 200
--DECLARE @X INT = 101
--DECLARE @Y INT = 101

--WHILE (@Y <= @PRange)
--BEGIN
--	PRINT @Y
--SET @X = 2
--SET @Y = @Y + 1 
--END
-- Attempt 3: Final Answer
DECLARE @PRange INT = 200
DECLARE @X INT = 101
DECLARE @Y INT = 101

WHILE (@Y <= @PRange)
BEGIN
	WHILE (@X <= @Y) 
	BEGIN
		IF ((@Y % @X) = 0) 
		BEGIN
			IF (@X = @Y) 
				PRINT @Y
				BREAK
		END
	IF ((@Y % @X) <> 0)   
	SET @X = @X + 1
	END
SET @X = 2
SET @Y = @Y + 1 
END

-- Question  7: Write the Fibonacci sequence for a given value of N = 25
-- Make the script flexible enough that N can be changed to
-- any arbitrary number and the script should still work.
-- The Fibonacci sequence is defined as:
--
-- N: 0| 1| 2| 3| 4| 5| 6 7| 8| ... | n |
-- -: -|--|--|--|--|--|---|---|---|-----|----------------|
-- F: 0| 1| 1| 2| 3| 5| 8| 13| 21| ... | F(n-2) + F(n-1)|
-- Attempt 1
--DECLARE @N INT = 25
--DECLARE @A INT = 0
--DECLARE @B INT = 1
--DECLARE @C INT = 0
--DECLARE @I INT = 0

--PRINT @A
--PRINT @B
-- Attempt 2: Final Answer
DECLARE @N INT = 25
DECLARE @A INT = 0
DECLARE @B INT = 1
DECLARE @C INT = 0
DECLARE @I INT = 0

PRINT @A
PRINT @B
WHILE @I <= (@N - 2)
BEGIN
	SET @C = @A + @B
	PRINT @C
	SET @I = @I + 1
	SET @A = @B
	SET @B = @C
END

-- Question  8: Generate a list of 1000 random numbers
-- between 10 and 19, both ends inclusive
-- Show the frequency table
-- Note: your frequency table values should be
-- different from one run to the next one
-- Attempt 1



-- Question  9: Given a comma separated list of numbers as a string
-- create a table with the numbers and the running sum.
-- Warning: In this exercise you cannot use the STRING_SPLIT() function
-- Assume as your input is: ' 1, 2, 3, 4, 316, 323, 324, 325, 326, 327, 328, 329'
-- Attempt 1: Final Answer 
USE ramr2012;
GO
DROP TABLE IF EXISTS [dbo].[Running Sum]
GO
DELETE FROM [dbo].[RunningSum]
GO

CREATE TABLE [dbo].[RunningSum] (
	N INT,
	RunningSum INT
)
GO
INSERT INTO [dbo].[RunningSum]
	(N)
VALUES
	(1),
	(2),
	(3),
	(4),
	(316),
	(323),
	(324),
	(325),
	(326),
	(327),
	(328),
	(329)
GO

SELECT
	[N],
	SUM([N])
		OVER (ORDER BY [N] ASC) AS [RunningSUM]
FROM [dbo].[RunningSum]
GO

-- Question  10: Using the Employee-Manager table, generated by the following script,
-- List the company org-chart
DECLARE @EmployeeManager TABLE(
EmployeeId INT NOT NULL,
ManagerId INT NULL
);

WITH EmpHierarchy AS (
SELECT [BusinessEntityID] AS [EmpId], COALESCE([OrganizationNode], hierarchyid::GetRoot()) AS [NodeId]
FROM [HumanResources].[Employee]
)
INSERT INTO @EmployeeManager (EmployeeId, ManagerId)
SELECT E.[EmpId] AS [EmpId], M.[EmpId] AS [MgrId]
FROM EmpHierarchy E LEFT JOIN EmpHierarchy M ON E.[NodeId].GetAncestor(1) = M.[NodeId]