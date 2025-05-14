/*

 Module 6 - T-SQL Specifics

*/


/*

 Attending this training, you've likely heard reference to both 'SQL' and 'T-SQL'.

How important is the T? Very, because it means it has extra function that are exclusive to SQL Serverand won't work in non-Microsoft database environments.

Here, let's cover T-SQL-specific functions you should consider using, and their ANSI counterpart.

*/

/* 

T-SQL Specific Function: STRING_SPLIT
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