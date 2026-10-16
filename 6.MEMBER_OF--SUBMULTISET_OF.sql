SET SERVEROUTPUT ON;
CLEAR SCREEN;

----------------------------------------------------------------------------

-->>> (1) MEMBER OF <<<--
-- 1. It is used to check whether a value is present inside a collection or not. 
-- 2. It is used with Nested Table and VARRAY collection types. [POSSIBLE]
-- 3. It is not used with Associative Array collection type.    [IMPOSSIBLE]

DECLARE
    TYPE T_NUM IS TABLE OF PLS_INTEGER;
    V_NUMS T_NUM := T_NUM(10,20,30);
    
    NUM INTEGER := 10;

BEGIN
    
    IF NUM MEMBER OF V_NUMS THEN
        DBMS_OUTPUT.PUT_LINE('THIS IS PRESENT INSIDE');
    END IF;
END;
/

----------------------------------------------------------------------------