/*----------------------------------------------------------------------------

    Module 2.3: SELECT statement - WHERE clause

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module
	-Introduce WHERE clause and purpose
	-Explaining Boolean logic and notation in SQL
	-Introduce NULL
*/

/*

	So far, SELECT and FROM identify specific 'objects' that we want to interact with, such as tables and columns.
	Starting with WHERE, we now identify how we want to see data returned in our query 
	In the WHERE clause, you are declaring what records you want from the available data.
	To declare that, you define predicates.
	Predicates are boolean statements. Each record is tested and either returns true (and the record is returned) or false (and the record is not returned in the dataset).

*/
	SELECT *
	FROM dbo.DimProduct
	WHERE Color = 'Black' --"=": Equality is a single equal sign. This query only return records from the DimProduct table where the Color column has a value of Black

	SELECT *
	FROM dbo.DimProduct
	WHERE Color = 'BLACK' --In Microsoft SQL Server, text strings match regardless of case by default. This is not true for all vendors (Oracle, MySQL, etc.)

	SELECT *
	FROM dbo.DimProduct
	WHERE Color <> 'Black' --"<>": Not Equal is the less than and greather than symbols. This query only return records from the DimProduct table where the Color column has a value other than Black

	SELECT *
	FROM dbo.DimProduct
	WHERE StandardCost > 100 --">": Less Than/Greater than symbols work per usual, as do many boolean scenarios

	SELECT *
	FROM dbo.DimProduct
	WHERE StandardCost > 100
		AND Color = 'Black' --AND/OR keywords allow for testing multiple criteria at the same time.

	SELECT *
	FROM dbo.DimProduct
	WHERE Status IS NULL --Databases have the ability to store NULL values. For SQL to test this, the syntax replaces = with IS/IS NOT

	SELECT *
	FROM dbo.DimProduct
	WHERE Color IN ('Black', 'Silver') --If you want to specify a specific list of acceptable values, you can use the IN statement to specify comma-separated values
	--You can also turn this into an exclusion list by replacing IN with NOT IN

/*

    In the above statement, we are testing for NULL. What is NULL?
        -The absence of a value, or a value that is unknown.
        -NULL is not the same as 0. 0, while typically meaning nothing, is still a defined value. NULL isn't defined.
    Why is this important?
        Since NULL is not a value that can be defined, there's no way to compare it to another value.
        While 0 = 0 will return true, NULL = any value will always return false.
        To handle this, the ANSI standard uses IS NULL
        Advanced: SQL Server does have a query session setting that allows for NULL = NULL (SET ANSI_NULL OFF), but this will be deprecated

*/
