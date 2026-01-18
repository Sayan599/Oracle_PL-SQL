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
