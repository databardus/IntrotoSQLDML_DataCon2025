/*----------------------------------------------------------------------------

    Module: Understanding Data Types (Basic)

----------------------------------------------------------------------------*/
/*
	Teacher's goals for Module 4
	-Use Azure Data Studio Object Explorer (on left) to explore the columns available and what properties a column has 
	-Identify the common data types used in SQL Server
	-Overview that this impacts how we can use aliases, as well as understanding how clauses impact each other
	-Present examples that showcase why this knowledge is relevant
*/

/*
	This section is specific to SQL Server, though some of the information is transferable to other vendor databases.
	Like Excel and other solutions that involve working with data, databases store data in various data types.
	This is done for two primary reasons: Efficient storage, and to support certain functions that work on specific data types.

	First, how do you know what data type a column is?
	In the Object Explorer on the left, you can navigate to individual tables you have access to.
	Underneath the table, there is a column folder. Opening this folder shows what columns are available.

	Each column in SQL Server has 3 basic properties:
	-Name: The name you use in a query to reference the column.
	-Data Type: This defines how the data is stored. 
				More importantly, it determines how values in the columns can be manipulated using arithmetic and functions
	-Nullability: Each column will say either NULL or NOT NULL. The former allows records to have NULL values in the column, while the latter won't.

	Covering all of the specific data types and impacts of data types in SQL Server could be a course in itself. 
	Instead, we'll focus on the three overarching datatypes commonly seen in databases, and what you need to know to effectively interact with the data using SQL.

*/

/*-----------------------------------------------------	
	Data Type 1: Number Data Types  
-----------------------------------------------------*/
	/*	Integers	*/
	--int: Mimicing mathematics, Integers store non-decimal numerical values
	SELECT 1 --This is an integer
	--There are multiple integer data types in SQL Server, all that end with the three letters 'int'. All we need to know for querying is that for sake of interactions, they all behave the same way.


	/*	Decimals	*/
	/*
		Decimal(x,y): A decimal value that can store a total of x digits, with y being the number of digits that are stored to the right of the decimal point
		Numeric(x,y): A synonym for Decimal. 
	*/
	SELECT 1.0 --This is a decimal
	--Monetary values or other values requiring decimals are stored in this data type.
	--There is also the money datatype in SQL Server, which will work the same as decimals. However, most times the decimal data type is used to represent monetary values as this is part of the ISO standard 

	/*	Number-based functions	*/
	/*
		As we stated before, Integers support common arithmetic operations.
		Decimal data types, being numerical in nature, also support those same functions.
		For functions, you'll find most functions involving numbers focus on aggregations (Sums, Maximum/Minimum value in a set, Averages, for example). 
		This means they are usually used in tandem with the GROUP BY clause if they are returned as columns alongside non-aggregate columns.
	*/
	SELECT MAX(ProductKey),SUM(SalesAmount), AVG(SalesAmount), MAX(SalesAmount), MIN(SalesAmount)
	FROM dbo.FactInternetSales
	--In the above example, GROUP BY is not needed because no non-aggregate columns are being returned.

	--One important thing to know about integers and decimals. You can use them in tandem for arithmetic functions, but occasionaly the results may not be what you expect.
	SELECT 5/2 --Dividing an integer by an integer returns an integer

	SELECT 5/2.5 --By dividing an integer by a decimal, you get a decimal value

	SELECT 5.5/2 --Same goes for dividing a decimal by an integer.

	SELECT 5/2.0 --Changing 2 (integer) to 2.0 (decimal), you're able to get a decimal result.

	--The full reasoning behind this involves understanding implicit conversion with number-based data types in deeper detail, and will be explained in a later section.

	--For a full list of arithmetic functions in SQL Server, read here: https://docs.microsoft.com/en-us/sql/t-sql/functions/mathematical-functions-transact-sql?view=sql-server-ver15

