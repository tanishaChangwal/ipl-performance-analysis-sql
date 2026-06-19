-- verifying rows
SELECT COUNT(*) FROM matches;
SELECT COUNT(*) FROM deliveries;

-- check for blanks
SELECT COUNT(*) FROM matches WHERE city = '';
SELECT COUNT(*) FROM matches WHERE winner = '';
SELECT COUNT(*) FROM deliveries WHERE player_dismissed = '';
SELECT COUNT(*) FROM deliveries WHERE dismissal_kind = '';
SELECT COUNT(*) FROM deliveries WHERE fielder = '';
SELECT COUNT(*) FROM deliveries WHERE extras_type = ' ';

SET SQL_SAFE_UPDATES = 0;
-- NULL cities
UPDATE matches SET city = 'Unknown' WHERE city IS NULL;

-- NULL winners
UPDATE matches SET winner = 'No Result' WHERE winner IS NULL;

-- NULL result margin
UPDATE matches SET result_margin = 0 WHERE result_margin IS NULL;

-- NULL and blank extras type
UPDATE deliveries SET extras_type = 'none' WHERE extras_type IS NULL OR extras_type = '';

-- NULL dismissed
UPDATE deliveries SET player_dismissed = 'not_out' WHERE is_wicket = 0;

-- NULL dismiss kindd
UPDATE deliveries SET dismissal_kind = 'none' WHERE is_wicket = 0;

-- NULL wickets
UPDATE deliveries SET fielder = 'none' WHERE is_wicket = 0;

UPDATE matches SET season = TRIM(season); 
SET SQL_SAFE_UPDATES = 1;

ALTER TABLE matches MODIFY `date` DATE;  -- clean date
CREATE INDEX idx_match_id ON deliveries(match_id);   -- index for join

-- Check for NULL in matches
SELECT 
    SUM(CASE WHEN city IS NULL THEN 1 ELSE 0 END) AS city_nulls,
    SUM(CASE WHEN winner IS NULL THEN 1 ELSE 0 END) AS winner_nulls,
    SUM(CASE WHEN result_margin IS NULL THEN 1 ELSE 0 END) AS margin_nulls
FROM matches;

-- Check for Null in deliveries
SELECT
    SUM(CASE WHEN extras_type IS NULL THEN 1 ELSE 0 END) AS extras_nulls,
    SUM(CASE WHEN player_dismissed IS NULL THEN 1 ELSE 0 END) AS dismissed_nulls,
    SUM(CASE WHEN dismissal_kind IS NULL THEN 1 ELSE 0 END) AS dismissal_nulls
FROM deliveries;

-- season clean
 SET SQL_SAFE_UPDATES = 0;

UPDATE matches SET season = '2008' WHERE season = '2007/08';
UPDATE matches SET season = '2010' WHERE season = '2009/10';
UPDATE matches SET season = '2021' WHERE season = '2020/21';

SET SQL_SAFE_UPDATES = 1;
ALTER TABLE matches MODIFY season YEAR;

-- error solve of alter season year
SELECT season FROM matches GROUP BY season;

SELECT season FROM matches WHERE season NOT REGEXP '^[0-9]{4}$'; -- checking no error in season

SET SQL_SAFE_UPDATES = 0;
UPDATE matches SET season = '2008' WHERE season = '2007/08';
UPDATE matches SET season = '2010' WHERE season = '2009/10';
UPDATE matches SET season = '2021' WHERE season = '2020/21';
SET SQL_SAFE_UPDATES = 1;
-- done, only year visible in season

SELECT id, COUNT(*) FROM matches 
	GROUP BY id HAVING COUNT(*) > 1; -- duplicate check

SELECT match_id, inning, `over`, ball, COUNT(*) AS countt FROM deliveries 
	GROUP BY match_id, inning, `over`, ball HAVING COUNT(*) > 1; -- to check if exact rows are duplicate

SELECT * FROM deliveries WHERE batsman_runs < 0;  -- looking for impossible values
SELECT * FROM matches WHERE target_runs < 0;    -- looking for impossible values

