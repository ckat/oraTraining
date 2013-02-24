/*2.1. Select all subordinates of Steven King; */
SELECT employee_id, manager_id, last_name FROM EMPLOYEES
START WITH manager_id = (SELECT employee_id FROM EMPLOYEES WHERE first_name = 'Steven' AND last_name = 'King')
CONNECT BY manager_id = prior employee_id;

/*
2.2. Select all managers of employee with phone_number = '650.505.2876'. Don't show that employee 
himself. 
*/
SELECT employee_id, manager_id, last_name, phone_number FROM EMPLOYEES
START WITH employee_id = (SELECT manager_id FROM EMPLOYEES WHERE phone_number = '650.505.2876')
CONNECT BY employee_id = prior manager_id;
/*
2.3. For each 'Programmer' show list of his managers from top to bottom (like '/King/..../TheProgrammer'). 
*/
SELECT last_name, job_title, sys_connect_by_path(last_name, '/') thelist 
FROM EMPLOYEES emp 
JOIN jobs jb ON emp.job_id = jb.job_id
WHERE job_title = 'Programmer'
START with (manager_id is null) -- top manager
CONNECT BY manager_id = prior employee_id;
/*
2.4. List all second-level subordinates of Steven King (direct subordinates are first-level subordinates). 
*/
SELECT employee_id, last_name, first_name FROM EMPLOYEES
WHERE level = 2
START WITH manager_id = (SELECT employee_id FROM EMPLOYEES WHERE first_name = 'Steven' AND last_name = 'King')
CONNECT BY manager_id = prior employee_id;
/*
2.5. For each employee show his salary and total salary of all his managers. Preserve tree structure in output. 
*/
/*
2.6. Generate list of dates from sysdate to last day of the year. 
*/
SELECT TRUNC(SYSDATE) + level - 1 as DAT FROM dual 
connect by level <= TRUNC(ADD_MONTHS(SYSDATE,12), 'YY') - SYSDATE + 1;

/*
Task 1.1 (SH)
Create report in Sales History schema.
For each calendar week of year 1998 show number of sold items of each product having name starting with ?Multimedia?. Report should be ?dense?.
Please, check "Expected result" for output example.
*/
SELECT spprod.prod_name, allWeeks.Calendar_Week_Number, NVL(CNT, 0) as CNT FROM(
SELECT pd.prod_name, t.calendar_week_number, COUNT(*) as CNT
FROM sales sl 
     JOIN products pd ON sl.prod_id = pd.prod_id
     JOIN times t ON sl.time_id = t.time_id
WHERE t.calendar_year = '1998' AND prod_name LIKE 'Multimedia%'
GROUP BY pd.prod_name, t.calendar_week_number) spprod
PARTITION BY (spprod.prod_name)
RIGHT JOIN
(
      SELECT DISTINCT calendar_week_number FROM times
      WHERE times.calendar_year = '1998'
) allWeeks
ON spprod.calendar_week_number = allWeeks.calendar_week_number
ORDER BY spprod.prod_name, allWeeks.Calendar_Week_Number ASC
