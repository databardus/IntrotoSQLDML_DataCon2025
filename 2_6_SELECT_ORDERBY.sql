/*----------------------------------------------------------------------------

	Module 2.6: SELECT statement - ORDER BY clause

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module
	-Introduce ORDER BY clause and purpose
	-Show ORDER BY using column name, column index, and Sir Column Not Returning in This Query
	-Order ascending and descending
*/

	--As the name implies, the ORDER BY clause sorts the query results.
	SELECT EnglishProductName, ProductKey
	FROM dbo.DimProduct
	ORDER BY EnglishProductName --Orders results alphabetically

	SELECT EnglishProductName, ProductKey
	FROM dbo.DimProduct
	ORDER BY EnglishProductName DESC --By default, ORDER BY Sorts each column in ascending order (You can also use ASC to be explicit). Use the DESC for each column to reverse sorting direction. 
	--This query sorts Orders results in reverse alphabetical order

	SELECT EnglishProductName, ProductKey
	FROM dbo.DimProduct
	ORDER BY ProductKey --You don't have to order by columns being returned.

	SELECT EnglishProductName, ProductKey
	FROM dbo.DimProduct
	ORDER BY 1 --ORDER BY clauses can reference columns by the order they are defined. In this case, the query will sort by EnglishProductName since it is the first column in the query.

	SELECT [Color],[EnglishProductName],COUNT(1) AS NumberOfProducts
	FROM dbo.DimProduct
	GROUP BY [Color],[EnglishProductName] --You can group by multiple columns at the same time. Most times the order of columns shouldn't matter
	ORDER BY NumberOfProducts --You can even define an aggregate column as your sorting column
