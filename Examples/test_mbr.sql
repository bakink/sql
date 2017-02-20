REM ALTER SESSION SET PARALLEL_FORCE_LOCAL=TRUE;

COLUMN sid HEADING "SID" FORMAT 999999
COLUMN name HEADING "Statistic Name" FORMAT A64
COLUMN value HEADING "Value" FORMAT 999999999999
SELECT s1.sid
,      s2.name
,      s1.value
FROM   v$sesstat s1
,      v$statname s2
,      v$px_session ps
WHERE  s1.statistic# = s2.statistic#
AND    s2.name IN('physical reads','physical read total bytes','physical read total multi block requests','physical read total IO requests')
AND    s1.sid = ps.qcsid(+)
AND    s1.sid = (SELECT DISTINCT sid from v$mystat);

SELECT /*+ FULL(xx) PARALLEL(xx,32) */ COUNT(*) FROM lws13 xx;

SELECT * FROM v$pq_tqstat;

SELECT s1.sid
,      s2.name
,      s1.value
FROM   v$sesstat s1
,      v$statname s2
,      v$px_session ps
WHERE  s1.statistic# = s2.statistic#
AND    s2.name IN('physical reads','physical read total bytes','physical read total multi block requests','physical read total IO requests')
AND    s1.sid = ps.qcsid(+)
AND    s1.sid = (SELECT DISTINCT sid from v$mystat);
