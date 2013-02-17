alter session set  current_schema=&SCHEMA;

drop table dep;
create table dep(
   dep_id number not null
  ,dep_name varchar2(10) not null);

drop table emp;
create table emp(
  last_name varchar2(10) not null
 ,dep_id number null
);

insert into dep values (10, 'Accounting');
insert into dep values (20, 'IT');
insert into dep values (30, 'Useless');
insert into dep values (40, 'Security');

insert into emp values ('King', 10);
insert into emp values ('Brooks', 10);
insert into emp values ('Bush', 20);
insert into emp values ('Smith', 30);
insert into emp values ('Baker', null);

commit;

select e.dep_id, e.last_name, d.dep_id, d.dep_name
from dep d
  cross join emp e
  
select 
  e.dep_id
 ,e.last_name
-- ,d.dep_id
 ,d.dep_name
from emp e
  inner join dep d on e.dep_id = d.dep_id
  
select e.dep_id, e.last_name, d.dep_id, d.dep_name
from emp e
  left outer join dep d  on e.dep_id = d.dep_id
where d.dep_id is NULL
  
select e.dep_id, e.last_name, d.dep_id, d.dep_name
from emp e
  right outer join dep d on e.dep_id = d.dep_id
  
select e.dep_id, e.last_name, d.dep_id, d.dep_name
from emp e
  full outer join dep d on e.dep_id = d.dep_id
  
  
select 
   e.dep_id
  ,e.last_name
  ,d.dep_id
  ,d.dep_name
from emp e, dep d
where e.dep_id = d.dep_id(+)



create table a (a_id number);
create table b (b_id number);
create table ab (a_id number, b_id number);

insert into a values (1);
insert into b values (2);
insert into ab values (null, 2);

commit;

select a.a_id, b.b_id, ab.a_id, ab.b_id
from a 
  left outer join ab on a.a_id = ab.a_id
  right outer join b on ab.b_id = b.b_id

select a.a_id, b.b_id, ab.a_id, ab.b_id
from a 
  left outer join (ab 
  right outer join b on ab.b_id = b.b_id) on a.a_id = ab.a_id
  
select a.a_id, b.b_id, ab.a_id, ab.b_id
from a 
  left outer join ab on a.a_id = ab.a_id
  inner join b on ab.b_id = b.b_id

select a.a_id, b.b_id, ab.a_id, ab.b_id
from a 
  left outer join (ab 
  inner join b on ab.b_id = b.b_id) on a.a_id = ab.a_id  
  
  
select a.a_id, b.b_id, ab.a_id, ab.b_id
from a,b,ab
where a.a_id = ab.a_id(+)
  and b.b_id = ab.b_id(+) 

select 
   dep_id
  ,e.last_name
  ,d.dep_name
from emp e natural join dep d


select 
   dep_id
  ,e.last_name
  ,d.dep_name
from emp e left join dep d using(dep_id)



select d.department_name, e.last_name
from departments d
  left join employees e on d.department_id = e.department_id
