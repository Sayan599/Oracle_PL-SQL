/*
    Context Switching :-
    There are two engines PLSQL Engine and SQL Engine.
    1. When we run a PLSQL block
    2. When it encounters a PLSQL block, PLSQL Engine handles
    3. When it encounters a SQL block, PLSQL Engine handover to SQL Engine
    4. Value is returned to PLSQL Engine
    5. This continues..

    Between PLSQL Engine and SQL Engine :-
    PLSQL Engine --- Context Switch --- SQL Engine


*/

-- Techniques :-
1. FORALL 
2. BULK COLLECT 

-- Before
-- Example using BULK COLLECT INTO collection :-
DECLARE
    TYPE tt_nest_tab_type IS TABLE OF postal_code%ROWTYPE;
    lv_nest_tab            tt_nest_tab_type := tt_nest_tab_type();

    lv_postal_code_rec     postal_code%ROWTYPE;
BEGIN
    FOR i IN (SELECT * FROM postal_code) LOOP
        lv_postal_code_rec.postoffice_name := i.postoffice_name;
        lv_postal_code_rec.pincode := i.pincode;
        lv_postal_code_rec.district_name := i.district_name;
        lv_postal_code_rec.city := i.city;
        lv_postal_code_rec.state := i.state;

        lv_nest_tab.EXTEND;
        lv_nest_tab(lv_nest_tab.LAST) := lv_postal_code_rec;

    END LOOP;
END;
/

-- After
DECLARE
    TYPE tt_nest_tab_type IS TABLE OF postal_code%ROWTYPE;
    lv_nest_tab            tt_nest_tab_type := tt_nest_tab_type();

BEGIN
    SELECT * 
    BULK COLLECT INTO lv_nest_tab
    FROM postal_code;
END;

