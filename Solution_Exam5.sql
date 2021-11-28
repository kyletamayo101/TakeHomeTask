/****** QUERY #5 ******/
-- Show the total sales per territory 7 day from any given date
-- Do not use a date range. Get the past 7 days from a given date

-- Rank territory for each month
DECLARE @EndDate DATETIME

SET		@EndDate = '2005-09-01 00:00:00.000'

;WITH CTE 
AS (
	SELECT	[ST].TerritoryID, [ST].Name [TerritoryName], DATEADD(DAY, -7, @EndDate) [StartDate], @EndDate [EndDate], 
			CASE WHEN (DATEDIFF(DAY, [SOH].OrderDate, @EndDate) >= 0) THEN DATEDIFF(DAY, [SOH].OrderDate, @EndDate) ELSE NULL END [Diff], [SOH].SubTotal
	FROM	Sales.SalesOrderHeader [SOH]
	JOIN	Sales.SalesTerritory [ST]
		ON	[SOH].TerritoryID = [ST].TerritoryID
)

SELECT	TerritoryID, TerritoryName, StartDate, EndDate, SUM([SOH].SubTotal) [SubTotal]
FROM	CTE [SOH]
WHERE	Diff <= 7
GROUP BY
		TerritoryID, TerritoryName, StartDate, EndDate
ORDER BY 
		SUM([SOH].SubTotal) DESC 