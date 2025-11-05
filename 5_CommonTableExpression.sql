/*--------------------------------------------------------

    Module: Common Table Expressions (CTEs)

--------------------------------------------------------*/

/*
    What is a CTE?
    A Common Table Expression (CTE) is a temporary result set you define as a SELECT statement.
    Once defined, you can reference it within a follow-up SELECT, INSERT, UPDATE, or DELETE statement.
*/

/*
    Benefits of CTEs:
    1. Improved readability: CTEs make complex queries easier to read and maintain.
    2. Reusability: You can reference the CTE multiple times within the same query.
    3. Simplifies recursive queries: CTEs are commonly used for hierarchical or recursive data.
    4. Conversion to temp tables: Writing your queries as CTEs make it easy to convert them to temp tables if needed.
*/

/*
    Using a CTE requires two steps:
    Step 1: Define the CTE using the WITH keyword.
    Step 2: Write the query that references the CTE.
*/

-- Example: Suppose I want to find the top X salespeople, organized by Sales Territory, based on total sales amount.
    WITH SalesBySalesperson AS (
        SELECT 
            de.EmployeeKey AS BusinessEntityID,
            de.FirstName,
            de.LastName,
            st.SalesTerritoryGroup,
            SUM(fis.SalesAmount) AS TotalSales
        FROM 
            FactInternetSales fis
        INNER JOIN 
            DimSalesTerritory st ON fis.SalesTerritoryKey = st.SalesTerritoryKey
        INNER JOIN 
            DimEmployee de ON fis.SalesEmployeeKey = de.EmployeeKey
        INNER JOIN 
            DimCustomer c ON fis.CustomerKey = c.CustomerKey
        GROUP BY 
            de.EmployeeKey, de.FirstName, de.LastName
    )

    -- Use the CTE in a query
    SELECT 
        BusinessEntityID,
        FirstName,
        LastName,
        TotalSales
    FROM 
        SalesBySalesperson --This is the CTE we just defined. We can use it like a table!
    ORDER BY 
        TotalSales DESC;

    -- Here's another example. 
    --In this example, we'll create a CTE to find an employee's manager
    --When finding an employee's manager alone, this could be done with a simple join.
    --However, as a CTE, this could then be used in another CTE to get the manager's manager.
    --In more complex scenarios, CTEs can be recursively defined to outline 
    --an employee's full hierarchy of managers in one record, all the way to the top.
WITH Employee AS (
        SELECT 
            e.EmployeeKey AS EmployeeID,
            e.FirstName AS EmployeeFirstName,
            e.LastName AS EmployeeLastName,
            e.ParentEmployeeKey AS ManagerID
        FROM 
            DimEmployee e
    )
    , EmployeeManager AS (
    SELECT 
        eh.EmployeeID,
        eh.EmployeeFirstName,
        eh.EmployeeLastName,
        m.FirstName AS ManagerFirstName,
        m.LastName AS ManagerLastName,
        m.ParentEmployeeKey AS SecondManagerID
    FROM 
        Employee eh
    LEFT JOIN 
        DimEmployee m ON eh.ManagerID = m.EmployeeKey
        --Notice how we're joining from a CTE of DimEmployee to the DimEmployee table again.
    )
    --We will showcase another round of reference to simulate the first round of recursion
    SELECT eh.*,
           m.FirstName AS SecondManagerFirstName,
           m.LastName AS SecondManagerLastName
    FROM EmployeeManager eh
    LEFT JOIN 
        DimEmployee m ON eh.SecondManagerID = m.EmployeeKey

    --There are more practical reasons to use CTEs, but this module explains the general function.
    --Future modules will make use of CTEs more regularly.
/*

    Module Summary
    - CTEs are temporary result sets defined within a query.
    - They improve readability and can be reused within the same query.

    Remember, CTEs are temporary and only exist for the duration of the query.
    If you need the CTE to persist, consider using a view or a temp table.

    Also, not every query needs to be a CTE.
    When considering whether to use a CTE, ask yourself:
    -Is the query complex enough to benefit from improved readability?

*/