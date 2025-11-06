
/*

    Module 8 - UNION statements
    Find yourself needing to join data from two different tables, but where
    each table has a different set of data that you want as separate records,
    not as one wide record?

    You can do that with the UNION statement
    The UNION statement relies on the following:
    1. each query that is in the UNION'd clause must have the same structure
        in the SELECT clause
    2. Data types of the data in the SELECT clauses must match (or be implicitly convertable).

    Let's explore an example where we have two fact tables.
        -One has Internet Sales
        -The other has Reseller Sales
    To have a query that returns all sales in one set, we need to
    write two queries, one for each source. Then, we union them together.

*/

SELECT 
    ProductKey,
    OrderDateKey,
    DueDateKey,
    ShipDateKey,
    CustomerKey AS CustomerOrResellerKey,
    PromotionKey,
    CurrencyKey,
    SalesTerritoryKey,
    SalesOrderNumber,
    SalesOrderLineNumber,
    RevisionNumber,
    OrderQuantity,
    UnitPrice,
    ExtendedAmount,
    UnitPriceDiscountPct,
    DiscountAmount,
    ProductStandardCost,
    TotalProductCost,
    SalesAmount,
    TaxAmt,
    Freight,
    CarrierTrackingNumber,
    CustomerPONumber,
    OrderDate,
    DueDate,
    ShipDate,
    SalesEmployeeKey AS EmployeeKey,
    'InternetSales' AS Source
FROM dbo.FactInternetSales
UNION ALL
SELECT 
    ProductKey,
    OrderDateKey,
    DueDateKey,
    ShipDateKey,
    ResellerKey AS CustomerOrResellerKey,
    PromotionKey,
    CurrencyKey,
    SalesTerritoryKey,
    SalesOrderNumber,
    SalesOrderLineNumber,
    RevisionNumber,
    OrderQuantity,
    UnitPrice,
    ExtendedAmount,
    UnitPriceDiscountPct,
    DiscountAmount,
    ProductStandardCost,
    TotalProductCost,
    SalesAmount,
    TaxAmt,
    Freight,
    CarrierTrackingNumber,
    CustomerPONumber,
    OrderDate,
    DueDate,
    ShipDate,
    EmployeeKey,
    'ResellerSales' AS Source
FROM dbo.FactResellerSales;

/*

    This can then be used in tandem with other SQL capabilities.

    For Example, what if you want to get total sales for products from both tables?

*/

WITH AllSales AS
(
SELECT 
    fis.ProductKey,
    dp.EnglishProductName,
    fis.OrderDateKey,
    fis.DueDateKey,
    fis.ShipDateKey,
    fis.CustomerKey AS CustomerOrResellerKey,
    fis.PromotionKey,
    fis.CurrencyKey,
    fis.SalesTerritoryKey,
    fis.SalesOrderNumber,
    fis.SalesOrderLineNumber,
    fis.RevisionNumber,
    fis.OrderQuantity,
    fis.UnitPrice,
    fis.ExtendedAmount,
    fis.UnitPriceDiscountPct,
    fis.DiscountAmount,
    fis.ProductStandardCost,
    fis.TotalProductCost,
    fis.SalesAmount,
    fis.TaxAmt,
    fis.Freight,
    fis.CarrierTrackingNumber,
    fis.CustomerPONumber,
    fis.OrderDate,
    fis.DueDate,
    fis.ShipDate,
    fis.SalesEmployeeKey AS EmployeeKey,
    'InternetSales' AS Source
FROM dbo.FactInternetSales fis
LEFT JOIN dbo.DimProduct dp
    ON fis.ProductKey = dp.ProductKey
UNION ALL
SELECT 
    frs.ProductKey,
    dp.EnglishProductName,
    frs.OrderDateKey,
    frs.DueDateKey,
    frs.ShipDateKey,
    frs.ResellerKey AS CustomerOrResellerKey,
    frs.PromotionKey,
    frs.CurrencyKey,
    frs.SalesTerritoryKey,
    frs.SalesOrderNumber,
    frs.SalesOrderLineNumber,
    frs.RevisionNumber,
    frs.OrderQuantity,
    frs.UnitPrice,
    frs.ExtendedAmount,
    frs.UnitPriceDiscountPct,
    frs.DiscountAmount,
    frs.ProductStandardCost,
    frs.TotalProductCost,
    frs.SalesAmount,
    frs.TaxAmt,
    frs.Freight,
    frs.CarrierTrackingNumber,
    frs.CustomerPONumber,
    frs.OrderDate,
    frs.DueDate,
    frs.ShipDate,
    frs.EmployeeKey,
    'ResellerSales' AS Source
FROM dbo.FactResellerSales frs
LEFT JOIN dbo.DimProduct dp
    ON frs.ProductKey = dp.ProductKey
)
SELECT
    EnglishProductName,
    --Source,
    SUM(SalesAmount) AS TotalSales
FROM AllSales sales
GROUP BY 
    sales.EnglishProductName 
    --,sales.Source
ORDER BY 
    sales.EnglishProductName 
    --,sales.Source