/**************************************************
** File: Assignment 7
** Date: 2023-06-05
** Auth: Ramkumar Rajanbabu
***************************************************
** Desc: Module 7 - Assignment 7
***************************************************
** Modification History
***************************************************
** Date			Author				Description 
** ----------	------------------  ---------------
** 2023-06-05	Ramkumar Rajanbabu	Completed q1-q10.
**************************************************/

-- Access Database
USE [AdventureWorks2019]
GO

-- **Questions**
-- Q1: Using @T1 and @T2, write a query that returns all values from both tables
-- including duplicates
DECLARE @T1 TABLE (
LETTER NCHAR(1)
)
DECLARE @T2 TABLE (
LETTER NCHAR(1)
)
INSERT INTO @T1 (LETTER) VALUES ('A'), ('B'), ('C'), ('D'), ('E'), ('F'), ('G'),
('H'), ('I'), ('J')
INSERT INTO @T2 (LETTER) VALUES ('a'), ('e'), ('i'), ('o'), ('u')
-- Attempt 1
--SELECT * FROM @T1
--GO
--SELECT * FROM @T2
--GO
-- Attempt 2: Final Answer
SELECT 
	* 
FROM @T1
UNION ALL
SELECT 
	* 
FROM @T2
GO

-- Q2: Using @T1 and @T2, write a query that returns all values from both tables
-- excluding duplicates
DECLARE @T1 TABLE (
LETTER NCHAR(1)
)
DECLARE @T2 TABLE (
LETTER NCHAR(1)
)
INSERT INTO @T1 (LETTER) VALUES ('A'), ('B'), ('C'), ('D'), ('E'), ('F'), ('G'),
('H'), ('I'), ('J')
INSERT INTO @T2 (LETTER) VALUES ('a'), ('e'), ('i'), ('o'), ('u')
-- Attempt 1: Final Answer
SELECT 
	* 
FROM @T1
UNION
SELECT 
	* 
FROM @T2
GO

-- Q3: Using @Person and the OUTPUT clause, write an UPDATE statement that changes
-- every [Birthday] to the same date 20 years back.
-- Show the inserted and deleted rows.
DECLARE @Person TABLE(
[NationalId] NVARCHAR(30) PRIMARY KEY NONCLUSTERED NOT NULL,
[Name] NVARCHAR(25) NOT NULL,
[LastName] NVARCHAR(25) NOT NULL,
[Birthday] DATETIME NOT NULL,
[PersonalEmail] NVARCHAR(100)
)
INSERT INTO @Person([NationalId],[Name],[LastName],[Birthday],[PersonalEmail])
OUTPUT inserted.*
VALUES
('XYZ01-9','Alpha','Nu','2000-01-01','alpha.nu@email.com')
,('XYZ02-8','Beta','Ksi','2000-01-02','beta.ksi@email.com')
,('XYZ03-7','Gamma','Omicron','2000-01-03','gamma.omicron@email.com')
,('XYZ04-6','Delta','Pi','3141-5-9','delta.pi@email.com')
-- Attempt 1: Final Answer
UPDATE @Person
	SET [Birthday] = DATEADD(YEAR, -20, [Birthday])
OUTPUT inserted.*, deleted.*

