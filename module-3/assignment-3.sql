/**************************************************
** File: Assignment 3
** Date: 2023-05-10
** Auth: Ramkumar Rajanbabu
***************************************************
** Desc: Module 3 - Assignment 3
***************************************************
** Modification History
***************************************************
** Date			Author				Description 
** ----------	------------------  ---------------
** 2023-05-10	Ramkumar Rajanbabu	Completed questions 3, 4, 10.
** 2023-05-11	Ramkumar Rajanbabu	Completed questions 1, 5, 8. Incomplete Questions 2, 6, 7, 9 
**************************************************/

-- Access Database
USE [AdventureWorks2019]
GO

SET ANSI_WARNINGS OFF
SET NOCOUNT ON

-- **Questions**
-- Q01 Get all order details with a negative margin
-- Show results: SalesOrderID, SalesOrderDetailID, Margin
-- Define Margin := Sales - Total Cost
-- Hint: Follow the relationship SalesOrderDetail >-- Product
-- Attempt 1
--SELECT
--	[D].[SalesOrderID],
--	[D].[SalesOrderDetailID],
--	[D].[LineTotal] - ([D].[OrderQty] * [P].[Standardcost]) AS [Margin]
--FROM [Sales].[SalesOrderDetail] AS D
--	INNER JOIN [Production].[Product] AS P
--		ON [D].[ProductID] = [P].[ProductID]
--WHERE [D].[LineTotal] - ([D].[OrderQty] * [P].[Standardcost]) < 0
--GO
-- Attempt 2: Final Answer
SELECT
	[D].[SalesOrderID],
	[D].[SalesOrderDetailID],
	SUM([D].[LineTotal]) - SUM([D].[OrderQty] * [P].[Standardcost]) AS [Margin]
FROM [Sales].[SalesOrderDetail] AS D
	INNER JOIN [Production].[Product] AS P
		ON [D].[ProductID] = [P].[ProductID]
WHERE [D].[LineTotal] - ([D].[OrderQty] * [P].[Standardcost]) < 0
GROUP BY
	[D].[SalesOrderID],
	[D].[SalesOrderDetailID]
ORDER BY
	[D].[SalesOrderID],
	[D].[SalesOrderDetailID]
GO

-- Q02 Get all orders where one or more details have a negative margin
-- Show results: SalesOrderID, Total Negative Margin, Total Order Margin
-- Starting Tables
--[LineTotal], [Order Quantity], [StandardCost]-- Starting Tables
-- Attempt 1
SELECT
	[O].[SalesOrderID],
	[O].[OrderQty],
	[O].[LineTotal],
	[P].[Standardcost]
FROM [Sales].[SalesOrderDetail] AS O
	INNER JOIN [Production].[Product] AS P
		ON [O].[ProductID] = [P].[ProductID]
WHERE [O].[LineTotal] - [O].[OrderQty] * [P].[Standardcost] < 0


-- Q03 Get the count of all rows, "customer ids" and "sales person ids" in the
--SalesOrderHeader table
-- Show results: Rows, Count of Customer Ids, Count of SalesPerson Ids
-- Attempt 1
--SELECT 
--	* 
--FROM [Sales].[SalesOrderHeader]
--GO
-- Attempt 2
--SELECT 
--	COUNT(*) AS [Rows]
--FROM [Sales].[SalesOrderHeader]
--GO
-- Attempt 3: Final Answer
SELECT 
	COUNT(*) AS [Rows],
	COUNT([CustomerID]) AS [CustomerID],
	COUNT([SalesPersonID]) AS [SalesPersonID]
FROM [Sales].[SalesOrderHeader]
GO

-- Q04 Get the sales total value and number of items per year, month
-- Show results: Year, Month, Sales total, Items total
-- Hint: use the functions YEAR() and MONTH() to obtain the year and month
-- Attempt 1
--SELECT * FROM [Sales].[SalesOrderDetail]
--GO
--SELECT * FROM [Sales].[SalesOrderHeader]
--GO
-- Attempt 2
--SELECT
--	[sod].[SalesOrderID],
--	[sod].[SalesOrderDetailID],
--	YEAR([soh].[OrderDate]) AS [Year],
--	MONTH([soh].[OrderDate]) AS [Month],
--	[sod].[LineTotal] AS [Sales Total],
--	[sod].[OrderQty] AS [Items Total]
--FROM [Sales].[SalesOrderDetail] AS [sod]
--INNER JOIN [Sales].[SalesOrderHeader] AS [soh]
--ON [sod].[SalesOrderID] = [soh].[SalesOrderID]
--GO
-- Attempt 3: Final Answer
SELECT
	YEAR([H].[OrderDate]) AS [Year],
	MONTH([H].[OrderDate]) AS [Month],
	SUM([D].[LineTotal]) AS [Sales Total],
	SUM([D].[OrderQty]) AS [Items Total]
