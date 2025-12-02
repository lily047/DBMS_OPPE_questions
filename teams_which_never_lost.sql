/*Write an SQL query to find the team names that have never lost a match (as a host or
as a guest). [Database: FLIS]
*/
SELECT t.name 
FROM teams t JOIN matches m ON t.team_id = m.host_team_id
WHERE host_team_score > guest_team_score
INTERSECT
SELECT t.name 
FROM teams t JOIN matches m ON t.team_id = m.guest_team_id
WHERE host_team_score < guest_team_score

SELECT t.name  --gives a different answer check this one 
FROM teams t 
WHERE t.team_id NOT IN (
    SELECT host_team_id 
    FROM matches m
    WHERE host_team_score < guest_team_score
    UNION 
    SELECT guest_team_id 
    FROM matches m 
    WHERE guest_team_score < host_team_score
)

SELECT t.name 
FROM teams t 
WHERE NOT EXISTS (
		SELECT 1
		FROM matches m 
		WHERE (m.host_team_id = t.team_id
		AND m.host_team_id < m.guest_team_id)
		OR (m.guest_team_id = t.team_id 
		AND m.guest_team_id < m.host_team_id)
)
