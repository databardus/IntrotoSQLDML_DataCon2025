USE AdventureWorks;
GO

-- Ensure the database is in a consistent state before starting
-- Revert any changes made by this script
DELETE FROM Person.Person WHERE LastName = 'Doe' AND FirstName = 'John';
UPDATE Person.Person SET EmailPromotion = 0 WHERE BusinessEntityID = 1;

-- SELECT Statement Example
-- Retrieve data from the Person.Person table
SELECT TOP 1 BusinessEntityID, FirstName, LastName, EmailPromotion
FROM Person.Person;

-- INSERT Statement Example
-- Insert a new record into the Person.Person table
INSERT INTO Person.Person (BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, EmailPromotion)
VALUES (20778, 'EM', 0, NULL, 'John', NULL, 'Doe', NULL, 0);

-- Reverse the INSERT Statement
-- Delete the record that was just inserted
DELETE FROM Person.Person WHERE LastName = 'Doe' AND FirstName = 'John';

-- UPDATE Statement Example
-- Update the EmailPromotion field for a specific record
UPDATE Person.Person
SET EmailPromotion = 1
WHERE BusinessEntityID = 1;

-- Reverse the UPDATE Statement
-- Revert the EmailPromotion field to its original value
UPDATE Person.Person
SET EmailPromotion = 0
WHERE BusinessEntityID = 1;

-- DELETE Statement Example
-- Delete a record from the Person.Person table
-- (For demonstration purposes, we will reinsert the record after deletion)
INSERT INTO Person.Person (BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, EmailPromotion)
VALUES (20779, 'EM', 0, NULL, 'Jane', NULL, 'Smith', NULL, 0);

DELETE FROM Person.Person WHERE LastName = 'Smith' AND FirstName = 'Jane';

-- Reverse the DELETE Statement
-- Reinsert the record that was just deleted
INSERT INTO Person.Person (BusinessEntityID, PersonType, NameStyle, Title, FirstName, MiddleName, LastName, Suffix, EmailPromotion)
VALUES (20779, 'EM', 0, NULL, 'Jane', NULL, 'Smith', NULL, 0);

-- Ensure the database is in a consistent state at the end
DELETE FROM Person.Person WHERE LastName = 'Doe' AND FirstName = 'John';
DELETE FROM Person.Person WHERE LastName = 'Smith' AND FirstName = 'Jane';
UPDATE Person.Person SET EmailPromotion = 0 WHERE BusinessEntityID = 1;
GO