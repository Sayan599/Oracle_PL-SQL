/*==============================================================================
  Title   : Extract values from DATE
==============================================================================*/

------------------------------
-- Day Components from Date
------------------------------

-- 'D' :- Returns the day of the week (1 to 7)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'D') FROM DUAL;

-- 'DD' :- Returns the day of the month (01 to 31)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD') FROM DUAL;

-- 'DDD' :- Returns the day of the year (001 to 366)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'DDD') FROM DUAL;

-- 'DY' :- Returns the Name of the day - Abbrv. (SUN TO SAT)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'DY') FROM DUAL;

-- 'DAY' :- Returns the Name of the day - Fullform (Sunday TO Saturday)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'DAY') FROM DUAL;

------------------------------
-- Month Components from Date
------------------------------

-- 'MM' :- Returns the month of the year (01 to 12)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'MM') FROM DUAL;

-- 'MON' :- Returns the Name of the month - Abbrv. (JAN TO DEC)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'MON') FROM DUAL;

-- 'MONTH' :- Returns the Name of the month - Fullform (JANUARY TO DECEMBER)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'MONTH') FROM DUAL;

-- 'RM' :- Returns the Roman numeral month (I to XII; January = I)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'RM') FROM DUAL;

------------------------------
-- Year Components from Date
------------------------------

-- 'YYYY' :- Returns the 4-digit year
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY') FROM DUAL;

-- 'YY' :- Returns the last 2 digits of the year
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YY') FROM DUAL;

-- 'YEAR' :- Returns the Year spelled out
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YEAR') FROM DUAL;

-- 'CC' :- Returns the Century (2-digit)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'CC') FROM DUAL;

------------------------------
-- Week Components from Date
------------------------------

SELECT SYSDATE, TO_CHAR(SYSDATE, 'W') AS "Week of Month", -- (1 to 7 First Week; 8 to 14 Second Week; etc.)
                TO_CHAR(SYSDATE, 'WW') AS "Week of Year",  -- (1 to 52/53)
                TO_CHAR(SYSDATE, 'IW') AS "ISO Week of Year" -- (1 to 52/53, ISO Standard)
FROM DUAL;

------------------------------
-- Time Components from Date
------------------------------

-- 'HH' :- Returns the hour of the day (01 to 12)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'HH')   AS "Hour (12-hour)" FROM DUAL;

-- 'HH12' :- Returns the hour of the day (01 to 12)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'HH12') AS "Hour (12-hour)" FROM DUAL;

-- 'HH24' :- Returns the hour of the day (00 to 23)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'HH24') AS "Hour (24-hour)" FROM DUAL;

-- 'MI' :- Returns the minutes (00 to 59)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'MI') AS "Minutes" FROM DUAL;

-- 'SS' :- Returns the seconds (00 to 59)
SELECT SYSDATE, TO_CHAR(SYSDATE, 'SS') AS "Seconds" FROM DUAL;

-- 'TS' :- Returns the Time Stamp (HH12:MI:SS AM) or Time Stamp
SELECT SYSDATE, TO_CHAR(SYSDATE + INTERVAL '5' HOUR , 'TS') FROM DUAL;

-- 'AM' / 'PM' :- Returns the Meridian indicator without periods
SELECT SYSDATE, TO_CHAR(SYSDATE + INTERVAL '5' HOUR , 'AM') FROM DUAL;

-- 'DL' :- Returns full date in letters
SELECT SYSDATE, TO_CHAR(SYSDATE + INTERVAL '5' HOUR , 'DL') FROM DUAL;

-- 'DS' :- Returns full date in numbers
SELECT SYSDATE, TO_CHAR(SYSDATE + INTERVAL '5' HOUR , 'DS') FROM DUAL;

