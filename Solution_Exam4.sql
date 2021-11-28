/****** QUERY #4 ******/
-- Show the list customers per territory who didn’t place an order in any given 30-day range
DECLARE	@StartDate DATETIME
DECLARE @EndDate DATETIME

SET		@StartDate = '2005-09-01 00:00:00.000'
SET		@EndDate = DATEADD(DAY, 30, @StartDate)

;WITH CTE 
AS (
	SELECT	CustomerID, TerritoryID
	FROM	Sales.SalesOrderHeader [SOH]
	WHERE	OrderDate BETWEEN @StartDate AND @EndDate
)

SELECT	[P].FirstName + ' ' + [P].MiddleName + '. ' + [P].LastName [CustomerName], [C].CustomerID, [ST].Name [TerritoryName]
FROM	CTE [SOH]
RIGHT JOIN	Sales.Customer [C]
	ON	[SOH].CustomerID = [C].CustomerID
JOIN	Person.Person [P]
	ON	[C].PersonID = [P].BusinessEntityID
	AND	[P].PersonType = 'IN'
JOIN	Sales.SalesTerritory [ST]
	ON	[C].TerritoryID = [ST].TerritoryID
WHERE	[SOH].CustomerID IS NULL
ORDER BY
		[ST].Name, [P].FirstName, [P].MiddleName, [P].LastName

