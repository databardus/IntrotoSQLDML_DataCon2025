/*----------------------------------------------------------------------------

	Module 2.7: SELECT statement Summary

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module
	-Review the six main clauses in a SELECT statement
	-Show a single query that has all of clauses in order
	-If it hasn't come up previously in training, cover the Object Explorer on the left and how to identify what tables are available to query
*/

	--When you put all of the clauses together, a SQL query looks like this.
	SELECT ProductKey, OrderDate, SUM(SalesAmount)
	FROM dbo.FactInternetSales
	WHERE ProductKey > 300
	GROUP BY ProductKey, OrderDate
	HAVING SUM(SalesAmount) > 10000
	ORDER BY ProductKey
	--Note that clauses in a SELECT statement need to be defined in this order. If you rearrange the clauses (for example, defining FROM before SELECT), your query will fail.

/*

    This covers all main clauses of the SQL SELECT statement. 
	There are many additional keywords that are used in SELECT statements, but they all are used in conjunction with these 6 clauses.
    From here, we'll learn additional keywords and techniques to use with these clauses for our various query needs.

	This will likely put you at the end of the first 4 hours of training.
	Depending on timing and if a model is available, it might be worthwhile to have trainees take time to experiment with 

*/