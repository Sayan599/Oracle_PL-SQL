Oracle 19c process :-

SET SERVEROUTPUT ON;
DECLARE
    TYPE ty_emp_list IS TABLE OF VARCHAR2(10);
    v_emp_list ty_emp_list := ty_emp_list();
BEGIN
    v_emp_list.EXTEND(4);
    v_emp_list(1) := 'Ravi';
    v_emp_list(2) := 'Divya';
    v_emp_list(3) := 'Kavin';
    v_emp_list(4) := 'Lokesh';

/*  1 - 'Ravi'
    2 - 'Divya'
    3 - 'Kavin'
    4 - 'Lokesh'
*/

    v_emp_list.DELETE(3); -- Delete 3rd index

/*  1 - 'Ravi'
    2 - 'Divya'

    4 - 'Lokesh'
*/ -- only varrays are re-indexed
 
    FOR i IN v_emp_list.FIRST .. v_emp_list.LAST LOOP
        IF v_emp_list.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(v_emp_list(i));
        END IF;
    END LOOP;
END;

Oracle 21c process :-

1. ``` indices of ``` :- 
This gives the indices of the elements in the collection.

SET SERVEROUTPUT ON;
DECLARE
    TYPE ty_emp_list IS TABLE OF VARCHAR2(10);
    v_emp_list ty_emp_list := ty_emp_list();
BEGIN
    v_emp_list.EXTEND(4);
    v_emp_list(1) := 'Ravi';
    v_emp_list(2) := 'Divya';
    v_emp_list(3) := 'Kavin';
    v_emp_list(4) := 'Lokesh';

/*  1 - 'Ravi'
    2 - 'Divya'
    3 - 'Kavin'
    4 - 'Lokesh'
*/
    v_emp_list.DELETE(3); -- Delete 3rd index

/*  1 - 'Ravi'
    2 - 'Divya'

    4 - 'Lokesh'
*/
    FOR i IN indices of v_emp_list LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;

    /* Output:
    1
    2
    4
    */ 
END;

2. ``` values of ``` :-
This gives the values of the elements in the collection.

SET SERVEROUTPUT ON;
DECLARE
    TYPE ty_emp_list IS TABLE OF VARCHAR2(10);
    v_emp_list ty_emp_list := ty_emp_list();
BEGIN
    v_emp_list.EXTEND(4);
    v_emp_list(1) := 'Ravi';
    v_emp_list(2) := 'Divya';
    v_emp_list(3) := 'Kavin';
    v_emp_list(4) := 'Lokesh';

/*  1 - 'Ravi'
    2 - 'Divya'
    3 - 'Kavin'
    4 - 'Lokesh'
*/
    v_emp_list.DELETE(3); -- Delete 3rd index

/*  1 - 'Ravi'
    2 - 'Divya'

    4 - 'Lokesh'
*/
    FOR i IN values of v_emp_list LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;

    /* Output:
    Ravi
    Divya
    Lokesh    
    */

END;

3. ``` pairs of ``` :-
This gives both indices and values of the elements in the collection.

SET SERVEROUTPUT ON;
DECLARE
    TYPE ty_emp_list IS TABLE OF VARCHAR2(10);
    v_emp_list ty_emp_list := ty_emp_list();
BEGIN
    v_emp_list.EXTEND(4);
    v_emp_list(1) := 'Ravi';
    v_emp_list(2) := 'Divya';
    v_emp_list(3) := 'Kavin';
    v_emp_list(4) := 'Lokesh';

/*  1 - 'Ravi'
    2 - 'Divya'
    3 - 'Kavin'
    4 - 'Lokesh'
*/
    v_emp_list.DELETE(3); -- Delete 3rd index

/*  1 - 'Ravi'
    2 - 'Divya'

    4 - 'Lokesh'
*/
    FOR i, j IN pairs of v_emp_list LOOP
        DBMS_OUTPUT.PUT_LINE(i || ' - ' || j);
    END LOOP;

    /* Output:
    1 - Ravi
    2 - Divya
    4 - Lokesh
    */
END;
