SET SERVEROUTPUT ON;
CLEAR SCREEN;
----------------------------------------------------------------------------

-- >>> (1) [ Implicit Cursor ] <<< --
-- 1. SQL% ISOPEN
-- 2. SQL% FOUND
-- 3. SQL% NOTFOUND
-- 4. SQL% ROWCOUNT

BEGIN
    UPDATE employee
    SET salary = salary + 1000
    WHERE emp_id = 100;

    -- 1. SQL%FOUND
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('FOUND: At least one row affected');
    END IF;

    -- 2. SQL%NOTFOUND
    IF SQL%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('NOTFOUND: No rows affected');
    END IF;

    -- 3. SQL%ISOPEN
    IF SQL%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('ISOPEN: Cursor is open');
    ELSE
        DBMS_OUTPUT.PUT_LINE('ISOPEN: Cursor is closed');
    END IF;

    -- 4. SQL%ROWCOUNT
    DBMS_OUTPUT.PUT_LINE('ROWCOUNT: ' || SQL%ROWCOUNT);

    ROLLBACK;
END;
/

-- FOUND: At least one row affected
-- ISOPEN: Cursor is closed
-- ROWCOUNT: 1

----------------------------------------------------------------------------

-- >>> (2) [ Explicit Cursor ] <<< --
-- 1. Explicit cursors are declared in the declarative part.

DECLARE
    CURSOR c_emps IS
        SELECT emp_id, first_name, last_name, salary
        FROM employee
        FETCH FIRST 5 ROWS ONLY;

BEGIN
    FOR rec IN c_emps LOOP
        DBMS_OUTPUT.PUT_LINE(rec.emp_id || ' ' || rec.first_name || ' ' || rec.last_name || ' ' || rec.salary);
    END LOOP;
END;
/

----------------------------------------------------------------------------

-- >>> (1) [ Parametrized Cursor ] <<< --
-- 1. Parametrized cursors are declared in the declarative part
-- 2. Parametrized cursors are used to pass parameters to the cursor.

DECLARE
    CURSOR c_emps(p_dept_name VARCHAR2) IS
        SELECT *
        FROM employee
        WHERE department = p_dept_name
        FETCH FIRST 5 ROWS ONLY;

    v_emp c_emps%ROWTYPE;
BEGIN
    OPEN c_emps('Sales');
    LOOP
        EXIT WHEN c_emps%NOTFOUND;
        FETCH c_emps INTO v_emp;
        DBMS_OUTPUT.PUT_LINE(v_emp.emp_id || ' ' || v_emp.first_name || ' ' || v_emp.last_name || ' ' || v_emp.department);
    END LOOP;
    
    IF c_emps%ISOPEN THEN
        CLOSE c_emps;
    END IF;
END;
/

----------------------------------------------------------------------------

-- >>> (4) [ Ref Cursor - Weak Cursor ] <<< --
-- 1. Does not specify a return row structure at declaration time.
-- 2. We need only FETCH cursor.
-- 3. FOR loop doesnt works as it is a weak cursor.

DECLARE
    TYPE ref_cursor IS REF CURSOR;
    v_ref ref_cursor;

    rec employee%ROWTYPE;

BEGIN
    OPEN v_ref FOR
        SELECT *
        FROM employee
        WHERE department = 'Sales'
        FETCH FIRST 5 ROWS ONLY;

    LOOP
        EXIT WHEN v_ref%NOTFOUND;
        FETCH v_ref INTO rec;

        DBMS_OUTPUT.PUT_LINE(rec.emp_id || ' ' || rec.first_name || ' ' || rec.last_name || ' ' || rec.department);
    END LOOP;

END;
/

----------------------------------------------------------------------------

-- >>> (5) [ Strong Cursor ] <<< --

-- 1. Its return row structure is specified when the type is declared.
-- 2. The query must return a row structure compatible with employees%ROWTYPE.
-- 3. We can use FOR loop.

DECLARE
    TYPE ref_cursor IS REF CURSOR RETURN employee%ROWTYPE;
    v_ref ref_cursor;

BEGIN
    OPEN v_ref FOR
        SELECT * FROM employee
        WHERE department = 'Sales'
        FETCH FIRST 5 ROWS ONLY;
    
    FOR rec IN v_ref LOOP
        DBMS_OUTPUT.PUT_LINE(rec.emp_id || ' ' || rec.first_name || ' ' || rec.last_name || ' ' || rec.department);
    END LOOP;
END;
/

----------------------------------------------------------------------------

-- >>> (6) [ FOR UPDATE Loop ] <<< --
-- FOR UPDATE tells Oracle: “lock these rows so no one else can change them while I am updating them”
-- Lock gets released when we COMMIT or ROLLBACK.
-- CURRENT OF c_emps means: update the row that the cursor is currently pointing to

DECLARE
    CURSOR c_emps IS 
    
        SELECT emp_id, first_name, last_name, salary
        FROM employee
        WHERE department = 'Sales'
        AND salary > 70000
        FOR UPDATE;

    v_emp_id employee.emp_id%TYPE;
    v_salary employee.salary%TYPE;

BEGIN

    FOR rec IN c_emps LOOP
        
        IF rec.salary > 70000 THEN
            UPDATE employee
            SET salary = salary + 1000
            WHERE CURRENT OF c_emps;
        END IF;

    END LOOP;

    COMMIT;
END;
/

----------------------------------------------------------------------------