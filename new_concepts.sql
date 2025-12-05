/*
Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. Output one of the following statements for each record in the table:

Equilateral: It's a triangle with  sides of equal length.
Isosceles: It's a triangle with  sides of equal length.
Scalene: It's a triangle with  sides of differing lengths.
Not A Triangle: The given values of A, B, and C don't form a triangle.
*/
SELECT 
    CASE --New shit 
        WHEN A + B <= C OR B + C <= A OR A + C <= B THEN 'Not A Triangle'
        WHEN A = B AND B = C THEN 'Equilateral'
        WHEN A <> B AND B <> C AND A <> C THEN 'Scalene'
        ELSE 'Isosceles'
    END triangle_types
FROM triangles;
/*
Generate the following two result sets:

Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter of each profession as a parenthetical (i.e.: enclosed in parentheses). For example: AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S).
Query the number of ocurrences of each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following format:

There are a total of [occupation_count] [occupation]s.
where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] is the lowercase occupation name. If more than one Occupation has the same [occupation_count], they should be ordered alphabetically.

Note: There will be at least two entries in the table for each type of occupation.
*/
SELECT CONCAT(Name, '(', LEFT(Occupation, 1), ')') 
FROM OCCUPATIONS
ORDER BY Name;

SELECT CONCAT('There are a total of ', COUNT(*), ' ', LOWER(Occupation), 's.') 
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(*), Occupation;
/*
Samantha was tasked with calculating the average monthly salaries for all employees in the EMPLOYEES table, but did not realize her keyboard's  key was broken until after completing the calculation. She wants your help finding the difference between her miscalculation (using salaries with any zeros removed), and the actual average salary.

Write a query calculating the amount of error (i.e.:  average monthly salaries), and round it up to the next integer.
*/
SELECT CEIL(AVG(SALARY) - AVG(REPLACE(SALARY, '0', ''))) FROM EMPLOYEES

/*
We define an employee's total earnings to be their monthly  worked, and the maximum total earnings to be the maximum total earnings for any employee in the Employee table. Write a query to find the maximum total earnings for all employees as well as the total number of employees who have maximum total earnings. Then print these values as 2 space-separated integers.
salary * months
*/
SELECT total_earnings, COUNT(*)
FROM (
    SELECT SALARY * MONTHS AS total_earnings
    FROM Employee
) AS earnings
WHERE total_earnings = (
SELECT (MAX(SALARY * MONTHS)) 
FROM Employee
)
GROUP BY total_earnings


/*
Consider p1 and p2 to be two points on a 2D plane.

a happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
b happens to equal the minimum value in Western Longitude (LONG_W in STATION).
c happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
d happens to equal the maximum value in Western Longitude (LONG_W in STATION).
Query the Manhattan Distance between points p1 and p2 and round it to a scale of  decimal places.
*/
SELECT ROUND(ABS(MAX(LAT_N) - MIN(LAT_N)) + ABS(MAX(LONG_W) - MIN(LONG_W)), 4)
FROM STATION;

/*
```

## Explanation

### What is Manhattan Distance?

Manhattan Distance = |x₂ - x₁| + |y₂ - y₁|

It's the distance you'd travel if you could only move horizontally or vertically (like navigating city blocks in Manhattan).

### Given Points:

**Point P₁:**
- a = MIN(LAT_N)
- b = MIN(LONG_W)
- Coordinates: (MIN(LAT_N), MIN(LONG_W))

**Point P₂:**
- c = MAX(LAT_N)  
- d = MAX(LONG_W)
- Coordinates: (MAX(LAT_N), MAX(LONG_W))

### Manhattan Distance Formula:
```
Distance = |c - a| + |d - b|
Distance = |MAX(LAT_N) - MIN(LAT_N)| + |MAX(LONG_W) - MIN(LONG_W)|
*/

---similar question:

/*
Consider  and  to be two points on a 2D plane where  are the respective minimum and maximum values of Northern Latitude (LAT_N) and  are the respective minimum and maximum values of Western Longitude (LONG_W) in STATION.

Query the Euclidean Distance between points  and  and format your answer to display  decimal digits.
*/
SELECT
  ROUND(
    SQRT(
      POWER(MAX(LAT_N) - MIN(LAT_N), 2)
    + POWER(MAX(LONG_W) - MIN(LONG_W), 2)
    ), 4
  ) AS euclidean_distance
FROM STATION
WHERE LAT_N IS NOT NULL
  AND LONG_W IS NOT NULL;