-- Q4: Using a MERGE statement, update @Person with all changes in @Person_HR_updates.
-- TARGET: @Person
-- SOURCE: @Person_HR_updates
-- Rule 1: If both @Person and @Person_HR_updates have the same value for [NationalId],
-- update all other columns in @Person with respective columns in
-- @Person_HR_updates
-- Rule 2: If a row with [NationalId] in @Person is not in @Person_HR_updates,
-- delete the row in @Person
-- Rule 3: If a row with [NationalId] in @Person_HR_updates is not in @Person,
-- insert the row in @Person
DECLARE @Person TABLE(
[NationalId] NVARCHAR(30) PRIMARY KEY NONCLUSTERED NOT NULL,
[Name] NVARCHAR(25) NOT NULL,
[LastName] NVARCHAR(25) NOT NULL,
[Birthday] DATETIME NOT NULL,
[PersonalEmail] NVARCHAR(100)
)
DECLARE @Person_HR_updates TABLE(
[NationalId] NVARCHAR(30) PRIMARY KEY NONCLUSTERED NOT NULL,
[Name] NVARCHAR(25) NOT NULL,
[LastName] NVARCHAR(25) NOT NULL,
[Birthday] DATETIME NOT NULL,
[PersonalEmail] NVARCHAR(100)
)
INSERT INTO @Person([NationalId],[Name],[LastName],[Birthday],[PersonalEmail])
OUTPUT inserted.*
VALUES
('XYZ01-9','Alpha','Nu','2000-01-01','alpha.nu@email.com')
,('XYZ02-8','Beta','Ksi','2000-01-02','beta.ksi@email.com')
,('XYZ03-7','Gamma','Omicron','2000-01-03','gamma.omicron@email.com')
,('XYZ04-6','Delta','Pi','3141-5-9','delta.pi@email.com')
INSERT INTO @Person_HR_updates([NationalId],[Name],[LastName],[Birthday],
[PersonalEmail])
OUTPUT inserted.*
VALUES
('XYZ01-9','Alfa','Nu','2000-01-01','alpha.nu@email.com')
,('XYZ02-8','Betta','Ksi','2000-01-02','beta.ksi@email.com')
,('XYZ04-6','Delta','Pi','3141-5-9','delta.pi@email.com')
,('XYZ05-5','Epsilon','Rho','2000-01-03','epsilon.rho@email.com')
-- Attempt 1
--MERGE INTO @Person P -- Target
--	USING @Person_HR_updates H -- Source
--	ON P.[NationalID] = H.[NationalID] -- Matched on
--	-- Rule 1
--	WHEN MATCHED THEN
--		UPDATE
--			SET [Name] = H.[Name],
--				[LastName] = H.[LastName],
--				[Birthday] = H.[Birthday],
--				[PersonalEmail] = H.[PersonalEmail]
--	OUTPUT inserted.*, deleted.*
--;
--SELECT * FROM @Person
--GO
-- Attempt 2: Final Answer
-- Error Occurred: An action of type 'DELETE' is not allowed in the 'WHEN NOT MATCHED' clause of a MERGE statement.
MERGE INTO @Person P -- Target
	USING @Person_HR_updates H -- Source
	ON P.[NationalID] = H.[NationalID] -- Matched on PK
	-- Rule 1
	WHEN MATCHED THEN
		UPDATE
			SET [Name] = H.[Name],
				[LastName] = H.[LastName],
				[Birthday] = H.[Birthday],
				[PersonalEmail] = H.[PersonalEmail]
	-- Rule 2
	WHEN NOT MATCHED BY TARGET THEN
		DELETE
	-- Rule 3
	WHEN NOT MATCHED BY SOURCE THEN
		INSERT ([NationalId],[Name], [LastName], [Birthday], [PersonalEmail])
			VALUES (H.[NationalId], H.[Name], H.[LastName], H.[Birthday], H.[PersonalEmail])
	OUTPUT inserted.*, deleted.*
;
SELECT * FROM @Person
GO