/*-----------------------------------------------	
	Data Type 2: Character String Data Types
-----------------------------------------------*/
	/*	Character strings	*/
	/*
.		char(X): This data type is a character string of X length, where X is an integer
		varchar(X): This data type is a character string of X length, where X is an integer
		nvarchar(X): This data type is a character string of X length, where X is an integer
		The difference between these 3 data types for character strings is outside the scope of this training. 
		For now, understand that they work essentially the same for many queries.
	*/

	/*	Character string-based functions	*/
	--Like many languages, SQL supports the ability to create and manipulate strings of characters

	--First, it is possible to merge multiple string values into one value
	SELECT 'Test' + ' String' --Plus signs are a simple form of concatenating strings together
	SELECT CONCAT('Test', 'String') --There is also a CONCAT() function that performs the same function for 2 to 254 character strings

	--Second, you can use functions to split a string into multiple parts
	--STRING_SPLIT is post SQL Server 2016, and allows you to split a string into multiple parts based on a delimiter.
	SELECT 
		DateKey,
		CustomerKey,
		value AS IndividualResponse -- Individual response extracted from the comma-separated values
	FROM 
		dbo.FactSurveyResponseAggregated
	CROSS APPLY  -- CROSS APPLY allows you to apply a function to each row in the table
		STRING_SPLIT(EnglishProductSubcategoryName, ',') -- Splits the SurveyResponse column into individual values
	ORDER BY CustomerKey, DateKey;

	--Third, you can use functions to only return specific parts of a string
	SELECT RIGHT('Test String', 6) --Returns the first 6 characters from the right of the string
	--The LEFT keywork performs the same function, but starts from the left side of the string
	SELECT SUBSTRING('Test String', 1, 4) --SUBSTRING() returns a subset of the string's characters

	--Fourth, You can get format the functions in various ways
	SELECT UPPER('Test String') --Returns the string in all caps
	SELECT TRIM('     Test   String      ') --Removes blank spaces from the front and end of strings
	SELECT REPLACE('       Test        String       ', ' ', '') --The equivalent of the last statement, but it removes additional spaces in between words
	--REPLACE() can also be used to replace specific characters in a string with other characters.
	--REPLACE() takes 3 arguments: The string to modify, the character to replace, and the character to replace it with.

	--Finally, there are some functions that can return specific properties of a 
	SELECT LEN('Test String') --Returns the number of characters in the string

	--This is just a small sample of functions for character strings
	--Compared to numerical values, interactions with character strings are more function based.

