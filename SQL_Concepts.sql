-- COUNT(*) vs COUNT(1) vs COUNT(column)
Assume a table has 𝟱 𝗿𝗼𝘄𝘀:
• 3 rows have values in 𝗰𝗼𝗹𝘂𝗺𝗻_𝗻𝗮𝗺𝗲
• 2 rows have 𝗡𝗨𝗟𝗟 in 𝗰𝗼𝗹𝘂𝗺𝗻_𝗻𝗮𝗺𝗲

1. 𝗖𝗢𝗨𝗡𝗧(*)
→ Counts 𝗔𝗟𝗟 𝗿𝗼𝘄𝘀
Result: 𝟱

2. 𝗖𝗢𝗨𝗡𝗧(𝟭)
→ Also counts 𝗔𝗟𝗟 𝗿𝗼𝘄𝘀 (𝗰𝗼𝗻𝘀𝘁𝗮𝗻𝘁 𝘃𝗮𝗹𝘂𝗲)
Result: 𝟱

3. 𝗖𝗢𝗨𝗡𝗧(𝗰𝗼𝗹𝘂𝗺𝗻_𝗻𝗮𝗺𝗲)
→ Counts only 𝗡𝗢𝗡-𝗡𝗨𝗟𝗟 values in the column
Result: 𝟯

𝗖𝗢𝗨𝗡𝗧(𝗗𝗜𝗦𝗧𝗜𝗡𝗖𝗧 𝗰𝗼𝗹𝘂𝗺𝗻_𝗻𝗮𝗺𝗲)
→ Counts 𝘂𝗻𝗶𝗾𝘂𝗲 𝗡𝗢𝗡-𝗡𝗨𝗟𝗟 values
Result: depends on how many 𝗱𝗶𝘀𝘁𝗶𝗻𝗰𝘁 𝘃𝗮𝗹𝘂𝗲𝘀 exist

𝗜𝗺𝗽𝗼𝗿𝘁𝗮𝗻𝘁 𝗻𝗼𝘁𝗲:
𝗖𝗢𝗨𝗡𝗧(*) and 𝗖𝗢𝗨𝗡𝗧(𝟭) always return the 𝘀𝗮𝗺𝗲 𝗿𝗲𝘀𝘂𝗹𝘁.
𝗡𝗨𝗟𝗟 𝘃𝗮𝗹𝘂𝗲𝘀 are only 𝗶𝗴𝗻𝗼𝗿𝗲𝗱 in 𝗖𝗢𝗨𝗡𝗧(𝗰𝗼𝗹𝘂𝗺𝗻_𝗻𝗮𝗺𝗲).

This is why 𝗖𝗢𝗨𝗡𝗧(*) is generally 𝗽𝗿𝗲𝗳𝗲𝗿𝗿𝗲𝗱 in SQL.

