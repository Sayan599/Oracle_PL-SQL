/*==============================================================================
  Title   : Pragma AUTONOMOUS_TRANSACTION
==============================================================================*/

-- Pragma AUTONOMOUS_TRANSACTION allows you to execute a transaction independent of the main transaction
-- 1) So if we ROLLBACK the main transaction, the changes made in the autonomous transaction will still be committed
-- 2) This is useful for logging, auditing, or any scenario where 
--    you want to ensure that certain operations are committed regardless of the outcome of the main transaction

----------------------------------------------------------------------------------
-- Note: To put COMMIT or ROLLBACK in a PL/SQL block, we need to use PRAGMA AUTONOMOUS_TRANSACTION  
----------------------------------------------------------------------------------


CREATE TABLE t(
    id NUMBER
);

INSERT INTO t VALUES(1);

DECLARE
    pragma AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO t VALUES(2);
    COMMIT;
END;

INSERT INTO t VALUES(3);

ROLLBACK;

SELECT * FROM t;

------------------------------
-- Usages :- 
------------------------------

-- 1. Error Logging:

PROCEDURE log_error(
    p_log_code INTEGER,
    p_log_mssg VARCHAR2
)
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO log_table
    VALUES(p_log_code, p_log_mssg);
    COMMIT;
END;

BEGIN
   INSERT INTO T VALUES(1);
   INSERT INTO T VALUES(12);
   INSERT INTO T VALUES('$3123');
   
   COMMIT;
EXCEPTION 
   WHEN others THEN
        log_error(SQLCODE, SQLERRM);
        ROLLBACK;   
END;

-- 2. Commit inside Trigger:
-- Note : Inside trigger commit is not possible

CREATE OR REPLACE TRIGGER bf_ins_trg
BEFORE 
INSERT ON t
FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    COMMIT;
END;

-- 3. Cannot perform a DML operation inside a SELECT query:
CREATE OR REPLACE FUNCTION fun_ins
RETURN NUMBER
IS
BEGIN
    INSERT INTO t VALUES(1);
    RETURN 1;
END;

SELECT fun_ins FROM DUAL; -->> This cases ERROR

-- == FIX ==

CREATE OR REPLACE FUNCTION fun_ins
RETURN NUMBER
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO t VALUES(1);
    RETURN 1;
END;

SELECT fun_ins FROM DUAL; -->> This cases ERROR
