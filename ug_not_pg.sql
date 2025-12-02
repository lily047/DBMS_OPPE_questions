/*
Q001lisdb: Write a SQL statement to find the unique book titles which are issued to 'PG' students but not to 'UG' students .[Database: LIS] lisdb:
*/

SELECT distinct co.title
FROM members m 
JOIN  book_issue i ON i.member_no = m.member_no 
JOIN book_copies c ON c.accession_no = i.accession_no
JOIN book_catalogue co ON co.ISBN_no = c.ISBN_no
WHERE m.member_type = 'PG'AND m.member_class = 'Student' AND NOT EXISTS ( 
			SELECT 1
			FROM book_issue i2 JOIN members m2 ON m2.member_no = i2.member_no 
			JOIN book_copies c2 ON c2.accession_no = i2.accession_no
			WHERE m2.member_type = 'UG' AND c2.ISBN_no = c.ISBN_no
)


/* Alt code: */

SELECT DISTINCT
	co.title
FROM
	members m
	JOIN book_issue i ON i.member_no = m.member_no
	JOIN book_copies c ON c.accession_no = i.accession_no
	JOIN book_catalogue co ON co.ISBN_no = c.ISBN_no
WHERE
	m.member_type = 'PG'
	AND m.member_class = 'Student'

EXCEPT ALL

SELECT DISTINCT
	co.title
FROM
	members m
	JOIN book_issue i ON i.member_no = m.member_no
	JOIN book_copies c ON c.accession_no = i.accession_no
	JOIN book_catalogue co ON co.ISBN_no = c.ISBN_no
WHERE
	m.member_type = 'UG'
	AND m.member_class = 'Student’;

