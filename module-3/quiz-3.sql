/**************************************************
** File: Quiz 3
** Date: 2023-05-10
** Auth: Ramkumar Rajanbabu
***************************************************
** Desc: Quiz 3
***************************************************
** Modification History
***************************************************
** Date			Author				Description 
** ----------	------------------  ---------------
** 2023-05-10	Ramkumar Rajanbabu	Completed questions 1-8
**************************************************/

-- Access Database
USE [AdventureWorks2019]
GO

-- **Questions**
-- Question 1
-- Which of the following queries is an implicit cross join:
SELECT S.*, P.*
FROM [HumanResources].[Shift] S, [Person].[PhoneNumberType] P
GO

-- Question 2
-- Which of the following result sets corresponds to a natural
-- join, or equi-join, between [Production].[ProductCategory]
-- and [Production].[ProductSubcategory] tables.
SELECT * FROM [Production].[ProductCategory] AS pc
INNER JOIN [Production].[ProductSubcategory] AS ps
ON [pc].[ProductCategoryID] = [ps].[ProductCategoryID]
GO

-- Question 3
-- Which is the right answer to the question: Get the number of
-- products per category?
SELECT
	C.[Name] AS [Category],
	Count(P.[Name]) AS [Products]
FROM [Production].[ProductCategory] C
INNER JOIN [Production].[ProductSubcategory] S
ON S.[ProductCategoryID] = C.[ProductCategoryID]
INNER JOIN [Production].[Product] P 
ON S.ProductSubcategoryID = P.ProductSubcategoryID
GROUP BY C.[Name]
GO

-- Question 4
-- What is the Bikes and Mountain Bikes total sales value? 
SELECT
	C.[Name] AS [Category],
	S.[Name] AS [Subcategory],
	SUM(O.[LineTotal]) AS [TOTAL]
FROM [Production].[ProductCategory] C
INNER JOIN [Production].[ProductSubcategory] S
ON S.[ProductCategoryID] = C.[ProductCategoryID]
INNER JOIN [Production].[Product] P 
ON S.ProductSubcategoryID = P.ProductSubcategoryID
INNER JOIN [Sales].[SalesOrderDetail] O
ON P.[ProductID] = O.[ProductID]
WHERE C.[Name] = 'Bikes'
GROUP BY  C.[Name], S.[Name]
GO

-- Question 5
-- Which query returns the list of product sub-categories and products with not sales;
-- as the following results:
SELECT
	S.[Name] AS [SUBCATEGORY],
	P.[Name] AS [PRODUCT],
	SUM(O.[LineTotal]) AS [TOTAL]
FROM [Production].[ProductSubcategory] S
LEFT JOIN [Production].[Product] P 
ON S.ProductSubcategoryID = P.ProductSubcategoryID
LEFT JOIN [Sales].[SalesOrderDetail] O
ON P.[ProductID] = O.[ProductID]
GROUP BY S.[Name], P.[Name]
HAVING  SUM(O.[LineTotal]) IS NULL
ORDER BY 1 ,2
GO

-- Question 6
-- Which are the two worst performing products, for the years of 2011 and 2014 
-- (aka, those two products with the lowest total sales for the years of 2011 and 2014):

-- Wrong A:  2011: 727, 736; and 2014: 943, 914 


-- Question 7
-- What is the query that gets all orders that were above the
-- month average for May, 2011?
SELECT [SalesOrderID]
FROM [Sales].[SalesOrderHeader] H
WHERE [SubTotal] > ( 
   SELECT AVG([SubTotal])
   FROM [Sales].[SalesOrderHeader] OH 
   WHERE YEAR(H.[OrderDate]) = YEAR(OH.[OrderDate]) 
     AND MONTH(H.[OrderDate]) = MONTH(OH.[OrderDate])
   )
AND  YEAR([OrderDate]) = 2011
AND  MONTH([OrderDate]) = 5
GO

-- Question 8
-- What's the query to get all orders that didn't include a
-- Mountain Bike or a Helmet in the order 

-- Wrong Answer 