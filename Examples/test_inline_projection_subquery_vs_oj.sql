REM *************************************************************************
REM AUTHOR:  Jeff Moss
REM NAME:    test_inline_projection_subquery_vs_oj.sql
REM
REM *************************************************************************
REM
REM Purpose:
REM   This script shows the difference between an inline projection based subquery
REM   vs an outer join approach to get the same result.
REM
REM Change History
REM
REM Date         Author             Description
REM ===========  =================  ================================================
REM 15-FEB-2017  Jeff Moss          Initial Version
REM *************************************************************************
DROP TABLE test PURGE;
DROP TABLE test2 PURGE;
CREATE TABLE test(col1 NUMBER NOT NULL);
CREATE TABLE test2(col1 NUMBER NOT NULL);
INSERT INTO test SELECT LEVEL FROM dual CONNECT BY LEVEL <10001;
INSERT INTO test2 SELECT LEVEL FROM dual CONNECT BY LEVEL < 5001;
COMMIT;
SET AUTOTRACE TRACEONLY
SELECT test.col1
,      (CASE WHEN test.col1 NOT IN (SELECT col1 FROM test2) THEN 'N' ELSE 'Y' END) derived_col1
FROM   test
ORDER BY 1
/
SELECT test.col1
,      (CASE WHEN test2.col1 IS NOT NULL THEN 'Y' ELSE 'N' END) derived_col1
FROM   test
,      test2
WHERE  test.col1 = test2.col1(+)
ORDER BY 1
/
SET AUTOTRACE OFF
