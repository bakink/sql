COLUMN inst_id HEADING "Instance|ID" FORMAT 999
COLUMN statistic HEADING "Statistic" FORMAT a30
COLUMN last_query HEADING "Last|Query" FORMAT 999,999,999,999
COLUMN session_total HEADING "Session|Total" FORMAT 999,999,999,999
SELECT inst_id
,      statistic
,      last_query
,      session_total
FROM   gv$pq_sesstat
/
