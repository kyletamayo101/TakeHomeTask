/****** QUERY #6 ******/
-- Create a select statement or stored prcedure that queries the products table
-- Display the results of the query / stored procedure in a paginated manner

DECLARE @PageNumber INT
DECLARE @NumberOfRecords INT

SET		@PageNumber = '2'
SET		@NumberOfRecords = '15'

SELECT	*
FROM	Production.Product
ORDER BY ProductID
	OFFSET @PageNumber * @NumberOfRecords ROWS FETCH NEXT @NumberOfRecords ROWS ONLY