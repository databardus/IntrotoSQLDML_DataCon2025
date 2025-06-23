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
WITH SalesByEmployee AS (
    SELECT 
        DE.EmployeeKey,
        DE.FirstName,
        DE.LastName,
        DT.SalesTerritoryGroup,
        TotalSales = SUM(FIS.SalesAmount),
        ROW_NUMBER() OVER (PARTITION BY DT.SalesTerritoryGroup ORDER BY SUM(FIS.SalesAmount) DESC) AS RowNum
    FROM DimEmployee DE
    JOIN FactInternetSales FIS ON DE.EmployeeKey = FIS.SalesEmployeeKey
    JOIN DimSalesTerritory DT ON DE.SalesTerritoryKey = DT.SalesTerritoryKey 
    GROUP BY 
        DT.SalesTerritoryGroup, 
        DE.EmployeeKey,
        DE.FirstName,
        DE.LastName
)
SELECT * 
FROM SalesByEmployee
WHERE RowNum = 1; -- Fetch the employee with the most sales-- Explanation: ROW_NUMBER assigns a unique rank to each row within a job title partition, ordered by salary.

-- Example 2: RANK - Assigns a rank to each row, with ties receiving the same rank
WITH EmployeeRanks AS (
    SELECT DISTINCT 
        DE.EmployeeKey,
        DE.FirstName,
        DE.LastName,
        DT.SalesTerritoryGroup,
        DE.Salary,
        RANK() OVER (PARTITION BY DT.SalesTerritoryGroup ORDER BY DE.Salary DESC) AS Rank
    FROM DimEmployee DE
    JOIN DimSalesTerritory DT ON DE.SalesTerritoryKey = DT.SalesTerritoryKey 

    )
SELECT * 
FROM EmployeeRanks
WHERE Rank <= 3; -- Fetch the top 3 highest-paid employees for each job title
-- Explanation: RANK assigns the same rank to rows with identical values, skipping ranks for ties.

-- Example 3: DENSE_RANK - Similar to RANK but does not skip ranks for ties
WITH EmployeeRanks AS (
    SELECT DISTINCT 
        DE.EmployeeKey,
        DE.FirstName,
        DE.LastName,
        DT.SalesTerritoryGroup,
        DE.Salary,
        DENSE_RANK() OVER (PARTITION BY DT.SalesTerritoryGroup ORDER BY DE.Salary DESC) AS Rank
    FROM DimEmployee DE
    JOIN DimSalesTerritory DT ON DE.SalesTerritoryKey = DT.SalesTerritoryKey 

    )
SELECT * 
FROM EmployeeRanks
WHERE Rank <= 3; -- Fetch the top 3 highest-paid employees for each job title
-- Explanation: DENSE_RANK ensures no gaps in ranking when ties occur.


-- Example 4: LAG and LEAD - Access previous and next rows
WITH AllSalaries AS
(
SELECT TOP (1000) [EmployeeKey]
      ,[ParentEmployeeKey]
      ,[EmpNatIDAltKey]
      ,[ParentEmpNatIDAltKey]
      ,[SalesTerritoryKey]
      ,[FirstName]
      ,[LastName]
      ,[MiddleName]
      ,[NameStyle]
      ,[Title]
      ,[HireDate]
      ,[BirthDate]
      ,[LoginID]
      ,[EmailAddress]
      ,[Phone]
      ,[MaritalStatus]
      ,[EmergencyContactName]
      ,[EmergencyContactPhone]
      ,[SalariedFlag]
      ,[Gender]
      ,[PayFrequency]
      ,[BaseRate]
      ,[VacationHours]
      ,[SickLeaveHours]
      ,[CurrentFlag]
      ,[SalesPersonFlag]
      ,[DepartmentName]
      ,[StartDate]
      ,[EndDate]
      ,[Status]
      ,[EmployeePhoto]
      ,[Salary]
      ,LAG(Salary) OVER (PARTITION BY [EmpNatIDAltKey] ORDER BY EffectiveDate) AS PreviousSalary
      ,LEAD(Salary) OVER (PARTITION BY [EmpNatIDAltKey] ORDER BY EffectiveDate) AS NextSalary
      ,[EffectiveDate]
      ,[ExpirationDate]
  FROM [dbo].[DimEmployee]
  WHERE SalariedFlag = 1
)
SELECT *, SalaryIncrease = (ABS(Salary - PreviousSalary) / PreviousSalary) * 100
FROM AllSalaries
WHERE Status = 'Current'
-- Explanation: LAG retrieves the previous row's value, and LEAD retrieves the next row's value.

-- Example 5: NTILE - Divide rows into a specified number of groups
SELECT 
    CustomerKey,
    FirstName,
    LastName,
    YearlyIncome,
    NTILE(4) OVER (ORDER BY YearlyIncome DESC) AS IncomeQuartile
FROM DimCustomer
WHERE YearlyIncome IS NOT NULL
ORDER BY IncomeQuartile, YearlyIncome DESC;
-- Explanation: NTILE divides the rows into 4 equal groups (quartiles) based on salary within each job title.

/*

    Module Summary
    - Windowing functions allow you to perform calculations across a set of rows related to the current row.
    - They are useful for advanced analytics, such as ranking, running totals, and moving averages.

*/