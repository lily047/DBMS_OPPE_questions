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

