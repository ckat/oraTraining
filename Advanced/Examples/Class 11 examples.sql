/*
  Task 1. Fibonnacci series.
  
  Generate first 50 Fibonacci numbers by SQL query.
  Fibonacci numbers are defined by the following rules:
    F(0) = F(1) = 1;
    F(N) = F(N-1) + F(N-2), N >= 2;
*/


/*
  Task 2. String parsing.
  
  Table "TheString" contains one row and one field called "str".  
  This field stores some arithmetical expression with numbers, arithmetic signs and parenthesis’s.
  
  2a. Write a query that will return each symbol from the string as a separate row
  
  2b. Return position of first parenthesis that breaks correct parenthesis’s  sequence.
*/

drop table TheString;
create table TheString(str) as select '2*((5+7)+2*(2+3))*8)+9' from dual;

select * from TheString;

/*
  Task 3. Deposits. 
  
  Some person has a deposit account.
  From time to time he/she adds money to that account.
 
  Daily interest rate is 1% (yes, 365% per year!). Interest is paid each day. 
  Bank uses compound interest - i.e. sum of interest is added to account and used for calculations next day.
  For example, if initial sum is 1000, account dynamic would be:
    Day 1: 1000.00
    Day 2: 1010.00
    Day 3: 1020.10
    etc.
    
 Using payments information from DEPOSITS table, calculate:
   3a. Account balance on Jun 01, 2012.
   3b. Account balance for each day between account opening and Jun 01,2012
   
*/
drop table deposits;
create table deposits(TheDate,Payment) as
select DATE'2012-01-01', 1000 from dual union all
select DATE'2012-02-01', 1000 from dual union all
select DATE'2012-03-01', 500 from dual union all
select DATE'2012-04-01', 1000 from dual;

select * from deposits;

/*
  Task 4. Store dynamics
  
  Table STOCK contains some store IN (receiving goods) and OUT (shipping goods) operations
  -  OP_ID – unique operation identifier. Can be used for operations ordering – 
            i.e. operation with greater OP_ID is later operation.
  -  OP_TYPE – ‘IN’ or ‘OUT’;
  -  OP_COUNT – number if items received or shipped. Positive of both IN and OUT operations.
  
  4a. For each operation, calculate store balance before operation and after it.
  
  4b. Store implements FIFO (first in – first out) write-off method.  
      For each shipping (OUT) operation define how many items from which IN operation has to be written-off. 
*/
drop table stock;
create table stock(op_id, op_type, op_count) as
select 1, 'IN',  10 from dual union all
select 2, 'IN',  15 from dual union all
select 3, 'OUT', 5  from dual union all
select 4, 'OUT', 10 from dual union all
select 5, 'IN',  5  from dual union all
select 6, 'OUT', 12 from dual;

select * from stock;
