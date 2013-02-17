-- Implicit char-to-date conversion is bad idea
-- for sqlplus execution
alter session set nls_territory='CIS';
select sysdate from dual;
select 1 from dual where sysdate > '01.01.12';
alter session set nls_territory='AMERICA';
select 1 from dual where sysdate > '01.01.12'; -- not a valid month
select sysdate from dual;

-- date arithmetic examples
select sysdate, sysdate - 2 
from dual;

select sysdate, sysdate-10/(24*60*60) 
from dual;

select date'2012-12-31'-sysdate 
from dual;

-- DATE functions
select 
  SYSDATE
 ,ADD_MONTHS(SYSDATE,3)
 ,NEXT_DAY(SYSDATE, 'TUESDAY')
 ,LAST_DAY(SYSDATE)
 ,ROUND(SYSDATE,'YEAR')
 ,TRUNC(SYSDATE, 'MONTH')
 ,EXTRACT(YEAR from SYSDATE)
from dual;

-- CASE transformation functions
select
   LOWER('Oracle SQL') 
  ,UPPER('Oracle SQL') 
  ,INITCAP('Oracle SQL')
from dual;

-- PADDING
select
   LPAD('Oracle SQL',15, '*')
  ,RPAD('Oracle SQL',15, '*')
from dual;

-- TRIMING
select
   LTRIM('==> Oracle SQL <==','=><')
  ,RTRIM('==> Oracle SQL <==','=><')
  ,TRIM('=' FROM '==> Oracle SQL <==')
from dual;

-- SUBSTRING
select 
   SUBSTR('Oracle SQL', 1, 6) -- first 6 symbols
  ,SUBSTR('Oracle SQL',7)     -- from 7th to the end
  ,SUBSTR('Oracle SQL',-3)    -- last 3 symbols
from dual;

-- REPLACE
select
   REPLACE('Oracle SQL', 'Oracle', 'ANSI')
from dual;

-- TRANSLATE
select
   TRANSLATE('My translate test string','t ','T_') -- character-by-characte replacement
  ,TRANSLATE('My translate test string','t ','T')  -- replace and DELETE some characters
  ,TRANSLATE('M2y tr4a5nslate 8test st9ri7ng123','X1234567890','X') -- Just deletion. Note: NULL can't be used as third parameter
from dual;

-- INSTR (string, substring, position, occurrence)
select
   INSTR('121212','2')      -- first occurrence from the beginning
  ,INSTR('121212','2',3)    -- first occurrence from 3rd char
  ,INSTR('121212','2',3, 2) -- second occurrence from 3rd char
  ,INSTR('121212','2',-1)  -- first occurrence from the end
from dual;

-- LENGTH
select LENGTH('Oracle SQL')
from dual;

-- NUMERIC functions
select
  ABS(-10)
 ,MOD(10,3)
 ,ROUND(11/3)
 ,ROUND(3.14159,4)
 ,TRUNC(3.14159,4)
 ,SIGN(-10)
from dual;

-- NVL
select 
   NVL(null,0)
  ,NVL(10,0)
from dual;

-- NVL2
select
   NVL2(null,10,0)
  ,NVL2(10,11,0)
from dual;

--COALEACE
select
   COALESCE(null,null,10,null,null,20)
from dual;

-- LNNVL
select 'Condition is NOT true (it is unknown)'
from dual
where LNNVL(1 = null);


select 'Condition is NOT true (it is FALSE)'
from dual
where LNNVL(1 = 2);

select 'Condition is true'
from dual
where LNNVL(1 = 1); 


-- TO_DATE
select
   TO_DATE('31.12.2012','dd.mm.yyyy')
  ,TO_DATE('2012-DEC-31 13:00:01','yyyy-mon-dd hh24:mi:ss')
from dual;

-- TO_CHAR
select 
  TO_CHAR(sysdate,'DD-MON-yyyy')
 ,TO_CHAR(sysdate,'hh24:mi')
 ,TO_CHAR(1020.50,'$9999.99')
from dual;

-- TO_NUMBER
select 
  TO_NUMBER('$1,555.30','$9,999.99') + 1000
from dual;

-- CAST
select 
   CAST(sysdate AS timestamp with time zone)
from dual;


-- Simple CASE
select 
  first_name, last_name,phone_number
 ,case SUBSTR(phone_number,1,3)
    when '650' then 'Department #50'
    when '590' then 'Department #90'
               else 'Some other department'
  end as dep_info
from employees;

-- Searched case
select 
  first_name, last_name, salary,
  case 
     when salary < 8000                 then 'Low'
     when salary between 8000 and 12000 then 'Medium'
     when salary > 12000                then 'High'
                                        else 'Null salary!?'
  end
from employees;

-- DECODE #1
select
  first_name, last_name
 ,decode(SUBSTR(phone_number,1,3)
        ,'650','Department #50'
        ,'590','Department #90'
        ,'Some other department') as dep_info
from employees;

-- DECODE #2
select 
   first_name, last_name, salary
  ,DECODE(SIGN(salary-8000)
          ,-1,'Low'
          ,0,'8000'
          ,1,'Medium or high'
          ,'Null salary!?')
from employees;

-- EXPRESSION vs FUNCTION
create or replace function print_one
return number
as
begin
  DBMS_OUTPUT.PUT_LINE('1');
  return 0;
end;

select print_one from dual;

-- "1" is printed for each selected row
select 
  commission_pct
 ,NVL(commission_pct, print_one)
from employees
where commission_pct is not null;

-- "1" is not printed at all
select 
  commission_pct
 ,case
    when commission_pct is not null then commission_pct
                                    else print_one
  end
from employees
where commission_pct is not null;