-- Q5: Using [Sales].[SalesOrderHeader] and a PIVOT clause, insert into
-- @MonthlySummary (specified above)
-- the monthly sales (as SUM([SubTotal]))
DECLARE @MonthlySummary TABLE(
[Year] INT,
M01 MONEY,
M02 MONEY,
M03 MONEY,
M04 MONEY,
M05 MONEY,
M06 MONEY,
M07 MONEY,
M08 MONEY,
M09 MONEY,
M10 MONEY,
M11 MONEY,
M12 MONEY
)
-- Attempt 1
--SELECT 
--	*
--FROM [Sales].[SalesOrderHeader]
--GO
-- Attempt 2: Raw data
--SELECT 
--	YEAR([OrderDate]) AS [Year],
--	DATEPART(MONTH, [OrderDate]) AS [Monthly Sales],
--	[SubTotal]
--FROM [Sales].[SalesOrderHeader]
--ORDER BY YEAR([OrderDate]), DATEPART(MONTH, [OrderDate]) 
--GO
-- Attempt 3: Aggregated data
--SELECT 
--	YEAR([OrderDate]) AS [Year],
--	DATEPART(MONTH, [OrderDate]) AS [Monthly Sales],
--	SUM([SubTotal])
--FROM [Sales].[SalesOrderHeader]
--GROUP BY YEAR([OrderDate]), DATEPART(MONTH, [OrderDate]) 
--ORDER BY YEAR([OrderDate]), DATEPART(MONTH, [OrderDate]) 
--GO
-- Attempt 4: Final Answer
INSERT INTO @MonthlySummary
SELECT
	[Year],
	P.[1],
	P.[2],
	P.[3],
	P.[4],
	P.[5],
	P.[6],
	P.[7],
	P.[8],
	P.[9],
	P.[10],
	P.[11],
	P.[12]
FROM (	
	-- Raw data
	SELECT 
		YEAR([OrderDate]) AS [Year],
		DATEPART(MONTH, [OrderDate]) AS [Monthly Sales],
		[SubTotal]
	FROM [Sales].[SalesOrderHeader]
) AS YM
PIVOT (
	SUM([SubTotal]) -- Aggregated data
	FOR [Monthly Sales]
	IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
) AS P

SELECT * FROM @MonthlySummary
GO

-- Q6: Using @MonthlySummary and an UNPIVOT clause, write a query that returns
-- the Year, Month and month sales.
DECLARE @MonthlySummary TABLE(
[Year] INT,
M01 MONEY,
M02 MONEY,
M03 MONEY,
M04 MONEY,
M05 MONEY,
M06 MONEY,
M07 MONEY,
M08 MONEY,
M09 MONEY,
M10 MONEY,
M11 MONEY,
M12 MONEY
)
INSERT INTO @MonthlySummary
SELECT
	[Year],
	P.[1],
	P.[2],
	P.[3],
	P.[4],
	P.[5],
	P.[6],
	P.[7],
	P.[8],
	P.[9],
	P.[10],
	P.[11],
	P.[12]
FROM (	
		-- Raw data
		SELECT 
			YEAR([OrderDate]) AS [Year],
			DATEPART(MONTH, [OrderDate]) AS [Monthly Sales],
			[SubTotal]
		FROM [Sales].[SalesOrderHeader]
	) AS YM
	PIVOT (
			SUM([SubTotal]) -- Aggregated data
			FOR [Monthly Sales]
			IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
		) AS P
-- Attempt 1: Final Answer
SELECT
	[Year],
	[Month],
	[Monthly Sales]
FROM (
	SELECT 
		[Year], [M01], [M02], [M03], [M04], [M05], [M06], [M07], [M08], [M09], [M10], [M11], [M12]
	FROM @MonthlySummary
) AS P
UNPIVOT (
	[Monthly Sales]
	FOR [Month]
	IN ([M01], [M02], [M03], [M04], [M05], [M06], [M07], [M08], [M09], [M10], [M11], [M12])
) AS U

-- Q7: Using [Sales].[SalesOrderHeader], find all sales for:
-- [OrderDate] >= '2012-06-01' AND [OrderDate] < '2013-07-01'
-- [TerritoryID] = 1
-- Show:
-- The consecutive row number in descending order of [SubTotal] for the week
-- partition
-- The order date
-- The week number
-- The sales order id
-- The order sub total
-- Attempt 1
--SELECT
--	[OrderDate],
--	[SubTotal]
--FROM [Sales].[SalesOrderHeader]
--WHERE [TerritoryID] = 1
--AND [OrderDate] >= '2012-06-01'
--AND [OrderDate] < '2013-07-01'
--GO
-- Attempt 2
--SELECT
--	ROW_NUMBER() OVER(ORDER BY [SubTotal] DESC) AS [Row Number],
--	[OrderDate],
--	DATEPART(WEEK, [OrderDate]) AS [Week Number],
--	[SalesOrderID],
--	[SubTotal]
--FROM [Sales].[SalesOrderHeader]
--WHERE [TerritoryID] = 1
--AND [OrderDate] >= '2012-06-01'
--AND [OrderDate] < '2013-07-01'
--GO
-- Attempt 3: Final Answer
SELECT
	ROW_NUMBER() OVER(
		PARTITION BY DATEPART(WEEK,[OrderDate]) ORDER BY [SubTotal] DESC
	) AS [Row Number],
	[OrderDate],
	DATEPART(WEEK, [OrderDate]) AS [Week Number],
	[SalesOrderID],
	[SubTotal]
