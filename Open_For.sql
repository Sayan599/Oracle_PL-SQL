-->>> Open For Statement in Dynamic SQL <<<--

----------------------------------------------------------------------------

--: Rules and Regulations :-
-- 1) It is same as we use Open For in PL/SQL cursor.
-- 2) It is just we can do some string concatenation
-- 3) It can also use Bind Variables.

----------------------------------------------------------------------------

-->>> (1) Simple "Open For"
set SERVEROUTPUT on;
DECLARE
    emp_cursor SYS_REFCURSOR;
    v_first_name EMPLOYEE.FIRST_NAME%TYPE;
    v_last_name EMPLOYEE.LAST_NAME%TYPE;
    v_emp_record EMPLOYEE%ROWTYPE;
BEGIN
    OPEN emp_cursor FOR 'SELECT * FROM EMPLOYEE';
        FETCH emp_cursor INTO v_emp_record;
        dbms_output.put_line(v_emp_record.first_name || ' ' || v_emp_record.last_name);
    CLOSE emp_cursor;
END;
/

----------------------------------------------------------------------------

-->>> (2) Open For "with Bind Variable"
set SERVEROUTPUT on;
DECLARE
    emp_cursor   SYS_REFCURSOR;
    v_dept_name  EMPLOYEE.DEPARTMENT%TYPE := 'Finance';
    v_emp_record EMPLOYEE%ROWTYPE;
    v_tab_name   VARCHAR2(30) := 'EMPLOYEE';
BEGIN
    OPEN emp_cursor FOR 'SELECT * FROM ' || v_tab_name ||  ' WHERE DEPARTMENT = :1' 
    USING v_dept_name;

    LOOP
        FETCH emp_cursor INTO v_emp_record;

        IF emp_cursor%NOTFOUND THEN
            EXIT;
        END IF;

        dbms_output.put_line(v_emp_record.first_name || ' ' || v_emp_record.last_name);
    END LOOP;

    CLOSE emp_cursor;
END;
/

----------------------------------------------------------------------------
