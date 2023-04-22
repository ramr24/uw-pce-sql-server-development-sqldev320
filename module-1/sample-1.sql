/**************************************************
** File: Sample 1
** Date: 2023-04-21
** Auth: Ramkumar Rajanbabu
***************************************************
** Desc: Module 1 - Sample 1
***************************************************
** Modification History
***************************************************
** Date			Author				Description 
** ----------	------------------  ---------------
** 2023-04-21	Ramkumar Rajanbabu	Started query
**************************************************/

-- Access Database
USE AdventureWorks2019
GO

-- Sample 1
-- Objective: Write a query that will provide you with the following information about an Employee
-- [BusinessEntityID],[Title],[FirstName],[MiddleName],[LastName],[Suffix],[JobTitle],
-- [PhoneNumber],[PhoneNumberType],[EmailAddress],[EmailPromotion],[AddressLine1],
-- [AddressLine2],[City],[StateProvinceName],[PostalCode],[CountryRegionName],
-- [AdditionalContactInfo]


-- SQL Query to find the column names
SELECT 
	TABLE_SCHEMA,
	TABLE_NAME,
	COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE COLUMN_NAME IN (
	'BusinessEntityID',
	'Title',
	'FirstName',
	'MiddleName',
	'LastName',
	'Suffix',
	'JobTitle',
	'PhoneNumber',
	'PhoneNumberType',
	'EmailAddress',
	'EmailPromotion',
	'AddressLine1',
	'AddressLine2',
	'City',
	'StateProvinceName',
	'PostalCode',
	'CountryRegionName',
	'AdditionalContactInfo')
-- Exclude Views
AND TABLE_NAME NOT LIKE 'V%'
Order BY COLUMN_NAME
GO

SELECT
	COUNT(*)
FROM Person.Person
GO

-- Attempt 1
--SELECT 
--	p.[BusinessEntityID],
--	p.[Title],
--	p.[FirstName],
--	p.[MiddleName],
--	p.[LastName],
--	p.[Suffix],
--	'JobTitle',
--	'PhoneNumber',
--	'PhoneNumberType',
--	'EmailAddress',
--	p.[EmailPromotion],
--	'AddressLine1',
--	'AddressLine2',
--	'City',
--	'StateProvinceName',
--	'PostalCode',
--	'CountryRegionName',
--	p.[AdditionalContactInfo]
--FROM Person.Person p
--GO
-- Attempt 2
--SELECT 
--	p.[BusinessEntityID],
--	p.[Title],
--	p.[FirstName],
--	p.[MiddleName],
--	p.[LastName],
--	p.[Suffix],
--	e.[JobTitle],
--	pp.[PhoneNumber],
--	pnt.[Name] AS [PhoneNumberType],
--	ea.[EmailAddress],
--	p.[EmailPromotion],
--	a.[AddressLine1],
--	a.[AddressLine2],
--	a.[City],
--	sp.[Name] AS [StateProvinceName],
--	a.[PostalCode],
--	cr.[Name] AS [CountryRegionName],
--	p.[AdditionalContactInfo]
--FROM Person.Person p
--INNER JOIN Person.EmailAddress ea
--ON p.BusinessEntityID = ea.BusinessEntityID
--INNER JOIN HumanResources.Employee e
--ON p.BusinessEntityID = e.BusinessEntityID
--INNER JOIN Person.PersonPhone pp
--ON p.BusinessEntityID = pp.BusinessEntityID
--INNER JOIN Person.PhoneNumberType pnt
--ON pp.PhoneNumberTypeID = pnt.PhoneNumberTypeID
--INNER JOIN Person.BusinessEntityAddress bea
--ON p.BusinessEntityID = bea.BusinessEntityID
--INNER JOIN Person.Address a
--ON bea.AddressID = a.AddressID
--INNER JOIN Person.StateProvince sp
--ON a.StateProvinceID = sp.StateProvinceID
--INNER JOIN Person.CountryRegion cr
--ON sp.CountryRegionCode = cr.CountryRegionCode
--GO
-- Attempt 3: not sure about this
SELECT 
	p.[BusinessEntityID],
	p.[Title],
	p.[FirstName],
	p.[MiddleName],
	p.[LastName],
	p.[Suffix],
	e.[JobTitle],
	pp.[PhoneNumber],
	pnt.[Name] AS [PhoneNumberType],
	ea.[EmailAddress], -- NULL
	p.[EmailPromotion],
	a.[AddressLine1],
	a.[AddressLine2],
	a.[City],
	sp.[Name] AS [StateProvinceName],
	a.[PostalCode],
	cr.[Name] AS [CountryRegionName],
	p.[AdditionalContactInfo]
FROM Person.Person p
INNER JOIN HumanResources.Employee e
ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN Person.BusinessEntityAddress bea
ON p.BusinessEntityID = bea.BusinessEntityID
INNER JOIN Person.Address a
ON bea.AddressID = a.AddressID
INNER JOIN Person.StateProvince sp
ON a.StateProvinceID = sp.StateProvinceID
INNER JOIN Person.CountryRegion cr
ON sp.CountryRegionCode = cr.CountryRegionCode
LEFT OUTER JOIN Person.PersonPhone pp
ON p.BusinessEntityID = pp.BusinessEntityID
LEFT OUTER JOIN Person.PhoneNumberType pnt
ON pp.PhoneNumberTypeID = pnt.PhoneNumberTypeID
LEFT OUTER JOIN Person.EmailAddress ea
ON p.BusinessEntityID = ea.BusinessEntityID
GO
