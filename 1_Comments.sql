/*----------------------------------------------------------------------------

	Module 1: Before You Code, Comment

----------------------------------------------------------------------------*/
/*
	Goals for Module 1
	-Single line comments
	-Multi-line comments
	-Importance of documenting what you write
*/
--First thing to know about SQL is that there are two ways to write comments in SQL code.

--Single-line comments start with double dashes (--), allowing you to write a comment in a single line.
    This line will cause an error because there is no comment marker before it

	SELECT 1 --Single line comments written on the same line as code works, as long as your code is before the double dash

/*Multi-line comments require a combination of forward slash and asterisks (/* to start, */ to end)*/

    /*

        As long as I keep my text between these two markings,
        I can write anything I want!

    */

/*

    What to comment?
    - The 'why' behind your code decisions for future developers (or yourself)
    - Document your code to explain complex logic or decisions
    - Things AI can't easily understand, like business rules or specific requirements

*/