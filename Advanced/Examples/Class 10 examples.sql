-- Example 1. Nulls. Default or KEEP NAV
select last_name, salary, commission_pct, commission_sum, income
from employees e
model
  dimension by (e.employee_id)
  measures (e.last_name, e.salary, e.commission_pct, 0 as commission_sum, 0 as income) /*KEEP NAV*/
  rules (
    commission_sum[ANY] = salary[cv()] * commission_pct[cv()]
   ,income[ANY] = salary[cv()] * (1 + commission_pct[cv()])
  )
order by last_name;

-- Example 2. Nulls. IGNORE NAV
select last_name, salary, commission_pct, commission_sum, income
from employees e
model
  dimension by (e.employee_id)
  measures (e.last_name, e.salary, e.commission_pct, 0 as commission_sum, 0 as income) IGNORE NAV
  rules (
    commission_sum[ANY] = salary[cv()] * commission_pct[cv()]
   ,income[ANY] = salary[cv()] * (1 + commission_pct[cv()])
  )
order by last_name;



-- Example 3. Messing NULLs and missing cells
select employee_id, department_id, message
from employees
  model return updated rows
  dimension by (employee_id)
  measures (department_id, cast('' as varchar2(20)) as message)
  rules (
    message[178] = case when department_id[cv()] is null then 'No department' else 'Some department' end
   ,message[-10] = case when department_id[cv()] is null then 'No department' else 'Some department' end
  );

-- Example 4. IS PRESENT
select employee_id, department_id, message
from employees
  model return updated rows
  dimension by (employee_id)
  measures (department_id, cast('' as varchar2(20)) as message)
  rules (
    message[178] = case when department_id[cv()]  is present then 'Present' else 'Not present' end
   ,message[-10] = case when department_id[cv()] is present then 'Present' else 'Not present' end
  ); 
  
-- Example 5. PresentV, PresentNNV
select employee_id, department_id, V as "PresentV", NNV as "PresentNNV"
from employees
  model return updated rows
  dimension by (employee_id)
  measures (department_id, cast('' as varchar2(20)) as V, cast('' as varchar2(20)) as NNV)
  rules (
    V[178] = PresentV(department_id[cv()],1,0)
   ,V[-10] = PresentV(department_id[cv()],1,0)
   ,NNV[178] = PresentNNV(department_id[cv()],1,0)
   ,NNV[-10] = PresentNNV(department_id[cv()],1,0)
  );
  
-- Example 6. Multiplication table with UPSERT ALL. Fail.
with t (x,y) as (select 2,2 from dual union all
                 select 5,5 from dual union all
                 select 7,8 from dual)
select x,y,product
from t
  model
    dimension by (x,y)
    measures(x*y as product)
    rules (
      upsert all product[x in (1,2,3,4,5,6,7,8,9), y in (1,2,3,4,5,6,7,8,9)] = cv(x)*cv(y)
    )
order by x,y;
    
-- Example 6. Multiplication table with FOR..IN (list).
with t (x,y) as (select 2,2 from dual union all
                 select 5,5 from dual union all
                 select 7,8 from dual)
select x,y,product
from t
  model
    dimension by (x,y)
    measures(x*y as product)
    rules (
      product[FOR x in (1,2,3,4,5,6,7,8,9), FOR y in (1,2,3,4,5,6,7,8,9)] = cv(x)*cv(y)
    )
order by x,y;

-- Example 7. Multiplication table with FOR in (subquery).
with t (x,y) as (select 2,2 from dual union all
                 select 5,5 from dual union all
                 select 7,8 from dual)
    ,n as (select level lv from dual connect by level <= 9)
select x,y,product
from t
  model
    dimension by (x,y)
    measures(x*y as product)
    rules (
      product[FOR x in (select lv from n), FOR y in (select lv from n)] = cv(x)*cv(y)
    )
order by x,y;


-- Example 7. Multiplication table with FOR...FROM...TO...INCREMENT
with t (x,y) as (select 2,2 from dual union all
                 select 5,5 from dual union all
                 select 7,8 from dual)
select x,y,product
from t
  model
    dimension by (x,y)
    measures(x*y as product)
    rules (
      product[FOR x FROM 1 TO 9 INCREMENT 1, FOR y FROM 1 TO 9 INCREMENT 1] = cv(x)*cv(y)
    )
order by x,y;

-- Example 8. Bank model #1
select *
from dual
  model
    dimension by (0 as period)
    measures(0.1 as r, 700 as d)
    rules upsert all iterate (100) (
      r[iteration_number+1] = r[iteration_number]*(1000/d[iteration_number])
     ,d[iteration_number+1] = 700*(1+5*(r[iteration_number] - 0.1))
    ); 
    
    
 -- Example 9. Bank model #2
select *
from dual
  model
    dimension by (0 as period)
    measures(0.1 as r, 700 as d)
    rules upsert all iterate (100) until ABS(r[iteration_number]-r[iteration_number-1])<=0.00001(
      r[iteration_number+1] = r[iteration_number]*(1000/d[iteration_number])
     ,d[iteration_number+1] = 700*(1+5*(r[iteration_number] - 0.1))
    ); 
    
 
