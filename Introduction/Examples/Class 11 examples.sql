
-- NOT NULL example
drop table tasks;
drop table person;
create table person(
   person_id  number(10)   not null
  ,full_name  varchar2(60) constraint person_fname_nn not null 
  ,birth_date date default SYSDATE
  ,sex        char(1)
);

select * from user_constraints where table_name = 'PERSON'

alter table person
  modify (birth_date not null);

insert into person (person_id) values (null);

-- UNIQUE example
drop table person;
create table person(
   person_id  number(10) constraint person_pid_un unique
  ,full_name  varchar2(60)
  ,birth_date date default SYSDATE
  ,sex        char(1)
  ,constraint person_name_date_un unique(full_name, birth_date) 
);

alter table person
  add constraint ux_person_all_cols
  unique (person_id,full_name,birth_date,sex);

insert into person (person_id,full_name, birth_date) values (1, 'John Doe', TRUNC(SYSDATE));
insert into person (person_id,full_name, birth_date) values (2, 'John Doe', TRUNC(SYSDATE));

-- PRIMARY KEY example
drop table person;
create table person(
   person_id  number(10)
  ,full_name  varchar2(60)
  ,birth_date date default SYSDATE
  ,sex        char(1)
);

alter table person
  add constraint pk_person
  primary key (person_id);

insert into person (person_id) values (1);
insert into person (person_id) values (1);
commit;

-- FOREIGN KEY examples
create table tasks(
  person_id number(10)
 ,task_text varchar2(255)
);

alter table tasks
  add constraint FK_tasks_person_id
  foreign key (person_id)
  references person(person_id);
  
select * from person
select * from tasks
  
insert into tasks(person_id, task_text) values (1,'Valid task');
insert into tasks(person_id, task_text) values (2,'No such person'); -- ORA-02293 parent key not found
delete from person where person_id = 1; -- ORA-02292 child record found
commit;

-- ON DELETE CASCADE 
alter table tasks
  drop constraint FK_tasks_person_id;

alter table tasks  
   add constraint FK_tasks_person_id  
   foreign key (person_id)  
   references person(person_id)
   on delete set null;
   
delete from person where person_id = 1;
select * from tasks;

-- CHECK examples
alter table person
  add constraint ck_person_sex
  check (sex in ('M','F'));
insert into person(person_id, sex) values (1,null);
insert into person(person_id, sex) values (1,'Y'); -- ORA-02290 check constraint violated
