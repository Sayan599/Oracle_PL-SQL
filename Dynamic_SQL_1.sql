EXECUTE IMMEDIATE 'SELECT QUERY'
[BULK COLLECT](more than 1rows) INTO(only for 1row) {variable1, record, collection}
[USING] bind_argument1;

-- We can numeric, character and string as bind_argument1. But we cannot use NULL as bind_arguments

SET SERVEROUTPUT ON;



-->>> (1) EXECUTE IMMEDIATE 
begin
   execute immediate 'GRANT SELECT ON EMPLOYEES TO HR';
end;
/

create or replace procedure proc_create_table (
   p_table_name        in varchar2,
   p_column_defination in varchar2
) is
begin
   execute immediate 'CREATE TABLE '
                     || p_table_name
                     || '('
                     || p_column_defination
                     || ')';
   commit;
   dbms_output.put_line('TABLE '
                        || p_table_name || ' IS CREATED SUCCESSFULLY');
end;
/

create or replace procedure proc_dyna_sql (
   p_sql in varchar2
) is
begin
   execute immediate p_sql;
   dbms_output.put_line('SQL: '
                        || p_sql || ' EXECUTED ');
end;
/



-->>> (2) EXECUTE IMMEDIATE with USING CLAUSE (Bind variables)
CREATE OR REPLACE PROCEDURE PROC_INSERT_EMP(
   P_EMP_ID      IN TEST_TABLE.ID%TYPE,
   P_EMP_NAME    IN TEST_TABLE.NAME%TYPE
)
IS
BEGIN
   EXECUTE IMMEDIATE
      'INSERT INTO TEST_TABLE (ID, NAME) VALUES (:1, :2)'
   USING P_EMP_ID, P_EMP_NAME;

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('EMPLOYEE INSERTED: ' || P_EMP_ID || ', ' || P_EMP_NAME);
END;
/

BEGIN
   PROC_INSERT_EMP(1, 'JOHN DOE');
   PROC_INSERT_EMP(2, 'STEVE SMITH');
END;
/




-->>> (3) EXECUTE IMMEDIATE with "USING" Clause and "RETURNING INTO" Clause
-- It is used with DML (INSERT, UPDATE, DELETE) statements to return values from the affected rows.
DECLARE
   V_NEW_ID TEST_TABLE.ID%TYPE;
BEGIN
   EXECUTE IMMEDIATE
      'INSERT INTO TEST_TABLE (ID, NAME) 
      VALUES (:1, :2) 
      RETURNING ID INTO :3'
      USING 3, 'JOHN'
      RETURNING INTO V_NEW_ID;
   
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('NEWLY INSERTED EMPLOYEE ID: ' || V_NEW_ID);
END;
/

DECLARE
   V_EMP_NAME TEST_TABLE.NAME%TYPE;
BEGIN
   EXECUTE IMMEDIATE
      'DELETE FROM TEST_TABLE 
      WHERE ID = :1 
      RETURNING NAME INTO :2' 
       USING 2
      RETURNING INTO V_EMP_NAME;

   COMMIT;
   DBMS_OUTPUT.PUT_LINE('DELETED EMPLOYEE NAME: ' || V_EMP_NAME);
END;

