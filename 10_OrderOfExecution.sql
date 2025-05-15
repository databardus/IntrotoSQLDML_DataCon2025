/*----------------------------------------------------------------------------

    Module: Understanding Order of Execution

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module 3
	-Identify the order of execution for SELECT clauses
	-Overview that this impacts how we can use aliases, as well as understanding how clauses impact each other
	-Present examples that showcase why this knowledge is relevant
*/

/*
    First off, let's discuss Order of Execution.
    In many programming languages, we're used to code executing in the order that it is written. 
	Line 1 is executed before line 2, then line 3, and so on.
    While SQL queries have a specific order the clauses are written in, this is not actually the order that SQL queries execute clauses.

    SQL clauses in a query (when written) are executed in the following order:

        1. FROM
        2. WHERE
        3. GROUP BY
        4. HAVING
        5. SELECT
        6. ORDER BY

    This is important for two main reasons.

*/

	/*
    	Reason 1: Aliasing - In a SELECT Statement, both the SELECT and FROM clauses can define aliases for columns and tables, respectively. 
		Because of order of execution, these aliases are only available to be used at certain times.
	*/
	SELECT Prod.ProductKey AS ProdKey, SUM(StandardCost) AS TotalCost
	FROM dbo.DimProduct AS Prod --FROM is the first clause to execute, so any alias in a FROM clause is available in the rest of the query.
	WHERE ProdKey = -1 --Referencing the 'ProdKey' alias from the SELECT clause doesn't work because WHERE executes before SELECT. Referencing Prod.ProductKey using the 'Prod' alias from the FROM statement would work.
	GROUP BY ProdKey --GROUP BY has the same issue as WHERE, only being able to reference the FROM clause
	HAVING TotalCost > 100 --HAVING can only reference FROM aliases
	ORDER BY ProdKey, Prod.ProductKey --ORDER BY is the last clause to execute, so it can reference all aliases

	/*
		Reason 2: Order of Operations - In the same way arithmetic has a defined order of operations to get consistent results, 
										SQL does this to get consistent results.
	*/
	SELECT ProductKey, OrderDate, SUM(SalesAmount)
	FROM dbo.FactInternetSales
	WHERE SalesAmount > 5000
	GROUP BY ProductKey, OrderDate
	HAVING SUM(SalesAmount) > 10000
	ORDER BY ProductKey
	/*
		This query returns no results. But we have days where SalesAmount is greater than 10,000 for a given product.
		However, our WHERE clause executes first, meaning we filter out InternetSales records with SalesAmounts greater than $5,000 before we try to aggregate.
		So the query only returns products who, on a given day, had at least one internetSale worth over $5,000, and then total sales for the day of over $10,000.
	*/
