-->>> Oracle Supplied Packages <<<-- 

----------------------------------------------------------------------------

-- Some Common Packages in Oracle :- 
-- 1. STANDARD = DECODE, NVL, NULLIF, etc. We dont need to explicitly use this pkg name
-- 2. DBMS_OUTPUT = Used to debug 
-- 3. UTL_FILE = Used to read and write OS files from DB server
-- 4. DBMS_MAIL = Used to send emails from the DB server
-- 5. DBMS_SCHEDULER = Used to schedule jobs
-- 6. DBMS_STATS = Used to gather optimizer statistics
-- 7. DBMS_LOB = Used to manipulate LOBs

----------------------------------------------------------------------------

-->>> (1) DBMS_OUTPUT Package <<<--
-- used to display output to debug PL/SQL code
-- Different Procedure present in this Pkg :-
-- 1. PUT = This is used to print output without a new line (32767 chars max)
-- 2. PUT_LINE = This is used to print output with a new line (32767 chars max)
-- 3. NEW_LINE = This is used to print new line 

-- Procedure to get line from buffer
-- 1. GET_LINE(line OUT VARCHAR2, status OUT INTEGER) = Get the current line of text from the buffer
-- 2. GET_LINES(lines OUT VARCHAR2, numlines IN INTEGER, status OUT INTEGER) = Get the current lines of text (multiple lines) from the buffer

SET SERVEROUTPUT ON;
DECLARE
    v_buffr VARCHAR2(32767);
    v_status INTEGER;
BEGIN
    DBMS_OUTPUT.PUT('Hello'); -- To print text (without new line)
    DBMS_OUTPUT.NEW_LINE; -- To print only new line
    DBMS_OUTPUT.PUT_LINE('Hello World!'); -- To print text (with new line)
END;
/

----------------------------------------------------------------------------

-->>> (2) UTL_FILE Package <<<--
-- (i)   Used to read and write OS files from DB server
-- (ii)  Before using this pkg, we need to create a Directory Object in Oracle which points to an OS path
-- (iii) It reads and writes to any OS files that are accessible to the Oracle DB server
-- (iv)  UTL_FILE opearates on the paths specified in the UTL_FILE_DIR parameter
-- Ex:- UTL_FILE_DIR = C:\My_files

-- Better approach :-
-- Create a DB Directory alias for specific OS path
-- The database doesnt check whether the OS path exists or not.
-- It just inserts a record in the DBA_DIRECTORIES view.
-- Ex:- CREATE OR REPLACE DIRECTORY my_dir AS 'C:\My_files';

-- Privileges needed to access the directory
-- Ex:- GRANT WRITE ON my_dir TO scott; (to write files)
-- Ex:- GRANT READ ON my_dir TO scott;  (to read files)

-- : UTL_FILE Procedures :-
-- 1) UTL_FILE.FOPEN(directory    IN VARCHAR2,  (directory alias created in Oracle)
--          filename     IN VARCHAR2,  (filename without path)
--          open_mode    IN VARCHAR2,  (w = write, r = read, a = append)
--          max_linesize IN BINARY_INTEGER DEFAULT NULL) 
--    RETURN FILE_TYPE;
--   file_type = Type file_type is record (id       binary_integer,
--                                         datatype binary_integer,
--                                         mode     binary_integer)    

-- 2) UTL_FILE.IS_OPEN(file IN FILE_TYPE) RETURN BOOLEAN;
-- 3) UTL_FILE.FCLOSE(file IN FILE_TYPE);
-- 4) UTL_FILE.FCLOSE_ALL;


-- Some other useful procedures :-

-- 1) UTL_FILE.GET_LINE(file   IN  FILE_TYPE,
--                      buffer OUT VARCHAR2,
--                      length IN  BINARY_INTEGER DEFAULT NULL);
-- This procedure reads a line of text from the file
-- It reads line until a newline character and goes to the next line
-- At very end of file, it raises "NO_DATA_FOUND" exception

CREATE OR REPLACE DIRECTORY my_dir AS 'C:\Users\SANDIPAN KAR\Desktop\Java\Dynamic_SQL';
SELECT * FROM DBA_DIRECTORIES;

