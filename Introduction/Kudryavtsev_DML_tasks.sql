-- ======= Task 8 ========
--Add yourself to EMPLOYEES table
INSERT
INTO EMPLOYEE2
(
EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
)
VALUES
(
employees_seq.nextval,'Alexander','Kudryavtsev', 'alfa', '555.000', date'2012-01-10', 'IT_PROG', 9000, null, 100, 90
);
 
--Update all emails in EMPLOYEES table adding "@epam.com" to the end
update employee
set email = email || '@epam.com';
 
--Set all employees’ salary to maximum salary available for their position (see JOBS table)
update employee emp
set salary = (
select max_salary from jobs jb
where jb.job_id = emp.job_id
);
 
--Delete records with even EMPLOYEE_ID from JOB_HISTORY table
delete from job_history
where mod(employee_id,2) = 0;
 
--Delete current records from JOB_HISTORY table. Record is considered "current" if combination
--of (employee_id, start_date, job_id and department_id) is present in EMPLOYEES table
select * from job_history jh
where exists (select * from employee emp
where emp.employee_id = jh.employee_id
and emp.hire_date = jh.start_date
and emp.job_id = jh.job_id
and emp.department_id = jh.department_id);
 
--Modify you own record in EMPLOYESS (added in Task #1) to have NULL in DEPARTMENT_ID
update employee set department_id = null
where first_name = 'Alexander'
and last_name = 'Kudryavtsev'
and hire_date = date'2012-01-10';
 
-- Modify "MERGE INTO emp_directory" statement shown in class. For employees without
--department DEPARTMENT_ID and CITY fields should be set to 'Unknown' in both insert and
--update part of statement.
merge into emp_directory old
using (
select
e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, j.job_title
,d.department_name, l.city
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
,old.department_name = NVL(new.department_name, 'Unknown')
,old.city = NVL(new.city, 'Unknown')
when not matched then insert
(employee_id,first_name,last_name,email,phone_number,job_title, department_name,city)
values (new.employee_id,new.first_name,new.last_name,new.email,new.phone_number,
new.job_title, NVL(new.department_name, 'Unknown'), NVL(new.city,'Unknown'));
 
 
--====== Task 9 ======
select count(*) from dba_objects;
 
--Using USER_TAB_COLUMNS view create two-column report. First column should contain table name, second column – comma separated list of table’s columns.
select table_name, listagg(column_name, ', ') WITHIN GROUP (ORDER BY column_name) as tcolumns
FROM user_tab_columns
GROUP BY table_name;
 
--Using DBA_USERS view create report showing user name, date of account creation and current account status
select username, created, account_status from dba_users;
 
--Using DBA_USERS and v$session view find number of currently connected sessions for each
--user in the database. Order list by number of sessions.
select du.username, count(1) SC from v$session sess
JOIN dba_users du
ON sess.user# = du.user_id
GROUP BY du.username
ORDER BY SC DESC;
 
 
--Create table COMPANIES to store the following information:
-- o ID of company. Integer number, as large as possible.
-- o Company name. String, max. 40 characters length.
-- o Full name of company. String, 255 characters length.
-- o Date of company foundation. If not provided – should be set to current date.
-- o Country of residence code. Two characters.
-- o Yearly revenue. Should be automatically rounded to $1000.
CREATE TABLE companies(
id number(38,0),
name varchar2(40 char),
full_name varchar2(255 char),
foundation_date date default sysdate,
country varchar2(2 char),
year_revenue number(20,-3)
);
 
-- ========= Task 10 =========
--Modify table COMPANIES created at the previous lesson:
--a. Make ID of company necessary and unique.
alter table companies add constraint pk_companies primary key(id);
--b. Make company name necessary.
alter table companies modify (name not null);
--c. Enforce the following rule: if full name of company is present, it should be unique.
alter table companies add constraint comp_fname_uq unique(full_name);
--d. Enforce the following rule: date of company foundation should be JUST date, without time.
alter table companies add constraint ck_date_trunc check (trunc(foundation_date) = foundation_date);
--e. Enforce the following rule: country of residence code should be in UPPERCASE.
alter table companies add constraint ck_residence_upp check (country = UPPER(country));
 
-- Modify EMPLOYEES table:
-- a. Add necessary field COMPANY_ID.
alter table employees add (company_id number(38,0) default 4 not null);-- using arbitrary handmade company
-- b. Ensure that value of this field is one of company id's from COMPANY table;
-- c. Ensure that company can't be deleted if it has at least one employee.
alter table employees add constraint FK_company
foreign key(company_id)
references companies(id);--on delete - forbiden by default;