/*------------------------------------------------------------	
	Data Type 3: Date/Time based Data Types
------------------------------------------------------------*/
	/*	Dates and Times	*/
	/*
		datetime: Stores both date and time
		date: Stored date only
		time: Stores time only
	*/
	/*	DateTime functions	*/
	--Like character strings, most operations on dates require using functions.
	
	/*	Date Ranges	*/
	--Checking if a date is in a given range is a fairly common use case for filtering. This is supported by arithmetic operators.
	SELECT *
	FROM dbo.FactInternetSales
	WHERE OrderDate > '2010-01-01' --The easiest way to define a date to compare against is actually a character string. Most definitions of dates will convert to strings. 
								   --Why this works is covered in another course.
	ORDER BY OrderDate --ORDER BY makes it easy to see that our filtering criteria works.

	--Sometimes it helps to check if records exist with a specific date range. There are two ways to define this.
	SELECT *
	FROM dbo.FactInternetSales
	WHERE OrderDate >= '2010-01-01' AND OrderDate <= '2010-12-31'
	--AND	` allows us to define a date range by comparing against the same date column.

	SELECT *
	from dbo.FactInternetSales
	WHERE OrderDate BETWEEN '2010-01-01' AND '2010-12-31'
	/*
		BETWEEN is another way of defining a range of acceptable values
		It functions the same way as the previous statement, where records matching the start/end date are included in the result set. 
		If you would rather have greater/less than instead, do not use BETWEEN
	*/

	/*	Date Parts	*/
	--Suppose you want to identify a specific part of the date and represent it as a different column.
	SELECT DATEPART(d, GETDATE()) --Specify what part of the date you want to return as the first argument (day, month, etc.) and it will return that part of the second argument (a date)
	SELECT GETDATE(), YEAR(GETDATE()), MONTH(GETDATE()), DAY(GETDATE()) --SQL Server also has individual functions for returning specific parts of a date

	/*	Date Manipulation	*/
	--There are also two useful functions for manipulating dates: DATEADD and DATEDIFF
	SELECT 
		DATEADD(d, 3, GETDATE()), --If you need to adjust a date to a different date, DATEADD lets you modify a date by an increment (2nd parameter) of a date part (day, month, hour, etc.)
		DATEDIFF(d, OrderDate, GETDATE()) --If you need to identify X number of dates since an order was placed, DATEDIFF allows you to compare dates and determine the days/month/years between them
	FROM dbo.FactInternetSales

	/*
		This covers the majority of data types that are used on a regular basis with database data.
		For more information on SQL Server data types, consider the following reading materials: https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-types-transact-sql?view=sql-server-ver15
	*/

/*-------------------------------------------------------
    Data Conversion functions
-------------------------------------------------------*/
/*	
	What if I need to change the data type for the function I am using?
	In SQL Server, you can use the CONVERT() and CAST() functions to change the data type of a value.

    Function: CONVERT
    Purpose: Converts a value from one data type to another, with additional formatting options.
    Pros: Provides more control over date and time formatting compared to CAST.

    Function: CAST
    Purpose: Converts a value from one data type to another.
    Does not provide formatting options like CONVERT does.

*/
    -- Example: Using CONVERT (T-SQL Specific)
    SELECT CONVERT(VARCHAR, GETDATE(), 101) AS FormattedDateMMDDYYYY,
        CONVERT(VARCHAR, GETDATE(), 120) AS FormattedDateISO;
	--To test with real data, use OrderDate from FactInternetSales
	SELECT CONVERT(VARCHAR, OrderDate, 101) AS FormattedDateMMDDYYYY,
	       CONVERT(VARCHAR, OrderDate, 120) AS FormattedDateISO
	FROM dbo.FactInternetSales;

    -- Example: Using CAST
    SELECT CAST(GETDATE() AS VARCHAR) AS FormattedDate;
	SELECT CAST('5' AS INT) AS ConvertedValue;

/*---------------------------------
	Additional Functions
-----------------------------------*/
/*
	Since this module heavily focusses on functions, let's look at some additional functions
	that will help you manipulate data in SQL Server.

*/

/*  
	Conditional Logic - CASE Statements  
	What if I need to return a different value based on a predicate?
	CASE statements are a way to return different values based on a predicate.
*/

-- Example: Suppose I want to bucket my sales into ranges to see how many transactions fall into each range.
-- I can use a CASE statement to do this.
SELECT 
	SalesOrderNumber,
	SalesAmount,
	CASE --Each record can only return one value, so the first predicate that is true will be returned.
		WHEN SalesAmount < 100 THEN 'Low' --This predicate is checked first. If the record fails, the next predicate is checked.
		WHEN SalesAmount BETWEEN 100 AND 500 THEN 'Medium'
		WHEN SalesAmount > 500 THEN 'High'
		ELSE 'Unknown' --If none of the above predicates are true, the ELSE statement is returned. 
		--ELSE is optional. If you don't specify an ELSE statement, the record will return NULL
		--if the above predicates are false.
	END AS SalesCategory --Best to alias the CASE statement so it has a column name in the result set
FROM 
	dbo.FactInternetSales;


/*

	In some cases, SQL Server has simplified the same conditional logic for specific cases.

*/

	-- Conditional Function: COALESCE
	-- Purpose: Returns the first non-NULL value from a list of expressions.
	-- This can be accomplished with a CASE statement, but COALESCE is more concise.

    SELECT COALESCE(NULL, NULL, 'DefaultValue') AS FirstNonNullValue;

	-- The most common use case for COALESCE is when a desired value may come from multiple columns
	-- depending on the data.
	SELECT 
		CustomerKey,
		COALESCE(dc.EmailAddress, 'No Email Provided') AS EmailAddress
	FROM 
		dbo.DimCustomer dc
		
    -- CASE Statement Equivalent:
    SELECT CASE 
                WHEN dc.EmailAddress IS NOT NULL THEN dc.EmailAddress
                ELSE 'No Email Provided'
            END AS EmailAddress
	FROM
		dbo.DimCustomer dc


    -- Conditional Function: GREATEST
    -- Purpose: Returns the greatest value from a list of expressions.

    -- Example: Using GREATEST (T-SQL Specific)
    SELECT GREATEST(10, 20, 30) AS MaxValue;
	--This example is simple, but when you realize you can pass multple columns into the function,
	--the use case becomes more apparent.

    -- Here is how you'd do the same thing with a CASE statement
	-- It's not as clean, but it works.
    SELECT CASE 
               WHEN 10 >= 20 AND 10 >= 30 THEN 10
               WHEN 20 >= 10 AND 20 >= 30 THEN 20
               ELSE 30
           END AS MaxValue;

    -- Conditional Function: LEAST
    -- Purpose: Returns the smallest value from a list of expressions.

    -- Example: Using LEAST (T-SQL Specific)
    SELECT LEAST(10, 20, 30) AS MinValue;

    -- ANSI SQL Equivalent: Not directly available; requires CASE expressions.
    SELECT CASE 
               WHEN 10 <= 20 AND 10 <= 30 THEN 10
               WHEN 20 <= 10 AND 20 <= 30 THEN 20
               ELSE 30
           END AS MinValue;


/*

	Module Summary
	-Data types are important to make use of the functions available in your database environment
	-Always check your database documentation for the specific data types available
	-Check new version of SQL Server for new functions that may be available
	-Functions are a key part of SQL Server, and are used to manipulate data in various ways

*/
