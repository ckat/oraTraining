-- Subquery in WHERE
select 
   e.last_name
  ,e.first_name
  ,e.hire_date
from employees e
where e.hire_date < (select hire_date 
                     from employees e2 
                     where e2.job_id = 'AD_PRES');
                     
--  subquery in SELECT
select 
   e.last_name
  ,e.first_name
  ,round(e.salary/(select sum(e2.salary) 
                   from employees e2)*100, 2) 
     as total_salary_percent
from employees e
order by total_salary_percent desc;

-- Subquery in HAVING
select d.department_name, count(*) as staff
from employees e
  inner join departments d on e.department_id = d.department_id
group by d.department_name
having count(*) > (select count(*) 
                   from employees)*0.1;

-- Scalar subquery without rows
select e.last_name
from employees e
where e.salary > (select e2.salary 
                  from employees e2 
                  where e2.last_name = 'Ivanov');

-- Scalar subqueyr with >1 rows
select e.last_name
from employees e
where e.salary > (select e2.salary 
                  from employees e2 
                  where e2.last_name = 'King');
                  
-- Multicolumn subquery
select 
   e.last_name, e.first_name
  ,e.department_id, e.job_id
from employees e
where (e.department_id, e.job_id) =
            (select e2.department_id, e2.job_id 
             from employees e2 
             where e2.last_name = 'Atkinson');
             
-- IN example
select d.department_name 
from departments d 
where d.location_id in 
    (select l.location_id 
     from locations l 
     where l.country_id = 'UK');
     
-- NOT IN examples (with NULLs)
select d.department_name
from departments d
where d.department_id 
      not in (select distinct e.department_id 
              from employees e);
              
-- ALL example
select e.last_name, e.first_name, e.job_id
from employees e
where e.salary > ALL 
          (select e2.salary 
           from employees e2 
           where e2.job_id = 'IT_PROG');
           
--  EXISTS example
select c.country_name
from countries c
where not exists 
    (select 1 from 
     locations l 
     where l.country_id = c.country_id);
     
-- Multicolumn and multirow subquery
select e.last_name, e.first_name
from employees e 
where (e.employee_id, e.department_id) 
        in (select jh.employee_id
                  ,jh.department_id 
              from job_history jh);

-- NOT IN quizz
select 1 from dual
where (1,1) not in (select 2, null from dual);

-- Correlated subquery in SELECT clause
select 
  e.last_name
 ,e.first_name
 ,d.department_name
 ,(select count(*) 
   from employees e2 
   where e2.department_id = e.department_id) 
   as num_colleagues 
from employees e
  inner join departments d on e.department_id = d.department_id;
  
-- Correlated subquery in WHERE clause
select e.last_name, e.first_name
from employees e
where e.salary >= ALL 
    (select e2.salary 
     from employees e2 
     where e2.job_id = e.job_id);

-- IN vs JOIN, example #1
select jh.employee_id
from   job_history jh
where jh.employee_id in 
  (select e.employee_id 
   from employees e);
   
select jh.employee_id
from job_history jh
  inner join employees e 
    on jh.employee_id = e.employee_id;
    
-- IN vs JOIN, example #2
select l.location_id
from locations l
where l.location_id in
    (select d.location_id 
     from departments d);

select l.location_id
from locations l
  inner join departments d 
  on l.location_id = d.location_id;
  
-- IN vs EXISTS
select distinct 
   e.department_id
  ,e.job_id
from employees e 
where (e.department_id, e.job_id) in 
  (select jh.department_id, jh.job_id 
   from job_history jh);
   
select distinct e.department_id, e.job_id
from employees e
where exists
   (select null
    from job_history jh
    where jh.department_id = e.department_id
         and jh.job_id = e.job_id);
         
-- NOT IN vs NOT EXISTS
select e.Last_Name
from employees e
where not exists
  (select null
   from employees e1
   where e1.manager_id = e.employee_id);
   
select e.Last_Name
from employees e
where e.employee_id not in
  (select e1.manager_id
   from employees e1);
   
-- Inline view
select 
  e.last_name
 ,e.first_name
 ,e.salary
 ,dep_stats.min_dep_salary
 ,dep_stats.avg_dep_salary
 ,dep_stats.max_dep_salary
from employees e left outer join
  (select 
      e2.department_id
     ,min(e2.salary) as min_dep_salary
     ,round(avg(e2.salary),2) as avg_dep_salary
     ,max(e2.salary) as max_dep_salary
   from employees e2
   group by e2.department_id) dep_stats on e.department_id = dep_stats.department_id
where e.salary >= dep_stats.avg_dep_salary*0.7;

-- WITH clause #1
with dep_budget as 
(select d.department_name, sum(e.salary) as budget 
 from departments d
   left outer join employees e on d.department_id = e.department_id
 group by d.department_name
)
select db1.*
from dep_budget db1
where db1.budget > (select avg(budget) from dep_budget db2);

-- WITH clause #2
with
   a as (select 1 as a_id from dual) 
  ,ab as (select null as a_id, 2 as b_id from dual)
select a.a_id, ab.a_id, ab.b_id
from a
   left outer join ab on a.a_id = ab.a_id;
