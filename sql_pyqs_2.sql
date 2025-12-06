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
/*
Write a SQL statement to find out the number of students who have studied in each building from 2005 till 2008 (including 2005, 2008).
*/
SELECT  COUNT(DISTINCT s.id ), se.building,
FROM student s 
JOIN takes t ON s.id = t.id
JOIN section se ON t.course_id = se.course_id AND t.sec_id = se.sec_id AND t.semester = se.semester AND t.year = se.year
WHERE se.year >=2005 AND se.year <= 2008
GROUP BY  se.building
-- MY mistake: when there are multiple primary keys in a table, join using all of them. 

/*
Let D be the set of all departments whose average salary is more than the maximum salary of 'Psychology' department. Write a SQL statement to find the name and salary of the instructor(s) who has/have the maximum salary in each department in D.
*/
SELECT i.name, i.salary 
FROM (
SELECT dept_name, AVG(SALARY) AS avg_salary
FROM instructor 
GROUP BY dept_name
HAVING AVG(SALARY) > (
    SELECT MAX(salary)
    FROM instructor 
    WHERE dept_name = 'Psychology'
)) AS a
JOIN instructor i ON i.dept_name = a.dept_name
WHERE i.salary = (
  SELECT MAX(SALARY)
  FROM instructor i2
  WHERE i2.dept_name = i.dept_name
) --optimize this query later on 

/*
Write a SQL statement to find out the number of courses which have been taught in Fall semester but never in Spring semester.
*/
WITH fall_only_courses AS (SELECT DISTINCT s.course_id
FROM section s JOIN course c ON c.course_id = s.course_id
WHERE semester = 'Fall'
EXCEPT 
SELECT DISTINCT s.course_id
FROM section s JOIN course c ON c.course_id = s.course_id
WHERE semester = 'Spring' )

SELECT COUNT( DISTINCT c.course_id )
FROM course c
JOIN fall_only_courses foc ON c.course_id = foc.course_id

--- i complicated shit
--easier version:
SELECT COUNT (DISTINCT course_id )
FROM section 
WHERE semester = 'Fall'
AND course_id NOT IN (
  SELECT course_id 
  FROM section 
  WHERE semester = 'Spring'
)

/*
Print name,id,num count of instructor(s) who has taught maximum number of classes on the day 'W'. (num count is the number of the classes they took on day 'W'.)
*/

WITH temp_table (iid, count_of_instrs) AS (SELECT i.id, COUNT(*) AS num_count_of_instructors
FROM instructor i
JOIN teaches t ON t.id = i.id 
JOIN section s ON s.course_id = t.course_id AND s.sec_id = t.sec_id AND t.semester= s.semester AND t.year = s.year 
JOIN time_slot ts ON s.time_slot_id = ts.time_slot_id
WHERE ts.day = 'W'
GROUP BY i.id
ORDER BY COUNT(*)  DESC
)

SELECT  i.name,i.id, tt.count_of_instrs
FROM  temp_table tt JOIN instructor i ON i.id = tt.iid
WHERE tt.count_of_instrs >= ALL (
  SELECT count_of_instrs 
  FROM temp_table 
)

