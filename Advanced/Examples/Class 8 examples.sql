-- question: show sales for each country during each year.
-- report without pivot. 
-- Note: many rows, not too readable format
with t as (select country,year,sales from sales_view)
select country, year, sum(sales)
from t
group by country, year
order by country, year;

-- The same with CASE-based pivot
with t as (select country,year,sales from sales_view)
select distinct year from t order by year;

with t as (select country,year,sales from sales_view)
select 
  country
 ,sum(case when year=1998 then sales else 0 end) as "1998"
 ,sum(case when year=1999 then sales else 0 end) as "1999"
 ,sum(case when year=2000 then sales else 0 end) as "2000"
 ,sum(case when year=2001 then sales else 0 end) as "2001"
from t
group by country
order by country;

-- The same with трушный pivot
with t as (select country,year,sales from sales_view)
select *
from t pivot (sum(sales) 
              for year in (1998,1999,2000,2001));
              
-- "Лишние" колонки
-- Ахтунг! Колонка, не упомянутая в pivot, автоматом включается в GROUP BY.
-- Как результат - от лишних колонок лучше избавиться заранее.
with t as (select country,year,product, sales from sales_view)
select *
from t pivot (sum(sales) for year in (1998,1999,2000,2001));


-- Columns naming. Example 1.
with t as (select country,year,sales from sales_view)
select *
from t pivot (sum(sales) for year in (1998,1999,2000,2001));

-- Columns naming. Example 2.
with t as (select country,year,sales from sales_view)
select *
from t pivot (sum(sales) as s for year in (1998,1999,2000,2001));

-- Columns naming. Example 2.
with t as (select country,year,sales from sales_view)
select *
from t pivot (sum(sales) as s for year in (1998,1999,2000,2001));

-- Columns naming. Example 3.
with t as (select country,year,sales from sales_view)
select *
from t pivot (sum(sales) as s for year in (1998 as "98",1999,2000,2001));


-- Several aggregate.
-- Note: only ONE aggregate may have no alias
with t as (select country,year,product, sales from sales_view)
select *
from t pivot (sum(sales) as sales,
              count(distinct product) as num_prod 
              for year in (1998,1999,2000,2001));
  
-- Multi-column PIVOT.
-- Query: for each product show sales in Argentina and Australia in 1998 and 1999 years
with t as (select country,year,product,sales as sales from sales_view)
select *
from t pivot (sum(sales) for (country,year) 
              in (('Argentina',1998) as Arg_98,('Argentina',1999) as Arg_99,
                  ('Australia',1998) as Aus_98,('Australia',1999) as Aus_99));

-- XML %)
with t as (select country,year,sales as sales from sales_view)
select *
from t pivot XML (sum(sales) for (year) in (ANY));

-- PIVOT and other clauses
-- Meaningless example, just to show that PIVOT results are
-- accessible in JOINs and WHERE.
with t as (select country,year,sales from sales_view)
select *
from t pivot (sum(sales) for year in (1998 as s98,1999 as s99,2000,2001)) t1
  inner join (select 1 from dual) on t1.s98 > 1000
where t1.s99 is not null;

with t as (select country,year,sales from sales_view)
select *
from t pivot (sum(sales) for year in (1998 as s98,1999 as s99,2000 as s00,2001 as s01)) t1
where t1.s98 > 1000;


-- UNPIVOT
-- creating example table
drop table unpivot_me;
create table unpivot_me
as 
with t as (select country, year, sales from sales_view where country like 'A%')
select *
from t pivot (sum(sales) for year in (1998,1999,2000,2001));

select * from unpivot_me;

--  unpivot example
select * from unpivot_me
UNPIVOT(sales for year in ("1998","1999","2000","2001"))


/*
-- Доказательство концепции: как только product упомянут в pivot, он перестает 
-- использоваться в группировке
with t as (select country,year,product, sales from sales_view)
select *
from t pivot (sum(sales*length(product)) as sales for year in (1998,1999,2000,2001));

-- Если нам нужен "просто разворот без аггрегации" - синтаксис все равно требует 
-- использования аггрегирующих функций.
with t as (select country,year,sum(sales) as sales from sales_view group by country, year)
select *
from t pivot (sum(sales) for year in (1998,1999,2000,2001));
*/
