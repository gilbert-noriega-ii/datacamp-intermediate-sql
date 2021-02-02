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

/*Select the team's long name and API id from the teams_germany table.
Filter the query for FC Schalke 04 and FC Bayern Munich using IN, giving you the team_api_IDs needed for the next step.*/

SELECT team_long_name, team_api_id
FROM teams_germany
WHERE team_long_name IN ('FC Schalke 04', 'FC Bayern Munich');

/*Create a CASE statement that identifies whether a match in Germany included FC Bayern Munich, FC Schalke 04, or neither as the home team.
Group the query by the CASE statement alias, home_team.*/

SELECT 
        CASE WHEN hometeam_id = 10189 THEN 'FC Schalke 04'
        WHEN hometeam_id = 9823 THEN 'FC Bayern Munich'
        ELSE 'Other' END AS home_team,
        COUNT(id) AS total_matches
FROM matches_germany
GROUP BY home_team;

/*In this exercise, you will be creating a list of matches in the 2011/2012 season where Barcelona was the home team. 
Select the date of the match and create a CASE statement to identify matches as home wins, home losses, or ties.*/

SELECT date,
	CASE WHEN home_goal > away_goal THEN 'Home win!'
        WHEN home_goal < away_goal THEN 'Home loss :(' 
        ELSE 'Tie' END AS outcome
FROM matches_spain;

/*Left join the teams_spain table team_api_id column to the matches_spain table awayteam_id. This allows us to retrieve the away team's identity.
Select team_long_name from teams_spain as opponent and complete the CASE statement from Step 1.*/

SELECT m.date, t.team_long_name AS opponent, 
	CASE WHEN m.home_goal > m.away_goal THEN 'Home win!'
        WHEN m.home_goal < m.away_goal THEN 'Home loss :('
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
LEFT JOIN teams_spain AS t
ON m.awayteam_id = t.team_api_id;

/*Complete the same CASE statement as the previous steps.
Filter for matches where the home team is FC Barcelona (id = 8634).*/

SELECT m.date, t.team_long_name AS opponent,
	CASE WHEN m.home_goal > m.away_goal THEN 'Barcelona win!'
        WHEN m.home_goal < m.away_goal THEN 'Barcelona loss :(' 
        ELSE 'Tie' END AS outcome 
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.awayteam_id = t.team_api_id
WHERE m.hometeam_id = 8634; 

/*Similar to the previous exercise, you will construct a query to determine the outcome of Barcelona's matches where they played as the away team.
Did their performance differ from the matches where they were the home team?
Complete the CASE statement to identify Barcelona's away team games (id = 8634) as wins, losses, or ties.
Left join the teams_spain table team_api_id column on the matches_spain table hometeam_id column. This retrieves the identity of the home team opponent.
Filter the query to only include matches where Barcelona was the away team.*/

SELECT  m.date, t.team_long_name AS opponent,
	CASE WHEN m.home_goal < m.away_goal THEN 'Barcelona win!'
        WHEN m.home_goal > m.away_goal THEN 'Barcelona loss :(' 
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.hometeam_id = t.team_api_id
WHERE m.awayteam_id = 8634;

/*In this exercise, you will retrieve information about matches played between Barcelona (id = 8634) and Real Madrid (id = 8633). 
Complete the first CASE statement, identifying Barcelona or Real Madrid as the home team using the hometeam_id column.
Complete the second CASE statement in the same way, using awayteam_id.*/

SELECT date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS home,
        
        CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS away
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);

/*Construct the final CASE statement identifying who won each match. Note there are 3 possible outcomes, but 5 conditions that you need to identify.
Fill in the logical operators to identify Barcelona or Real Madrid as the winner.*/

SELECT date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as home,
	
        CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as away,
	
        CASE WHEN home_goal > away_goal AND hometeam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal > away_goal AND hometeam_id = 8633 THEN 'Real Madrid win!'
        WHEN home_goal < away_goal AND awayteam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal < away_goal AND awayteam_id = 8633 THEN 'Real Madrid win!'
        ELSE 'Tie!' END AS outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);

