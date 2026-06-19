CREATE DATABASE ipl_db;
USE ipl_db;
CREATE TABLE matches (
    id INT PRIMARY KEY, season VARCHAR(10), city VARCHAR(50), `date` DATE, match_type VARCHAR(20), player_of_match VARCHAR(50), 
    venue VARCHAR(100), team1 VARCHAR(50), team2 VARCHAR(50), toss_winner VARCHAR(50), toss_decision VARCHAR(10), winner VARCHAR(50), 
    `result` VARCHAR(20), result_margin INT, target_runs INT, target_overs INT, super_over VARCHAR(5), umpire1 VARCHAR(50),
    umpire2 VARCHAR(50) );
    
CREATE TABLE deliveries (
    match_id INT, inning INT, batting_team VARCHAR(50), bowling_team VARCHAR(50), `over` INT, ball INT, batter VARCHAR(50), 
    bowler VARCHAR(50), non_striker VARCHAR(50), batsman_runs INT, extra_runs INT, total_runs INT, extras_type VARCHAR(20), is_wicket INT, 
    player_dismissed VARCHAR(50), dismissal_kind VARCHAR(30), fielder VARCHAR(50), FOREIGN KEY (match_id) REFERENCES matches(id)
);

SHOW VARIABLES LIKE 'secure_file_priv';
ALTER TABLE matches MODIFY target_overs DECIMAL(4,1);
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/matches.csv'
INTO TABLE matches
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, season, city, `date`, match_type, player_of_match, venue, team1, team2, 
toss_winner, toss_decision, winner, `result`, @result_margin, @target_runs, 
@target_overs, super_over, @method, umpire1, umpire2)
SET 
result_margin = NULLIF(@result_margin, 'NA'),
target_runs = NULLIF(@target_runs, 'NA'),
target_overs = NULLIF(@target_overs, 'NA');

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/deliveries.csv'
INTO TABLE deliveries
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(match_id, inning, batting_team, bowling_team, `over`, ball, batter, bowler,
non_striker, batsman_runs, extra_runs, total_runs, extras_type, is_wicket,
player_dismissed, dismissal_kind, fielder);

