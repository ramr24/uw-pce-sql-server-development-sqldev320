/**************************************************
** File: Class Assignment
** Date: 2023-04-27
** Auth: Ramkumar Rajanbabu
***************************************************
** Desc: Module 2 - Class Assignment
***************************************************
** Modification History
***************************************************
** Date			Author				Description 
** ----------	------------------  ---------------
** 2023-04-27	Ramkumar Rajanbabu	Started query
**************************************************/

-- Access Database
USE AdventureWorks2019
GO

-- SQL Query to find the column names
SELECT 
	TABLE_SCHEMA,
	TABLE_NAME,
	COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN (
	'Sales',
	'Taxes',
	'Freight',
	'TotalDue')
-- Exclude Views
AND TABLE_NAME NOT LIKE 'V%'
Order BY COLUMN_NAME
GO

-- **Questions**
-- Question 1: Get the total for Subtotal, Tax, and Freight for all orders
-- Show results: Sales, Taxes, Freight, TotalDue
-- Hint: Check table [Sales].[SalesOrderHeader]

-- Attempt 1
--SELECT
--	[SubTotal],
--	[TaxAmt],
--	[Freight],
--	[TotalDue]
--FROM Sales.SalesOrderHeader
--GO
-- Attempt 2: Final Answer
SELECT
	SUM([SubTotal]) AS SubTotal,
	SUM([TaxAmt]) AS TaxAmt,
	SUM([Freight]) AS Freight,
	SUM([TotalDue]) AS TotalDue
FROM Sales.SalesOrderHeader
GO

-- Question  2: Get the Tax pct for all orders
-- Show results: Tax, Sales, Tax pct
-- Estimate the pct relative to sales


-- Question  3: Get the Freight pct for all orders
-- Show results: Freight, Sales, Freight pct
-- Estimate the pct relative to sales
 

-- Question  4: Get the summary of freight percents,
-- with the total freight, total value of sales and number of orders
-- Show results: Freight Pct, Freight, Sales, Orders


-- Question  5: Get the average value of an order by year, month
-- Show results: Year, Month, Avg Value of Orders
 

-- Question  6: Get all products that have a color value
-- Show results: Product Name


-- Question  7: Get the summary of product lines
-- with the number of products in each product line
 

-- Question  8: Get all product names that end in 'wheel'


-- Question  9: Find if there are any products with a list price less than the standard cost
-- Show product id and name for those products
 

-- Question  10: Get the year summary, with rollup, of sales by sales person id
-- handle the case when there is no sales person associated to the sale
-- Show results: Year, Sales Person Id, Sales
