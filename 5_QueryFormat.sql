/* -----------------------------------------------------

    Modul 5: Query Formatting

----------------------------------------------------------*/
/*
	Teacher's goals for Module
	-Establish why query formatting is important
	-Showcase an approach to formatting queries and explain why
*/

/*

    As with most thing we write, always assume that someday, someone other than you will want to read a query you wrote.
    This can be when you need assistance writing a complicated query, or if someone else can benefit from your query, but needs to know how it works.

    For these reasons, it is important to format and document your queries in a consistent way. 
    Let's take some time to discuss best practices around query formatting.

    Note: The following information are suggested best practices on how to make queries easier to read.
          This doesn't mean this is the only way to format queries. There are many approaches
          What is important is that you strive to be consistent.

	Jared's Rules for Formattting
	1. SQL Keywords should be in all caps, and nothing else
	2. Use Carriage Returns to separate clauses
	3. Use Carriage Returns for columns references in clauses, but indent them
	4. Use Carriage Returns for predicates in clauses, but indent them 
	5. Match Column Name formatting with table column names
	6. Alias your Tables and use aliases in your column references



    Topics to cover:
    -Keywords for the SQL language should be uppercase (SELECT, FROM, GROUP BY)
    -The 6 main keywords (SELECT,FROM,WHERE,GROUP BY, HAVING, ORDER BY) should be at the same level of indentation. Everything else should be indented more or less
        -Use indentation in the same way you would use it in a PowerPoint or Word document.
    -Try to keep your code formatted so you don't have to scroll sideways
    -When aliasing columns or tables, pick alias names that balance being short, but are also easy to understand (i.e. p vs. Product)
    -Especially for complex queries, document logic that speaks to how specific parts of the query work. Do not always assume that it is intuitive.
    -If you save a query somewhere, consider including the following information in your query:
        -A change log indicating when the query has been altered, by who, and what change was made
        -A description of what the query is intended to do.

*/
--To share an example, us this for Adventureworks (or create your own)
	select dp.englishproductname, fis.productkey, fis.orderdate, sum(fis.salesamount) from dbo.factinternetsales fis inner join dbo.dimproduct dp on fis.productkey = dp.productkey	where fis.productkey > 300 group by dp.englishproductname, fis.productkey, orderdate having SUM(salesamount) > 10000 order by fis.productkey

	--Let's take an example of a query that has no formatting, and format it for readability
	--Instructor note: take time to create a scenario that can be used in a lot of scenarios
	declare @productkey int = 1

	select productkey, englishproductname, productalternatekey, productalternatekey, weightunitmeasurecode, sizeunitmeasurecode from dbo.dimproduct where productkey = @productkey order by 6

	--Not the easiest to read for a few reasons. Let's clean this up step by step
	--First, it is helpful to upppercase all references to SQL keywords (SELECT, FROM, WHERE, etc.). Since they are always in the same 

	SELECT productkey, englishproductname, productalternatekey, productalternatekey, weightunitmeasurecode, sizeunitmeasurecode FROM dbo.dimproduct WHERE productkey = @productkey ORDER BY 6

	--Next, indentation is important. Start with the same SQL keywords

	SELECT productkey, englishproductname, productalternatekey, productalternatekey, weightunitmeasurecode, sizeunitmeasurecode 
	FROM dbo.dimproduct 
	WHERE productkey = @productkey 
	ORDER BY 6

	--Then do the same for column names, but further indented in
	SELECT 
		productkey, 
		englishproductname, 
		productalternatekey, 
		--productalternatekey, 
		weightunitmeasurecode, 
		sizeunitmeasurecode 
	FROM dbo.dimproduct 
	WHERE 
		productkey = @productkey 
	ORDER BY 6

	--Depending on the formatting of the column names in the table, consider either matching the formatting of the table, or camel casing for readability
	SELECT 
		ProductKey, 
		EnglishProductName, 
		ProductAlternateKey, 
		ProductAlternateKey, 
		WeightUnitMeasureCode, 
		SizeUnitMeasureCode 
	FROM dbo.DimProduct
	WHERE 
		ProductKey = @ProductKey 
	ORDER BY 6


	--While it is functional in this state, adding an alias to the table and using the alias for the tables would be more specific
	--It is also reduces the necessary adjustments should you ever add in joins 
	SELECT 
		dp.ProductKey, 
		dp.EnglishProductName, 
		dp.ProductAlternateKey, 
		dp.ProductAlternateKey, 
		dp.WeightUnitMeasureCode, 
		dp.SizeUnitMeasureCode 
	FROM dbo.dimproduct dp
	WHERE 
		productkey = @productkey 
	ORDER BY 6

	--Now, suppose I want to add a Join to this query. I can do the following:
	SELECT 
		dp.ProductKey, 
		dp.EnglishProductName, 
		dp.ProductAlternateKey, 
		dp.ProductAlternateKey, 
		dp.WeightUnitMeasureCode, 
		dp.SizeUnitMeasureCode, 
		FIS.SalesOrderNumber,
		FIS.OrderDate
	FROM dbo.dimproduct dp
	INNER JOIN dbo.FactInternetSales FIS
		ON dp.ProductKey = FIS.ProductKey
	WHERE productkey = @productkey 
	ORDER BY 6

	declare @productkey int = 1

/*	
	Note the error I had to resolve in the WHERE clause. Since ProductKey isn't aliased and both DimProduct and FactInternetSales have a column named ProductKey, we get an error that it is ambiguous.
	Adding an alias resolves the error.
*/
	SELECT 
		dp.ProductKey, 
		dp.EnglishProductName, 
		dp.ProductAlternateKey, 
		dp.ProductAlternateKey, 
		dp.WeightUnitMeasureCode, 
		dp.SizeUnitMeasureCode 
		FIS.SalesOrderNumber,
		FIS.OrderDate
	FROM dbo.dimproduct dp
	INNER JOIN dbo.FactInternetSales FIS
		ON dp.ProductKey = FIS.ProductKey
	WHERE dp.productkey = @productkey 
	ORDER BY 6

/*	
	So if we don't use table aliases, what does this query look like?
	Since most of the columns are uniquely named, we technically don't need aliases. However, for ProductKey, we do need an alias
	When no alias is defined and you need to define the productkey, the table's name must be used instead.
	It would then look like this at a minimum:
*/
	SELECT 
		dimproduct.ProductKey, 
		EnglishProductName, 
		ProductAlternateKey, 
		ProductAlternateKey, 
		WeightUnitMeasureCode, 
		SizeUnitMeasureCode 
		SalesOrderNumber,
		OrderDate
	FROM dbo.dimproduct
	INNER JOIN dbo.FactInternetSales
		ON dimproduct.ProductKey = FactInternetSales.ProductKey
	WHERE dimProduct.productkey = @productkey 
	ORDER BY 6

	--So without the table aliases, the full table name needs to be referenced at
	--  The join clause criteria
	--  Column References in SELECT/WHERE/GROUP BY/HAVING clauses where the column name is not unique
