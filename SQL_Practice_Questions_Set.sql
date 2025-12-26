SELECT * from ENTRIES;
/

WITH cte AS (
SELECT   name, floor most_visited_floor, COUNT(1) times 
FROM     ENTRIES
GROUP BY name, floor
)
SELECT c.name,  
       (SELECT count(1) FROM ENTRIES WHERE name = c.name) total_visits,
       c.most_visited_floor,
       (SELECT LISTAGG(DISTINCT resources, ',') WITHIN GROUP (ORDER BY resources) FROM ENTRIES WHERE name = c.name) resources_used
FROM   cte c 
WHERE  times = (SELECT max(times) FROM cte);
/

WITH floor_stats AS (
    SELECT name,
           floor,
           COUNT(*) AS times
    FROM ENTRIES
    GROUP BY name, floor
),
ranked_floors AS (
    SELECT fs.name,
           fs.floor AS most_visited_floor,
           fs.times,
           ROW_NUMBER() OVER (PARTITION BY fs.name ORDER BY fs.times DESC) AS rn,
           COUNT(*) OVER (PARTITION BY fs.name) AS total_visits,
           LISTAGG(DISTINCT e.resources, ',') WITHIN GROUP (ORDER BY e.resources) OVER (PARTITION BY fs.name) AS resources_used
    FROM floor_stats fs
    JOIN ENTRIES e ON fs.name = e.name  -- To access resources
    GROUP BY fs.name, fs.floor, fs.times  -- Ensure grouping for LISTAGG
)
SELECT name,
       most_visited_floor,
       total_visits,
       resources_used
FROM ranked_floors
WHERE rn = 1;