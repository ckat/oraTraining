-- Ratio_to_report
select 
   department_id
  ,salary
  ,ratio_to_report(salary) over(partition by department_id) as r
  ,salary/sum(salary) over(partition by department_id) as r_again
from emp
order by department_id, salary;

-- ListAgg (aggregate)
select
  department_id
 ,ListAgg(last_name,',') within group (order by last_name) as staff
from emp
group by department_id

-- ListAgg (analytic)
select 
   department_id
  ,salary
  ,ListAgg(last_name, ',') 
     within group (order by last_name)
     over(partition by department_id) 
     as colleagues
from emp
order by department_id;

-- row_number
select
  last_name
 ,hire_date
 ,row_number() over(order by hire_date) as dinosaur_rank
from emp
order by last_name;

-- rank
select
  last_name
 ,salary
 ,rank() over(order by salary desc) as mcduck_rank
from emp
order by salary desc;

-- dense_rank
select
  last_name
 ,salary
 ,dense_rank() over(order by salary desc) as mcduck_rank
from emp
order by salary desc;

-- cume_dist
select 
   department_id
  ,salary
  ,cume_dist() over(order by salary) as cdist
from emp
order by salary;

-- ntile
select 
   department_id
  ,salary
  ,ntile(5) over (order by salary desc) as ntl
from emp
order by salary desc;

-- percent_rank
select 
   last_name
  ,salary
  ,percent_rank() over (order by salary) as prank
from emp
order by salary;

-- lag and lead
select 
   department_id
  ,hire_date
  ,lag(last_name,1,'NOBODY') over (partition by department_id order by hire_date) as prev_in_dept
  ,last_name
  ,lead(last_name,1,'NOBODY') over (partition by department_id order by hire_date) as next_in_dept
from emp
order by department_id, hire_date;

-- first_value and last_value
select 
   department_id
  ,last_name
  ,salary
  ,first_value(last_name) 
     over (partition by department_id order by salary) 
     as least_paid
  ,last_value(last_name) 
     over (partition by department_id order by salary 
           rows between unbounded preceding 
                    and unbounded following) 
     as most_paid
from emp
order by department_id, salary;

-- NTH_VALUE
select 
   department_id
  ,last_name
  ,hire_date
  ,nth_value(last_name,2) from first 
     over (partition by department_id order by hire_date
           rows between unbounded preceding 
                    and unbounded following) 
     as second_in_dep
  ,nth_value(last_name,2) from last 
     over (partition by department_id order by hire_date 
           rows between unbounded preceding 
                    and unbounded following) 
     as last_but_one
from emp
order by department_id, hire_date;

-- RESPECT NULLS
with t(id, val) 
  as (select level, decode(MOD(level,3),1,level*100,null) 
      from dual connect by level <=10)
select 
   id
  ,val
  ,NVL(val,lag(val,1) ignore nulls 
           over(order by id)) as dense_val
from t;

select 
   department_id
  ,salary
  ,cume_dist() over(order by salary)
from emp
order by salary

select 
   department_id
  ,salary
  ,cume_dist() over(order by salary)
  ,ntile(5) over (order by salary)
from emp
order by salary


select 
   department_id
  ,salary
  ,cume_dist() over(order by salary)
  ,percent_rank() over (order by salary)
from emp
order by salary


select 
   department_id
  ,salary
  ,first_value(last_name) over()
from emp
order by salary
