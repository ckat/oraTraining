-- Example 1. Just for illustration (SH schema)   
select 
   case when grouping(Country) = 1 then 'All countries' else Country end as Sales_Country
  ,case when grouping(year) = 1 then 'All years' else TO_CHAR(year) end as Sales_Year
  ,sum(sales) as sales 
from sales_view
group by rollup (Country, year)
order by grouping(country),country, grouping(year),year;

-- Example 2. Rollup (SH schema)   
select 
   country
  ,year
  ,sum(sales) as sales 
from sales_view
group by rollup (country, year)
order by country nulls last, year nulls last;

-- Example 3. GORUPING #1. (HR schema)
select
  job_id
 ,department_id
 ,count(*)
 ,grouping(job_id) job_grouping
 ,grouping(department_id) dep_grouping
from employees
group by rollup (job_id, department_id)
order by job_id nulls last
        ,department_id nulls last;

-- Example 4. GORUPING #2. (HR schema)    
select
  job_id
 ,NVL(TO_CHAR(department_id),
      case
        when GROUPING(department_id) = 1 then 'All deps'
        else 'No dep'
      end) as dep_id
 ,count(*)
from employees
group by rollup (job_id, department_id)
order by job_id nulls last
        ,GROUPING(department_id)
        ,department_id nulls last;
        
-- Example 5. Cube. (SH schema)
select 
   case when grouping(Country) = 1 
           then 'All countries' 
        else Country 
   end as Sales_Country
  ,case when grouping(year) = 1 
           then 'All years' 
        else TO_CHAR(year) 
   end as Sales_Year
  ,sum(sales) as sales 
from sales_view
group by cube (country, year)
order by grouping(country)
        ,country
        ,grouping(year)
        ,year;


-- Example 6. Grouping sets, #1. (SH schema)
select 
   case when grouping(Country) = 1 
           then 'All countries' 
        else Country 
   end as Sales_Country
  ,case when grouping(year) = 1 
           then 'All years' 
        else TO_CHAR(year) 
   end as Sales_Year
  ,sum(sales) as sales 
from sales_view
group by grouping sets (country, year)
order by grouping(country)
        ,country
        ,grouping(year)
        ,year;
        
        
-- Example 7. Grouping sets, #2. (SH schema)
select 
   case when grouping(Country) = 1 
           then 'All countries' 
        else Country 
   end as Sales_Country
  ,case when grouping(year) = 1 
           then 'All years' 
        else TO_CHAR(year) 
   end as Sales_Year
  ,sum(sales) as sales 
from sales_view
group by grouping sets ((country, year),country,())
order by grouping(country)
        ,country
        ,grouping(year)
        ,year;

-- Example 8. Need for FIRST/LAST functions (HR schema, EMP table)
select department_id, hire_date, last_name
from emp
order by hire_date;

select d.department_id, d.min_date, e.last_name 
from (select department_id, min(hire_date) as min_date
      from emp
      group by department_id) d
  inner join emp e on d.department_id = e.department_id and d.min_date = e.hire_date;
  
-- Example 9. FIRST/LAST with unique values(HR schema, EMP table)
select
  department_id
 ,min(hire_date) as min_date
 ,min(last_name) keep (dense_rank first order by hire_date) as last_name
from emp
group by department_id;


-- Example 10. FIRST/LAST with non-unique values(HR schema, EMP table)
select
  department_id
 ,max(salary) as max_Salary
 ,min(last_name) keep (dense_rank last order by salary) as last_name
 ,count(*) keep (dense_rank last order by salary) as num_people
from emp
group by department_id;
