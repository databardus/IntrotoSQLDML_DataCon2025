-- Windowing Functions in T-SQL
-- Windowing functions are a powerful feature in SQL that allow you to perform calculations across a set of rows related to the current row.
-- Unlike aggregate functions, windowing functions do not collapse rows into a single result; instead, they return a value for each row in the result set.
-- Benefits:
-- 1. Simplifies complex queries.
-- 2. Enables advanced analytics like ranking, running totals, and moving averages.
-- 3. Provides flexibility by allowing partitioning and ordering of data.

-- Common Use Cases:
-- 1. Ranking rows (e.g., RANK, DENSE_RANK, ROW_NUMBER).
-- 2. Calculating running totals or cumulative sums (e.g., SUM with OVER clause).
-- 3. Finding moving averages or lag/lead values (e.g., LAG, LEAD).
-- 4. Percentile calculations (e.g., PERCENT_RANK, NTILE).

-- Demonstration using the AdventureWorks database
-- Ensure you are using the AdventureWorks database
USE AdventureWorks;

-- Example 1: ROW_NUMBER - Assigns a unique number to each row within a partition
WITH EmployeeSalaries AS (
    SELECT 
        BusinessEntityID,
        JobTitle,
        Rate,
        ROW_NUMBER() OVER (PARTITION BY JobTitle ORDER BY Rate DESC) AS RowNum
    FROM HumanResources.EmployeePayHistory
    JOIN HumanResources.Employee ON EmployeePayHistory.BusinessEntityID = Employee.BusinessEntityID
)
SELECT * 
FROM EmployeeSalaries
WHERE RowNum = 1; -- Fetch the highest-paid employee for each job title
-- Explanation: ROW_NUMBER assigns a unique rank to each row within a job title partition, ordered by salary.

-- Example 2: RANK - Assigns a rank to each row, with ties receiving the same rank
WITH EmployeeRanks AS (
    SELECT 
        BusinessEntityID,
        JobTitle,
        Rate,
        RANK() OVER (PARTITION BY JobTitle ORDER BY Rate DESC) AS Rank
    FROM HumanResources.EmployeePayHistory
    JOIN HumanResources.Employee ON EmployeePayHistory.BusinessEntityID = Employee.BusinessEntityID
)
SELECT * 
FROM EmployeeRanks
WHERE Rank <= 3; -- Fetch the top 3 highest-paid employees for each job title
-- Explanation: RANK assigns the same rank to rows with identical values, skipping ranks for ties.

-- Example 3: DENSE_RANK - Similar to RANK but does not skip ranks for ties
WITH EmployeeDenseRanks AS (
    SELECT 
        BusinessEntityID,
        JobTitle,
        Rate,
        DENSE_RANK() OVER (PARTITION BY JobTitle ORDER BY Rate DESC) AS DenseRank
    FROM HumanResources.EmployeePayHistory
    JOIN HumanResources.Employee ON EmployeePayHistory.BusinessEntityID = Employee.BusinessEntityID
)
SELECT * 
FROM EmployeeDenseRanks
WHERE DenseRank <= 3; -- Fetch the top 3 highest-paid employees for each job title
-- Explanation: DENSE_RANK ensures no gaps in ranking when ties occur.

-- Example 4: SUM - Calculate running totals
WITH RunningTotals AS (
    SELECT 
        BusinessEntityID,
        JobTitle,
        Rate,
        SUM(Rate) OVER (PARTITION BY JobTitle ORDER BY Rate DESC) AS RunningTotal
    FROM HumanResources.EmployeePayHistory
    JOIN HumanResources.Employee ON EmployeePayHistory.BusinessEntityID = Employee.BusinessEntityID
)
SELECT * 
FROM RunningTotals;
-- Explanation: SUM with the OVER clause calculates a cumulative total for each job title.

-- Example 5: LAG and LEAD - Access previous and next rows
WITH LagLeadExample AS (
    SELECT 
        BusinessEntityID,
        JobTitle,
        Rate,
        LAG(Rate) OVER (PARTITION BY JobTitle ORDER BY Rate DESC) AS PreviousRate,
        LEAD(Rate) OVER (PARTITION BY JobTitle ORDER BY Rate DESC) AS NextRate
    FROM HumanResources.EmployeePayHistory
    JOIN HumanResources.Employee ON EmployeePayHistory.BusinessEntityID = Employee.BusinessEntityID
)
SELECT * 
FROM LagLeadExample;
-- Explanation: LAG retrieves the previous row's value, and LEAD retrieves the next row's value.

-- Example 6: NTILE - Divide rows into a specified number of groups
WITH NTileExample AS (
    SELECT 
        BusinessEntityID,
        JobTitle,
        Rate,
        NTILE(4) OVER (PARTITION BY JobTitle ORDER BY Rate DESC) AS Quartile
    FROM HumanResources.EmployeePayHistory
    JOIN HumanResources.Employee ON EmployeePayHistory.BusinessEntityID = Employee.BusinessEntityID
)
SELECT * 
FROM NTileExample;
-- Explanation: NTILE divides the rows into 4 equal groups (quartiles) based on salary within each job title.

-- These examples demonstrate the versatility of windowing functions in T-SQL for advanced analytics.