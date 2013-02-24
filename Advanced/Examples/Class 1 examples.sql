-- EXAMPLE #1 (for SH schema)

-- tables creation
drop table y_box_sales;
create table y_box_sales as
select p.prod_name, t.day_number_in_week, sum(s.quantity_sold) as cnt
from sales s
  inner join times t on s.time_id = t.time_id
  inner join products p on s.prod_id = p.prod_id
where s.prod_id = 16 and t.day_number_in_week not in (1,5)
   or s.prod_id = 147 and t.day_number_in_week not in (5,6,7) 
group by p.prod_name, t.day_number_in_week
order by prod_name, day_number_in_week;

drop table week_days;
create table week_days as
  select level as day_number_in_week
  from dual connect by level <= 7;

select * from y_box_sales;
select * from week_days;

-- basic ugly report
select w.day_number_in_week,s.prod_name,s.cnt
from week_days w
  left outer join y_box_sales s on w.day_number_in_week = s.day_number_in_week
order by prod_name, day_number_in_week;
  
-- separate reports for products
select w.day_number_in_week,s.prod_name,s.cnt
from week_days w
  left join (select * 
             from y_box_sales 
             where prod_name = 'Extension Cable') s 
      on w.day_number_in_week = s.day_number_in_week
order by day_number_in_week;

select w.day_number_in_week,s.prod_name,s.cnt
from week_days w
  left join (select * 
             from y_box_sales 
             where prod_name = 'Y Box') s 
       on w.day_number_in_week = s.day_number_in_week
order by day_number_in_week;


-- cool report with partitioned outer join
select w.day_number_in_week,s.prod_name,s.cnt
from week_days w
  left outer join y_box_sales s 
  partition by (prod_name) 
  on w.day_number_in_week = s.day_number_in_week
order by prod_name, day_number_in_week;



-- EXAMPLE #2 (for HR schema)

-- usual outer join
with hired_by_dep as 
  (select department_id, extract(year from hire_date) as year, count(*) as cnt
   from employees
   group by department_id, extract(year from hire_date)
  )
select d.department_name, h.year, h.cnt
from departments d
  left outer join hired_by_dep h on d.department_id = h.department_id
order by d.department_name, h.year;

-- partitioned outer join
with hired_by_dep as 
  (select department_id, extract(year from hire_date) as year, count(*) as cnt
   from employees
   group by department_id, extract(year from hire_date)
  )
select d.department_name, h.year, nvl(h.cnt,0) as cnt
from departments d
  left outer join hired_by_dep h 
    partition by (year)
    on d.department_id = h.department_id
order by d.department_name, h.year;
