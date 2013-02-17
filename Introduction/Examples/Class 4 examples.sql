-- Aggregate functions and NULLs
select
  avg(commission_pct)  as AVG_NO_NULLS
 ,count(commission_pct) as COUNT_NO_NULLS
 ,avg(NVL(commission_pct,0)) as AVG_WITH_NULLS
 ,count(NVL(commission_pct,0)) as COUNT_WITH_NULLS
from employees;

-- options of COUNT function
SELECT 
    COUNT(*)  -- all rows
   ,COUNT(1)  -- all rows
   ,COUNT(manager_id)  -- rows with manager_id is not null
   ,COUNT(commission_pct)  -- rows with commission_pct is not null
FROM employees;

-- DISTINCT in aggregate functions
SELECT 
    COUNT(*) 
   ,COUNT(DISTINCT last_name)  
   ,SUM(salary)
   ,SUM(DISTINCT salary)
FROM employees;

-- empty data set
SELECT
   count(*)
  ,count(salary)
  ,sum(salary)
FROM (select * 
      from employees 
      where employee_id <0);
      
-- Simple GROUP BY
SELECT 
    job_id 
   ,AVG(salary)  
FROM employees
where job_id in ('IT_PROG','AC_ACCOUNT')
GROUP BY job_id;

-- GROUP BY with several columns
SELECT 
  department_id
  ,job_id
  ,count(*)
FROM employees
GROUP BY job_id, department_id
ORDER BY department_id;

-- GROUP BY allowed selection - RIGHT
SELECT 
  department_id
  ,job_id
  ,department_id || ' ' || job_id
  ,count(*)
  ,1
FROM employees
GROUP BY job_id, department_id;


-- GROUP BY allowed selection - WRONG
SELECT 
  department_id
  ,job_id
  ,manager_id
  ,count(*)
FROM employees
GROUP BY job_id, department_id;


-- GROUP BY with ORDER BY
SELECT
  department_id
 ,count(*) as cnt
 ,sum(salary) as budget
FROM employees
GROUP BY department_id
ORDER BY cnt, sum(salary);

-- GROUP BY and WHERE - WRONG
SELECT
  department_id
 ,count(*) as cnt
 ,sum(salary) as budget
FROM employees
WHERE count(*) > 5
GROUP BY department_id;

-- GROUP BY and HAVING
SELECT
  department_id
 ,count(*) as cnt
 ,sum(salary) as budget
FROM employees
GROUP BY department_id
HAVING count(*) > 5;

-- Nested aggregate functions - WRONG
SELECT AVG(MAX(salary))
FROM employees;

-- Nested aggregate functions - RIGHT
SELECT AVG(MAX(salary))
FROM employees
GROUP BY department_id;

-- Nested aggregate functions - WRONG #2
SELECT SUM(AVG(MAX(salary)))
FROM employees
GROUP BY department_id;

-- ListAgg
SELECT department_id, 
LISTAGG(last_name, ', ') WITHIN GROUP (ORDER BY last_name) 
FROM employees 
GROUP BY department_id
