-- Total matches played
SELECT COUNT(*) AS total_matches FROM matches;
 
-- Total seasons
SELECT COUNT(DISTINCT season) AS total_seasons FROM matches;
 
-- Total teams
SELECT COUNT(DISTINCT team1) AS total_teams FROM (
    SELECT team1 FROM matches
    UNION
    SELECT team2 FROM matches
) AS all_teams;
 
-- Total runs scored overall
SELECT SUM(total_runs) AS total_runs_scored FROM deliveries;
 
-- Total wickets taken
SELECT COUNT(*) AS total_wickets FROM deliveries WHERE is_wicket = 1;
 
-- Total sixes sixes
SELECT COUNT(*) AS total_sixes FROM deliveries WHERE batsman_runs = 6;
 
-- Total fours
SELECT COUNT(*) AS total_fours FROM deliveries WHERE batsman_runs = 4;

-- Most IPL titles won
SELECT winner, COUNT(*) AS titles
FROM matches
WHERE match_type = 'Final'
GROUP BY winner
ORDER BY titles DESC;
 
-- Overall wins per team
SELECT winner AS team, COUNT(*) AS total_wins
FROM matches
WHERE winner != 'No Result'
GROUP BY winner
ORDER BY total_wins DESC;
 
-- Win percentage per team
SELECT team, total_matches, total_wins,
    ROUND((total_wins / total_matches) * 100, 2) AS win_percentage
FROM ( SELECT t.team, COUNT(*) AS total_matches, SUM(CASE WHEN m.winner = t.team THEN 1 ELSE 0 END) AS total_wins
    FROM ( SELECT team1 AS team FROM matches  
    UNION ALL
        SELECT team2 AS team FROM matches) t
    JOIN matches m ON m.team1 = t.team OR m.team2 = t.team
    GROUP BY t.team
) AS team_stats
ORDER BY win_percentage DESC;
 
