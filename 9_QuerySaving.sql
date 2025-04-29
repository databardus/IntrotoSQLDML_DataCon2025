/*----------------------------------------------------------------------------

    Module 7: Storing Queries on SQL Server

----------------------------------------------------------------------------*/
/*
	Teacher's goals for this Module
	-Define what three forms of storing queries: Files, Stored Procedures, and Views
	-Explain the differences between the three options and their use cases
	-Show basics of creating and deleting objects using the CREATE and DROP statements

	Note: Consult training org's policy for what trainees will/will not be able to create security-wise. Only teach them what they will be able to do.

*/

/*
    Most times queries are generated for a certain use. That use may exist for some time, and while that use is relevant, we want to be able to store our queries.
    How do we store queries for future use?

    For analytical queries, there are three main approaches:
    1. Store the query as a file somewhere
    2. Store the query as a View (if it only returns data via SELECT statement)
    3. Store the query as a Stored procedure (for SELECT statements and other uses)

    Option 1 is the simplest. Most development tools have the ability to create .sql files.
    This is a fancy form of a text file that SQL tools know how to add formatting (for keywords for the language)
    Any formatting and comments in this window get saved within the file.

    Options 2 and 3 create objects within a database environment. This means access to this will be restricted by your IT department.
    If you determine a need for this access, discuss it with the appropriate staff.

	Which option is best to use when?
		-Option 1 (File) is best for personal use or if you prefer sharing files ad hoc between people who use the same tools as you.
		-Option 2 (View) is best if the query results will be the source of some process, or if multiple people are going to query it on a consistent basis.
		-Option 3 (Stored Procedure), for the analyst, is about the same as Option 2. Option 3 is better if performance becomes a concern and temp tables are used (covered in another training)

*/

	--To create a View or Stored Procedure, use the keyword CREATE with either VIEW or PROCEDURE (for stored procedures)
	/*

	CREATE VIEW dbo.TestView
	AS 
	SELECT 1 AS TestColumn

	*/
	/*

	CREATE PROCEDURE dbo.TestProcedure
	AS
	SELECT 1 as TestColumn

	*/
	--Once you run the CREATE statements, you should find them in their respective folders in the explorer (Views folder for views, Programmability->Stored Procedures for the procedure)
	--Note that the name of your procedure must be unique within the schema you create it in.


	--To use the objects, views and stored procedures have different forms of execution
	--For a view, query it with a SELECT statement, the same way you would a table
	SELECT * from dbo.TestView

	/*
	--For a procedure, you use the EXECUTE (or EXEC for short) to call the procedure
	EXEC dbo.TestProcedure
	*/

	/*
	--If you ever want to modify an existing view/procedure, replace CREATE in the above statements with ALTER
	ALTER VIEW dbo.TestView
	AS 
	SELECT 1 AS TestColumn
	*/

	/*
	ALTER PROCEDURE dbo.TestProcedure
	AS
	SELECT 1 as TestColumn
	*/

	--If you don't like what you've created, delete the object by replacing CREATE with DROP
	--Note: Since you're deleting it, you just need to reference the name of the object, not what it does.
	DROP VIEW dbo.TestView
	GO

	DROP PROCEDURE dbo.TestProcedure
	GO

	--Once you initially create the object, you can use the explorer to script CREATE/ALTER/DROP statements

	--One final thing on object creation, specifically a difference between views and procedures. 
	--Remember creating variables (See Variable Module)? You can use the same principals to create procedures with parameters (views can do this, stored procedures cannot)
	CREATE PROCEDURE dbo.TestProcesureWithParameter
	(
		@ProductKey int, --Before the AS keyword, add parentheses and then define you parameter (doesn't need the DECLARE keyword like a variable)
		@Date datetime   --Like variable declarations, you can declare multiple parameters for a stored procedure
	)
	AS
	SELECT *
	FROM dbo.DimProduct
	WHERE ProductKey = @ProductKey

	--Defining parameters for a procedure then requires passing in values when executing the procedure
	EXEC dbo.TestProcesureWithParameter 1, GETDATE() --Pass in values for the parameter after calling the procedure (comma separated if multiple parameters)
	--You can explicitly defined the parameters (@ProductKey = 1, @Date = GETDATE()), but most times this isn't necessary
