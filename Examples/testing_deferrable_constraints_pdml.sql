REM Test what happens with PDML when running against a table with a deferrable constraint
COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN statistic HEADING "Statistic" FORMAT a30
COLUMN last_query HEADING "Last|Query" FORMAT 999,999,999,999
COLUMN session_total HEADING "Session|Total" FORMAT 999,999,999,999
SELECT statistic
,      session_total
FROM   gv$pq_sesstat
WHERE  statistic = 'DML Parallelized'
ORDER BY statistic
/

DROP TABLE defer_pdml_test PURGE
/
CREATE TABLE defer_pdml_test(part_key_col    DATE              NOT NULL
				            ,non_key_col     NUMBER            NOT NULL 
							           CONSTRAINT check1 CHECK (non_key_col BETWEEN 10 AND 99) 
							           INITIALLY DEFERRED DEFERRABLE ENABLE
					        )
PARTITION BY RANGE(part_key_col)
(PARTITION p1 VALUES LESS THAN (TO_DATE('01-SEP-2014','DD-MON-YYYY'))
,PARTITION p2 VALUES LESS THAN (TO_DATE('01-OCT-2014','DD-MON-YYYY'))
,PARTITION p3 VALUES LESS THAN (TO_DATE('01-NOV-2014','DD-MON-YYYY'))
,PARTITION p4 VALUES LESS THAN (TO_DATE('01-DEC-2014','DD-MON-YYYY'))
)
/
REM First insert without any constraints
ALTER SESSION FORCE PARALLEL DML PARALLEL 4
/
INSERT INTO defer_pdml_test
SELECT ADD_MONTHS(TO_DATE('01-AUG-2014','DD-MON-YYYY'),MOD(ROWNUM,4))
,      50
FROM   dual
CONNECT BY LEVEL < 100001
/
COMMIT
/
EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>USER,TABNAME=>'DEFER_PDML_TEST');
SELECT partition_name,num_rows
FROM   dba_tab_partitions
WHERE  table_Name='DEFER_PDML_TEST'
ORDER BY partition_position
/
COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN statistic HEADING "Statistic" FORMAT a30
COLUMN last_query HEADING "Last|Query" FORMAT 999,999,999,999
COLUMN session_total HEADING "Session|Total" FORMAT 999,999,999,999
SELECT statistic
,      session_total
FROM   gv$pq_sesstat
WHERE  statistic = 'DML Parallelized'
ORDER BY statistic
/

REM Now do it without the DEFERRABLE constraint...
DROP TABLE defer_pdml_test PURGE
/
CREATE TABLE defer_pdml_test(part_key_col    DATE              NOT NULL
				            ,non_key_col     NUMBER            NOT NULL 
							           CONSTRAINT check1 CHECK (non_key_col BETWEEN 10 AND 99) 
					        )
PARTITION BY RANGE(part_key_col)
(PARTITION p1 VALUES LESS THAN (TO_DATE('01-SEP-2014','DD-MON-YYYY'))
,PARTITION p2 VALUES LESS THAN (TO_DATE('01-OCT-2014','DD-MON-YYYY'))
,PARTITION p3 VALUES LESS THAN (TO_DATE('01-NOV-2014','DD-MON-YYYY'))
,PARTITION p4 VALUES LESS THAN (TO_DATE('01-DEC-2014','DD-MON-YYYY'))
)
/
REM First insert without any constraints
ALTER SESSION FORCE PARALLEL DML PARALLEL 4
/
INSERT INTO defer_pdml_test
SELECT ADD_MONTHS(TO_DATE('01-AUG-2014','DD-MON-YYYY'),MOD(ROWNUM,4))
,      50
FROM   dual
CONNECT BY LEVEL < 100001
/
COMMIT
/
EXEC DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>USER,TABNAME=>'DEFER_PDML_TEST');
SELECT partition_name,num_rows
FROM   dba_tab_partitions
WHERE  table_Name='DEFER_PDML_TEST'
ORDER BY partition_position
/
COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN statistic HEADING "Statistic" FORMAT a30
COLUMN last_query HEADING "Last|Query" FORMAT 999,999,999,999
COLUMN session_total HEADING "Session|Total" FORMAT 999,999,999,999
SELECT statistic
,      session_total
FROM   gv$pq_sesstat
WHERE  statistic = 'DML Parallelized'
ORDER BY statistic
/
