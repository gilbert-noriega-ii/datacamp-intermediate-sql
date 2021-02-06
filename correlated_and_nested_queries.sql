/* teams_germany table fields are 

id
team_api_id
team_long_name
team_short_name

*/

/* matches_germany table fields are 

id
country_id
season
stage
date
hometeam_id
awayteam_id
home_goal
away_goal

*/

/* teams_spain table fields are 

id
team_api_id
team_long_name
team_short_name

*/

/* matches_spain table fields are 

id
country_id
season
stage
date
hometeam_id
awayteam_id
home_goal
away_goal

*/

/* teams_italy table fields are 

id
team_api_id
team_long_name
team_short_name

*/

/* matches_italy table fields are 

id
country_id
season
stage
date
hometeam_id
awayteam_id
home_goal
away_goal

*/

/* country table fields are 

id
name

*/

/* match table fields are 

id
country_id
season
stage
date
hometeam_id
awayteam_id
home_goal
away_goal

*/

/*In this exercise, you will practice using correlated subqueries to examine matches with scores that are extreme outliers for each country -- above 3 times the average score!
Select the country_id, date, home_goal, and away_goal columns in the main query.
Complete the AVG value in the subquery.
Complete the subquery column references, so that country_id is matched in the main and subquery.*/

SELECT 
	main.country_id,
    main.date,
    main.home_goal, 
    main.away_goal
FROM match AS main
WHERE 
	(home_goal + away_goal) > 
        (SELECT AVG((sub.home_goal + sub.away_goal) * 3)
         FROM match AS sub
         WHERE main.country_id = sub.country_id);

/*In this exercise, you're going to add an additional column for matching to answer the question -- what was the highest scoring match for each country, in each season?

Select the country_id, date, home_goal, and away_goal columns in the main query.
Complete the subquery: Select the matches with the highest number of total goals.
Match the subquery to the main query using country_id and season.
Fill in the correct logical operator so that total goals equals the max goals recorded in the subquery.*/

SELECT 
	main.country_id,
    main.date,
    main.home_goal,
    main.away_goal
FROM match AS main
WHERE 
	(home_goal + away_goal) = 
        (SELECT MAX(sub.home_goal + sub.away_goal)
         FROM match AS sub
         WHERE main.country_id = sub.country_id
               AND main.season = sub.season);

/*In this exercise, you will practice creating a nested subquery to examine the highest total number of goals in each season, overall, and during July across all seasons.

Complete the main query to select the season and the max total goals in a match for each season. Name this max_goals.
Complete the first simple subquery to select the max total goals in a match across all seasons. Name this overall_max_goals.
Complete the nested subquery to select the maximum total goals in a match played in July across all seasons.
Select the maximum total goals in the outer subquery. Name this entire subquery july_max_goals.
*/

SELECT
	season,
    MAX(home_goal + away_goal) AS max_goals,
    (SELECT MAX(home_goal + away_goal) FROM match) AS overall_max_goals,
    (SELECT MAX(home_goal + away_goal) 
    FROM match
    WHERE id IN (
          SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 07)) AS july_max_goals
FROM match
GROUP BY season;

/*Generate a list of matches where at least one team scored 5 or more goals.*/

SELECT
	country_id,
    season,
	id
FROM match
WHERE home_goal >= 5 OR away_goal >= 5;

/*Turn the query from the previous step into a subquery in the FROM statement.
COUNT the match ids generated in the previous step, and group the query by country_id and season.*/

SELECT
    country_id,
    season,
    COUNT(id) AS matches
