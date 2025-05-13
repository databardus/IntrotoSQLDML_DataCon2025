/*----------------------------------------------------------------------------

	Modeul 2.5: SELECT statement - HAVING clause

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module
	-Introduce HAVING clause and purpose
	-Show interaction between WHERE and HAVING
*/

/*	
	HAVING is essentially the same as WHERE. 
    The difference is the WHERE clause filters on individual record values, while HAVING filters on records already grouped by a GROUP BY clause.
	To prove that, the follow two statements are logically equivalent (i.e. they return the same results).
*/
	SELECT ProductKey, StandardCost
	FROM dbo.DimProduct
	WHERE StandardCost > 100

	SELECT ProductKey, SUM(StandardCost) AS TotalStandardCost
	FROM dbo.DimProduct
	GROUP BY ProductKey
	HAVING SUM(StandardCost) > 100

	--HAVING Is more useful when you are trying to filter for specific aggregate scenarios.

	SELECT ProductKey, OrderDate, SUM(SalesAmount)
	FROM dbo.FactInternetSales
	GROUP BY ProductKey, OrderDate
	HAVING SUM(SalesAmount) > 10000 --This query returns products where, on a specific order date, over $10,000 were ordered

	--You can use WHERE and HAVING within the same query. Just make sure you pay attention to what is being filtered when!

	SELECT ProductKey, OrderDate, SUM(SalesAmount)
	FROM dbo.FactInternetSales
	WHERE ProductKey > 300
	GROUP BY ProductKey, OrderDate
	HAVING SUM(SalesAmount) > 10000 --This query returns products where, on a specific order date, over $10,000 were ordered