SET SERVEROUTPUT ON;
DECLARE
    f_file UTL_FILE.FILE_TYPE;
    f_buffer VARCHAR2(32767);
    i INTEGER := 1;
BEGIN
    f_file := UTL_FILE.FOPEN('MY_DIR', 'temp file.txt', 'r', 32767);
    LOOP
        UTL_FILE.GET_LINE(f_file, f_buffer);
        IF i >= 3 THEN
            DBMS_OUTPUT.PUT_LINE('FIRST NAME :- ' || REGEXP_SUBSTR(f_buffer, '^(\S+)\s+(\S+)\s+(\d+)$', 1, 1, '', 1));
            DBMS_OUTPUT.PUT_LINE('LAST NAME :- '  || REGEXP_SUBSTR(f_buffer, '^(\S+)\s+(\S+)\s+(\d+)$', 1, 1, '', 2));
            DBMS_OUTPUT.PUT_LINE('SALARY :- '     || REGEXP_SUBSTR(f_buffer, '^(\S+)\s+(\S+)\s+(\d+)$', 1, 1, '', 3));
            dbms_output.NEW_LINE;
        END IF;
        i := i + 1;
    END LOOP;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            UTL_FILE.FCLOSE(f_file);
END;
/

-- 2) UTL_FILE.PUT(file IN FILE_TYPE, buffer IN VARCHAR2) = 
-- This procedure writes a string to the file without a new line

-- 3) UTL_FILE.NEW_LINE(file IN FILE_TYPE, lines IN BINARY_INTEGER DEFAULT 1) =
-- This procedure writes one or more new lines to the file

-- 4) UTL_FILE.PUT_LINE(file IN FILE_TYPE, buffer IN VARCHAR2) =
-- This procedure writes a string to the file with a new line

-- 5) UTL_FILE.PUTF(file IN FILE_TYPE, format IN VARCHAR2, args IN VARCHAR2 DEFAULT NULL) = 
-- This procedure writes a formatted string (like printf in C) 

DECLARE
    f_file UTL_FILE.FILE_TYPE;
    f_buffer VARCHAR2(32767);
BEGIN
    f_file := UTL_FILE.FOPEN('MY_DIR', 'temp.csv', 'a', 32767);
    UTL_FILE.PUT_LINE(f_file, 'First Name,Last Name');
    for i in (SELECT * from EMPLOYEE) LOOP
        UTL_FILE.PUT(f_file, i.first_name || ',');
        UTL_FILE.PUT(f_file, '"' || REPLACE(i.first_name, '"', '""') || '","');
        UTL_FILE.PUT(f_file, '"' || REPLACE(i.last_name, '"', '""') || '"');
        
        UTL_FILE.PUT(f_file, i.last_name);
        UTL_FILE.NEW_LINE(f_file);
    end loop;
    UTL_FILE.FCLOSE(f_file);
END;
/

----------------------------------------------------------------------------

-->>> UTL.FFLUSH Package <<<--
-- This is used to force write the buffered data to the file immediately
-- PUT & PUT_LINE doesnt write data to the file, it just stores it in the buffer
-- Syntax :- UTL_FILE.FFLUSH(file IN FILE_TYPE);

DECLARE
   f UTL_FILE.FILE_TYPE;
BEGIN
   f := UTL_FILE.FOPEN('MY_DIR', 'log.txt', 'W');

   UTL_FILE.PUT_LINE(f, 'Job started');
   UTL_FILE.FFLUSH(f);   -- immediate write

   UTL_FILE.PUT_LINE(f, 'Job finished');
   UTL_FILE.FCLOSE(f);   -- final flush + close
END;
/

-- 

DECLARE
   f UTL_FILE.FILE_TYPE;
BEGIN
   DBMS_OUTPUT.PUT_LINE('File is opening');
   f := UTL_FILE.FOPEN('MY_DIR', 'log.csv', 'A');
   UTL_FILE.FCLOSE(f);
   DBMS_OUTPUT.PUT_LINE('File is closed');
END;
/