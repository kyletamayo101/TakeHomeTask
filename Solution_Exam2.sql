/****** QUERY #2 ******/
-- Show the top performing person per territory per month in terms of total sales (unit price * quantity)

-- Rank all sales person per territory for each month
WITH CTE (SalesPersonName, SalesPersonID, TerritoryName, OrderDateMonth, SubTotal, SalesPersonRank)
AS (
	SELECT	[P].FirstName + ' ' + [P].MiddleName + '. ' + [P].LastName [SalesPersonName], [SOH].SalesPersonID, [ST].Name [TerritoryName], FORMAT([SOH].OrderDate, 'yyyy-MM') [OrderDateMonth], SUM([SOH].SubTotal) [SubTotal], RANK() OVER (PARTITION BY [ST].TerritoryID, FORMAT([SOH].OrderDate, 'yyyy-MM') ORDER BY SUM([SOH].SubTotal) DESC) [SalesPersonRank]
	FROM	Sales.SalesOrderHeader [SOH]
	JOIN	Sales.SalesPerson [SP]
		ON	[SOH].SalesPersonID = [SP].BusinessEntityID
	JOIN	Person.Person [P]
		ON	[SP].BusinessEntityID = [P].BusinessEntityID
		AND [P].PersonType = 'SP'
	JOIN	Sales.SalesTerritory [ST]
		ON	[SOH].TerritoryID = [ST].TerritoryID
	GROUP BY
			[P].FirstName, [P].MiddleName, [P].LastName, [SOH].SalesPersonID, [ST].Name, FORMAT([SOH].OrderDate, 'yyyy-MM'), [ST].TerritoryID
)

SELECT	SalesPersonName, SalesPersonID, TerritoryName, OrderDateMonth, SubTotal
FROM	CTE
WHERE	SalesPersonRank = 1
ORDER BY OrderDateMonth, TerritoryName