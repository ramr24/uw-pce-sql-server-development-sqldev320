/**************************************************
** File: Assignment 3
** Date: 2023-05-09
** Auth: Ramkumar Rajanbabu
***************************************************
** Desc: Module 3 - Assignment 3
***************************************************
** Modification History
***************************************************
** Date			Author				Description 
** ----------	------------------  ---------------
** 2023-05-09	Ramkumar Rajanbabu	Started assignment
**************************************************/

-- Access Database
USE [AdventureWorks2019]
GO

SET ANSI_WARNINGS OFF
SET NOCOUNT ON

-- SQL Query to find the column names
--SELECT 
--	TABLE_SCHEMA,
--	TABLE_NAME,
--	COLUMN_NAME
--FROM INFORMATION_SCHEMA.COLUMNS
--WHERE COLUMN_NAME IN (
--	'Freight')
---- Exclude Views
--AND TABLE_NAME NOT LIKE 'V%'
--Order BY COLUMN_NAME
--GO

-- **Questions**
-- Q01 Get all order details with a negative margin
-- Show results: SalesOrderID, SalesOrderDetailID, Margin
-- Define Margin := Sales - Total Cost
-- Hint: Follow the relationship SalesOrderDetail >-- Product



-- Q02 Get all orders where one or more details have a negative margin
-- Show results: SalesOrderID, Total Negative Margin, Total Order Margin



-- Q03 Get the count of all rows, "customer ids" and "sales person ids" in the
--SalesOrderHeader table
-- Show results: Rows, Count of Customer Ids, Count of SalesPerson Ids



-- Q04 Get the sales total value and number of items per year, month
-- Show results: Year, Month, Sales total, Items total
-- Hint: use the functions YEAR() and MONTH() to obtain the year and month



-- Q05 Get the average value of an order by year, month
-- include the average number of lines and the average number of items per order
-- Show results: Year, Month, Avg Value of Orders, Avg Number of Items, Avg Number
--of Lines



-- Q06 Get the total sales, cost, margin and margin percent per country
-- Define Margin = Sales Value - Cost Value
-- Define Margin% = (1 - Cost/Sales) * 100
-- Hint: Follow the relationships SalesOrderheader >-- SalesTerritory >--
--CountryRegion



-- Q07 Get the top 5 salespersons by margin per year
-- Show information as: Year, Employee ID, Employee Name (Last, First), Margin
-- For every year, show the top 5.
-- For Margin, use the definition given in Q04.



-- Q08 Get all 2012 customers that did not return in 2013



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
