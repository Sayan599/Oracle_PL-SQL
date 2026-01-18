/*
    BULK COLLECT (Define) or OPEN/ FETCH/ BULK COLLECT:-
    This is used to store the result from SQL --> Collection
*/

/*
    DBMS_UTILITY.GET_TIME :-
    This is used to capture the start time and end time of any code;

    eg :-
    
        v_start := DBMS_UTILITY.GET_TIME;
            -- your code
        v_end   := DBMS_UTILITY.GET_TIME;

        elapsed := (v_end - v_start) ;  
*/

Select first_name || ' ' || last_name name From Employee;
/

-- Traditional Way (Old)
SET SERVEROUTPUT ON;
DECLARE
    TYPE t_emp_type IS TABLE OF VARCHAR2(200);
    v_emp_coll t_emp_type := t_emp_type();

    CURSOR c_emp_name 
    IS SELECT first_name || ' ' || last_name name From Employee;

    v_start NUMBER;
    v_end   NUMBER;
BEGIN
    v_start := DBMS_UTILITY.GET_TIME; 
    FOR rec IN c_emp_name LOOP
        v_emp_coll.EXTEND;
        v_emp_coll(v_emp_coll.LAST) := rec.name;
    END LOOP;
    v_end   := DBMS_UTILITY.GET_TIME;

    DBMS_OUTPUT.PUT_LINE('Total Time Taken -> ' || (v_end - v_start));

    FOR I IN v_emp_coll.FIRST .. v_emp_coll.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_coll(i));
    END LOOP;
END;
/


-- Using BULK COLLECT INTO (Performance Improved) (New) 
DECLARE
    TYPE t_emp_type IS TABLE OF VARCHAR2(200);
    v_emp_coll t_emp_type := t_emp_type();

    CURSOR c_emp_name 
    IS SELECT first_name || ' ' || last_name name FROM EMPLOYEE;

    v_start INTEGER;
    v_end   INTEGER;
BEGIN
    DBMS_OUTPUT.PUT_LINE(q'[Using 'BULK COLLECT INTO' Way ->>]');

    v_start := DBMS_UTILITY.GET_TIME;
    OPEN c_emp_name;
    FETCH c_emp_name BULK COLLECT INTO v_emp_coll;
    CLOSE c_emp_name;
    v_end   := DBMS_UTILITY.GET_TIME;

    DBMS_OUTPUT.PUT_LINE('Total Time Taken ->> ' || (v_end - v_start));

    FOR i IN v_emp_coll.FIRST .. v_emp_coll.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(v_emp_coll(i));
    END LOOP;
END;
/