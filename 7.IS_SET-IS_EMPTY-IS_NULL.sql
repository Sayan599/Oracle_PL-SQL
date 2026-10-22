SET SERVEROUTPUT ON;
CLEAR SCREEN;
----------------------------------------------------------------------------

-- >>> (1) [IS A SET] <<< --
-- 1. It is used to check whether a collection is a set or not.
-- 2. It checks duplicates.
-- 3. It is used with Nested Table. [POSSIBLE]
-- 4. It is not used with Associative Array & VARRAY collection types.    [IMPOSSIBLE]

DECLARE
    TYPE T_NUM IS TABLE OF INTEGER;
    V_NUMS T_NUM := T_NUM(10, 20, 30, 30);

BEGIN
    IF V_NUMS IS A SET THEN
        DBMS_OUTPUT.PUT_LINE('This is a SET collection');
    ELSE
        DBMS_OUTPUT.PUT_LINE('This is NOT a SET collection');
    END IF;
END;
/

-- OUTPUT : This is NOT a SET collection

----------------------------------------------------------------------------

-- >>> (2) [IS EMPTY] <<< --
-- 1. It is used to check whether a collection is empty or not.
-- 2. It checks the number of elements.
-- 3. It is used with all collection types. [POSSIBLE]
-- 4. It is not used with Associative Array & VARRAY collection types.    [IMPOSSIBLE]

DECLARE
    TYPE T_NUM IS TABLE OF INTEGER;
    V_NUMS T_NUM := T_NUM(10, 20, 30, 30);

BEGIN
    V_NUMS.DELETE; -- deletes all elements
    IF V_NUMS IS EMPTY THEN
        DBMS_OUTPUT.PUT_LINE('This collection is empty');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('This collection is not empty');    
    END IF;
END;
/

-- OUTPUT : This collection is empty

----------------------------------------------------------------------------

-- >>> (3) [IS NULL] <<< --
-- 1. It is used to check whether a collection is null or not.
-- 2. It checks the collection variable is initialized or not.
-- 3. It is used with Nested Table & VARRAY. [POSSIBLE]

DECLARE
    TYPE T_NUM IS VARRAY(5) OF INTEGER;
    V_NUMS T_NUM;

BEGIN
    IF V_NUMS IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('This collection is NULL');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('This collection is not NULL');    
    END IF;
END;
/

----------------------------------------------------------------------------

