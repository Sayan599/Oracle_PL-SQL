SET SERVEROUTPUT ON;

DECLARE 
   emails VARCHAR2(500) := 'SAYAN@EMAIL.COM;SIDDHARTHA@EMAIL.COM;JOHN@EMAIL.COM';
   email VARCHAR2(100);
   i NUMBER := 1;
BEGIN
     WHILE i < LENGTH(emails) LOOP                    
        DBMS_OUTPUT.PUT_LINE(SUBSTR(emails, i, INSTR(emails,';',i) - i));         
        i := INSTR(emails,';',i) + 1;   

        IF INSTR(emails,';',i) = 0 THEN
            DBMS_OUTPUT.PUT_LINE(SUBSTR(emails,i));
            EXIT;
        END IF;
     END LOOP;
END;
/

SELECT 'yes' as lett from dual
where REGEXP_LIKE('AEIOudasdajdsh', '[aA]{1,}[eE]{1,}[iI]{1,}[oO]{1,}[uU]{1,}');
/

(1) Emails with Gmail
Table: users(email)
Find all rows where the email belongs to gmail.com.

SELECT 'yes' as lett from dual
where REGEXP_LIKE('abc@gmail.com', '@(gmail\.com)$');
/

(2) Names starting with a vowel
Table: employees(name)
Return employees whose name starts with a vowel (A, E, I, O, U).

SELECT 'yes' as lett from dual
where REGEXP_LIKE('Aryan', '^[aeiouAEIOU]');
/

Phone numbers with only digits
Table: contacts(phone)
Find phone numbers that contain only digits and are at least 10 characters long.

SELECT 'yes' as lett from dual
where REGEXP_LIKE('9051465454', '^[0-9]{10,}$');

Words ending with “ing”
Table: posts(title)
Get titles that end with the word "ing".

SELECT 'yes' as lett from dual
where REGEXP_LIKE('ruding', '(ing)$');
/

SELECT REGEXP_REPLACE('abc123@gmail.com', 'gmail\.com', 'yahoo.com') FROM dual;
/

SELECT 'yes' AS lett
FROM dual
WHERE REGEXP_LIKE('@gmail.com', '^.+@gmail\.com$');
/

SELECT 'yes' as lett from dual
where REGEXP_LIKE('12345-4515', '^[0-9]{5}(-[0-9]{4}){0,1}$');
/

Employee IDs format
Starts with EMP
Followed by exactly 4 digits
Example: EMP1023

SELECT 'yes' as lett from dual
where REGEXP_LIKE('EMP1234', '^(EMP)[0-9]{4}$');
/

Table: users(username)
Find usernames that contain at least one special character (@, #, $, %, etc.).

SELECT 'yes' as lett from dual
where REGEXP_LIKE('USER$DAS23', '[@#$%]+');
/

Dates in YYYY-MM-DD
Table: orders(order_date_text)
Match strings that look like a date in YYYY-MM-DD format.

SELECT 'yes' AS lett
FROM dual
WHERE REGEXP_LIKE('2024-12-19', '^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1|2][0-9]|3[0|1])$');
