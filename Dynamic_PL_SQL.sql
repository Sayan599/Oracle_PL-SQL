-->>> Dynamic PLSQL 

----------------------------------------------------------------------------

--: Rules and Regulations :-
-- 1) It should be a valid PL/SQL block
-- 2) It should finish with a semicolon (;)
-- 3) It can access only global objects
-- 4) We can't use EXCEPTION block in it
-- 5) We can only use OUT bind variables only in Dynamic PLSQL block

----------------------------------------------------------------------------

   SET SERVEROUTPUT ON;
begin
   for emp in (
      select *
        from employee
   ) loop
      dbms_output.put_line(emp.first_name
                           || ' ' || emp.last_name);
   end loop;
end;
/

----------------------------------------------------------------------------

-->>> (1) Simple Dynamic PLSQL
declare
   v_dynamic_sql varchar2(2000);
begin
   v_dynamic_sql := q'[BEGIN
                         FOR EMP IN (SELECT * FROM EMPLOYEE) LOOP
                             DBMS_OUTPUT.PUT_LINE(EMP.FIRST_NAME || ' ' || EMP.LAST_NAME);
                         END LOOP;
                       END;]';
   execute immediate v_dynamic_sql;
end;
/
----------------------------------------------------------------------------

-->>> (2) with "local" variable declaration

declare
   v_dynamic_sql varchar2(2000);
    -- Cannot use inside dynamic PLSQL
    -- v_dept_name   VARCHAR2(200) := 'Finance'; 
begin
   v_dynamic_sql := q'[DECLARE
                            v_dept_name   VARCHAR2(200) := 'Finance';
                       BEGIN
                            FOR EMP IN (SELECT * FROM EMPLOYEE WHERE department = v_dept_name) LOOP
                                DBMS_OUTPUT.PUT_LINE(EMP.FIRST_NAME || ' ' || EMP.LAST_NAME);
                            END LOOP;
                       END;]';
   execute immediate v_dynamic_sql;
end;
/

----------------------------------------------------------------------------

-->>> (3) with "global" variables (Pks)

create or replace package pkg_temp as
   v_deptment_id_pkg varchar2(200) := 'Finance';
end pkg_temp;
/

declare
   v_dynamic_sql varchar2(2000);
begin
   v_dynamic_sql := q'[BEGIN
                            FOR EMP IN (SELECT * FROM EMPLOYEE WHERE department = pkg_temp.v_deptment_id_pkg) LOOP
                                DBMS_OUTPUT.PUT_LINE(EMP.FIRST_NAME || ' ' || EMP.LAST_NAME);
                            END LOOP;
                       END;]';
   execute immediate v_dynamic_sql;
end;
/

----------------------------------------------------------------------------

-->>> (4) with bind variables

declare
   v_dynamic_sql varchar2(2000);
   v_dept_name   varchar2(200) := 'Finance';
begin
   v_dynamic_sql := q'[BEGIN
                            FOR EMP IN (SELECT * FROM EMPLOYEE WHERE department = :1) LOOP
                                DBMS_OUTPUT.PUT_LINE(EMP.FIRST_NAME || ' ' || EMP.LAST_NAME);
                            END LOOP;
                       END;]';
   execute immediate v_dynamic_sql
      using v_dept_name;
end;
/

----------------------------------------------------------------------------

-->>> (5) with OUT bind variables

declare
   v_dynamic_sql varchar2(2000);
   v_dept_name   varchar2(200) := 'Finance';
   v_max_salary  number := 0;
begin
   v_dynamic_sql := q'[BEGIN
                            FOR EMP IN (SELECT * FROM EMPLOYEE WHERE department = :1) LOOP
                                IF emp.salary > :2 THEN
                                      :2 := emp.salary;
                                  END IF;
                            END LOOP;
                       END;]';
   execute immediate v_dynamic_sql
      using v_dept_name,in out v_max_salary;
   dbms_output.put_line('Max Salary in '
                        || v_dept_name
                        || ' Department is: ' || v_max_salary);
end;
/

----------------------------------------------------------------------------

-->>> (6) with Exception Catching
-- We cannot use EXCEPTION block in Dynamic PLSQL block
-- We have to catch exception in the Main block

declare
   v_dynamic_sql varchar2(2000);
   v_dept_name   varchar2(200) := 'Finance';
begin
   v_dynamic_sql := q'[BEGIN
                            FOR EMP IN (SELECT * FROM EMPLOYEE WHERE departme = :1) LOOP
                                DBMS_OUTPUT.PUT_LINE(EMP.FIRST_NAME || ' ' || EMP.LAST_NAME);
                            END LOOP;
                       END;]';
   execute immediate v_dynamic_sql
      using v_dept_name;
exception
   when others then
      dbms_output.put_line('Error Occurred: ' || sqlerrm);
end;
/