FROM [Sales].[SalesOrderDetail] AS [D]
INNER JOIN [Sales].[SalesOrderHeader] AS [H]
ON [D].[SalesOrderID] = [H].[SalesOrderID]
GROUP BY YEAR([H].[OrderDate]), MONTH([H].[OrderDate])
ORDER BY YEAR([H].[OrderDate]), MONTH([H].[OrderDate])
GO

-- Q05 Get the average value of an order by year, month
-- include the average number of lines and the average number of items per order
-- Show results: Year, Month, Avg Value of Orders, Avg Number of Items, Avg Number
--of Lines
-- Attempt 1
SELECT 
	[O].[SalesOrderID],
	SUM([O].[LineTotal]) AS [Order Total],
	SUM([O].[OrderQty]) AS [Order Items],
	COUNT(*) AS [Order Lines]
FROM [Sales].[SalesOrderDetail] O
GROUP BY [O].[SalesOrderID]
GO
-- Attempt 2: Final Answer
;WITH ORDER_SUMMARY AS (
	SELECT 
		[O].[SalesOrderID],
		SUM([O].[LineTotal]) AS [Order Total],
		SUM([O].[OrderQty]) AS [Order Items],
		COUNT(*) AS [Order Lines]
	FROM [Sales].[SalesOrderDetail] O
	GROUP BY [O].[SalesOrderID]
)
SELECT
	YEAR([OrderDate]) AS [Year],
	MONTH([OrderDate]) AS [Month],
	AVG([H].[SubTotal]) AS [Avg Value or Orders],
	AVG([Order Items]) AS [Avg Number of Items],
	AVG([Order Lines]) AS [Avg Number of Lines]
FROM [Sales].[SalesOrderHeader] AS H
	INNER JOIN ORDER_SUMMARY AS S
		ON H.[SalesOrderID] = S.[SalesOrderID]
GROUP BY YEAR([OrderDate]), MONTH([OrderDate])
ORDER BY YEAR([OrderDate]), MONTH([OrderDate])
GO

-- Q06 Get the total sales, cost, margin and margin percent per country
-- Define Margin = Sales Value - Cost Value
-- Define Margin% = (1 - Cost/Sales) * 100
-- Hint: Follow the relationships SalesOrderheader >-- SalesTerritory >--
--CountryRegion
-- Attempt 1
--SELECT
--	*
--FROM [Person].[CountryRegion] C
--	INNER JOIN [Sales].[SalesTerritory] T
--		ON [C].[CountryRegionCode] = [T].[CountryRegionCode]
--	INNER JOIN [Sales].[SalesOrderHeader] H
--		ON [H].[TerritoryID] = [T].[TerritoryID]
--	INNER JOIN [Sales].[SalesOrderDetail] D
--		ON [H].[SalesOrderID] = [D].[SalesOrderID]
--	INNER JOIN [Production].[Product] P
--		ON [D].[ProductID] = [P].[ProductID]
--GO
-- Attempt 2
SELECT
	*
FROM [Person].[CountryRegion] C
	INNER JOIN [Sales].[SalesTerritory] T
		ON [C].[CountryRegionCode] = [T].[CountryRegionCode]
	INNER JOIN [Sales].[SalesOrderHeader] H
		ON [H].[TerritoryID] = [T].[TerritoryID]
	INNER JOIN [Sales].[SalesOrderDetail] D
		ON [H].[SalesOrderID] = [D].[SalesOrderID]
	INNER JOIN [Production].[Product] P
		ON [D].[ProductID] = [P].[ProductID]
GO


-- Q07 Get the top 5 salespersons by margin per year
-- Show information as: Year, Employee ID, Employee Name (Last, First), Margin
-- For every year, show the top 5.
-- For Margin, use the definition given in Q04.
-- CROSS APPLY
-- tABLES: ORDERDETAIL, ORDERHEADER, PRODUCT, PERSON.PERSON, 


-- Q08 Get all 2012 customers that did not return in 2013
-- Attempt 1: Get all 2012 customers
--SELECT
--	[H].[CustomerID]
--FROM [Sales].[SalesOrderHeader] AS H
--WHERE YEAR([H].[OrderDate]) = 2012
--GO
-- Attempt 2: Get all 2013 customers
--SELECT
--	[H].[CustomerID]
--FROM [Sales].[SalesOrderHeader] AS H
--WHERE YEAR([H].[OrderDate]) = 2013
--GO
-- Attempt 3: Final Answer
SELECT
	[H].[CustomerID]
FROM [Sales].[SalesOrderHeader] AS H
WHERE YEAR([H].[OrderDate]) = 2012
EXCEPT
SELECT
	[H].[CustomerID]
FROM [Sales].[SalesOrderHeader] AS H
WHERE YEAR([H].[OrderDate]) = 2013
GO

