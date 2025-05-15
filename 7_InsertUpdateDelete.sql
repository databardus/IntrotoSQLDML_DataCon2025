/*---------------------------------------------------

    Module: From SELECT to INSERT, UPDATE, DELETE

---------------------------------------------------*/

/*
    So much of what we've covered has been about SELECT statements.
    Now we have just one module for INSERT, UPDATE, and DELETE statements?

    Why? Two reasons:
    1. Because our knowledge of SELECT statements impacts everything we can do with INSERT, UPDATE, and DELETE.
    2. Changing a SELECT statement to an INSERT, UPDATE, or DELETE statement is as simple as changing the first clause of the statement.

    Let's showcase this with a few examples.
*/

/*

    First, as a best practice, before we write an INSERT, UPDATE, or DELETE statement, 
    we should always start with a SELECT statement.
    This allows us to see the data we are working with and ensure we are not making any mistakes.

*/

--First, let's write a SELECT statement to identify a record we want to create.
SELECT 
    20778 AS EmployeeKey, 
    NULL AS ParentEmployeeKey, 
    'Weird Al' AS FirstName, 
    'Yankovic' AS LastName, 
    'Musid Legend' AS Title, 
    GETDATE() AS HireDate, 
    '1959-10-23' AS BirthDate, 
    'weirdal.yankovic@example.com' AS EmailAddress, 
    '555-123-4567' AS Phone, 
    'M' AS MaritalStatus, 
    'M' AS Gender, 
    2 AS PayFrequency, 
    60000 AS BaseRate;

/*------------------------------------
    INSERT Statement
------------------------------------*/
/*
    An insert statement is used to create a new record (or records) in a table.

    To change our SELECT statement to an INSERT statement, 
    we add an INSERT INTO clause in front of our SELECT clause.
    The INSERT INTO clause takes two parameters:
    1. The table we are inserting into
    2. The columns we are inserting into (does not have to be all columns)

    Now, let's write an INSERT statement to create a new record in the DimEmployee table
    using our SELECT statement above.

*/
INSERT INTO DimEmployee -- This is the table we are inserting into
(
    EmployeeKey, --These are the columns we are inserting into
    ParentEmployeeKey, 
    FirstName, 
    LastName, 
    Title, 
    HireDate, 
    BirthDate, 
    EmailAddress, 
    Phone, 
    MaritalStatus, 
    Gender, 
    PayFrequency, 
    BaseRate
)
SELECT 
    20778 AS EmployeeKey, --Note: Our Select statement columns need to match the order of the columns above
    NULL AS ParentEmployeeKey, 
    'Weird Al' AS FirstName, 
    'Yankovic' AS LastName, 
    'Musid Legend' AS Title, 
    GETDATE() AS HireDate, 
    '1959-10-23' AS BirthDate, 
    'weirdal.yankovic@example.com' AS EmailAddress, 
    '555-123-4567' AS Phone, 
    'M' AS MaritalStatus, 
    'M' AS Gender, 
    2 AS PayFrequency, 
    60000 AS BaseRate;
    --Since we are manually specifying the values, we don't need to use any other clauses (WHERE, ORDER BY, etc.)
    --However, as long as the columns in SELECT match the columns in INSERT, 
    --we can use as many clauses as we want!


/*

    Additional Notes:
    - The aliases in the SELECT statement are not necessary for the INSERT statement. The order is all that matters.
    - You can insert one to many records. Whatever is returned in the SELECT statement will be inserted into the table.
    - You can source data from as many tables as you want, as long as the columns match.
    - You can also use a WHERE clause to filter the data you want to insert.

*/

-- Now let's write a SELECT statement to see the data we just inserted.
SELECT 
    BusinessEntityID, 
    PersonType, 
    NameStyle, 
    Title, 
    FirstName, 
    MiddleName, 
    LastName, 
    Suffix, 
    EmailPromotion
FROM DimEmployee
WHERE BusinessEntityID = 20778;

/*---------------------------------------
    UPDATE Statement
---------------------------------------*/

-- To update Weird Al, we replace the SELECT clause with an UPDATE clause
UPDATE de --UPDATE defines the table we are updating, either by alias or full name
    SET Pay = 6000000 --SET defines the columns we are updating (comma separated)
FROM DimEmployee de
WHERE BusinessEntityID = 20778; --WHERE defines the records we are updating

--Like the INSERT statement, we can use as many clauses as we want in the UPDATE statement.
--Also like the INSERT statement, we can only modify a single table at a time.

--Running the SELECT statement again will show the updated data

/*---------------------------------------
    DELETE Statement
---------------------------------------*/

--For the final statement, we will delete Weird Al from the DimEmployee table.
--The syntax for a DELETE statement is simple: replace the SELECT clause with DELETE
DELETE --If this query contains joins, you will need to specify which table you are deleting from here 
FROM DimEmployee
WHERE BusinessEntityID = 20778; --Bye bye, Weird Al!
--I'm deleting using the BusinessEntityID, but you can use any column in the WHERE clause
--to identify the record(s) you want to delete.
--Just be careful with your WHERE clause, as this will delete all records that match the criteria!
--This is why we always start with a SELECT statement to identify the records 
--we want to delete before deleting them.

--Running the SELECT statement again will show that Weird Al has been deleted.

/*------------------------------------

    Module Summary
    - INSERT, UPDATE, and DELETE statements are used to create, modify, and delete records in a table.
    - They are all derived from the SELECT statement, with the first clause changed to INSERT, UPDATE, or DELETE.
    - As a best practice, always start with a SELECT statement to identify the records you want 
      to create, modify, or delete.

------------------------------------*/