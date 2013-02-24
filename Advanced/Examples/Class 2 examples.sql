drop table cities;
create table cities(
  city        varchar2(50 char)
 ,region_code varchar2(10 char)
);

insert into cities(city, region_code) values ('Kyiv','North');
insert into cities(city, region_code) values ('Lviv','West');
insert into cities(city, region_code) values ('Donetsk','East');
insert into cities(city, region_code) values ('Dnipropetrovks','Center');
insert into cities(city, region_code) values ('Simferopol','South');
insert into cities(city, region_code) values ('Ivano-Frankivsk','West');
insert into cities(city, region_code) values ('Lugansk','East');


drop table trains;
create table trains(
  train_code     varchar2(10 char)      not null
 ,origin         varchar2(50 char)      not null
 ,destination    varchar2(50 char)      not null
 ,duration_min   number(5)              not null
);
 

alter table trains 
  add constraint trains_PK
  primary key (train_code);
 
insert into trains (train_code, origin, destination, duration_min)
values ('91','Kyiv','Lviv',472);

insert into trains (train_code, origin, destination, duration_min)
values ('38','Kyiv','Donetsk',732);

insert into trains (train_code, origin, destination, duration_min)
values ('80','Kyiv','Dnipropetrovsk',454);

insert into trains (train_code, origin, destination, duration_min)
values ('69','Donetsk','Lviv',1413);

insert into trains (train_code, origin, destination, duration_min)
values ('172','Dnipropetrovsk','Simferopol',359);

insert into trains (train_code, origin, destination, duration_min)
values ('606','Lviv','Ivano-Frankivsk',168);

insert into trains (train_code, origin, destination, duration_min)
values ('820','Donetsk','Lugansk',150);

insert into trains (train_code, origin, destination, duration_min)
values ('122','Lugansk','Simferopol',920);

insert into trains (train_code, origin, destination, duration_min)
values ('296','Ivano-Frankivsk','Simferopol',1659);


-- Simple example: what cities can we reach from Kyiv?
SELECT distinct destination
FROM trains
START WITH origin='Kyiv'
CONNECT BY PRIOR destination = origin;

-- Simple example #2: what are valid origins for 'Ivano-Frankivsk'?
SELECT distinct origin
FROM trains
START WITH destination='Ivano-Frankivsk'
CONNECT BY destination = PRIOR origin;

-- CONNECT BY and JOINs: order of execution
-- Question: what non-West cities can we reach 'Ivano-Frankivsk' from?
-- Note: join filters out Lviv and we see no valid origins. We just can't build other routes without Lviv
SELECT distinct origin
FROM trains t
  inner join cities c on t.origin = c.city and c.region_code <> 'West'
START WITH destination='Ivano-Frankivsk'
CONNECT BY destination = PRIOR origin;

-- CONNECT BY and WHERE: order of execution
-- Question: what non-West cities can we reach 'Ivano-Frankivsk' from?
-- Note: WHERE works AFTER CONNECT BY. So result is valid this time.
SELECT distinct origin
FROM trains t
  inner join cities c on t.origin = c.city
WHERE c.region_code <> 'West'
START WITH destination='Ivano-Frankivsk'
CONNECT BY destination = PRIOR origin;

-- CONNECT BY and GROUP BY: order of execution
-- Question: how many routes exist from Kyiv to any other city?
-- Note: GROUP BY works AFTER CONNECT BY. 
SELECT destination, count(*) as "Routes number"
FROM trains
START WITH origin='Kyiv'
CONNECT BY PRIOR destination = origin
GROUP BY destination;

-- Use PRIOR several times. 
-- Question: What cities can we reach from Kyiv if Lviv is too beautiful and nobody leaves it. 
SELECT distinct destination
FROM trains
START WITH origin='Kyiv'
CONNECT BY PRIOR destination = origin 
       and PRIOR destination <> 'Lviv';

-- LEVEL preudocolumn
SELECT destination, level
FROM trains
START WITH origin='Kyiv' -- level = 1 for records in START WITH
CONNECT BY PRIOR destination = origin; -- level increments for each hierarchy level

-- SYS_CONNECT_BY_PATH
-- Questions: show all routes from Kyiv to Simferopol
SELECT 
   sys_connect_by_path(origin,'/') || '/' || destination as route
  ,level as num_trains
FROM trains
WHERE destination = 'Simferopol'
START WITH origin='Kyiv' 
CONNECT BY PRIOR destination = origin;

-- ORDER SIBLING BY 
SELECT LPAD(' ',(level-1)*3,'-') || destination, train_code
FROM trains
START WITH origin='Kyiv'
CONNECT BY PRIOR destination = origin;

SELECT LPAD(' ',(level-1)*3,'-') || destination, train_code
FROM trains
START WITH origin='Kyiv'
CONNECT BY PRIOR destination = origin
ORDER BY train_code;

SELECT LPAD(' ',(level-1)*3,'-') || destination, train_code
FROM trains
START WITH origin='Kyiv'
CONNECT BY PRIOR destination = origin
ORDER SIBLINGS BY train_code;


-- CYCLES
/* 
insert into trains (train_code, origin, destination, duration_min)
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

select * from cycle_test;

-- just to see routes
select id, sys_connect_by_path(id,'/') as route
from cycle_test
start with id = 1
connect by prior id = parent_id;

-- create cycle
update cycle_test 
set parent_id = 6
where id = 1;

commit;

-- ERROR: connect-by loop in user data.
select id, sys_connect_by_path(id,'/') as route
from cycle_test
start with id = 1
connect by prior id = parent_id;

-- No Error. We see the row leading to cycle
select id
  ,sys_connect_by_path(id,'/') as route
  ,Connect_By_IsCycle
from cycle_test
start with id = 1
connect by NOCYCLE prior id = parent_id;

-- Rows generation from DUAL 
-- using finite CONNECT BY cyscle
select level 
from dual
connect by level <= 10;
