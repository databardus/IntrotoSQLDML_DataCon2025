/*----------------------------------------------------------------------------
    
	Module 2.1: SELECT statement - The SELECT clause

----------------------------------------------------------------------------*/
/*
	Goals for Module
	-Introduce SELECT clause, purpose and formatting
	-Defining multiple columns to be returned.
	-Introduce arithmetic and function capabilities in SQL
	-Introduce column aliasing
	-Selecting individual queries to run.

*/

/*

	SELECT is where you declare what columns are returned by the query
	SELECT statements require you define at least one column

	Fun Fact: SELECT is the only statement you can run as its own statement.
    So before we add any other clauses, let's show what a SELECT statement looks like on its own.

*/

    --Your first SELECT statement - a lone SELECT clause 
	SELECT 1 --This will return a single column with a single row containing the value 1

	--You can define one to many columns to return in a SELECT clause. Columns are comma-separated
	--Let's add another columns
	SELECT 1, 2 --This will return two columns, each with a single row containing the values 1 and 2

	--Code-wise,formatting is flexible in SQL. You can keep your SELECT columns in the same line, or in separate lines.
	SELECT 1,
		   2,
		   3
		   ,4 --If split across multiple lines, commas can be either before or after the column

			,5 --Adding in multiple spaces between lines is also valid, as long as there's a comma somewhere in between!

			, --The comma doesn't even need to be in the same row as the column definition!
			6
	
	/*
		**Select individual queries in a window**
		In your IDE, in a query window like this, you can run all defined queries simultaneously.
		As an alternative, you can highlight an individual query and, as long as what is highlighted is valid, it'll run for you.
		This approach works even if you highlight a query in a comment area. Try running this : SELECT 1
	*/
	--While passing back integers is fun, it's not very productive. 
    --What may be helpful is knowing that when you identify data to be returned, you can also apply functions to return specific values
	
    SELECT 
		1+1,    --You can do arithmetic and return it as a value
		25/5+2, --Order of operations functions the same way as in mathematics
		ABS(-1), --SQL Also has some functions built in, such as absolute value. We'll cover more about functions later in the training
		'Test'  --SQL uses single quotes to define character strings 
	
    /*
    
        As an initial overview of the SELECT statement, we'll end with an important topic: Aliasing
        Regardless of what you are returning as a column in a SELECT statement, you always have the ability to name the column with an alias
        Aliases are defined one of two ways
    
    */

	SELECT 1+1 AS Addition, --You can use the AS keyword to define a column alias at the end of a column definition,
		   TextField = 'Test' --You can also define the column alias first, followed by an equal (=) sign and the value you want to 

	/*-----------------------------------------------------------------
		There are more capabilities within the SELECT statement, but this sets up a base of what can be accomplished in a SELECT clause
	-----------------------------------------------------------------*/