-- did winning toss help win match?
SELECT 
    toss_decision,
    COUNT(*) AS total,
    SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS won_after_toss,
    ROUND(SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS win_pct
FROM matches
WHERE winner != 'No Result'
GROUP BY toss_decision;
 
-- super over matches by team
SELECT winner AS team, COUNT(*) AS super_over_wins
FROM matches
WHERE super_over = 'Y'
GROUP BY winner
ORDER BY super_over_wins DESC;

-- team win per season
SELECT m.season, m.winner AS team, COUNT(*) AS wins
FROM matches m
WHERE m.winner != 'No Result'
GROUP BY m.season, m.winner
ORDER BY m.season, wins DESC;

-- totall run score per season
SELECT m.season, SUM(d.total_runs) AS total_runs
FROM matches m
JOIN deliveries d ON m.id = d.match_id
GROUP BY m.season
ORDER BY m.season;
 
-- Total matches per season
SELECT season, COUNT(*) AS total_matches
FROM matches
GROUP BY season
ORDER BY season;
 
-- Highest scoring match per season
SELECT season, id AS match_id, team1, team2, target_runs
FROM matches
WHERE (season, target_runs) IN (
    SELECT season, MAX(target_runs)
    FROM matches
    GROUP BY season )
ORDER BY season;


-- Top 10 run scorers of all time
SELECT batter, SUM(batsman_runs) AS total_runs
FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC
LIMIT 10;
 
-- Top 10 six hitters
SELECT batter, COUNT(*) AS total_sixes
FROM deliveries
WHERE batsman_runs = 6
GROUP BY batter
ORDER BY total_sixes DESC
LIMIT 10;
 
-- Top 10 four hitters
SELECT batter, COUNT(*) AS total_fours
FROM deliveries
WHERE batsman_runs = 4
GROUP BY batter
ORDER BY total_fours DESC
LIMIT 10;
 
-- Highest individual scores in a match
SELECT 
    d.match_id,
    d.batter,
    d.batting_team,
    m.season,
    SUM(d.batsman_runs) AS runs_scored
FROM deliveries d
JOIN matches m ON d.match_id = m.id
GROUP BY d.match_id, d.batter, d.batting_team, m.season
ORDER BY runs_scored DESC
LIMIT 10;

-- Top 10 wicket takers
SELECT bowler, COUNT(*) AS total_wickets
FROM deliveries
WHERE is_wicket = 1
AND dismissal_kind NOT IN ('run out', 'retired hurt', 'obstructing the field')
GROUP BY bowler
ORDER BY total_wickets DESC
LIMIT 10;
 
-- Most dot balls bowled
SELECT bowler, COUNT(*) AS dot_balls
FROM deliveries
WHERE total_runs = 0
GROUP BY bowler
ORDER BY dot_balls DESC
LIMIT 10;
 
-- Types of dismissals
SELECT dismissal_kind, COUNT(*) AS total
FROM deliveries
WHERE is_wicket = 1 AND dismissal_kind != 'none'
GROUP BY dismissal_kind
ORDER BY total DESC;

-- Most matches hosted per venue
SELECT venue, city, COUNT(*) AS matches_hosted
FROM matches
GROUP BY venue, city
ORDER BY matches_hosted DESC
LIMIT 10;
 
-- Highest average score per venue (batting friendly venues)
SELECT 
    m.venue,
    ROUND(AVG(d.total_runs) * 120, 0) AS avg_innings_score
FROM matches m
JOIN deliveries d ON m.id = d.match_id
GROUP BY m.venue
ORDER BY avg_innings_score DESC
LIMIT 10;
 
-- Super over matches
SELECT id, season, team1, team2, winner, venue
FROM matches
WHERE super_over = 'Y'
ORDER BY season;

-- Highest team totals in an innings
SELECT 
    d.match_id,
    d.batting_team,
    d.inning,
    m.season,
    SUM(d.total_runs) AS innings_total
FROM deliveries d
JOIN matches m ON d.match_id = m.id
GROUP BY d.match_id, d.batting_team, d.inning, m.season
ORDER BY innings_total DESC
LIMIT 10;

-- Runs scored in each phase overall
SELECT 
    CASE 
        WHEN `over` BETWEEN 1 AND 6 THEN 'Powerplay (1-6)'
        WHEN `over` BETWEEN 7 AND 15 THEN 'Middle (7-15)'
        WHEN `over` BETWEEN 16 AND 20 THEN 'Death (16-20)'
    END AS phase,
    SUM(total_runs) AS runs_scored,
    COUNT(CASE WHEN is_wicket = 1 THEN 1 END) AS wickets_lost
FROM deliveries
GROUP BY phase
ORDER BY phase;
 
-- Best powerplay teams (batting)
SELECT 
    batting_team,
    ROUND(AVG(over_runs), 2) AS avg_powerplay_runs
FROM (
    SELECT match_id, batting_team, SUM(total_runs) AS over_runs
    FROM deliveries
    WHERE `over` BETWEEN 1 AND 6
    GROUP BY match_id, batting_team
) AS pp
GROUP BY batting_team
ORDER BY avg_powerplay_runs DESC;

-- Using CTE to calculate total wins by each team
WITH team_wins AS (
    SELECT winner, COUNT(*) AS wins
    FROM matches
    GROUP BY winner
)
SELECT * FROM team_wins ORDER BY wins DESC;

-- Rank batters based on runs(window fun)
SELECT
    batter,
    SUM(batsman_runs) AS total_runs,
    RANK() OVER (
        ORDER BY SUM(batsman_runs) DESC
    ) AS batter_rank
FROM deliveries GROUP BY batter;

-- Using view to store batting statistics as a reusable virtual table
CREATE VIEW batting_stats AS
SELECT batter, SUM(batsman_runs) AS total_runs
FROM deliveries GROUP BY batter;

SELECT * FROM batting_stats ORDER BY total_runs DESC;  -- run view
drop database github_upload;