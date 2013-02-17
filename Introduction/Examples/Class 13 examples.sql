-- Table and data creation
--drop table TheBig;
--drop index IX_TheBig_ID;

create table TheBig
as 
  select 
    level as id 
   ,DBMS_RANDOM.string('A',5) as name
   ,DBMS_RANDOM.string('A',1000) as padder
  from dual
  connect by level <= 10000;
  
select * from TheBig where rownum = 1;

insert into TheBig 
select t.id,t.name,t.padder 
from TheBig t
  cross join (select level from dual connect by level <= 10);

-- Without index. 
select name from TheBig where id = 6;

-- create index
create index IX_TheBig_ID on TheBig(id);

-- with index. Should be fast
select name from TheBig where id = 6;


-- gather table (and index) statistics
begin
   DBMS_STATS.gather_table_stats(ownname => USER,tabname => 'THEBIG',cascade => true);
end;

-- Show plan for index range scan
select name from TheBig where id = 6;

-- Show plan for table access full
select name from TheBig where id > 0;


