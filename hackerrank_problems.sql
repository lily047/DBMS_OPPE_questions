/*
Rounding to the nearest integer
Query the average population for all cities in CITY, rounded down to the nearest integer.
*/
SELECT (FLOOR(AVG(POPULATION)))
FROM CITY 

/*
Query the sum of Northern Latitudes (LAT_N) from STATION having values greater than  38.7880 and less than 137.2345. Truncate your answer to  decimal places.
*/
SELECT TRUNCATE(SUM(LAT_N), 4)
FROM STATION 
WHERE LAT_N > 38.7880 AND LAT_N < 137.2345

/*
Query the Western Longitude (LONG_W) for the largest Northern Latitude (LAT_N) in STATION that is less than 137.2345. Round your answer to  decimal places.
*/
SELECT ROUND(LONG_W, 4)
FROM STATION 
WHERE LAT_N < 137.2345 
ORDER BY LAT_N DESC 
LIMIT 1

