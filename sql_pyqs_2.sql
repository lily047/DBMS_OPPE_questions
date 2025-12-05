/*
Write an SQL query to find the match dates where the host team score is not between 1 and 4.
*/
SELECT match_date
FROM matches 
WHERE NOT (host_team_score >= 1 AND host_team_score <= 4)

/*
Write a SQL statement to find the player name, jersey no of player and team
name of players who played for teams that hosted matches in 2020 and also had a
jersey number less than 10.
*/
SELECT DISTINCT p.name, p.jersey_no, t.name
FROM players p 
JOIN teams t ON p.team_id = t.team_id 
JOIN matches m ON m.host_team_id = t.team_id 
WHERE m.match_date BETWEEN '2020-01-01' AND '2020-12-31' AND p.jersey_no <10

--ALT CODE 
  SELECT DISTINCT p.name, p.jersey_no, t.name
FROM players p 
JOIN teams t ON p.team_id = t.team_id 
JOIN matches m ON m.host_team_id = t.team_id 
WHERE EXTRACT (year FROM m.match_date) = 2020
AND p.jersey_no < 10

/*
Write a SQL statement to find the titles of books issued by students from the
'Mechanical Engineering' department.
*/
SELECT ca.title 
FROM book_catalogue ca 
JOIN book_copies co ON co.ISBN_no = ca.ISBN_no 
JOIN book_issue i ON i.accession_no = co.accession_no 
JOIN members m ON m.member_no = i.member_no 
JOIN students s ON s.roll_no = m.roll_no 
JOIN departments d ON s.department_code = d.department_code 
WHERE d.department_name = 'Mechanical Engineering'
--ALT code 
SELECT ca.title 
FROM book_catalogue ca 
WHERE EXISTS (
  SELECT 1
  FROM book_copies CO
  JOIN book_issue i ON i.accession_no = co.accession_no 
  JOIN members m ON m.member_no = i.member_no 
  JOIN students s ON s.roll_no = m.roll_no 
  JOIN departments d ON s.department_code = d.department_code 
  WHERE d.department_name = 'Mechanical Engineering' AND co.ISBN_no = ca.ISBN_NO 
)
-- the second one only checks where there exists a record satisfying those conditions, the og query extracts all the data

/*
Write an SQL query to find the number of distinct titles of books issued by the
students whose first name starts with 'S' for each department name. Display the
department name and number of books.
*/
SELECT d.department_name, COUNT(DISTINCT ca.title)
FROM students s
JOIN departments d ON s.department_code = d.department_code
JOIN members m ON s.roll_no = m.roll_no 
JOIN book_issue i ON i.member_no = m.member_no 
JOIN book_copies c ON c.accession_no =i.accession_no 
JOIN book_catalogue ca ON ca.ISBN_no = c.ISBN_no
WHERE s.student_fname LIKE 'S%'
GROUP BY d.department_code

/*
Find the first names and last names of authors, having the author's first name as a single character.
*/
SELECT author_fname, author_lname 
FROM book_authors 
WHERE LENGTH(author_fname) = 1

/*
Find out the total number of members in the UG with alias name or column header as 'total member'.
*/
SELECT COUNT(*) AS "total member"
FROM students s JOIN members m ON s.roll_no = m.roll_no 
WHERE m.member_type = 'UG'
-- column name should always be in "" ; single quotes throw an error

/*
Find the first names and last names of the students whose birthday is in May 2002 or in May 2003.
*/
SELECT student_fname, student_lname 
FROM students 
WHERE (dob BETWEEN '2002-05-01' AND '2002-05-31')
   OR (dob BETWEEN '2003-05-01' AND '2003-05-31');

--ALT CODE 
SELECT student_fname, student_lname 
FROM students 
WHERE MONTH(dob) = 5 
  AND YEAR(dob) IN (2002, 2003);

--ALT CODE 
SELECT student_fname, student_lname 
FROM students 
WHERE EXTRACT(MONTH FROM dob) = 5 
  AND EXTRACT(YEAR FROM dob) IN (2002, 2003);

/*
Find details of those instructors of the Accounting department who have more salary than at least one instructor of the Psychology department.
*/
SELECT *
FROM instructor i1 
WHERE i1.dept_name ='Accounting' AND i1.salary >(
  SELECT MIN(i2.salary)
  FROM instructor i2
  WHERE i2.dept_name = 'Psychology'
)

/*
Find the name of the teams which belong to the same city as the team 'Amigos'.
*/
SELECT t1.name 
FROM teams t1 
WHERE t1.name <> 'Amigos' AND t1.city = (
  SELECT t2.city 
  FROM teams t2 
  WHERE t2.name = 'Amigos'
  )
/*
Find out the name of courses which have been taught in both Fall semester and Spring semester.
*/

SELECT title 
FROM course 
WHERE course_id IN (
  (SELECT c.course_id 
  FROM course c JOIN teaches t ON t.course_id = c.course_id 
  WHERE t.semester = 'Fall')
  INTERSECT
  (SELECT c.course_id  
  FROM course c JOIN teaches t ON t.course_id = c.course_id 
  WHERE t.semester = 'Spring')
)

--MY OG query:
(SELECT c.title
FROM course c JOIN teaches t ON t.course_id = c.course_id 
WHERE t.semester = 'Fall')
INTERSECT
(SELECT c.title 
FROM course c JOIN teaches t ON t.course_id = c.course_id 
WHERE t.semester = 'Spring')
/*
Query 2 returns:  Titles that appear in BOTH Fall AND Spring
Problem: If two different courses have the same title, this could give unexpected results.

Query1 **Returns:** Titles of courses (by ID) that are taught in BOTH Fall AND Spring
**Better:** Uses unique identifier (course_id) to find specific courses

## Key Difference: When Titles Duplicate

### Example Scenario:
```
Courses:
course_id | title
----------|------------------
CS101     | Intro to Programming
CS102     | Intro to Programming  (same title, different course!)
MATH201   | Calculus

Teaches:
course_id | semester
----------|----------
CS101     | Fall
CS102     | Spring
MATH201   | Fall
MATH201   | Spring
```

### Query 1 Result:
```
title
------------------
Intro to Programming  ← Found because title exists in both semesters (even though different courses!)
Calculus
```

### Query 2 Result:
```
title
------------------
Calculus  ← Only this, because only MATH201 (same course_id) is in both semesters

*/
