/****** QUERY #3 ******/
-- Rank each territory according to total sales (unit price * quantity) for a given month

-- Rank territory for each month
DECLARE	@MonthDate VARCHAR(7)
SET		@MonthDate = '2005-07'


SELECT	[ST].TerritoryID, [ST].Name [TerritoryName], FORMAT([SOH].OrderDate, 'yyyy-MM') [OrderDateMonth], SUM([SOH].SubTotal) [SubTotal]
FROM	Sales.SalesOrderHeader [SOH]
JOIN	Sales.SalesTerritory [ST]
	ON	[SOH].TerritoryID = [ST].TerritoryID
WHERE	FORMAT([SOH].OrderDate, 'yyyy-MM') = @MonthDate
GROUP BY
		[ST].TerritoryID, [ST].Name, FORMAT([SOH].OrderDate, 'yyyy-MM')
ORDER BY 
		SUM([SOH].SubTotal) DESC