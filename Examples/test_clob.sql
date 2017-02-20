drop table clob_test purge;
create table clob_test(non_clob_col    number    not null
                      ,clob_col        clob      not null
					  ,non_clob_col2   number    not null
                      ,clob_col2       clob      not null
					   )
/
INSERT into clob_test 
	SELECT rownum
,      LPAD('X',12000,'X')
,      rownum
,      LPAD('X',12000,'X')
FROM   dual
CONNECT BY LEVEL < 20001
/
COMMIT
/
select count(*) from clob_test
/
select column_name,securefile,in_row from user_lobs where table_name='CLOB_TEST'
/
drop table clob_subset purge
/
create table clob_subset parallel 16 compress pctfree 0 as 
select non_clob_col,clob_col from clob_test where rownum<10000
/
