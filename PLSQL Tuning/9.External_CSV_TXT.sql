/*==============================================================================
  Title   : External Tables
==============================================================================*/

-- External tables allow you to query data stored in external files (like CSV or TXT) 
-- as if they were regular database tables. 
-- This is particularly useful for loading large datasets without having to import them into the database first.

----------------------------------------------------------------------------------

-- STEP 1: Create a directory object in Oracle
-- This directory object points to the location on the server
CREATE OR REPLACE DIRECTORY ext_dir 
AS 'C:\Users\SANDIPAN KAR\Desktop\Java\Dynamic_SQL\External_Temp';

-- CHECK (if created)
SELECT * FROM dba_directories
where directory_name = 'EXT_DIR';

DROP TABLE emp_tab; -- Drop if already exists

-- STEP 2: Create an external table that references the CSV file
CREATE TABLE emp_tab (
    empno NUMBER,
    ename VARCHAR2(50),
    hiredate DATE,
    deptno NUMBER
)
ORGANIZATION EXTERNAL (
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_dir
    ACCESS PARAMETERS (
        RECORDS DELIMITED BY NEWLINE
        SKIP 1 -- Skip header row
        FIELDS TERMINATED BY ','
        MISSING FIELD VALUES ARE NULL
    )
    LOCATION ('emp_dept10.txt')
)
REJECT LIMIT UNLIMITED;
/

SELECT * FROM emp_tab
where DEPTNO = 10;
/

-- TO check if the tables is created as external or not
SELECT table_name, external
FROM DBA_TABLES
WHERE TABLE_NAME = 'EMP_TAB';

-- To check the details of the external table 
SELECT * 
FROM DBA_EXTERNAL_TABLES
WHERE TABLE_NAME = 'EMP_TAB';

-- To check the files associated with the external table
SELECT * 
FROM DBA_EXTERNAL_LOCATIONS
WHERE TABLE_NAME = 'EMP_TAB';