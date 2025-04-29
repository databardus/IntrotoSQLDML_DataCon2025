/*----------------------------------------------------------------------------


    Module 3: Introducing Joins

----------------------------------------------------------------------------*/

/*
	Teacher's goals for Module
	-Define what a Join is and its importance in SQL
	-Identify its reliance on Boolean logic like WHERE clauses
	-Define the 4 basic forms of a Join, broken into Inner and Outer
	-Showcase various scenarios where INNER and LEFT JOINS are helpful
*/


/*

    Databases, by design, are relational models. This means that data (i.e. column) is organized into groups, and these groupings become mathematical relations, or tables as we commonly reference them.
    Up to now we've only focused on single-table queries. But the true power of SQL lies in its ability to navigate and make use of the relationships in a database to query multiple tables at the same time.
    This is accomplished with one of the most important keywords in the SQL language: JOIN, which joins tables together.

	A JOIN, in simple terms, is an attempt to connect two tables together. The goal is for records in one table to find connected records in a second table.
	By successfully joining tables, records from both tables are combined into one wider record containing the columns from both tables.
  
	--Another analogy: Imagine each table is a lego piece, and each record in a table is a nub on a Lego piece. Each nub has a number associated to another lego piece.
	--				   Your goal in a join is to line up the lego piece to connect by matching numbers on both lego pieces
	--                 For each lego, The Join criteria defines which lego piece I want to connect to, as well as which knob on the Lego I can connect to

	How do JOINS work? An example would be the easiest way to explain.
*/


	--This query will be used to explain Joins, as well as a few other concepts.
	SELECT DP.EnglishProductName, FIS.ProductKey, FIS.OrderDate, FIS.SalesAmount
	FROM dbo.FactInternetSales FIS
	INNER JOIN dbo.DimProduct DP
		ON FIS.ProductKey = DP.ProductKey
	WHERE FIS.ProductKey > 300
	--GROUP BY ProductKey, OrderDate
	--HAVING SUM(SalesAmount) > 10000
	ORDER BY FIS.ProductKey

	----SELECT *--FIS.*, DP.*
	----FROM dbo.FactInternetSales FIS
	----INNER JOIN dbo.DimProduct DP
	----	ON FIS.ProductKey = DP.ProductKey

