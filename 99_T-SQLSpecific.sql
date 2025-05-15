/*----------------------------------------

    Module: T-SQL Specifics

----------------------------------------*/


/*

    Attending this training, you've likely heard reference to both 'SQL' and 'T-SQL'.

    How important is the T? Very, because it means it has extra function that are exclusive to SQL Server
    and won't work in non-Microsoft database environments.

    Referencing 'SQL' exclusively typically refers to ANSI, 
    which manages on of the well-known (and evolving) standards of the SQL language. 
    While ANSI-managed standards are generally used across all database platforms,
    each vendor chooses to implement their own version of SQL with omissions, additions, and changes.

    Here, let's cover some notable T-SQL-specific functions you should consider using, and their non-function counterpart.

*/


/*
    Changing data types in SQL Server

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

    -- Example: Using CAST
    SELECT CAST(GETDATE() AS VARCHAR) AS FormattedDate;


/* 

    Function: STRING_SPLIT
    -- Purpose: Splits a string into rows based on a specified delimiter.
    -- Pros: Simplifies string splitting operations.

*/

-- Example: T-SQL Specific
SELECT value AS SplitValue
FROM STRING_SPLIT('Red,Green,Blue', ',');

-- ANSI SQL Equivalent: Using Common Table Expressions (CTE) and XML
WITH SplitCTE AS (
    SELECT 
        CAST('<x>' + REPLACE('Red,Green,Blue', ',', '</x><x>') + '</x>' AS XML) AS Data
)
SELECT T.value('.', 'VARCHAR(MAX)') AS SplitValue
FROM SplitCTE
CROSS APPLY Data.nodes('/x') AS T(value);

-- T-SQL Specific Function: FORMAT
-- Purpose: Formats values as strings with specified formatting.
-- Pros: Simplifies formatting of dates, numbers, etc.
-- Cons: Slower performance compared to other methods; not portable.

-- Example: Using FORMAT (T-SQL Specific)
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') AS FormattedDate;

-- ANSI SQL Equivalent: Using CONVERT
SELECT CONVERT(VARCHAR, GETDATE(), 23) AS FormattedDate;

-- T-SQL Specific Function: IIF
-- Purpose: Provides a shorthand for CASE expressions.
-- Pros: More concise syntax for simple conditional logic.
-- Cons: Limited to T-SQL; not portable.

-- Example: Using IIF (T-SQL Specific)
SELECT IIF(SalesYTD > 100000, 'High', 'Low') AS SalesCategory
FROM Sales.SalesPerson;

-- ANSI SQL Equivalent: Using CASE
SELECT CASE 
           WHEN SalesYTD > 100000 THEN 'High'
           ELSE 'Low'
       END AS SalesCategory
FROM Sales.SalesPerson;

-- T-SQL Specific Function: TRY_CONVERT
-- Purpose: Attempts to convert a value to a specified data type and returns NULL if it fails.
-- Pros: Prevents errors during conversion.
-- Cons: Not portable to other platforms.

-- Example: Using TRY_CONVERT (T-SQL Specific)
SELECT TRY_CONVERT(INT, '123') AS ConvertedValue,
       TRY_CONVERT(INT, 'ABC') AS FailedConversion;

