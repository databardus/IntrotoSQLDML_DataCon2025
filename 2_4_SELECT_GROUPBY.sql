/*----------------------------------------------------------------------------

    Module 2.4: SELECT statement - GROUP BY clause

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module
	-Introduce GROUP BY clause and purpose
	-Introduce concept of aggregation functions.
*/

/*	
	GROUP BY declares how you want records in a query result set to be grouped.
 You define your groups by one to many columns.
 For each group, one to many records become one record.
	This clause supports agrregation functions such as SUM() and COUNT()
	For GROUP BY queries to run, you need two things, which we'll see in the following examples.
*/

	SELECT [Color]
	FROM dbo.DimProduct
	GROUP BY [Color] -- This query returns each unique color in DimProduct


	SELECT [Color], COUNT(1) AS NumberOfProducts
	FROM dbo.DimProduct
	GROUP BY [Color] -- This query returns each unique color in DimProduct and a count of the records of each color

	SELECT SUM(SalesAmount)
	FROM dbo.FactInternetSales --You can still use aggregation functions without the GROUP BY clause. Then it will summarize all data in a table.

	SELECT [Color],[EnglishProductName],COUNT(1) AS NumberOfProducts
	FROM dbo.DimProduct
	GROUP BY [Color],[EnglishProductName] --You can group by multiple columns at the same time. Most times the order of columns shouldn't matter

	--NOTE: When using GROUP BY, your query can only define either columns to group by, or an aggregate function. If you define additional columns, your query will fail.
	SELECT [Color],[EnglishProductName],COUNT(1) AS NumberOfProducts
	FROM dbo.DimProduct
	GROUP BY [Color] --This query fails because EnglishProductName 'is not contained in either an aggregate function or the GROUP BY clause.
