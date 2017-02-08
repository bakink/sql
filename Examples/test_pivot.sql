REM Oracle Docs 11g: http://docs.oracle.com/cd/E11882_01/server.112/e41084/statements_10002.htm#CHDFIIDD
REM Oracle Docs 12c: http://docs.oracle.com/database/121/SQLRF/statements_10002.htm#CHDFIIDD
REM Appears to be no change between 11g and 12c, at least the documentation is exactly the same.

SET VERIFY OFF
SET FEEDBACK ON
SET ECHO OFF

DROP TABLE test PURGE;
CREATE TABLE test(col1                 NUMBER       NOT NULL
                 ,col2                 NUMBER       NOT NULL
				 ,unpivoted_col_id     NUMBER       NOT NULL
				 ,unpivoted_col_val    NUMBER       NULL
				 );
INSERT INTO test VALUES(1,10,1,101);
INSERT INTO test VALUES(1,10,2,102);
INSERT INTO test VALUES(1,10,3,103);
INSERT INTO test VALUES(1,10,4,104);
INSERT INTO test VALUES(1,10,5,105);
INSERT INTO test VALUES(2,20,1,201);
INSERT INTO test VALUES(2,20,2,NULL);
INSERT INTO test VALUES(2,20,3,203);
INSERT INTO test VALUES(2,20,4,204);
INSERT INTO test VALUES(2,20,5,205);
COMMIT;
PROMPT Select all the rows from the table...
SELECT * FROM test ORDER BY col1;
PROMPT Pivot the rows...
PROMPT ...Select all columns and rows
PROMPT ...Order by displayed column
SELECT *
FROM   test
PIVOT
(
  SUM(unpivoted_col_val)
    for unpivoted_col_id in (1 as pivoted_col_1,2 as pivoted_col_2,3 as pivoted_col_3,4 as pivoted_col_4,5 as pivoted_col_5)
)
ORDER BY col1
/

PROMPT ...Do not select PIVOTED_COL_5 at all
PROMPT ...Filter by displayed column
PROMPT ...Order by displayed column
SELECT col1,col2,pivoted_col_1,pivoted_col_2,pivoted_col_3,pivoted_col_4
FROM   test
PIVOT
(
  SUM(unpivoted_col_val)
    for unpivoted_col_id in (1 as pivoted_col_1,2 as pivoted_col_2,3 as pivoted_col_3,4 as pivoted_col_4,5 as pivoted_col_5)
)
WHERE col1 = 2
ORDER BY col1
/

PROMPT ...From the selected unpivoted columns, do not pivot PIVOTED_COL_4
PROMPT ...Filter by non displayed column
PROMPT ...Order by non displayed column
SELECT col1,pivoted_col_1,pivoted_col_2,pivoted_col_3,pivoted_col_5
FROM   test
PIVOT
(
  SUM(unpivoted_col_val)
    for unpivoted_col_id in (1 as pivoted_col_1,2 as pivoted_col_2,3 as pivoted_col_3,5 as pivoted_col_5)
)
WHERE col2 = 10
ORDER BY col2
/
