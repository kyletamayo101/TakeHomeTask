/****** QUERY #1 ******/
-- Show the top selling product in terms order quantity of sales per product category for each month

-- Rank all products per product category for each month
WITH CTE (ProductName, ProductCategoryID, TransactionDateMonth, TotalSales, ProductRank)
AS (
	SELECT	[P].Name [ProductName], [PC].ProductCategoryID, FORMAT([TH].TransactionDate, 'yyyy-MM') [TransactionDateMonth], SUM([TH].Quantity) [TotalSales], RANK() OVER (PARTITION BY [PC].ProductCategoryID, FORMAT([TH].TransactionDate, 'yyyy-MM') ORDER BY SUM([TH].Quantity) DESC) [ProductRank]
	FROM	Production.Product [P]
	JOIN	Production.ProductSubcategory [PSC]
		ON	[P].ProductSubcategoryID = [PSC].ProductSubcategoryID
	JOIN	Production.ProductCategory [PC]
		ON	[PSC].ProductCategoryID = [PC].ProductCategoryID
	JOIN	Production.TransactionHistory [TH]
		ON	[P].ProductID = [TH].ProductID
	WHERE	TH.TransactionType = 'S'
	GROUP BY
			[P].Name, [PC].ProductCategoryID, FORMAT([TH].TransactionDate, 'yyyy-MM')

	UNION

	SELECT	[P].Name [ProductName], [PC].ProductCategoryID, FORMAT([THA].TransactionDate, 'yyyy-MM') [TransactionDateMonth], SUM([THA].Quantity) [TotalSales], RANK() OVER (PARTITION BY [PC].ProductCategoryID, FORMAT([THA].TransactionDate, 'yyyy-MM') ORDER BY SUM([THA].Quantity) DESC) [ProductRank]
	FROM	Production.Product [P]
	JOIN	Production.ProductSubcategory [PSC]
		ON	[P].ProductSubcategoryID = [PSC].ProductSubcategoryID
	JOIN	Production.ProductCategory [PC]
		ON	[PSC].ProductCategoryID = [PC].ProductCategoryID
	JOIN	Production.TransactionHistoryArchive [THA]
		ON	[P].ProductID = [THA].ProductID
	WHERE	[THA].TransactionType = 'S'
	GROUP BY
			[P].Name, [PC].ProductCategoryID, FORMAT([THA].TransactionDate, 'yyyy-MM')
)

SELECT	ProductName, ProductCategoryID, TransactionDateMonth, TotalSales
FROM	CTE
WHERE	ProductRank = 1
ORDER BY TransactionDateMonth, ProductCategoryID