FROM [Sales].[SalesOrderHeader]
WHERE [TerritoryID] = 1
AND [OrderDate] >= '2012-06-01'
AND [OrderDate] < '2013-07-01'
GO

-- Q8: Using [Sales].[SalesOrderHeader], find all sales for:
-- [OrderDate] >= '2012-06-01' AND [OrderDate] < '2013-07-01'
-- [TerritoryID] = 1
-- Show:
-- The ranking of the sales order, in descending order of [SubTotal] for the
-- week partition
-- The order date
-- The week number
-- The sales order id
-- The order sub total
-- Attempt 1: Final Answer
SELECT
	RANK() OVER(
		PARTITION BY YEAR([OrderDate]),
		DATEPART(WEEK, [OrderDate]) ORDER BY [SubTotal] DESC
	) AS [Row Number],
	[OrderDate],
	YEAR([OrderDate]) AS [Year],
	DATEPART(WEEK, [OrderDate]) AS [Week Number],
	[SalesOrderID],
	[SubTotal]
FROM [Sales].[SalesOrderHeader]
WHERE [TerritoryID] = 1
AND [OrderDate] >= '2012-06-01'
AND [OrderDate] < '2013-07-01'
GO

-- Q9: Write a query using SUM() OVER() clause with [Sales].[SalesOrderHeader]
-- that returns the Year, Quarter and the SUM([SubTotal])
-- ordered by Year, Quarter
-- Attempt 1
--SELECT
--	YEAR([OrderDate]) AS [Year],
--	DATEPART(QUARTER, [OrderDate]) AS [Quarter],
--	SUM([SubTotal])
--FROM [Sales].[SalesOrderHeader]
--GROUP BY YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate]) 
--ORDER BY YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate]) 
--GO
-- Attempt 2: Final Answer
SELECT DISTINCT
	YEAR([OrderDate]) AS [Year],
	DATEPART(QUARTER, [OrderDate]) AS [Quarter],
	SUM([SubTotal]) OVER(
		PARTITION BY YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate])
		ORDER BY YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate])
	)AS [Quarterly Total]
FROM [Sales].[SalesOrderHeader]
ORDER BY YEAR([OrderDate]), DATEPART(QUARTER, [OrderDate]) 
GO

-- Q10: Write a query using LAG() OVER() clause with [Sales].[SalesOrderHeader]
-- that returns the Year, the SUM([SubTotal]), the previous year and the
-- SUM([SubTotal]) of the previous year
-- ordered by Year
-- Attempt 1
--SELECT DISTINCT
--	YEAR([OrderDate]) AS [Year],
--	SUM([SubTotal]) AS [Sales]
--FROM [Sales].[SalesOrderHeader]
--GROUP BY YEAR([OrderDate])
--ORDER BY YEAR([OrderDate])
--GO
-- Attempt 2: Final Answer
SELECT DISTINCT
	YEAR([OrderDate]) AS [Year],
	SUM([SubTotal]) AS [Sales],
	LAG(YEAR([OrderDate]), 1, NULL) OVER(
		ORDER BY YEAR([OrderDate])
	) AS [Previous Year],
	LAG(SUM([SubTotal]), 1, NULL) OVER(
		ORDER BY YEAR([OrderDate])
	) AS [Previous Year Sales]
FROM [Sales].[SalesOrderHeader]
GROUP BY YEAR([OrderDate])
ORDER BY YEAR([OrderDate])
GO