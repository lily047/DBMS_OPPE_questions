---EASY 

/*
15. Write an SQL query to find the names of users who have never placed an order
*/

SELECT
	user_name
FROM
	users u
WHERE
	NOT EXISTS (
		SELECT
			*
		FROM
			orders o
		WHERE
			o.user_id = u.user_id
	);

/*
12. Write an SQL query to find the referee_id, number of matches conducted by referee 'Tony Joseph Louis'
*/

SELECT
	referee,
	count(*)
FROM
	match_referees mr
JOIN referees r ON r.referee_id IN( mr.referee, mr.assistant_referee_1, mr.assistant_referee_2, mr.fourth_referee )
WHERE
	name = 'Tony Joseph Louis'
GROUP BY referee;

--MEDIUM AND HARD 
/*
1. Find department_code in which total number of female students is less than 7
*/
SELECT 
	d.department_code
FROM 
	departments d 
JOIN students s ON d.department_code = s.department_code 
WHERE 
	s.gender = 'F'
GROUP BY 
	d.department_code
HAVING 
	COUNT(*) <7 

/*
2. Find name and dob of oldest player
*/

SELECT
	name,
	dob
FROM
	players
ORDER BY dob
LIMIT 1;


/*
Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
The STATION table is described as follows:
*/
/*
Enter your query here.
*/
(SELECT 
    s.city , CHAR_LENGTH(s.city)
FROM 
    station s
WHERE CHAR_LENGTH(s.city) = (
    SELECT 
        MAX(CHAR_LENGTH(city ))
    FROM station 
)
ORDER BY 
    s.city 
LIMIT 1 )
UNION 
(SELECT 
    s.city, 
    CHAR_LENGTH(s.city)
FROM 
    station s
WHERE CHAR_LENGTH(s.city) = (
    SELECT 
        MIN(CHAR_LENGTH(city ))
    FROM station 
)
ORDER BY 
    s.city 
LIMIT 1 )
ORDER BY city

--ALT CODE 
/*The WITH clause in SQL is used to create a CTE (Common Table Expression).
Think of it as making a temporary result/table that you can use inside your main query.*/

WITH lengths AS (
    SELECT 
        MIN(CHAR_LENGTH(city)) AS min_len,
        MAX(CHAR_LENGTH(city)) AS max_len
    FROM station
)
(
    SELECT city, CHAR_LENGTH(city) AS len
    FROM station s
    CROSS JOIN lengths l
    WHERE CHAR_LENGTH(s.city) = l.max_len
    ORDER BY city
    LIMIT 1
)
UNION ALL
(
    SELECT city, CHAR_LENGTH(city) AS len
    FROM station s
    CROSS JOIN lengths l
    WHERE CHAR_LENGTH(s.city) = l.min_len
    ORDER BY city
    LIMIT 1
);

/*
Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
*/

--postgres does not support REGEXp, hackerrank uses MySQL 

--MySQL 
SELECT 
    DISTINCT city 
FROM 
    station 
WHERE 
    city REGEXP '^[aeiou]';

--POSTGRESSQL
SELECT 
	name 
FROM 
	teams 
WHERE 
	name  ~* '^[aeiou]'
-- * infront of the ~ makes it case insensitive 
-- !~* means does not match 
--For cities which do not strat with the vowels, add a "NOT" REGEXP 

/*
Query the list of CITY names ending with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates.
*/

--postgres does not support REGEXp, hackerrank uses MySQL 
SELECT 
    DISTINCT city 
FROM 
    station 
WHERE 
    city REGEXP '[aeiou]$';

/*
Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.
*/
/*
Enter your query here.
*/
SELECT 
    name 
FROM 
    students 
WHERE 
    marks > 75
ORDER BY 
    SUBSTRING(name, -3), 
    ID 
/*
"" throw a syntax error cuz they r not used for strings but are used for columns 
EXCEPT - removes duplicates 
EXCPET ALL - doesn't remove duplicates 
*/

/*
12. Write a SQL statement to find the player name, jersey no of player and team name of players who played for teams that hosted matches in 2020 and also had a jersey number less than 10
*/

SELECT DISTINCT
	p.name,
	jersey_no,
	t.name
FROM
	matches m
JOIN teams t ON t.team_id = m.host_team_id
JOIN players p ON p.team_id = t.team_id
WHERE
	match_date BETWEEN '2020-01-01' AND '2020-12-31' AND
	jersey_no < 10;

/*
10. Write an SQL query to retrieve the names of all teams that have won all the matches they played (means their score was always higher than the guest
team)
*/

SELECT
	name
FROM
	teams t
WHERE
	NOT EXISTS (SELECT
					*
				FROM
					matches m
				WHERE
					m.host_team_id = t.team_id AND
					m.host_team_score <= m.guest_team_score);
