-- Create view
create or replace view sales_people
as 
select first_name, last_name 
from employees 
where job_id in ('SA_REP', 'SA_MAN');


select * from sales_people;


-- DML on views, example 1
create or replace view v_departments
as 
select department_id, department_name
from departments;

insert into v_departments (department_id,department_name)
values (departments_seq.nextval, 'Test department');

select * from departments where department_name like 'Test%';

-- DML on views, example 2
insert into sales_people(first_name,last_name)
values ('Pavlo','Morozov');

-- Create sequence
CREATE SEQUENCE seq_test
       START WITH 1       
       INCREMENT BY 1;

-- Sequence usage
select seq_test.nextval from dual;
select seq_test.currval from dual;


-- Sequence increment, example 1.
select seq_test.nextval, seq_test.nextval
from dual;

-- Sequence increment, example 2.
select seq_test.nextval
from (select 1 from dual
      union all
      select 1 from dual);

-- Sequence increment, example 3.
select seq_test.currval, seq_test.nextval 
from (select 1 from dual
      union all
      select 1 from dual);

-- Synonym example
create public synonym my_emp for employees;

select * from my_emp;

select * from dba_synonyms where synonym_name = 'MY_EMP';
