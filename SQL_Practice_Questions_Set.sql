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

-- Pareto Principle: 80% of effects come from 20% of causes
with cte as (
       SELECT product_id,
              SUM(sales_amount) as total_sales
       FROM sales
       GROUP BY product_id
       ORDER BY SUM(sales_amount) desc
)
SELECT COUNT(1) * 20 / 100 AS top_20_percent_products,
       
FROM cte

--  Find the percentage variance of sales from previous day
SELECT *
  FROM salesvar_tbl;

WITH cte AS (
   SELECT salesvar_tbl.*,
          LAG(sales, 1) over (order by dt) prev
     from salesvar_tbl
)
select dt,
       sales,
       case when prev is not null then ( ( sales - prev ) * 100 ) / prev else null end as "%var"
  from cte
 where ( ( ( sales - prev ) * 100 ) / prev > 0
    or prev is null );


-- Write a query to find PersonID, Name, no of friends, sum of marks of person who have friends with total score greater than 100
select * from person;
select * from friend;
/

SELECT P.personid, P.name, COUNT((SELECT SCORE FROM PERSON WHERE F.FID = PersonID)) No_of_Friends, SUM((SELECT SCORE FROM PERSON WHERE F.FID = PersonID)) Total_Friend_Score
FROM PERSON P LEFT JOIN FRIEND F ON P.PersonID = F.PID
GROUP BY P.personid, P.name
having SUM((SELECT SCORE FROM PERSON WHERE F.FID = PersonID)) > 100;
/

select f.pid, sum(p.score) as total_friend_score, count(1) as No_of_Friends
from friend f inner join person p on f.fid = p.personid
GROUP by f.pid; 
/

select * from orders;
rollback

delete from orders where rowid in (
select rowid from orders o
where created_at != (select max(created_at) from orders where o.order_id = order_id));
/

select * from employee
where rownum <= 5;