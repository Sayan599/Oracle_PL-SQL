CREATE TABLE EMP_SOURCE
(
    EMPNO INTEGER,
    ENAME VARCHAR2(200),
    SAL INTEGER
);

INSERT INTO EMP_SOURCE
SELECT 1, 'RAVI', 1000 FROM dual UNION ALL
SELECT 2, 'RAGHU', 2000 FROM dual UNION ALL
SELECT 3, 'PRIYA', 3000 FROM dual UNION ALL
SELECT 4, 'KAVIN', 4000 FROM dual;

COMMIT;

SELECT * FROM EMP_SOURCE;
SELECT * FROM EMP_TARGET;
/

DELETE FROM EMP_TARGET where EMPNO = 5;

MERGE INTO emp_target T
USING (SELECT * FROM emp_source) S
ON (T.empno = S.empno)

WHEN NOT MATCHED THEN
    INSERT 
    VALUES (S.empno, S.ename, S.sal);
/

UPDATE EMP_SOURCE
SET SAL = 3500
WHERE EMPNO = 3;

INSERT INTO EMP_SOURCE
SELECT 5, 'SUMAN', 5000 FROM DUAL;
/

-- Using 'Merge' statement :
MERGE INTO emp_target T
USING emp_source S
   ON (T.empno = S.empno)
 WHEN matched THEN
      UPDATE 
      SET sal = S.sal
 WHEN not matched THEN
      INSERT
      VALUES (S.empno,
              S.ename,
              S.sal);
/

MERGE INTO emp_source S
USING emp_target T
ON (S.empno = T.empno)
WHEN MATCHED THEN
DELETE WHERE S.empno = T.empno;
/


MERGE INTO emp_target T
USING emp_source S
   ON (T.empno = S.empno)
 WHEN matched THEN
      UPDATE 
      SET sal = S.sal
      DELETE
      WHERE S.resigned = 'Y'
 WHEN not matched THEN
      INSERT
      VALUES (S.empno,
              S.ename,
              S.sal);