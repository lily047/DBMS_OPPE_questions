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