/*	--JOIN syntax
	
	JOIN criteria is two-part. 
	--First, define the table we're joining to and the join form. 
	--Second, define a predicate identifying how we get a successful join into the table defined in the join
	--Think of it as a WHERE clause, but successful/failed joins determine whether we find a record to join to instead of whether a record is filtered out (though in the case of inner joins, both occur).

    JOIN can take one of 4 forms, with 2 forms being the most frequently used. These forms exists to handle the various ways we may want to join tables.
    To understand the variations of JOINs, Imagine a Venn diagram with two intersecting circles, where each circle contains all records from a table (Table A on the left, Table B on the right). For a given record in these tables, this gives you 4 possible outcomes of where the record exists. These outcomes define the 4 forms.
    The 4 forms are:
    -Inner Join: A record exists in both Table A and Table B
    -Left Outer Join: A record is in Table A, but not Table B
    -Right Outer Join: A record is in Table B, but not Table A
    -Full Outer Join: A record is either in Table A, Table B, or Both. No matter what, we want records from both table

	--Things we can observe
	--First, what columns can be returned by a successful join?
	--Since this query returns all (*) columns from both tables identified, I can return all columns from both tables
	--I can pick any subset of columns from the two tables

	--Second, what records are/are not returned?
	--As an inner join, we only see records when content exists for both tables. The rest are filtered out.
	--If this were a left join and some records didn't find matches, the records remain, and the columns from the join table return NULLs

	--Third, how do we know which columns to use in join criteria?
	--Talk to whoever designed your data model
	--Most times the model will define 'Key' columns that simplify joins between tables (i.e. this model has ProductKey in both tables). But we can use any column in tables to perform joins.
	--Many data models will use the same name for columns that are meant to join

	--Fourth, table aliases
	--In this example, I created an alias for both tables that are being joined.
	--As a best practice, this is encouraged so your code is easier to read. We'll dig into this further in the Formatting section
*/

	--So how would other joins differ?
	--Let's test out a LEFT JOIN (Note: This model enforces high quality data rules, which means most left joins won't differ. We're adding in an extra clause to show what a left join looks like, but it's not that effective)

	SELECT *--FIS.*, DR.*
	FROM dbo.FactInternetSales FIS
	LEFT JOIN dbo.DimProduct DR
		ON FIS.ProductKey = DR.ProductKey
		AND DR.ProductKey <> 372
	WHERE FIS.ProductKey = 372

	--Viewing the query results, you can see that any columns returned from the Product table are NULL. 
	--This indicates that the join for this record failed. 
	--However, since this is a left join, we still return the record

	--RIGHT JOINs are logically equivalent to left joins. Here's proof
	SELECT *--FIS.*, DR.*
	FROM dbo.FactInternetSales FIS
	RIGHT JOIN dbo.DimProduct DR
		ON FIS.ProductKey = DR.ProductKey
		AND FIS.ProductKey <> 372
	WHERE DR.ProductKey = 372

	--In this case, the success/failure of the join is enforced the same. 
	--Since Product is on the 'right' (i.e. It is the table being joined to the FROM table), we only see the one record for the product.
	--We could make a further adjustment to make it return the same results as the left join.
	--Most times, structuring queries with LEFT JOINs logically makes more sense. 
	--Start with the table you always want records from, then LEFT JOIN tables in that may/may not have supplemental data

	--If we take the results from our left and right joins, we can combine them to get our FULL OUTER JOIN results

	SELECT Top 1000 *--FIS.*, DR.*
	FROM dbo.FactInternetSales FIS
	FULL OUTER JOIN dbo.DimProduct DR
		ON FIS.ProductKey = DR.ProductKey
		AND DR.ProductKey <> 372
	--WHERE FIS.ProductKey = 372
	ORDER BY FIS.ProductKey

	--This query, being a full join, will return the following:
	--1 record for each record in FactInternetSales that does not have a matching record in DimProduct (Product columns are NULL)
	--1 record for each record in DimProduct that does not have a matching record in FactInternetSales (InternetSales columns are NULL)
	--1 record for each record in FactInternetSales that has a matching DimProduct record (All column can return values)

	--Which join do you use when? It depends on your reporting scenarios.
	--Take this scenario, for example.
	--Use INNER JOINs when you're only focused on Products that have Internet Sales
	--Use LEFT JOINs when you are interested InternetSales for a Product that isn't defined (or want to identify products that have no InternetSales yet!)
	--Use FULL OUTER JOINs when you want all scenarios mentioned above.


	--Other useful tips for using joins
	--As you saw in the scenarios above, your JOIN criteria does not always have to compare columns between the tables.
		--You can compare one table's columns to a value (or variable).
		--In an INNER JOIN, this functions the same as a WHERE clause.
		--In a LEFT JOIN, the join only succeeds if the criteria is met.
		----This technique is especially useful if you are joining to a 'roleplaying' table.
	--It is possible to join to a table multiple times. This is usually helpful in scenarios involving roleplaying tables (i.e. Date)

	--Table joins are one of the foundational components in the SQL language. This is how we make use of relationships in a model.

	--SQL Table joins are not limited to joining two tables together. You can join multiple tables at the same time
	--For example, you can join multiple tables to the base table, provided the appropriate join columns exist
	SELECT *--FIS.*, DR.*
	FROM dbo.FactInternetSales FIS
	INNER JOIN dbo.DimProduct DP
		ON FIS.ProductKey = DP.ProductKey --Joining to Key on the table in the FROM statement
	INNER JOIN dbo.DimPromotion DPR
		ON FIS.PromotionKey = DPR.PromotionKey --Joining to Key on the table in the FROM statement

	--You can also join a table by using columns from a previously joined table
	SELECT *--FIS.*, DR.*
	FROM dbo.FactInternetSales FIS
	INNER JOIN dbo.DimProduct DP
		ON FIS.ProductKey = DP.ProductKey --Joining to Key on the table in the FROM statement
	INNER JOIN dbo.DimProductSubcategory DPS
		ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey --Joining to Key on the table from the previous INNER JOIN statement
	INNER JOIN dbo.DimProductCategory DPC
		ON DPS.ProductCategoryKey = DPC.ProductCategoryKey --Joining to Key on the table from the previous INNER JOIN statement

	--These are all INNER JOINs in this example, but any of these joins can be other forms of JOINs
