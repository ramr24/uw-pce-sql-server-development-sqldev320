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
** 2023-06-05	Ramkumar Rajanbabu	Completed q1, q2, q3.
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

-- Q4: Using a MERGE statement, and @Person_HR_updates as the source and @Person as
-- the target.
-- Update @Person with all changes in @Person_HR_updates
-- If both @Person and @Person_HR_updates have the same value for [NationalId],
-- update all other columns in @Person with respective columns in
-- @Person_HR_updates
-- If a row with [NationalId] in @Person is not in @Person_HR_updates,
-- delete the row in @Person
-- If a row with [NationalId] in @Person_HR_updates is not in @Person,
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
INSERT INTO @Person([NationalId],[Name],[LastName],[Birthday],[PersonalEmail])
OUTPUT inserted.*
VALUES
('XYZ01-9','Alpha','Nu','2000-01-01','alpha.nu@email.com')
,('XYZ02-8','Beta','Ksi','2000-01-02','beta.ksi@email.com')
,('XYZ03-7','Gamma','Omicron','2000-01-03','gamma.omicron@email.com')
,('XYZ04-6','Delta','Pi','3141-5-9','delta.pi@email.com')
INSERT INTO @Person_HR_updates([NationalId],[Name],[LastName],[Birthday],
[PersonalEmail])
VALUES
('XYZ01-9','Alfa','Nu','2000-01-01','alpha.nu@email.com')
,('XYZ02-8','Betta','Ksi','2000-01-02','beta.ksi@email.com')
,('XYZ04-6','Delta','Pi','3141-5-9','delta.pi@email.com')
,('XYZ05-5','Epsilon','Rho','2000-01-03','epsilon.rho@email.com')
-- Attempt 1

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
-- Attempt 2
SELECT
	[Year],
	P.[M01],
	P.[M02],
	P.[M03],
	P.[M04],
	P.[M05],
	P.[M06],
	P.[M07],
	P.[M08],
	P.[M09],
	P.[M10],
	P.[M11],
	P.[M12]
FROM (
		SELECT
			YEAR([OrderDate]) AS [Year]
	) AS YM
	PIVOT (
			SUM([SubTotal])
			FOR [Month]
			IN ([M01], [M02], [M03], [M04], 
				[M05], [M06], [M07], [M08],
				[M09], [M10], [M11], [M12])
		) AS P
	ORDER BY Year

-- Q6: Using @MonthlySummary and an UNPIVOT clause, write a query that returns
-- the Year, Month and month sales.
-- Attempt 1

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
-- Attempt 1

-- Q9: Write a query using SUM() OVER() clause with [Sales].[SalesOrderHeader]
-- that returns the Year, Quarter and the SUM([SubTotal])
-- ordered by Year, Quarter
-- Attempt 1

-- Q10: Write a query using LAG() OVER() clause with [Sales].[SalesOrderHeader]
-- that returns the Year, the SUM([SubTotal]), the previous year and the
-- SUM([SubTotal]) of the previous year
-- ordered by Year
-- Attempt 1
