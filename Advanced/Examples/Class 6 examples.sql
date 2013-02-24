/*
  Table TUMBLER stores "turn on" and "turn off" events
  for some machine:
      - event_time - date and time of event
      - event_type - "ON" of "OFF" 
  Calculate how much time (in days) machine were ON and OFF
  during period represented in TUMBLER table
  Note: "ON" event can be followed by "OFF" event only and vice virsa
*/
drop table tumbler;
create table tumbler(event_time,event_type)
as
select DATE'2012-01-01','ON'  from dual union all
select DATE'2012-01-17','OFF' from dual union all
select DATE'2012-01-19','ON'  from dual union all
select DATE'2012-02-28','OFF' from dual union all
select DATE'2012-03-02','ON'  from dual;

select * from tumbler
order by event_time;

/*
  Each record in VISITS table represents one visit to client
  Company policy requires to visit each client not later than 
  in 30 days after previous visit.
  Find all visits that breaks this rule. S     how client_id, visit_date
  and number of days passed since previous visit.
*/
create table visits(client_id, visit_date)
as 
select 1, DATE'2012-01-01' from dual union all
select 1, DATE'2012-01-27' from dual union all
select 1, DATE'2012-02-28' from dual union all
select 1, DATE'2012-03-10' from dual union all
select 2, DATE'2012-02-10' from dual union all
select 2, DATE'2012-03-02' from dual union all
select 2, DATE'2012-05-20' from dual union all
select 3, DATE'2012-04-12' from dual union all
select 3, DATE'2012-04-28' from dual;

select * from visits 
order by client_id, visit_date;


/*
  Database table called CVs contains info about employees job history.
    last_name - employee last name. Unique.
    start_date - date of job start.
    end_date - date of job end.
    company - name of company employee worked for.
  You should find all periods when employee was working for two companies at the same time.
  For each such period show employee last_name, period start and end date and names of both companies
  Note: it's known that nobody have worked for three companies at the same time.
*/
drop table CVs;
create table CVs(last_name,start_date,end_date,company)
as
select 'Smith',DATE'2002-04-01',DATE'2003-08-12','Student''s heaven' from dual union all
select 'Smith',DATE'2003-08-13',DATE'2003-08-20','The big mistake' from dual union all
select 'Smith',DATE'2004-02-01',DATE'2008-09-30','Next step corp' from dual union all
select 'Smith',DATE'2008-10-01',TRUNC(SYSDATE),'Smith and co' from dual union all
select 'Baker',DATE'2001-01-01',DATE'2004-07-31','Sugar candies' from dual union all
select 'Baker',DATE'2002-03-01',DATE'2004-12-31','McDonalds' from dual union all
select 'Baker',DATE'2005-01-01',TRUNC(SYSDATE),'Sportlife' from dual union all
select 'Jeeves',DATE'1990-01-01',DATE'1993-12-31','Mr. Woodster' from dual union all
select 'Jeeves',DATE'1991-05-05',DATE'1992-12-31','Some TV show' from dual union all
select 'Jeeves',DATE'2004-01-01',TRUNC(SYSDATE),'Princeton-Plainsboro' from dual;

select * from CVs
order by last_name, start_date;


/*
  Income tax rate is some Banana Republic is changed very often.
  These changes are relexted in TAX_RATE table:
    - change_date - date when new tax rate is set.
    - rate - tax rate in percent.
  Using TAX_RATE table, report rate value for each day between min(change_date) and max(change_date)
*/
drop table tax_rate;
create table tax_rate(change_date,rate)
as
select DATE'2012-01-01', 10 from dual union all
select DATE'2012-01-04', 13 from dual union all
select DATE'2012-01-05', 15 from dual union all
select DATE'2012-01-10', 13 from dual;

select * from tax_rate order by change_date



/*
  Information about blank passport forms are stored in database table FORMS, one row per form.
  Due to paper saving initiative, we should show availale forms in continious ranges.
  Write a query to produce desired report.
*/
drop table forms;
create table forms(seria, numb)
as 
select 'AA',100000 from dual union all
select 'AA',100001 from dual union all
select 'AA',100005 from dual union all
select 'AA',100006 from dual union all
select 'BB',100004 from dual union all
select 'BB',100010 from dual union all
select 'BB',100011 from dual union all
select 'BB',100012 from dual;

select * from forms 
order by seria, numb

/*
  During the call mobile phone initiates a connection to cell
  and keeps it active until call end.
  If calling person is moving during the call, connection can be
  transfered from one cell to another to ensure high transmission quality.
  Table CONN contains information about phone-to-cell connections:
    - phone_no - phone number;
    - cell_id  - cell identificator;
    - start_time - date and time of connection start;
    - duration - connection duration in seconds.
  Two connections are considered to be parts of one call if
  difference between start_date1 + duration1 and start_date2 is less than one second.
  Using CONN table, report phone_number and start_time of each call.
*/
drop table CONN;
create table CONN(phone_no, cell_id, start_time, duration)
as 
select '111-11-11', 1 ,TO_DATE('01.10.2012 06:01:00','dd.mm.yyyy hh24:mi:ss'),18 from dual union all
select '111-11-11', 38,TO_DATE('01.10.2012 09:38:40','dd.mm.yyyy hh24:mi:ss'),124 from dual union all
select '222-22-22', 1 ,TO_DATE('01.10.2012 06:01:19','dd.mm.yyyy hh24:mi:ss'),71 from dual union all
select '222-22-22', 2 ,TO_DATE('01.10.2012 06:02:30','dd.mm.yyyy hh24:mi:ss'),193 from dual union all
select '222-22-22', 2 ,TO_DATE('01.10.2012 18:40:43','dd.mm.yyyy hh24:mi:ss'),17 from dual union all
select '222-22-22', 1 ,TO_DATE('01.10.2012 18:41:00','dd.mm.yyyy hh24:mi:ss'),89 from dual union all
select '333-33-33', 7 ,TO_DATE('01.10.2012 14:15:01','dd.mm.yyyy hh24:mi:ss'),10 from dual union all
select '333-33-33', 17,TO_DATE('01.10.2012 14:15:11','dd.mm.yyyy hh24:mi:ss'),48 from dual union all
select '333-33-33', 9 ,TO_DATE('01.10.2012 14:15:59','dd.mm.yyyy hh24:mi:ss'),156 from dual;

select * from CONN order by phone_no, start_time;


  

