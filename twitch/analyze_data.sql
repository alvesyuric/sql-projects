-- Joining the two tables:

-- 10. Let’s join the two tables on that column.
SELECT *
FROM stream m
JOIN chat c
	ON m.device_id = c.device_id
LIMIT 10;


-- How does view count change in the course of a day?

--10. Let’s write a query that returns the hours of the time column and the view count for each hour. Lastly, filter the result with only the users in your country
SELECT
	STRFTIME('%H', time),
    COUNT(*)
FROM stream
WHERE country = 'BR'
GROUP BY 1
ORDER BY 2 DESC;

-- 8. Let’s run this query and take a look at the time column from the stream table:
SELECT time
FROM stream
LIMIT 10;


-- Aggregate Functions:

-- 7. Group the games into their genres: Multiplayer Online Battle Arena (MOBA), First Person Shooter (FPS), Survival, and Other.
SELECT
	CASE
    	WHEN game = 'Counter-Strike: Global Offensive'
        	THEN 'FPS'
        WHEN game = 'DayZ' 
        	OR game = 'ARK: Survival Evolved'
            THEN 'Survival'
    	WHEN game = 'League of Legends'
        	OR game = 'Dota 2'
            OR game = 'Heroes of the Storm'
            THEN 'MOBA'
        ELSE 'Others'
    END AS 'genre',
    game,
    COUNT(*)
FROM stream
GROUP BY 2
order by 3 DESC; 

-- 6. Create a list of players and their number of streamers.
SELECT player, COUNT(*)
FROM stream
GROUP BY 1
ORDER BY 2 DESC;

-- 5. Where are these LoL stream viewers located?
SELECT country, COUNT(*)
FROM stream
WHERE game = 'League of Legends'
GROUP BY 1
order by 2 desc
LIMIT 10;

-- 4. What are the most popular games in the stream table?
SELECT game, COUNT(*)
FROM stream
GROUP BY 1
order by 2 desc;


-- Getting Started:

-- 3. What are the unique channels in the stream table?
SELECT DISTINCT channel
FROM stream;

-- 2. What are the unique games in the stream table?
SELECT DISTINCT game
FROM stream;

-- 1. Select the first 20 rows from each of the two tables.
SELECT *
FROM chat
LIMIT 20;

SELECT *
FROM stream
LIMIT 20;