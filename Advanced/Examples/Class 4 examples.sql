-- Problem. Example #1, solution #1.
select
  e.department_id
 ,e.last_name
 ,e.salary
 ,d.budget
 ,ROUND(e.salary/d.budget*100,2) as percent_in_budget
from employees e left join 
  (select department_id, sum(salary) as budget
   from employees 
   group by department_id) d on e.department_id = d.department_id
order by e.department_id;
   
-- Problem. Example #1, solution #2.
select
  e.department_id
 ,e.last_name
 ,e.salary
 ,(select sum(e1.salary) from employees e1 where e1.department_id = e.department_id) as budget
 ,ROUND(e.salary/(select sum(e1.salary) from employees e1 where e1.department_id = e.department_id)*100,2) as percent_in_budget
from employees e
order by e.department_id;

-- Problem. Example #2.
select
  e.first_name || ' ' || e.last_name as Full_Name
 ,e.Department_ID
 ,e.Salary
 ,(select count(*) 
   from employees e1 
   where e1.department_id = e.department_id
     and e1.salary > e.salary) + 1 as Salary_Rank
from employees e
order by e.Department_ID, Salary_Rank;

-- Problem. Example #3.
select
  e.job_id
 ,e.last_name
 ,e.hire_date
 ,e.salary
 ,(select avg(e1.salary) 
   from employees e1 
   where e1.job_id = e.job_id 
     and e1.hire_date between e.hire_date-366 and e.hire_date-1) as sliding_avg
from employees e
order by e.job_id, e.hire_date;

-- Table for further examples
drop table emp;
create table emp
as select department_id, last_name, hire_date, salary
   from employees 
   where department_id in (60,100);
   
insert into emp(department_id, last_name, hire_date, salary)
values (100,'Doe',DATE'2008-01-01',0);

update emp
  set salary = (TRUNC(rownum/2)+1)*300, hire_date = DATE'2012-01-01'+rownum*7;
  
commit;
   
select * from emp order by department_id;

-- Basic syntax. Example #1.
select 
   last_name
  ,salary
  ,sum(salary) over() as total_salary
from emp;

-- Basic syntax. Example #2.
select 
   last_name
  ,salary
  ,avg(salary) over() as avg_salary
  ,count(*) over() as total_emps
from emp;

-- Partitioning. Example #1.
select 
   department_id
  ,last_name
  ,salary
  ,min(salary) over(partition by department_id) as min_dep_sal
  ,max(salary) over(partition by department_id) as max_dep_sal
from emp
order by department_id;

-- Partitioning. Example #2.
select 
   department_id
  ,extract(month from hire_date) as month
  ,last_name
  ,salary
  ,sum(salary) over(partition by department_id,extract(month from hire_date)) as cum_salary
from emp
order by department_id, month;

-- Ordering. Example #1.
select 
   department_id
  ,last_name
  ,salary
  ,rank() over(partition by department_id order by salary desc) as salary_rank
from emp
order by department_id, salary desc;

-- Ordering. Example #2.
select 
   last_name
  ,hire_date
  ,salary
  ,rank() over(order by salary desc) as salary_rank
  ,rank() over(order by hire_date) as workterm_rank
from emp
order by salary desc;

-- Window. Example #1.
select 
   department_id
  ,last_name
  ,salary
  ,sum(salary) over(partition by department_id order by last_name) as cum_salary
from emp
order by department_id;

-- Window. Example #2.
select 
   department_id
  ,last_name
  ,hire_date
  ,count(*) over(partition by department_id order by hire_date) as cum_num_people
from emp
order by department_id;

-- rows window
select 
   department_id
  ,last_name
  ,hire_date
  ,salary
  ,avg(salary) over(partition by department_id 
                    order by hire_date
                    rows between 1 preceding and 1 following ) 
   as sliding_avg
from emp
order by department_id;

-- range window
select 
   department_id
  ,last_name
  ,hire_date
  ,salary
  ,avg(salary) over(partition by department_id 
                    order by hire_date
                    range between 15 preceding and 15 following ) as sliding_avg
from emp
order by department_id;
