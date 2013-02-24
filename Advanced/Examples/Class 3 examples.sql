-- WITH reminder
WITH MyTab(id) as 
 (select 1 from dual)
select * from MyTab;


-- basic example
WITH sub (city) AS
  (select destination from trains where origin = 'Kyiv'
   UNION ALL
   select trains.destination
   from sub 
     inner join trains on sub.city = trains.origin
  )
select distinct city
from sub;

-- replacement for LEVEL function
with sub (city,lvl) as 
  (select destination,1 from trains where origin = 'Kyiv'
   union all
   select t.destination, s.lvl + 1
   from sub s
     inner join trains t on s.city = t.origin 
  )
select * from sub;

-- replacement for SYS_CONNECT_BY_PATH
with sub (city,route) as 
  (select destination,'/' || origin || '/' || destination 
   from trains where origin = 'Kyiv'
   union all
   select t.destination, s.route || '/' || t.destination
   from sub s
     inner join trains t on s.city = t.origin 
  )
select * from sub;

-- cumulative SUM
with sub (city,duration) as 
  (select destination,duration_min 
   from trains where origin = 'Kyiv'
   union all
   select t.destination, s.duration + t.duration_min
   from sub s
     inner join trains t on s.city = t.origin 
  )
select * from sub;

-- ordering (DEPTH FIRST)
with sub (city,lvl) as 
  (select destination,1 from trains where origin = 'Kyiv'
   union all
   select t.destination, s.lvl + 1
   from sub s
     inner join trains t on s.city = t.origin 
  )
  search depth first 
    by city asc
    set order_col
select LPAD(' ',(lvl-1)*3,'-') || city, order_col
from sub
order by order_col;

-- ordering (breadth FIRST)
with sub (city,lvl) as 
  (select destination,1 from trains where origin = 'Kyiv'
   union all
   select t.destination, s.lvl + 1
   from sub s
     inner join trains t on s.city = t.origin 
  )
  search breadth  first 
    by city asc
    set order_col
select LPAD(' ',(lvl-1)*3,'-') || city, order_col
from sub
order by order_col;

-- cycle example
/*
insert into trains (train_code, origin, destination, duration_min, departure_time)
values ('12','Simferopol','Kyiv',838,INTERVAL '16:50' HOUR TO MINUTE);
*/

drop table cycle_test;
create table cycle_test(id, parent_id) as 
    select 1, null from dual union all
    select 2, 1    from dual union all
    select 3, 1    from dual union all
    select 4, 2    from dual union all
    select 5, 3    from dual union all
    select 6, 3    from dual;

-- just to see routes
with sub (id, route) as
  (select id, '/' || id
   from cycle_test
   where id = 1
   union all
   select c.id, s.route || '/' || c.id
   from sub s
     inner join cycle_test c on s.id = c.parent_id
  )
select * from sub;

-- create cycle
update cycle_test 
set parent_id = 6
where id = 1;

commit;

-- cycle error
with sub (id, route) as
  (select id, '/' || id
   from cycle_test
   where id = 1
   union all
   select c.id, s.route || '/' || c.id
   from sub s
     inner join cycle_test c on s.id = c.parent_id
  )
select * from sub;

-- correct cycle processing
with sub (id, route) as
  (select id, '/' || id
   from cycle_test
   where id = 1
   union all
   select c.id, s.route || '/' || c.id
   from sub s
     inner join cycle_test c on s.id = c.parent_id
  )
  cycle id set is_cycle to '1' default '0'
select * from sub;





