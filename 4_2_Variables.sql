/*----------------------------------------------------------------------------

    Module 8: Defining variables

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module
	-Explain the DECLARE variable used to define a variable, and what is needed
	-Define multiple variables in the same DECLARE statement
	-Show how you can assign a value
	-Use a variable within a query
*/

	--Aside of knowing what functions can be performed with certain data types, there is another useful function: Defining variables.
	--Variables can make your SQL queries more dynamic. 

	--For example, If you're wanting to filter data and do so in different ways, you can define a variable, incorporate it into your query, and then change the value as you see fit.
	--Let's query DimProduct and use a variable to control what is returned.

	--Variables are created using the DECLARE statement.
	--When defining a variable, you need to define the data type of the variable.
	--Variable names begin with the @ symbol.
	--Unlike column names, variables cannot be encapsulated in brackets. This also means variable names can't have spaces
	DECLARE @ProductAlternateKeyVariable varchar(20) = 'AR-5381'

	--Once you have a variable declared, you can use it in queries defined after the variable
	SELECT *
	FROM dbo.DimProduct
	WHERE ProductAlternateKey = @ProductAlternateKeyVariable--The query, when run, uses 'AR-5381' in place of @ProductAlternateKeyVaraiable

	--
	DECLARE @ProductAlternateKeyVariable varchar(20) --You can define variables without specifying a value for the variable

	--At a later time, if you want to assign a value to the variable, you use the SET statement, like so
	SET @ProductAlternateKeyVariable = 'AR-5381'

	--For most intents and purposes, you can treat a variable as a column. Any place you can use a column, you can use a variable.
	--For example, suppose we want each record to have a column specifying today's date
	DECLARE @CurrentDate datetime = GETDATE() --GETDATE is a function in SQL Server that returns the current date and time

	SELECT *, @ProductAlternateKeyVariable, @CurrentDate --Variables can be returned as a column in a dataset
	FROM dbo.DimProduct

	--You can also define multiple variables in a single DECLARE statement, like so:
	DECLARE @Int1 int = 5,
			@Int2 int = 6

	SELECT @Int1 + @Int2 --Just like columns, variables can be used in functions and arithmetic operations.
