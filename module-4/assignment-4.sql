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
** 2023-05-12	Ramkumar Rajanbabu	Completed questions 1, 2
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

 

-- Question  5: Write a script that creates index [SalesOrderDetail_CarrierTracking]
-- on [Sales].[SalesOrderDetail]
-- For [CarrierTrackingNumber], [SalesOrderID], [SalesOrderDetailID]
-- Make sure the index does not exist before attemping to create it
-- Hint: drop the index, if the index exists, before creating it
-- Hint: Get the table id first; either get it from [sys].[tables] or use the OBJECT_ID() function
-- Hint: check in [sys].[indexes] if the index exists

 

-- Question  6: Check which numbers between 101 and 200 are primes

 

-- Question  7: Write the Fibonacci sequence for a given value of N = 25
-- Make the script flexible enough that N can be changed to
-- any arbitrary number and the script should still work.
-- The Fibonacci sequence is defined as:
--
-- N: 0| 1| 2| 3| 4| 5| 6 7| 8| ... | n |
-- -: -|--|--|--|--|--|---|---|---|-----|----------------|
-- F: 0| 1| 1| 2| 3| 5| 8| 13| 21| ... | F(n-2) + F(n-1)|

 

-- Question  8: Generate a list of 1000 random numbers
-- between 10 and 19, both ends inclusive
-- Show the frequency table
-- Note: your frequency table values should be
-- different from one run to the next one

 

-- Question  9: Given a comma separated list of numbers as a string
-- create a table with the numbers and the running sum.
-- Warning: In this exercise you cannot use the STRING_SPLIT() function
-- Assume as your input is: ' 1, 2, 3, 4, 316, 323, 324, 325, 326, 327, 328, 329'

 

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