/*Let's generate a list of matches won by Italy's Bologna team! There are quite a few additional teams in the two tables, so a key part of generating a usable query will be using your CASE statement as a filter in the WHERE clause.
Identify Bologna's team ID listed in the teams_italy table by selecting the team_long_name and team_api_id.*/

SELECT team_long_name, team_api_id
FROM teams_italy
WHERE team_long_name = 'Bologna';

/*Select the season and date that a match was played.
Complete the CASE statement so that only Bologna's home and away wins are identified.*/

SELECT season, date,
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
		END AS outcome
FROM matches_italy;

/*Select the home_goal and away_goal for each match.
Use the CASE statement in the WHERE clause to filter all NULL values generated by the statement in the previous step.*/

-- Select the season, date, home_goal, and away_goal columns
SELECT 
	season,
    date,
	home_goal,
	away_goal
FROM matches_italy
WHERE 
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
		END IS NOT NULL;

/*Using the country and unfiltered match table, you will count the number of matches played in each country during the 2012/2013, 2013/2014, and 2014/2015 match seasons.
Create a CASE statement that identifies the id of matches played in the 2012/2013 season. Specify that you want ELSE values to be NULL.
Wrap the CASE statement in a COUNT function and group the query by the country alias.*/

SELECT 
	c.name AS country,
    COUNT(CASE WHEN m.season = '2012/2013' 
        	THEN m.id ELSE NULL END) AS matches_2012_2013
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY country;

/*Create 3 CASE WHEN statements counting the matches played in each country across the 3 seasons.
END your CASE statement without an ELSE clause.*/

SELECT 
	c.name AS country,
    COUNT(CASE WHEN m.season = '2012/2013' THEN m.id END) AS matches_2012_2013,
	COUNT(CASE WHEN m.season = '2013/2014' THEN m.id END) AS matches_2013_2014,
	COUNT(CASE WHEN m.season = '2014/2015' THEN m.id END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY country;

/*Your goal here is to use the country and match table to determine the total number of matches won by the home team in each country during the 2012/2013, 2013/2014, and 2014/2015 seasons.
Create 3 CASE statements to "count" matches in the '2012/2013', '2013/2014', and '2014/2015' seasons, respectively.
Have each CASE statement return a 1 for every match you want to include, and a 0 for every match to exclude.
Wrap the CASE statement in a SUM to return the total matches played in each season.
Group the query by the country name alias.*/

SELECT 
	c.name AS country,
	SUM(CASE WHEN m.season = '2012/2013' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2012_2013,
 	SUM(CASE WHEN m.season = '2013/2014' AND m.home_goal > m.away_goal
        THEN 1 ELSE 0 END) AS matches_2013_2014,
	SUM(CASE WHEN m.season = '2014/2015' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY country;

/*Your task is to examine the number of wins, losses, and ties in each country. The matches table is filtered to include all matches from the 2013/2014 and 2014/2015 seasons.
Create 3 CASE statements to COUNT the total number of home team wins, away team wins, and ties. This will allow you to examine the total number of records. You will convert this to an AVG in the next step.*/

SELECT 
    c.name AS country,
    COUNT(CASE WHEN m.home_goal > m.away_goal THEN m.id 
        END) AS home_wins,
    COUNT(CASE WHEN m.home_goal < m.away_goal THEN m.id 
        END) AS away_wins,
    COUNT(CASE WHEN m.home_goal = m.away_goal THEN m.id 
        END) AS ties
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

/*Calculate the percentage of matches tied using a CASE statement inside AVG.
Fill in the logical operators for each statement. Alias your columns as ties_2013_2014 and ties_2014_2015, respectively.*/

SELECT 
	c.name AS country,
	AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2013_2014,
	AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;

/*The previous "ties" columns returned values with 14 decimal points, which is not easy to interpret. Use the ROUND function to round to 2 decimal points.*/

SELECT 
	c.name AS country,
	ROUND(AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2013_2014,
	ROUND(AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;