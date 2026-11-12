select * from emp_json;
/

-- {
--   "name": "Sayan",
--   "salary": 50000,
--   "skills": ["SQL", "Python", "Java"]
-- }

select json_value(emp_data, '$.name') as name,
       json_value(emp_data, '$.salary') as salary,
       json_value(emp_data, '$.skills[0]') as skills1
from emp_json
where emp_id = 1;