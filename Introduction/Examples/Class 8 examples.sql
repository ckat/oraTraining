-- Insert example #1
INSERT INTO region VALUES (5,'Australia');

-- Insert example #2
INSERT INTO contacts(
   first_name
  ,last_name
  ,email
  ,phone)
SELECT
    first_name
   ,last_name
   ,NVL(email, 'No email')
   ,NVL(phone_number,'No phone')
FROM employees
WHERE email is not null 
         or phone_number is not null;
         
-- Insert example #3
INSERT INTO countries(country_id, country_name, region_id)
VALUES ('SL', 'Sealand', 1);

-- Insert example #4
INSERT INTO countries(country_name)
VALUES ('Neverland');

-- delete example #1
DELETE FROM job_history;

-- delete example #2
DELETE FROM jobs j
WHERE not exists 
   (select null 
    from employees e 
    where j.job_id = e.job_id)       
and not exists 
   (select null 
    from job_history jh  
    where jh.job_id = j.job_id);

-- Update examples
UPDATE employees
SET salary = salary*1.1;

UPDATE employees
SET commission_pct=commission_pct*2
WHERE hire_date < SYSDATE - 5*365;

UPDATE employees e 
SET salary = (select j.max_salary
              from jobs j
              where j.job_id = e.job_id);
              
UPDATE employees 
SET (salary,commission_pct) = 
    (select salary, commission_pct 
     from employees 
     where employee_id = 145)
WHERE employee_id = 146;

-- Syntax options for UPDATE from other table. 
-- Task: for all employees set hire_date to the very first day in company.
-- The very first day - i.e. take job history into account.

-- Just for this example create table with first days
create table first_days as 
  select employee_id, min(start_date) as first_day 
  from job_history
  group by employee_id;

-- This constraint is necessary for "update (subquery) set..." example
alter table first_days
  add constraint first_days_PK
  primary key (employee_id);
   
-- Change hire_date to first_day. Memento NULLs!
UPDATE employees e
SET e.hire_date = (select fd.first_day
                   from first_days fd 
                   where fd.employee_id = e.employee_id);

-- Safer but more complex
UPDATE employees e
SET e.hire_date = (select fd.first_day
                   from first_days fd 
                   where fd.employee_id = e.employee_id)
WHERE exists (select null
              from first_days fd
              where fd.employee_id = e.employee_id);
                
-- Quite simple. 
-- But with limitations for subquery (no GROUP BY, no DISTINCT, key-preserved table rule etc.)
-- MERGE is a good alternative.
update (
  select e.hire_date as old_date, fd.first_day as new_date
  from employees e
    inner join first_days fd on e.employee_id = fd.employee_id)
set old_date = new_date;
                   

                   

-- MERGE example #1
drop table regions_new;
create table regions_new as select * from regions;

insert into regions_new(region_id, region_name) values (5,'Australia');
update regions_new set region_name = 'United Europe' 
where region_id = 1;

update regions set region_name = 'Europe' where region_id = 1
select * from regions;
select * from regions_new;

MERGE INTO Regions r
USING regions_new rn ON (r.region_id = rn.region_id)
WHEN MATCHED THEN UPDATE SET
    r.region_name = rn.region_name
WHEN NOT MATCHED THEN INSERT (region_id, region_name) 
    VALUES (rn.region_id, rn.region_name);
    
select * from regions;

rollback;

-- MERGE example #2
drop table emp_directory;
create table emp_directory as
select
  e.employee_id
 ,e.first_name
 ,e.last_name
 ,e.email
 ,e.phone_number
 ,j.job_title
 ,d.department_name
 ,l.city
from employees e
  inner join jobs j on e.job_id = j.job_id
  left outer join departments d on e.department_id = d.department_id
  left outer join locations l on d.location_id = l.location_id;
  
select * from emp_directory;

update employees set 
  phone_number='555.555.5555'
where employee_id = 100;

update departments set 
  department_name = 'Executive office'
where department_name = 'Executive';

insert into employees (employee_id, first_name, last_name, email, phone_number, hire_date,job_id,salary, commission_pct, manager_id, department_id)
values (employees_seq.nextval, 'Vasyl','Pupkin', 'Vasyl_Pupkin@epam.com', '123.456.7890',SYSDATE, 'IT_PROG', 10000, null, 100, 60);

merge into emp_directory old
using (
   select
     e.employee_id
    ,e.first_name
    ,e.last_name
    ,e.email
    ,e.phone_number
    ,j.job_title
    ,d.department_name
    ,l.city
   from employees e
     inner join jobs j on e.job_id = j.job_id
     left outer join departments d on e.department_id = d.department_id
     left outer join locations l on d.location_id = l.location_id
    ) new
on (old.employee_id = new.employee_id)
when matched then update set
    old.first_name = new.first_name
   ,old.last_name = new.last_name
   ,old.email = new.email
   ,old.phone_number = new.phone_number
   ,old.job_title = new.job_title
   ,old.department_name = new.department_name
   ,old.city = new.city
when not matched then insert (employee_id,first_name,last_name,email,phone_number,job_title, department_name,city)
                      values (new.employee_id,new.first_name,new.last_name,new.email,new.phone_number,
                              new.job_title, new.department_name,new.city);
                              
select * from emp_directory;

rollback;
    
-- Multi-table INSERT
drop table job_history_2005;
drop table job_history_2006;
drop table job_history_2007;
drop table job_history_old;
create table job_history_2005 as select * from job_history where 1=0;
create table job_history_2006 as select * from job_history where 1=0;
create table job_history_2007 as select * from job_history where 1=0;
create table job_history_old as select * from job_history where 1=0;

INSERT FIRST
  WHEN extract(year from end_date)=2005 THEN 
    INTO job_history_2005 (employee_id, start_date, end_date, job_id, department_id)
    VALUES (employee_id, start_date, end_date, job_id, department_id)
  WHEN extract(year from end_date)=2006 THEN 
    INTO job_history_2006 (employee_id, start_date, end_date, job_id, department_id)
    VALUES (employee_id, start_date, end_date, job_id, department_id)
  WHEN extract(year from end_date)=2007 THEN 
    INTO job_history_2007 (employee_id, start_date, end_date, job_id, department_id)
    VALUES (employee_id, start_date, end_date, job_id, department_id)
  ELSE 
    INTO job_history_old (employee_id, start_date, end_date, job_id, department_id)
    VALUES (employee_id, start_date, end_date, job_id, department_id)
SELECT employee_id, start_date, end_date, job_id, department_id
FROM job_history;

select * from job_history_2005;
select * from job_history_2006;
select * from job_history_2007;
select * from job_history_old;

rollback;


