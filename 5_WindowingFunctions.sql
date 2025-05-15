/*------------------------------------------------------------

    Module - Windowing Functions

------------------------------------------------------------*/

/*
    Remember GROUP BY, where you collapse multiple rows into a single row with aggregate values?
    Windowing functions are similar, but instead of collapsing multiple rows into a single row,
    the individual records remain and have a function performed across the group.
    
    Benefits:
    1. Enables advanced analytics like ranking, running totals, and moving averages.
    2. Provides flexibility by allowing partitioning and ordering of data.

    Common Use Cases:
    1. Ranking rows (e.g., RANK, DENSE_RANK, ROW_NUMBER).
    2. Running Totals or cumulative sums (e.g., SUM with OVER clause).

*/
-- Common Use Cases:
-- 1. Ranking rows (e.g., RANK, DENSE_RANK, ROW_NUMBER).
-- 2. Calculating running totals or cumulative sums (e.g., SUM with OVER clause).
-- 3. Finding moving averages or lag/lead values (e.g., LAG, LEAD).
-- 4. Percentile calculations (e.g., PERCENT_RANK, NTILE).

-- Example 1: ROW_NUMBER - Assigns a unique number to each row within a partition
WITH EmployeeSalaries AS (
    SELECT 
        EmployeeKey,
        Title AS JobTitle,
        SalaryRate AS Rate,
        ROW_NUMBER() OVER (PARTITION BY Title ORDER BY SalaryRate DESC) AS RowNum
    FROM DimEmployee
    JOIN FactEmployeeSalary ON DimEmployee.EmployeeKey = FactEmployeeSalary.EmployeeKey
)
SELECT * 
FROM EmployeeSalaries
WHERE RowNum = 1; -- Fetch the highest-paid employee for each job title
-- Explanation: ROW_NUMBER assigns a unique rank to each row within a job title partition, ordered by salary.

-- Example 2: RANK - Assigns a rank to each row, with ties receiving the same rank
WITH EmployeeRanks AS (
    SELECT 
        EmployeeKey,
        Title AS JobTitle,
        SalaryRate AS Rate,
        RANK() OVER (PARTITION BY Title ORDER BY SalaryRate DESC) AS Rank
    FROM DimEmployee
    JOIN FactEmployeeSalary ON DimEmployee.EmployeeKey = FactEmployeeSalary.EmployeeKey
)
SELECT * 
FROM EmployeeRanks
WHERE Rank <= 3; -- Fetch the top 3 highest-paid employees for each job title
-- Explanation: RANK assigns the same rank to rows with identical values, skipping ranks for ties.

-- Example 3: DENSE_RANK - Similar to RANK but does not skip ranks for ties
WITH EmployeeDenseRanks AS (
    SELECT 
        EmployeeKey,
        Title AS JobTitle,
        SalaryRate AS Rate,
        DENSE_RANK() OVER (PARTITION BY Title ORDER BY SalaryRate DESC) AS DenseRank
    FROM DimEmployee
    JOIN FactEmployeeSalary ON DimEmployee.EmployeeKey = FactEmployeeSalary.EmployeeKey
)
SELECT * 
FROM EmployeeDenseRanks
WHERE DenseRank <= 3; -- Fetch the top 3 highest-paid employees for each job title
-- Explanation: DENSE_RANK ensures no gaps in ranking when ties occur.

-- Example 4: SUM - Calculate running totals
WITH RunningTotals AS (
    SELECT 
        EmployeeKey,
        Title AS JobTitle,
        SalaryRate AS Rate,
        SUM(SalaryRate) OVER (PARTITION BY Title ORDER BY SalaryRate DESC) AS RunningTotal
    FROM DimEmployee
    JOIN FactEmployeeSalary ON DimEmployee.EmployeeKey = FactEmployeeSalary.EmployeeKey
)
SELECT * 
FROM RunningTotals;
-- Explanation: SUM with the OVER clause calculates a cumulative total for each job title.

-- Example 5: LAG and LEAD - Access previous and next rows
WITH LagLeadExample AS (
    SELECT 
        EmployeeKey,
        Title AS JobTitle,
        SalaryRate AS Rate,
        LAG(SalaryRate) OVER (PARTITION BY Title ORDER BY SalaryRate DESC) AS PreviousRate,
        LEAD(SalaryRate) OVER (PARTITION BY Title ORDER BY SalaryRate DESC) AS NextRate
    FROM DimEmployee
    JOIN FactEmployeeSalary ON DimEmployee.EmployeeKey = FactEmployeeSalary.EmployeeKey
)
SELECT * 
FROM LagLeadExample;
-- Explanation: LAG retrieves the previous row's value, and LEAD retrieves the next row's value.

-- Example 6: NTILE - Divide rows into a specified number of groups
WITH NTileExample AS (
    SELECT 
        EmployeeKey,
        Title AS JobTitle,
        SalaryRate AS Rate,
        NTILE(4) OVER (PARTITION BY Title ORDER BY SalaryRate DESC) AS Quartile
    FROM DimEmployee
    JOIN FactEmployeeSalary ON DimEmployee.EmployeeKey = FactEmployeeSalary.EmployeeKey
)
SELECT * 
FROM NTileExample;
-- Explanation: NTILE divides the rows into 4 equal groups (quartiles) based on salary within each job title.

-- Example 7: LAG
-- Purpose: Accesses data from a previous row in the same result set.

SELECT SalesOrderNumber, OrderDate, 
        LAG(OrderDate) OVER (PARTITION BY CustomerKey ORDER BY OrderDate) AS PreviousOrderDate
FROM FactInternetSales;

-- Example 8: LEAD
-- Purpose: Accesses data from a subsequent row in the same result set.

SELECT SalesOrderNumber, OrderDate, 
        LEAD(OrderDate) OVER (PARTITION BY CustomerKey ORDER BY OrderDate) AS NextOrderDate
FROM FactInternetSales;

/*

    Module Summary
    - Windowing functions allow you to perform calculations across a set of rows related to the current row.
    - They are useful for advanced analytics, such as ranking, running totals, and moving averages.

*/