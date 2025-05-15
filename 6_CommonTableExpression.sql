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

-- Example: Suppose I want to find the top 10 salespeople based on total sales amount.
    WITH SalesBySalesperson AS (
        SELECT 
            sp.SalesPersonKey AS BusinessEntityID,
            p.FirstName,
            p.LastName,
            SUM(fis.SalesAmount) AS TotalSales,
            RANK() OVER (ORDER BY SUM(fis.SalesAmount) DESC) AS SalesRank
        FROM 
            FactInternetSales fis
        INNER JOIN 
            DimSalesTerritory st ON fis.SalesTerritoryKey = st.SalesTerritoryKey
        INNER JOIN 
            DimSalesPerson sp ON fis.SalesPersonKey = sp.SalesPersonKey
        INNER JOIN 
            DimCustomer c ON fis.CustomerKey = c.CustomerKey
        INNER JOIN 
            DimPerson p ON c.PersonKey = p.PersonKey
        GROUP BY 
            sp.SalesPersonKey, p.FirstName, p.LastName
    )

    -- Use the CTE in a query
    SELECT 
        BusinessEntityID,
        FirstName,
        LastName,
        TotalSales,
        SalesRank
    FROM 
        SalesBySalesperson --This is the CTE we just defined. We can use it like a table!
    WHERE 
        SalesRank <= 10 -- Filter for top 10 salespeople
    ORDER BY 
        SalesRank;


    -- Here's another example - Recursion. 
    --In this example, we'll create a CTE to find an employee's manager
    --When finding an employee's manager alone, this could be done with a simple join.
    --However, as a CTE, this could then be used recursively to outline 
    --an employee's full hierarchy of managers, all the way to the top.
    WITH EmployeeHierarchy AS (
        SELECT 
            e.EmployeeKey AS EmployeeID,
            e.FirstName AS EmployeeFirstName,
            e.LastName AS EmployeeLastName,
            e.ManagerKey AS ManagerID
        FROM 
            DimEmployee e
    )
    SELECT 
        eh.EmployeeID,
        eh.EmployeeFirstName,
        eh.EmployeeLastName,
        m.FirstName AS ManagerFirstName,
        m.LastName AS ManagerLastName
    FROM 
        EmployeeHierarchy eh
    LEFT JOIN 
        DimEmployee m ON eh.ManagerID = m.EmployeeKey
        --Notice how we're joining from a CTE of DimEmployee to the DimEmployee table again.

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