SET SERVEROUTPUT ON;
CLEAR SCREEN;
----------------------------------------------------------------------------

-- >>> (1) [ SET() ] <<< --
-- 1. It is used to elimiate duplicates from a collection.
-- 2. It works with Integer & VARCHAR2.
-- 3. It is only used with Nested Table.
-- 4. It is cannot be used with Associative Array & VARRAY. [NOT POSSIBLE]


DECLARE
    TYPE T_CHAR IS TABLE OF VARCHAR2(100);
    V_CHARS T_CHAR := T_CHAR('Sayan', 'Rahul', 'Sayan', 'Rohit');


    N INTEGER;
BEGIN
    V_CHARS := SET(V_CHARS);
    N := V_CHARS.FIRST;

    LOOP
        EXIT WHEN N IS NULL;
        DBMS_OUTPUT.PUT_LINE(V_CHARS(N));
        N := V_CHARS.NEXT(N);
        
    END LOOP;

END;
/