FROM
	(SELECT
    	country_id,
    	season,
    	id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS subquery
GROUP BY country_id, season;

/*Finally, declare the same query from step 2 as a subquery in FROM with the alias outer_s.
Left join it to the country table using the outer query's country_id column.
Calculate an AVG of high scoring matches per country in the main query.*/

SELECT
	c.name AS country,
    AVG(outer_s.matches) AS avg_seasonal_high_scores
FROM country AS c
LEFT JOIN(
        SELECT 
              country_id, 
              season,
              COUNT(id) AS matches
        FROM (
              SELECT country_id, season, id
              FROM match
              WHERE home_goal >= 5 OR away_goal >= 5) AS inner_s
        GROUP BY country_id, season) AS outer_s
ON c.id = outer_s.country_id
GROUP BY country;

/*In this exercise, let's rewrite a similar query using a CTE.

SELECT
  c.name AS country,
  COUNT(sub.id) AS matches
FROM country AS c
INNER JOIN (
  SELECT country_id, id 
  FROM match
  WHERE (home_goal + away_goal) >= 10) AS sub
ON c.id = sub.country_id
GROUP BY country;

Complete the syntax to declare your CTE.
Select the country_id and match id from the match table in your CTE.
Left join the CTE to the league table using country_id.*/

WITH match_list AS (
    SELECT 
  		country_id, 
  		id
    FROM match
    WHERE (home_goal + away_goal) >= 10)
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;

/*Just like a subquery in FROM, you can join tables inside a CTE.

Declare your CTE, where you create a list of all matches with the league name.
Select the league, date, home, and away goals from the CTE.
Filter the main query for matches with 10 or more goals.*/

WITH match_list AS (
      SELECT 
  		l.name AS league, 
     	m.date, 
  		m.home_goal, 
  		m.away_goal,
       (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN league as l ON m.country_id = l.id)
SELECT league, date, home_goal, away_goal
FROM match_list
WHERE total_goals >= 10;

/*Declare a CTE that calculates the total goals from matches in August of the 2013/2014 season.
Left join the CTE onto the league table using country_id from the match_list CTE.
Filter the list on the inner subquery to only select matches in August of the 2013/2014 season.*/

WITH match_list AS (
    SELECT 
  		country_id,
  	  (home_goal + away_goal) AS goals
    FROM match
  	WHERE id IN (
       SELECT id
       FROM match
       WHERE season = '2013/2014' AND EXTRACT(MONTH FROM date) = 08))
SELECT 
	l.name,
  AVG(match_list.goals)
FROM league AS l
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;

/*Create a query that left joins team to match in order to get the identity of the home team. This becomes the subquery in the next step.*/

SELECT 
	m.id, 
    t.team_long_name AS hometeam
FROM match AS m
LEFT JOIN team as t
ON m.hometeam_id = team_api_id;

/*Add a second subquery to the FROM statement to get the away team name, changing only the hometeam_id. Left join both subqueries to the match table on the id column.*/

SELECT
	m.date,
  hometeam,
  awayteam,
  m.home_goal,
  m.away_goal
FROM match AS m

INNER JOIN (
  SELECT match.id, team.team_long_name AS hometeam
  FROM match
  LEFT JOIN team
  ON match.hometeam_id = team.team_api_id) AS home
ON home.id = m.id

INNER JOIN (
  SELECT match.id, team.team_long_name AS awayteam
  FROM match
  LEFT JOIN team
  ON match.awayteam_id = team.team_api_id) AS away
ON away.id = m.id;

/*Using a correlated subquery in the SELECT statement, match the team_api_id column from team to the hometeam_id from match.*/

SELECT
    m.date,
   (SELECT team_long_name
    FROM team AS t
    WHERE t.team_api_id = m.hometeam_id) AS hometeam
FROM match AS m;

/*Create a second correlated subquery in SELECT, yielding the away team's name.
Select the home and away goal columns from match in the main query.*/

SELECT
    m.date,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.hometeam_id) AS hometeam,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.awayteam_id) AS awayteam,
     home_goal,
     away_goal
FROM match AS m;

/*Select id from match and team_long_name from team. Join these two tables together on hometeam_id in match and team_api_id in team.*/

SELECT 
	m.id, 
    t.team_long_name AS hometeam
FROM match AS m
LEFT JOIN team AS t 
ON t.team_api_id = m.hometeam_id;

/*Declare the query from the previous step as a common table expression. SELECT everything from the CTE into the main query.*/

WITH home AS (
	SELECT m.id, t.team_long_name AS hometeam
	FROM match AS m
	LEFT JOIN team AS t 
	ON m.hometeam_id = t.team_api_id)

SELECT *
FROM home;

/*Let's declare the second CTE, away. Join it to the first CTE on the id column.
The date, home_goal, and away_goal columns have been added to the CTEs. SELECT them into the main query.*/

WITH home AS (
  SELECT m.id, 
         m.date, 
  		   t.team_long_name AS hometeam, 
         m.home_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.hometeam_id = t.team_api_id),

     away AS (
  SELECT m.id, 
         m.date, 
  		   t.team_long_name AS awayteam, 
         m.away_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.awayteam_id = t.team_api_id)

SELECT 
	  home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal
FROM home
INNER JOIN away
ON home.id = away.id;