-- Q09 Get the Quarterly percent of Total Sales change (quarter over quarter) for
--2011, 2012, 2013, 2014
-- Hints:
-- > use DATEPART(QUARTER, [OrderDate]) to obtain the quarter
-- > try making a self-join
-- > number quarters consecutively; so, you can compare first quarter of year
--against last quarter of previous year


-- Q010 Get SalesPerson monthly quota achievement pct for 2012
-- Define achivement as Total Sales / Quota
-- Asume Quota value is the monthly quota, and doesn't change over month
-- Hint: follow relationships SalesOrderHeader >-- SalesPerson >-- Person
-- Show results: [Last Name, First Name], Employee ID, Year, Month, SalesQuota,
--QuotaPct
-- Attempt 1
--SELECT
--	[SalesPersonID],
--	YEAR([OrderDate]) AS [Year],
--	MONTH([OrderDate]) AS [Month]
--FROM [Sales].[SalesOrderHeader]
--WHERE YEAR([OrderDate]) = 2012
--GO
-- Attempt 2
--SELECT
--	[soh].[SalesPersonID],
--	YEAR([soh].[OrderDate]) AS [Year],
--	MONTH([soh].[OrderDate]) AS [Month]
--FROM [Sales].[SalesOrderHeader] AS soh
--INNER JOIN [Sales].[SalesPerson] AS sp
--ON [soh].[SalesPersonID] = [sp].[BusinessEntityID]
--WHERE YEAR([soh].[OrderDate]) = 2012
--GO
-- Attempt 3
--SELECT
--	[soh].[SalesPersonID],
--	YEAR([soh].[OrderDate]) AS [Year],
--	MONTH([soh].[OrderDate]) AS [Month],
--	[sp].[SalesQuota]
--FROM [Sales].[SalesOrderHeader] AS soh
--INNER JOIN [Sales].[SalesPerson] AS sp
--ON [soh].[SalesPersonID] = [sp].[BusinessEntityID]
--WHERE YEAR([soh].[OrderDate]) = 2012
--GO
-- Attempt 4
--SELECT
--	([FirstName] + ' ' + [LastName]) AS Employee,
--	[soh].[SalesPersonID],
--	YEAR([soh].[OrderDate]) AS [Year],
--	MONTH([soh].[OrderDate]) AS [Month],
--	[sp].[SalesQuota]
--FROM [Sales].[SalesOrderHeader] AS soh
--INNER JOIN [Sales].[SalesPerson] AS sp
--ON [soh].[SalesPersonID] = [sp].[BusinessEntityID]
--INNER JOIN [Person].[Person] AS pp
--ON [sp].[BusinessEntityID] = [pp].[BusinessEntityID]
--WHERE YEAR([soh].[OrderDate]) = 2012
--GO
-- Attempt 5
--SELECT
--	([FirstName] + ' ' + [LastName]) AS Employee,
--	[pp].[BusinessEntityID],
--	YEAR([soh].[OrderDate]) AS [Year],
--	MONTH([soh].[OrderDate]) AS [Month],
--	[sp].[SalesQuota],
--	SUM([soh].[SubTotal]) AS [Month Total]
--FROM [Sales].[SalesOrderHeader] AS soh
--INNER JOIN [Sales].[SalesPerson] AS sp
--ON [soh].[SalesPersonID] = [sp].[BusinessEntityID]
--INNER JOIN [Person].[Person] AS pp
--ON [sp].[BusinessEntityID] = [pp].[BusinessEntityID]
--WHERE YEAR([soh].[OrderDate]) = 2012
--GROUP BY
--	([FirstName] + ' ' + [LastName]),
--	[pp].[BusinessEntityID],
--	YEAR([soh].[OrderDate]),
--	MONTH([soh].[OrderDate]),
--	[sp].[SalesQuota]
--GO
-- Attempt 6: Final Answer
SELECT
	([FirstName] + ' ' + [LastName]) AS Employee,
	[pp].[BusinessEntityID],
	YEAR([soh].[OrderDate]) AS [Year],
	MONTH([soh].[OrderDate]) AS [Month],
	[sp].[SalesQuota],
	SUM([soh].[SubTotal]) AS [Month Total],
	(SUM([soh].[SubTotal]) / [sp].[SalesQuota]) * 100 AS [Pct Quota]
FROM [Sales].[SalesOrderHeader] AS soh
	INNER JOIN [Sales].[SalesPerson] AS sp
		ON [soh].[SalesPersonID] = [sp].[BusinessEntityID]
	INNER JOIN [Person].[Person] AS pp
		ON [sp].[BusinessEntityID] = [pp].[BusinessEntityID]
WHERE YEAR([soh].[OrderDate]) = 2012
GROUP BY
	([FirstName] + ' ' + [LastName]),
	[pp].[BusinessEntityID],
	YEAR([soh].[OrderDate]),
	MONTH([soh].[OrderDate]),
	[sp].[SalesQuota]
GO