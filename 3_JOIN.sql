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

	--Let's start with a simple example of a CROSS JOIN, which is not commonly used in practice.
	--Hoiwever, it is a good way to show how joins work.
	SELECT *
	FROM DimProduct AS A --Becomes the 'Left' table of our join
	CROSS JOIN DimProductSubcategory AS B --Becomes the 'Right' table of our join
	--Notice that we do not have an ON clause in a CROSS JOIN. 
	--This is because every record in the first table is combined with every record in the second table.

/*	--JOIN syntax
	
	JOIN criteria is two-part. 
	--First, define the table we're joining to and the join form. 
	--Second, define a predicate identifying how we get a successful join into the table defined in the join
	--	NOTE: The second clause applies to every join except CROSS
	--Think of a JOIN as a WHERE clause, but successful/failed joins determine whether we find a record to join to instead of whether a record is filtered out (though in the case of inner joins, both occur).

    JOIN can take one of 5 forms, with 2 forms being the most frequently used. These forms exists to handle the various ways we may want to join tables.
    To understand the variations of JOINs, Imagine a Venn diagram with two Lego bricks, 
	where each brick contains all records from a table (Table A on the left, Table B on the right). 
	For a given record in these tables, this gives you 5 possible outcomes of where the record exists. 
	These outcomes define the 5 forms.
    The 5 forms are:
	-Cross Join: Every combination of records from A and B, regardless of logical commonality.
    -Full Outer Join: A record is either in Table A, Table B, or Both. No matter what, we want records from both table
    -Left Outer Join: A record is in Table A, but not Table B
    -Right Outer Join: A record is in Table B, but not Table A
    -Inner Join: A record exists in both Table A and Table B

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

	--Alright, so CROSS JOINS aren't very useful because the matching records can have nothing in common.
	--Can we narrow the results down to something more useful?
	--Let's take a step to reduce our results using a FULL JOIN.
	SELECT *
	FROM DimProduct AS A --Becomes the 'Left' table of our join
	FULL JOIN DimProductSubcategory AS B --Becomes the 'Right' table of our join
		ON A.ProductSubcategoryKey = B.ProductSubcategoryKey
	ORDER BY A.ProductKey

	--The above query is a FULL JOIN, which means we will return all records from both tables
	--at least once, regardless of whether the predicate succeeds.
	--The next join that is more specific is a LEFT JOIN.
	--A LEFT JOIN preserves all records from the 'left' table, but removes records from the right that have no match.
	SELECT *
	FROM DimProduct AS A --Becomes the 'Left' table of our join
	LEFT JOIN DimProductSubcategory AS B --Becomes the 'Right' table of our join
		ON A.ProductSubcategoryKey = B.ProductSubcategoryKey
	ORDER BY A.ProductKey

	--A RIGHT JOIN accomplishes the same thing as a LEFT JOIN, but the roles of the two tables are reversed.

	--Then finally, the most common join is an INNER JOIN, which only returns records that have a match in both tables.
	SELECT *
	FROM DimProduct AS A --Becomes the 'Left' table of our join
	INNER JOIN DimProductSubcategory AS B --Becomes the 'Right' table of our join
		ON A.ProductSubcategoryKey = B.ProductSubcategoryKey
	--WHERE A.ProductKey IS NOT NULL OR B.ProductSubcategoryKey IS NOT NULL
	ORDER BY A.ProductKey

	/*
		What if I want to join to more than one table?
		Define multiple join clauses with their own predicates
		Think of it as joining two tables first, then another table after the first two join.
		While functionally it all happens at the same time, 
		you can build joins to tens of hundreds of tables
		by joining them one at a time
	*/
	SELECT
		A.ProductKey,
		A.ProductSubcategoryKey AS AProductSubcategoryKey,
		B.ProductSubcategoryKey AS BProductSubcategoryKey,
		B.ProductCategoryKey AS BProductCategoryKey,
		C.ProductCategoryKey AS CProductCategoryKey,
		A.EnglishProductName,
		B.ProductSubcategoryName,
		C.ProductCategoryName
	FROM DimProduct AS A
	LEFT JOIN DimProductSubcategory AS B
		ON A.ProductSubcategoryKey = B.ProductSubcategoryKey
	--Joining another table to what we have
	LEFT JOIN DimProductCategory AS C
		ON B.ProductCategoryKey = C.ProductCategoryKey

	--Can you join at table to itself? Yes, you can!
	SELECT 
		eh.EmployeeID,
		eh.EmployeeFirstName,
		eh.EmployeeLastName,
		m.FirstName AS ManagerFirstName,
		m.LastName AS ManagerLastName
	FROM 
		DimEmployee eh
	LEFT JOIN 
		DimEmployee m ON eh.ManagerID = m.EmployeeKey


/* Here are additional examples using different tables */

	--This query will be used to explain Joins, as well as a few other concepts.
	SELECT DP.EnglishProductName, FIS.ProductKey, FIS.OrderDate, FIS.SalesAmount
	FROM dbo.FactInternetSales FIS
	INNER JOIN dbo.DimProduct DP
		ON FIS.ProductKey = DP.ProductKey
	WHERE FIS.ProductKey > 300
	--GROUP BY ProductKey, OrderDate
	--HAVING SUM(SalesAmount) > 10000
	ORDER BY FIS.ProductKey

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

	--One important note on formatting. Aliasing your tables in join is important to keep your code clean
	--Let's revisit a query earlier that returns data from 3 tables
	SELECT
		A.ProductKey,
		A.ProductSubcategoryKey AS AProductSubcategoryKey,
		B.ProductSubcategoryKey AS BProductSubcategoryKey,
		B.ProductCategoryKey AS BProductCategoryKey,
		C.ProductCategoryKey AS CProductCategoryKey,
		A.EnglishProductName,
		B.ProductSubcategoryName,
		C.ProductCategoryName
	FROM DimProduct AS A
	LEFT JOIN DimProductSubcategory AS B
		ON A.ProductSubcategoryKey = B.ProductSubcategoryKey
	LEFT JOIN DimProductCategory AS C
		ON B.ProductCategoryKey = C.ProductCategoryKey

	/*
		Notice how the column names exist in multiple tables.
		For this query to work, I have to reference something that identifies which table it
		is coming from.
		I do that with the prefix, which references the table alias.
		The table alias keeps the code cleaner.

		To prove the point, here's the same query that does not use table aliases.
	*/

	-- Created by Copilot in SSMS - review carefully before executing
SELECT
  DimProduct.ProductKey,
  DimProduct.ProductSubcategoryKey AS AProductSubcategoryKey,
  DimProductSubcategory.ProductSubcategoryKey AS BProductSubcategoryKey,
  DimProductSubcategory.ProductCategoryKey AS BProductCategoryKey,
  DimProductCategory.ProductCategoryKey AS CProductCategoryKey,
  DimProduct.EnglishProductName,
  DimProductSubcategory.ProductSubcategoryName,
  DimProductCategory.ProductCategoryName
FROM DimProduct
LEFT JOIN DimProductSubcategory
  ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
LEFT JOIN DimProductCategory
  ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey;

/*

	Module Summary
	-Table joins make use of the relationships in a database to query multiple tables at the same time
	-Different joins determine what happens to records that do not have a match in the other table
	-Remember Legos - Each table is a lego piece, and legos can be connected in various ways
	-Joins are only limited by the data tables have in common.

*/
