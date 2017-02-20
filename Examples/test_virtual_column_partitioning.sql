DROP TABLE vc_test PURGE;
CREATE TABLE vc_test
  ( dw_from_date  DATE   NOT NULL
  , dw_to_date    DATE   NOT NULL
  , key_col       NUMBER NOT NULL
  , non_key_col   NUMBER NULL
  ,dwfd_year as (extract(year from dw_from_date) - 2000)
  ,dwtd_year as (extract(year from dw_to_date))
--  ,dwtd_year as (case extract(year from dw_to_date)
--            when 9999 then -1
--        else
--            extract(year from dw_to_date) - 2000
--        end)
--,   constraint vc_pk primary key(key_col, dw_from_date)
,   constraint ck_01 check(dw_from_date = trunc(dw_from_date))
,   constraint ck_02 check(dw_to_date = trunc(dw_to_date))
,   constraint ck_03 check(dw_to_date >= dw_from_date)
  )
PARTITION BY RANGE (dwtd_year)
INTERVAL (1) 
(
PARTITION P1 VALUES LESS THAN (0)
)
/
SELECT partition_name,high_value from user_tab_partitions WHERE table_name='VC_TEST' ORDER BY partition_position;
INSERT INTO vc_test(dw_from_date,dw_to_date,key_col,non_key_col) VALUES('01-JAN-2015','31-DEC-9999',1,2);
COMMIT;
SELECT partition_name,high_value from user_tab_partitions WHERE table_name='VC_TEST' ORDER BY partition_position;
INSERT INTO vc_test(dw_from_date,dw_to_date,key_col,non_key_col) VALUES('01-JAN-2015','01-FEB-2015',2,3);
COMMIT;
SELECT partition_name,high_value from user_tab_partitions WHERE table_name='VC_TEST' ORDER BY partition_position;

select dbms_stats.create_extended_stats(USER,'VC_TEST','(dw_to_date,dwtd_year)') FROM dual;
exec dbms_stats.gather_table_stats(ownname=>USER,tabname=>'VC_TEST',method_opt=>'for all columns size 1');

REM This does not prune...
EXPLAIN PLAN FOR
SELECT *
FROM   vc_test
WHERE  DATE '2016-06-01' BETWEEN dw_from_date AND dw_to_date
/
select plan_table_output from table(dbms_xplan.display(format=>'ALL -PROJECTION'));

REM This does not prune...
EXPLAIN PLAN FOR
SELECT *
FROM   vc_test
WHERE  SYSDATE BETWEEN dw_from_date AND dw_to_date
/
select plan_table_output from table(dbms_xplan.display(format=>'ALL -PROJECTION'));

REM This does not prune...
EXPLAIN PLAN FOR
SELECT *
FROM   vc_test
WHERE  dw_to_date = DATE '9999-12-31'
/
select plan_table_output from table(dbms_xplan.display(format=>'ALL -PROJECTION'));

REM This does not prune...
EXPLAIN PLAN FOR
SELECT *
FROM   vc_test
WHERE  SYSDATE <= dw_to_date
/
select plan_table_output from table(dbms_xplan.display(format=>'ALL -PROJECTION'));

REM This DOES prune...but then, it should!
EXPLAIN PLAN FOR
SELECT *
FROM   vc_test
WHERE  SYSDATE BETWEEN dw_from_date AND dw_to_date
AND    dwtd_year = TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))
/
select plan_table_output from table(dbms_xplan.display(format=>'ALL -PROJECTION'));
