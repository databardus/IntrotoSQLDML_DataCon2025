/*----------------------------------------------------------------------------

    Module 3: Understanding Data Types (Basic)

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

/*	
	Data Type 1: Number Data Types  
*/
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

/*	
	Data Type 2: Character String Data Types
*/
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

	--Second, you can use functions to only return specific parts of a string
	SELECT RIGHT('Test String', 6) --Returns the first 6 characters from the right of the string
	--The LEFT keywork performs the same function, but starts from the left side of the string
	SELECT SUBSTRING('Test String', 1, 4) --SUBSTRING() returns a subset of the string's characters

	--Third, You can get format the functions in various ways
	SELECT UPPER('Test String') --Returns the string in all caps
	SELECT TRIM('     Test   String      ') --Removes blank spaces from the front and end of strings
	SELECT REPLACE('       Test        String       ', ' ', '') --The equivalent of the last statement, but it removes additional spaces in between words

	--Finally, there are some functions that can return specific properties of a 
	SELECT LEN('Test String') --Returns the number of characters in the string

	--This is just a small sample of functions for character strings
	--Compared to numerical values, interactions with character strings are more function based.

/*	
	Data Type 3: Date/Time based Data Types
*/
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
