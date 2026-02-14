INSERT INTO target_table
SELECT ...
FROM source_tables
LOG ERRORS INTO err$_target_table ('MONTHLY_JOB')
REJECT LIMIT UNLIMITED;
/

SELECT *
FROM err$_target_table;
/

BEGIN
  DBMS_ERRLOG.CREATE_ERROR_LOG(
    dml_table_name => 'TARGET_TABLE'
  );
END;
/