-- ANSI SQL Equivalent: Using CASE with ISNUMERIC (partial equivalent)
SELECT CASE 
           WHEN ISNUMERIC('123') = 1 THEN CAST('123' AS INT)
           ELSE NULL
       END AS ConvertedValue,
       CASE 
           WHEN ISNUMERIC('ABC') = 1 THEN CAST('ABC' AS INT)
           ELSE NULL
       END AS FailedConversion;

    -- T-SQL Specific Function: LAG
    -- Purpose: Accesses data from a previous row in the same result set.
    -- Pros: Simplifies calculations involving previous rows.

    -- Example: Using LAG (T-SQL Specific)
    SELECT SalesOrderNumber, OrderDate, 
           LAG(OrderDate) OVER (PARTITION BY CustomerKey ORDER BY OrderDate) AS PreviousOrderDate
    FROM FactInternetSales;

    -- ANSI SQL Equivalent: Not directly available; requires self-joins or subqueries.

    -- T-SQL Specific Function: LEAD
    -- Purpose: Accesses data from a subsequent row in the same result set.
    -- Pros: Simplifies calculations involving next rows.

    -- Example: Using LEAD (T-SQL Specific)
    SELECT SalesOrderNumber, OrderDate, 
           LEAD(OrderDate) OVER (PARTITION BY CustomerKey ORDER BY OrderDate) AS NextOrderDate
    FROM FactInternetSales;

    -- ANSI SQL Equivalent: Not directly available; requires self-joins or subqueries.

    -- T-SQL Specific Function: GREATEST
    -- Purpose: Returns the greatest value from a list of expressions.
    -- Pros: Simplifies comparisons of multiple values.

    -- Example: Using GREATEST (T-SQL Specific)
    SELECT GREATEST(10, 20, 30) AS MaxValue;

    -- ANSI SQL Equivalent: Not directly available; requires CASE expressions.
    SELECT CASE 
               WHEN 10 >= 20 AND 10 >= 30 THEN 10
               WHEN 20 >= 10 AND 20 >= 30 THEN 20
               ELSE 30
           END AS MaxValue;

    -- T-SQL Specific Function: LEAST
    -- Purpose: Returns the smallest value from a list of expressions.
    -- Pros: Simplifies comparisons of multiple values.

    -- Example: Using LEAST (T-SQL Specific)
    SELECT LEAST(10, 20, 30) AS MinValue;

    -- ANSI SQL Equivalent: Not directly available; requires CASE expressions.
    SELECT CASE 
               WHEN 10 <= 20 AND 10 <= 30 THEN 10
               WHEN 20 <= 10 AND 20 <= 30 THEN 20
               ELSE 30
           END AS MinValue;

    -- T-SQL Specific Function: DATEPART
    -- Purpose: Extracts a specific part of a date (e.g., year, month, day).
    -- Pros: Simplifies date manipulation.

    -- Example: Using DATEPART (T-SQL Specific)
    SELECT DATEPART(YEAR, GETDATE()) AS CurrentYear,
           DATEPART(MONTH, GETDATE()) AS CurrentMonth;

    -- ANSI SQL Equivalent: Using EXTRACT
    SELECT EXTRACT(YEAR FROM CURRENT_DATE) AS CurrentYear,
           EXTRACT(MONTH FROM CURRENT_DATE) AS CurrentMonth;

        -- T-SQL Specific Function: COALESCE
        -- Purpose: Returns the first non-NULL value from a list of expressions.
        -- Pros: Simplifies handling of NULL values in queries.
        -- Cons: Limited to T-SQL; not portable to all database platforms.

    -- Example: Using COALESCE (T-SQL Specific)
    SELECT COALESCE(NULL, NULL, 'DefaultValue') AS FirstNonNullValue;

    -- ANSI SQL Equivalent: Using CASE
    SELECT CASE 
                WHEN NULL IS NOT NULL THEN NULL
                WHEN NULL IS NOT NULL THEN NULL
                ELSE 'DefaultValue'
            END AS FirstNonNullValue;

-- Summary of Pros and Cons of T-SQL Specific Functions:
-- Pros:
-- 1. Simplifies complex operations with concise syntax.
-- 2. Provides additional functionality not available in ANSI SQL.
-- 3. Optimized for Microsoft SQL Server.

-- Cons:
-- 1. Lack of portability to other database platforms.
-- 2. May lead to vendor lock-in.
-- 3. Some functions may have performance trade-offs.

-- Note: The AdventureWorks database is used for examples involving tables.
-- Ensure the database is restored and accessible before running these queries.