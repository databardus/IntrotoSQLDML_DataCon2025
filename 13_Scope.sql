/*----------------------------------------------------------------------------

    Module: Understanding Transaction (Variable Scope)

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module 
	-Define what Scope is
	-Show examples of how variables can be used on the same query within a scope
*/

/*
    Aside from dynamic queries, another benefit of using variables is the ability to define and use the same value in multiple queries.
    This is possible using the coding concept 'Scope'. 
    
    Scope (for those without programming backgrounds) is the range of statements under which a variable or object is valid to be referenced.
    The SQL language follows this practice, most times allowing variables to be referenced within the scope of a transaction.
    The full definition of a transaction in SQL is a bit complicated. For sake of this course, think of a transaction as highlighting and running multiple queries

    Up to this point in the training, most time we only run a single SELECT statement at a time. 
    However, it is possible to run multiple queries at once.
*/

	SELECT 1 --If I select and run these two queries, they both run and return their values within the same transaction, or scope.

	SELECT 2

	DECLARE @Variable1 int = 100 --If I declare a variable and then do the same thing, I can use the same variable in multiple queries

	SELECT @Variable1 

	SELECT @Variable1

	--Note that, like aliases, I can only reference a variable after its been declared.
	SELECT @Variable1 --Running this with the next statement fails since the variable isn't defined yet.
					  --However, running this statement with the preceding declaration of the variable works just fine!

	DECLARE @Variable1 int = 100 --If I declare a variable and then do the same thing, I can use the same variable in multiple queries

	SELECT @Variable1 

	SELECT @Variable1

	--If I select both declarations of Variable1 and run them, I get an error at the second declaration that Variable1 already exists.
	--This error occurs because by selecting and running both, they are running in the same scope, which only allows a variable name to be declared once.

	--Why is this importnat? Suppose you want to filter two tables by the same value.
	DECLARE @ProductKey int = 1 --I select this variable and the next two queries, and both run with the same value filtering the results
	SELECT *
	FROM dbo.DimProduct
	WHERE ProductKey =  @ProductKey

	SET @ProductKey = 310

	SELECT *
	FROM dbo.FactInternetSales
	WHERE ProductKey = @ProductKey

	--A value of 1 only returns a record from DimProduct, not FactInternetSales. If I change the variable value to 310, I get values for both
	--Also, if I reset @ProductKey between the queries, the second query uses the new value.
