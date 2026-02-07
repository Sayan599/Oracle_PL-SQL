-- Parallel Processing Hint Example
-- This example demonstrates how to use the PARALLEL hint in a SQL query
-- to improve performance by enabling parallel execution.

Syntax :-
-- /*+ Hint */

-- ==============================================================================
--   Title   : /*+ APPEND */
-- ==============================================================================

------------------------------
-- DML only
-- This works with INSERT statements to enable direct-path inserts.
-- This will not verify the watermark space[created by deleted rows] and will
-- insert data in new spaces only.
-- It improves performance for large data loads. But costs memory.
------------------------------

INSERT /*+ APPEND */ INTO employees_backup
SELECT * FROM employees;

-- ==============================================================================
--   Title   : nologging
-- ==============================================================================

------------------------------
-- used only in any DDL operation
-- This will avoid generating any logs for any DML operation.
------------------------------

explain plan :-
    SELECT * FROM DBMS_XPLAN.DISPLAY();

-- To check the cpu_count parameter for parallel execution

SELECT value
  FROM v$parameter
 WHERE name = 'cpu_count';

-- ==============================================================================
--   Title   : /*+ PARALLEL (table_alias, degree) */
-- ==============================================================================

------------------------------
-- This hint is used to enable parallel execution for a specific table in a query.
-- Degree = no. of servers to be used 
-- Recommended to set degree to cpu_count/2 or cpu_count
------------------------------

EXPLAIN PLAN FOR
SELECT *
  FROM employee e
 WHERE e.department = 'Sales';

EXPLAIN PLAN FOR
SELECT /*+ PARALLEL(e, 4) */ *
  FROM employee e
 WHERE e.department = 'Sales';

SPOOL 'plan_output.txt';
SELECT /*+ PARALLEL(e, 4) */ *
  FROM employee e
 WHERE e.department = 'Sales';
SPOOL OFF;