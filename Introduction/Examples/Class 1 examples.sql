-- Just select 
SELECT first_name, last_name, job_id 
FROM employees;

-- Select all columns with "*"
SELECT * 
FROM employees;

-- Select unique values of column
SELECT DISTINCT job_id 
FROM employees;

-- Select unique combinations of several columns
SELECT DISTINCT job_id, department_id 
FROM employees;

-- Selecting from dual
SELECT sysdate 
FROM dual;

-- Comments in SQL statement
-- SQL statement may include
SELECT 1 
FROM /* two types of comments*/ dual;

-- Expressions, string literals, concatenation, arithmetic operations
-- Column aliaces
SELECT 
    first_name || ' ' || last_name || '''s salary is:' Full_Name
   ,salary*12 as "Salary per Year"
FROM employees;

-- NULLs and arithmetics
SELECT 
    last_name
   ,salary
   ,commission_pct
   ,salary*commission_pct
FROM employees;

-- Operators order of precedence
-- ERROR! 
select 'Price and VAT are ' || 100+20 || ' UAH'
from dual;

-- Operators order of precedence
-- OK
select 'Price and VAT are ' || (100+20) || ' UAH'
from dual;

-- WHERE with comparition operator
SELECT last_name 
FROM employees
WHERE employee_id = 100;

-- WHERE with logical operators
SELECT first_name, last_name, salary
FROM employees
WHERE last_name = 'King' and not first_name = 'Janette' 
         or salary > 15000;
         
-- WHERE with range condition
SELECT first_name, last_name, salary
FROM employees
WHERE salary between 15000 and 30000;

-- WHERE with like conditions
SELECT first_name, last_name, job_id
FROM employees
WHERE last_name like 'K%'
  and first_name not like '_a%'
  and job_id like 'AD\_%' escape '\';
  
-- NULL conditions
SELECT last_name
FROM employees
WHERE commission_pct is null
  and manager_id is not null;
  
-- IN condition
SELECT last_name, job_id
FROM employees
WHERE job_id in ('AD_PRES','AD_VP');

