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

/*In this exercise, you will generate a list of matches where the total goals scored (for both teams in total) is more than 3 times the average for games in the matches_2013_2014 table, which includes all games played in the 2013/2014 season.
Calculate triple the average home + away goals scored across all matches. This will become your subquery in the next step*/


SELECT 3 * AVG(home_goal + away_goal)
FROM matches_2013_2014;

/*Select the date, home goals, and away goals in the main query.
Filter the main query for matches where the total goals scored exceed the value in the subquery.*/

SELECT date, home_goal, away_goal
FROM  matches_2013_2014
WHERE (home_goal + away_goal) > 
       (SELECT 3 * AVG(home_goal + away_goal)
        FROM matches_2013_2014); 

/*Your goal in this exercise is to generate a list of teams that never played a game in their home city. 
Create a subquery in the WHERE clause that retrieves all unique hometeam_ID values from the match table.
Select the team_long_name and team_short_name from the team table. Exclude all values from the subquery in the main query.*/

SELECT team_long_name, team_short_name
FROM team
WHERE team_api_id NOT IN
     (SELECT DISTINCT hometeam_ID FROM match);

/*Let's do some further exploration in this database by creating a list of teams that scored 8 or more goals in a home match.
Create a subquery in WHERE clause that retrieves all hometeam_ID values from match with a home_goal score greater than or equal to 8.
Select the team_long_name and team_short_name from the team table. Include all values from the subquery in the main query.*/

SELECT team_long_name, team_short_name
FROM team
WHERE team_api_id IN
	  (SELECT hometeam_id 
       FROM match
       WHERE home_goal >= 8);

/*Your goal in this exercise is to generate a subquery using the match table, and then join that subquery to the country table to calculate information about matches with 10 or more goals in total!
Create the subquery to be used in the next step, which selects the country ID and match ID (id) from the match table.
Filter the query for matches with greater than or equal to 10 goals.*/

SELECT country_id, id
FROM match
WHERE (home_goal + away_goal) >= 10;

/*Construct a subquery that selects only matches with 10 or more total goals.
Inner join the subquery onto country in the main query.
Select name from country and count the id column from match.*/

SELECT c.name AS country_name,
    COUNT(sub.id) AS matches
FROM country AS c
INNER JOIN (SELECT country_id, id 
           FROM match
           WHERE (home_goal + away_goal) >= 10) AS sub
ON c.id = sub.country_id
GROUP BY country_name;

/*In the previous exercise, you found that England, Netherlands, Germany and Spain were the only countries that had matches in the database where 10 or more goals were scored overall. Let's find out some more details about those matches -- when they were played, during which seasons, and how many of the goals were home vs. away goals.
Complete the subquery inside the FROM clause. Select the country name from the country table, and the home goal, and away goal columns from the match table.
Create a column in the subquery that adds home and away goals, called total_goals. This will be used to filter the main query.
Select the country, date, home goals, and away goals in the main query.
Filter the main query for games with 10 or more total goals.*/

SELECT
	country,
    date,
    home_goal,
    away_goal
FROM 
	(SELECT c.name AS country, 
     	    m.date, 
     		m.home_goal, 
     		m.away_goal,
           (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN country AS c
    ON m.country_id = c.id) AS subq
WHERE total_goals >= 10;

/*In the following exercise, you will construct a query that calculates the average number of goals per match in each country's league.
In the subquery, select the average total goals by adding home_goal and away_goal.
Filter the results so that only the average of goals in the 2013/2014 season is calculated.
In the main query, select the average total goals by adding home_goal and away_goal. This calculates the average goals for each league.
Filter the results in the main query the same way you filtered the subquery. Group the query by the league name.*/

SELECT 
	l.name AS league,
    ROUND(AVG(home_goal + m.away_goal), 2) AS avg_goals,
    (SELECT ROUND(AVG(home_goal + away_goal), 2) 
     FROM match
     WHERE season = '2013/2014') AS overall_avg
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
WHERE season = '2013/2014'
GROUP BY league;

/*In the previous exercise, you created a column to compare each league's average total goals to the overall average goals in the 2013/2014 season. In this exercise, you will add a column that directly compares these values by subtracting the overall average from the subquery.
Select the average goals scored in a match for each league in the main query.
Select the average goals scored in a match overall for the 2013/2014 season in the subquery.
Subtract the subquery from the average number of goals calculated for each league.
Filter the main query so that only games from the 2013/2014 season are included.*/

SELECT
	name AS league,
	ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
	ROUND(AVG(m.home_goal + m.away_goal) - 
		(SELECT AVG(home_goal + away_goal)
		 FROM match 
         WHERE season = '2013/2014'),2) AS diff
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
WHERE season = '2013/2014'
GROUP BY l.name;

/*In this lesson, you will build a final query across 3 exercises that will contain three subqueries 
-- one in the SELECT clause, one in the FROM clause, and one in the WHERE clause. 
In the final exercise, your query will extract data examining the average goals scored in each stage of a match. 
Does the average number of goals scored change as the stakes get higher from one stage to the next?


Extract the average number of home and away team goals in two SELECT subqueries.
Calculate the average home and away goals for the specific stage in the main query.
Filter both subqueries and the main query so that only data from the 2012/2013 season is included.
Group the query by the m.stage column.*/

SELECT 
	m.stage,
    ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
    ROUND((SELECT AVG(home_goal + away_goal) 
           FROM match 
           WHERE season = '2012/2013'),2) AS overall
FROM match AS m
WHERE season = '2012/2013'
GROUP BY m.stage;

/*In this next step, you will turn the main query into a subquery to extract a list of stages 
where the average home goals in a stage is higher than the overall average for home goals in a match.

Calculate the average home goals and average away goals from the match table for each stage in the FROM clause subquery.
Add a subquery to the WHERE clause that calculates the overall average home goals.
Filter the main query for stages where the average home goals is higher than the overall average.
Select the stage and avg_goals columns from the s subquery into the main query.*/

SELECT 
	s.stage,
	ROUND(s.avg_goals, 2) AS avg_goals
FROM 
	(SELECT
		 stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');


/*In this final step, you will add a subquery in SELECT to compare the average number of goals scored in each stage to the total.

Create a subquery in SELECT that yields the average goals scored in the 2012/2013 season. Name the new column overall_avg.
Create a subquery in FROM that calculates the average goals scored in each stage during the 2012/2013 season.
Filter the main query for stages where the average goals exceeds the overall average in 2012/2013.*/

SELECT 
	s.stage,
    ROUND(s.avg_goals, 2) AS avg_goal,
    (SELECT AVG(home_goal + away_goal) FROM match WHERE season = '2012/2013') AS overall_avg
FROM 
	(SELECT
		 stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');