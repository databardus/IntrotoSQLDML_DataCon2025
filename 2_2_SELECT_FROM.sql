/*----------------------------------------------------------------------------

    Module 2.2: SELECT statement - FROM clause

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module 
	-Introduce FROM clause and purpose
	-Defining the four parts of a table idenfifier
	-Introduce table aliasing
	-Explain the use of brackets in SQL Server
*/

/*

	In the FROM clause, you are declaring where you are getting the data from.
	The base definition requires identifying a table name, and a SELECT clause to determine what columns to return

*/
	SELECT * --An asterisk in a SELECT clause means return all columns from a defined table
	FROM [DimProduct]

/*
		In the above statement, we just named the table. This only works if the table is the only table with that name in the database
		If there are multiple tables with the same name, then you have to 'qualify' the table you are trying to access.
		There are 4 layers in a hierarchy that you use to qualify a table:
			-The table 
			-The schema: tables are grouped together in a database by a schema.
			-The database: schemas are grouped together in a database.
			-The server: A server can have multiple databases

		Each layer is separated by a period, and must be put in order

		As a best practice, it's best to qualify a table reference in a FROM statement with at least two parts: schema.table, for example.
*/


	--SELECT * from sys.servers

	SELECT *
	--   [server].[database].[schema].[table]
	FROM [servername].[AdventureWorksDW].[dbo].[DimProduct] DP --This is an example of a 'fully qualified' reference to a table
	--Also notice that the table has an Alias defined. This makes it easier to reference the table in other clauses in the query.
	--How this is useful will be addressed in later modules

/*

		Some query examples used so far include brackets, and some do not. What are brackets used for?
			-Formatting - Encapsulating data names in brackets can make them easier to read. It also allows for the adding of spaces in column/table names.
			-Spaces - If you want to have spaces in a name, you must encapsulate your name in brackets when referencing it
				-For Example, suppose your want to query data from a table named 'Dim Account'
					FROM Dim Account   --Referencing a table this way will return an error
					FROM [Dim Account] --Referencing a table this way is acceptable
			-Keywords - The SQL language has certain reserved words for specific purposes (SELECT, for example). Brackets help identify when you do not want to reference the keyword

*/
		SELECT 1 AS [Select] --Without brackets, this query fails.
