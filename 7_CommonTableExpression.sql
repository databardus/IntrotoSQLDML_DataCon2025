-- Common Table Expressions (CTEs) in SQL

-- What is a CTE?
-- A Common Table Expression (CTE) is a temporary result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement.
-- It is defined using the WITH keyword and exists only for the duration of the query in which it is used.

-- Benefits of CTEs:
-- 1. Improved readability: CTEs make complex queries easier to read and maintain.
-- 2. Reusability: You can reference the CTE multiple times within the same query.
-- 3. Simplifies recursive queries: CTEs are commonly used for hierarchical or recursive data.

-- Common Use Cases:
-- 1. Simplifying complex joins or subqueries.
-- 2. Breaking down a query into logical steps.
-- 3. Performing recursive queries, such as finding hierarchical relationships (e.g., organizational charts).

-- Demonstration of a CTE:
-- Let's use the AdventureWorks database to demonstrate a CTE.
-- In this example, we'll calculate the total sales for each salesperson and then filter for salespeople with total sales above a certain threshold.

-- Step 1: Define the CTE using the WITH keyword.
-- Step 2: Write the query that references the CTE.

-- Example:
USE AdventureWorks;

-- Define the CTE
WITH SalesBySalesperson AS (
    SELECT 
        sp.BusinessEntityID,
        p.FirstName,
        p.LastName,
        SUM(sod.LineTotal) AS TotalSales
    FROM 
        Sales.SalesOrderDetail sod
    INNER JOIN 
        Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    INNER JOIN 
        Sales.SalesPerson sp ON soh.SalesPersonID = sp.BusinessEntityID
    INNER JOIN 
        Person.Person p ON sp.BusinessEntityID = p.BusinessEntityID
    GROUP BY 
        sp.BusinessEntityID, p.FirstName, p.LastName
)

-- Use the CTE in a query
SELECT 
    BusinessEntityID,
    FirstName,
    LastName,
    TotalSales
FROM 
    SalesBySalesperson
WHERE 
    TotalSales > 50000
ORDER BY 
    TotalSales DESC;

-- Explanation:
-- 1. The CTE "SalesBySalesperson" calculates the total sales for each salesperson.
-- 2. The main query selects data from the CTE and filters for salespeople with total sales greater than 50,000.
-- 3. The result is sorted in descending order of total sales.

-- Try modifying the threshold in the WHERE clause to see how the results change!