-- Running Avg with time-period :- 
-- AVG(column) OVER (PARTITION BY column 
--                   ORDER BY column 
--                   ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
SELECT user_id, 
       tweet_date, 
       ROUND(
             AVG(tweet_count) OVER (PARTITION BY user_id
                                    ORDER BY tweet_date asc
                                    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
            ,2) rolling_avg_3d 
FROM   tweets
ORDER BY user_id;
/

SELECT * from v$version;
/

SELECT * FROM EMPLOYEE;
SELECT DEPARTMENT, SUM(SALARY) OVER (PARTITION BY DEPARTMENT ORDER BY EMP_ID) SUM_SAL FROM EMPLOYEE;
/


SELECT
  T1.user_id
FROM transactions AS T1 INNER JOIN transactions AS T2
  ON DATE(T2.transaction_date) = DATE(T1.transaction_date) + 1
INNER JOIN transactions AS T3
  ON DATE(T3.transaction_date) = DATE(T1.transaction_date) + 2
WHERE t1.user_id = t2.user_id and t2.user_id = t3.user_id
ORDER BY T1.user_id;
/

-- Last Day & First Day
with ds as (
  select to_date('01-jan-2026', 'dd-MON-yy') dt from dual union all
  select to_date('10-feb-2026', 'dd-MON-yy') dt from dual union all
  select to_date('15-feb-2028', 'dd-MON-yy') dt from dual union all
  select to_date('25-apr-2026', 'dd-MON-yy') dt from dual
)
select dt,
       last_day (dt) LAST_DATE, -- Last Day of the Month
       trunc(dt,'Month') FIRST_DATE -- First Day of the Month
from ds;
/

/*==============================================================================
  Title   : "Trunc" & "Round" (with NUMBER)
==============================================================================*/

SELECT TRUNC(123456.123456, 2) TRUNC_NUM FROM DUAL; -- 123456.12
SELECT TRUNC(123456.123456,-2) TRUNC_NUM FROM DUAL; -- 123400 (Brings to nearest lowest) 


SELECT ROUND(123456.126456,  2) ROUND_NUM FROM DUAL; -- 123456.13
SELECT ROUND(123456.126756,  3) ROUND_NUM FROM DUAL; -- 123456.127
SELECT ROUND(123456.126756, -3) ROUND_NUM FROM DUAL; -- 123000 (Brings to nearest highest)
SELECT ROUND(123500.126756, -3) ROUND_NUM FROM DUAL; -- 124000 (it will check for last 3digit and then raise the number 4th)
SELECT ROUND(126500.126756, -4) ROUND_NUM FROM DUAL; -- 130000 

/*==============================================================================
  Title   : "Trunc" & "Round" (with DATE)
==============================================================================*/

-- DD :- Trunc to start of the day
SELECT TO_CHAR(
                   TRUNC(TO_DATE('16/JAN/2021 03:30:45 PM', 'DD/MON/YYYY HH:MI:SS AM'),'DD')
               , 'DD/MON/YYYY HH:MI:SS AM') AS DT FROM DUAL; -- 16/JAN/2021 12:00:00 AM

-- HH :- Trunc to start of the hour
SELECT TO_CHAR(
                   TRUNC(TO_DATE('16/JAN/2021 03:30:45 PM', 'DD/MON/YYYY HH:MI:SS AM'),'HH')
               , 'DD/MON/YYYY HH:MI:SS AM') AS DT FROM DUAL; -- 16/JAN/2021 03:00:00 PM

-- MI :- Trunc to start of the minute
SELECT TO_CHAR(
                   TRUNC(TO_DATE('16/JAN/2021 03:30:45 PM', 'DD/MON/YYYY HH:MI:SS AM'),'MI')
               , 'DD/MON/YYYY HH:MI:SS AM') AS DT FROM DUAL; -- 16/JAN/2021 03:00:00 PM

-- DAY :- Trunc to start of the day
SELECT TO_CHAR(
                   TRUNC(TO_DATE('16/JAN/2021 03:30:45 PM', 'DD/MON/YYYY HH:MI:SS AM'),'DD')
               , 'DD/MON/YYYY HH:MI:SS AM') AS DT FROM DUAL;

-- DAY :- Trunc to start of the week
SELECT TRUNC(TO_DATE('16/JAN/2021 03:30:45 PM', 'DD/MON/YYYY HH:MI:SS AM'), 'DAY') AS DT FROM DUAL; 

-- MONTH :- Trunc to start of the month
SELECT TRUNC(TO_DATE('16/JAN/2021 03:30:45 PM', 'DD/MON/YYYY HH:MI:SS AM'), 'MONTH') AS DT FROM DUAL; 

-- YEAR :- Trunc to start of the year
SELECT TRUNC(TO_DATE('16/JULY/2021 03:30:45 PM', 'DD/MON/YYYY HH:MI:SS AM'), 'YEAR') AS DT FROM DUAL; 

/*==============================================================================
  Title   : "Round" (with DATE)
==============================================================================*/

-- It does the Round off to next half (Start) if it falls in second half
-- It does the Round off to first half (Start) if it falls in first half

-- YEAR :- Round to start of the year
SELECT ROUND(TO_DATE('16/JULY/2021 03:30:45 PM', 'DD/MON/YYYY HH:MI:SS AM'), 'YEAR') AS DT FROM DUAL; 


----------------------------------------------X----------------------------------------------
----------------------------------------------X----------------------------------------------


/*==============================================================================
  Title   : "FIRST_VALUE() " & "LAST_VALUE()"
==============================================================================*/

-------------------------------------------------------------------------------
-- FIRST_VALUE() :- This is used to get the first value in the partition block
-------------------------------------------------------------------------------

SELECT department_id,
       salary,
       FIRST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary DESC) AS "Highest_Salary_in_Dept"
FROM   employee;

---------------------------------------------------------------------------------------------------------
-- LAST_VALUE() :- (By Default) This is used to get (ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
--                  the last value in the partition block but considering only the rows upto the current row.
--                  To get lowest in the partition block 
--                  We need (ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
----------------------------------------------------------------------------------------------------------

SELECT department_id,
       salary,
       LAST_VALUE(salary) OVER (PARTITION BY department_id ORDER BY salary DESC
                                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS "Lowest_Salary_in_Dept"
FROM   employee;
