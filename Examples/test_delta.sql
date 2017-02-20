DROP TABLE target PURGE;
DROP TABLE source PURGE;
CREATE TABLE source(legacy_key_col1          NUMBER           NOT NULL
                   ,non_key_col1             VARCHAR2(10)
                   );
CREATE TABLE target(dw_from_date             DATE             NOT NULL
                   ,legacy_key_col1          NUMBER           NOT NULL
                   ,non_key_col1             VARCHAR2(10)
                   ,dw_to_date               DATE             NOT NULL
                   )
PARTITION BY RANGE(dw_to_date)
(PARTITION p_2012 VALUES LESS THAN(TO_DATE(' 2013-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
,PARTITION p_2013 VALUES LESS THAN(TO_DATE(' 2014-01-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS', 'NLS_CALENDAR=GREGORIAN'))
,PARTITION p_max VALUES LESS THAN(MAXVALUE)
);
INSERT INTO source VALUES(2,'DEFG');
INSERT INTO source VALUES(3,'NMOPQ');
INSERT INTO source VALUES(4,'XYZ');
INSERT INTO source VALUES(5,'UVW');
INSERT INTO source VALUES(5,'WXY');
INSERT INTO target VALUES('01-JAN-2013',1,'ABC','31-DEC-9999');
INSERT INTO target VALUES('01-JAN-2013',2,'DEF','31-JAN-2013');
INSERT INTO target VALUES('01-FEB-2013',2,'DEFG','31-DEC-9999');
INSERT INTO target VALUES('01-MAR-2013',3,'NMO','30-MAR-2013');
INSERT INTO target VALUES('31-MAR-2013',3,'NMOP','31-DEC-9999');
COMMIT;
SELECT s.legacy_key_col1
,      s.non_key_col1
,      t.dw_from_date
,      t.legacy_key_col1
,      t.non_key_col1
,      t.dw_to_date
,      (CASE WHEN s.legacy_key_col1 IS NULL AND t.legacy_key_col1 IS NOT NULL THEN 'D' 
             WHEN s.legacy_key_col1 IS NOT NULL AND t.legacy_key_col1 IS NULL THEN 'I' 
             WHEN s.legacy_key_col1 IS NOT NULL AND t.legacy_key_col1 IS NOT NULL 
              AND NVL(s.non_key_col1,LPAD('X',11,'X')) != NVL(t.non_key_col1,LPAD('X',11,'X'))
             THEN 'U'
              END) transaction_type
,      COUNT(*) OVER(PARTITION by s.legacy_key_col1) source_key_count
FROM   source s
FULL OUTER JOIN target partition(p_max) t
ON  s.legacy_key_col1 = t.legacy_key_col1
ORDER BY transaction_type NULLS LAST

