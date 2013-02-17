-- orderign by column name
SELECT last_name
FROM   employees
ORDER BY last_name;

-- ordering by column number
SELECT last_name, salary
FROM   employees
ORDER BY 2, 1;

-- ordering by alias
SELECT last_name || ' ' || first_name as full_name
FROM   employees
ORDER BY full_name

-- ordering by expression
SELECT last_name, first_name
FROM   employees
ORDER BY  (1+NVL(commission_pct,0))*salary;


-- ASC and DESC
SELECT    
   first_name
  ,last_name
  ,hire_date
FROM employees
ORDER BY hire_date desc
        ,last_name asc; -- ASC is the default option
        
-- NULLS FIRST/LAST
SELECT last_name, commission_pct
FROM   employees
ORDER BY commission_pct desc nulls first;

select rownum, e.* from employees e

-- No ORDER BY - no order (long example)
drop table order_by_test;
create table order_by_test(
   id number
  ,name varchar2(50)
  ,filler varchar2(2000)
);

insert into order_by_test
select level, 'Row ' || level, DBMS_RANDOM.STRING('A',2000) 
from dual
connect by level <= 1000;

select * from order_by_test;

/*
  delete from order_by_test where id <= 40;
  
  insert into order_by_test
  select level+100, 'Row ' || (level+100), DBMS_RANDOM.STRING('A',2000) 
  from dual
  connect by level <= 40;
  
  select * from order_by_test;
*/

select id from order_by_test where id <= 10;

create index ix_order_test_id
  on order_by_test(id);
  
begin
  DBMS_STATS.GATHER_TABLE_STATS(ownname=> USER, tabname=>'ORDER_BY_TEST',cascade=>true);
end;

select id from order_by_test where id <= 10;


-- ROWNUM - simple example
select 
  rownum
 ,region_id
 ,region_name
from regions;

-- ROWNUM - 5 random records
SELECT rownum, last_name, hire_date
FROM employees
WHERE rownum <= 5;

-- ROWNUM - top 5 records. WRONG!
SELECT rownum, last_name, hire_date
FROM employees
WHERE rownum <= 5
ORDER BY hire_date desc;

-- ROWNUM - top 5 records. Right!
SELECT * FROM 
   (SELECT last_name, hire_date
    FROM employees
    ORDER BY hire_date desc)
WHERE rownum <= 5;

-- Pagination - WRONG!
SELECT rownum, last_name, hire_date
FROM employees
WHERE rownum > 10 
  and rownum <=20;

-- Pagination - step 1.
SELECT last_name, hire_date
FROM employees
ORDER BY hire_date desc;

-- Pagination - step 2.
SELECT rownum as rn, sub1.*
FROM
   (SELECT last_name, hire_date
    FROM employees
    ORDER BY hire_date desc) sub1;

-- Pagination - step 3.
SELECT *
FROM 
  (SELECT rownum as rn, sub1.*
   FROM
      (SELECT last_name, hire_date
       FROM employees
       ORDER BY hire_date desc)  sub1
    where rownum <= 20
  ) 
WHERE rn > 10;
