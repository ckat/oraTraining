-- UNION
select d.department_name
from employees e 
  inner join departments d on e.department_id = d.department_id
group by d.department_name
having count(*) > 10
union
select d.department_name 
from departments d
  inner join locations l on d.location_id = l.location_id
where l.country_id = 'UK';

-- UNION ALL
select * 
from (
  select job_id, start_date, end_date
  from job_history
  where employee_id = 101
  union all
  select job_id,hire_date, null
  from employees  
  where employee_id = 101)
order by start_date;

-- NULL madness
select null from dual
union 
select null from dual;

-- MINUS
select department_name
from departments
minus 
select d.department_name
from locations l
  inner join departments d on l.location_id = d.location_id
where l.country_id = 'US';

-- INTERSECT
select employee_id, job_id
from employees
intersect
select employee_id, job_id
from job_history;

-- Order of execution, example #1
select 2 from dual 
minus
select 1 from dual
union all
select 2 from dual;

-- Order of execution, example #2
select 2 from dual 
minus
(select 1 from dual
 union all
 select 2 from dual);
 
-- Set operations and ORDER BY. Wrong #1
select 2 as f1 from dual
order by f1 
union all
select 1 as f2 from dual;

-- Set operations and ORDER BY. Wrong #2 
select 2 as f1 from dual
union all
select 1 as f2 from dual
order by f2;

-- Set operations and ORDER BY. Right
select 2 as f1 from dual
union all
select 1 as f2 from dual
order by f1;
