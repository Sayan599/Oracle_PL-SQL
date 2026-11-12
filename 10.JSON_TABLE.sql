-- Table Creation
CREATE TABLE EMP_JSON (
    EMP_ID NUMBER,
    EMP_DATA CLOB
);
-- Insert data
INSERT INTO EMP_JSON
VALUES(2, '
{
  "employee": {
    "emp_id": 101,
    "name": "Sayan",
    "salary": 50000,
    "department": { "dept_id": 10,
                    "dept_name": "IT",
                    "location": "Kolkata"},
    "skills": [ 
                    {
                        "skill_id": 1,
                        "skill_name": "SQL",
                        "experience": 3
                    },
                    {
                        "skill_id": 2,
                        "skill_name": "Python",
                        "experience": 1
                    },
                    {
                        "skill_id": 3,
                        "skill_name": "Java",
                        "experience": 2
                    }
              ],
    "projects": [
                    {
                        "project_id": 201,
                        "project_name": "Employee Management",
                        "technologies": ["Oracle", "PLSQL", "FastAPI"]
                    },
                    {
                        "project_id": 202,
                        "project_name": "Data Processing",
                        "technologies": ["Python", "Pandas", "AWS"]
                    }
                ]
    } 
}
');

-- CHECK
SELECT * FROM EMP_JSON;
/

SELECT E.EMP_ID, J.*
FROM EMP_JSON E, JSON_TABLE(EMP_DATA, '$.employee.skills[*]' COLUMNS (SKILL_ID NUMBER PATH '$.skill_id',
                                                             skill_name VARCHAR2(2000) PATH '$.skill_name',
                                                             experience NUMBER PATH '$.experience')) J
-- table_name, JSON_TABLE(json_column_name, json_path COLUMNS (column_list))
WHERE EMP_ID = 2;





