/*
    FORALL (In-Bind):-
    It is used to insert data from Collection -> Insert INTO Table
*/

Limitations:-
1. Must not have 'LOOP', 'END LOOP' keywords
2. Only one Statement must be there 


Statement :- 
Write a PLSQL block to load all employee info from Collection into EMP_BKP Table


Select * FROM employee; -- 100rows
Select * from employee_bkp; -- 0 rows

-- USING FOR loop
-- Added line
