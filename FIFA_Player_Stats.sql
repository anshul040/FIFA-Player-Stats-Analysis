-- Find the clubs with the highest average value per player: 
SELECT club, AVG(player_value) AS avg_value 
FROM player_stats 
GROUP BY club 
ORDER BY avg_value DESC 
LIMIT 5; 

-- Identify the players with the highest total of dribbling and vision attributes within each club: 
SELECT club, player, (dribbling + vision) AS total_dribble_vision 
FROM player_stats 
WHERE club IN ( 
    SELECT DISTINCT club 
    FROM player_stats 
) 
ORDER BY club, total_dribble_vision DESC; 

-- Find the players with the highest overall performance who have a market value above the average market value: 
WITH avg_market_value AS ( 
    SELECT AVG(player_value) AS avg_value 
    FROM player_stats 
) 
SELECT player, 
       (ball_control + dribbling + marking + slide_tackle + stand_tackle + aggression + 
        reactions + att_position + interceptions + vision + composure + crossing + 
        short_pass + long_pass + acceleration + stamina + strength + balance + 
        sprint_speed + agility + jumping + heading + shot_power + finishing + 
        long_shots + curve + fk_acc + penalties + volleys) AS overall_performance, 
        player_value 
FROM player_stats 
WHERE player_value > (SELECT avg_value FROM avg_market_value) 
ORDER BY overall_performance DESC 
LIMIT 5; 

-- Calculate the average values of key attributes for players in different age groups (e.g., under 20, 20-25, 26-30, and over 30):
SELECT
  CASE
    WHEN age < 20 THEN 'Under 20'
    WHEN age BETWEEN 20 AND 25 THEN '20-25'
    WHEN age BETWEEN 26 AND 30 THEN '26-30'
    ELSE 'Over 30'
  END AS age_group,
  AVG(ball_control) AS avg_ball_control,
  AVG(dribbling) AS avg_dribbling
FROM player_stats
GROUP BY age_group;

-- Calculate the average value of each attribute for players in the top 3 clubs with the highest total player_value:

WITH TopClubs AS (
  SELECT club
  FROM player_stats
  GROUP BY club
  ORDER BY SUM(player_value) DESC
  LIMIT 3
)
SELECT club, AVG(ball_control) AS avg_ball_control, AVG(dribbling) AS avg_dribbling
FROM player_stats
WHERE club IN (SELECT club FROM TopClubs)
GROUP BY club;

-- Identify players with the highest "shot_power" and "long_shots" who are also above the average in "vision":

SELECT player, shot_power, long_shots, vision
FROM player_stats
WHERE shot_power > (SELECT AVG(shot_power) FROM player_stats)
  AND long_shots > (SELECT AVG(long_shots) FROM player_stats)
  AND vision > (SELECT AVG(vision) FROM player_stats)
ORDER BY shot_power + long_shots + vision DESC
LIMIT 5;

-- Calculate the average difference between each player's "ball_control" and "dribbling" attributes and identify the player with the highest average difference:

WITH AttributeDifferences AS (
  SELECT player, (ball_control - dribbling) AS attribute_difference
  FROM player_stats
)
SELECT player, AVG(attribute_difference) AS avg_difference
FROM AttributeDifferences
GROUP BY player
ORDER BY avg_difference DESC
LIMIT 1;

-- Identify the clubs with the highest average "agility" and "balance" among players who have "acceleration" above a certain threshold
SELECT club, AVG(agility) AS avg_agility, AVG(balance) AS avg_balance
FROM player_stats
WHERE acceleration > 80
GROUP BY club
ORDER BY avg_agility + avg_balance DESC
LIMIT 5;

-- Identify the players who have the highest sum of "dribbling," "ball_control," and "finishing" attributes among those with "shot_power" above the average:

SELECT player, dribbling, ball_control, finishing, shot_power
FROM player_stats
WHERE shot_power > (SELECT AVG(shot_power) FROM player_stats)
ORDER BY dribbling + ball_control + finishing DESC
LIMIT 5;

-- Calculate the average "heading" attribute for players in clubs that have an average "heading" attribute higher than the overall average:

WITH ClubAvgHeading AS (
  SELECT club, AVG(heading) AS avg_heading
  FROM player_stats
  GROUP BY club
  HAVING avg_heading > (SELECT AVG(heading) FROM player_stats)
)
SELECT club, AVG(heading) AS avg_heading
FROM player_stats ps
WHERE ps.club IN (SELECT club FROM ClubAvgHeading)
GROUP BY club;

-- Identify the players with the highest "finishing" and "long_shots" attributes in clubs with "stamina" above the average:

SELECT player, finishing, long_shots, club
FROM player_stats
WHERE club IN (
  SELECT club
  FROM player_stats
  WHERE stamina > (SELECT AVG(stamina) FROM player_stats)
)
ORDER BY finishing + long_shots DESC
LIMIT 5;





