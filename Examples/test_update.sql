DROP TABLE target PURGE;
DROP TABLE source PURGE;
CREATE TABLE source(key_col1          NUMBER           NOT NULL
                   ,non_key_col1             VARCHAR2(200)
                   )
STORAGE(INITIAL 1M NEXT 1M);
CREATE TABLE targeti(key_col1          NUMBER           NOT NULL
                    ,non_key_col1             VARCHAR2(200)
                    )
PARTITION BY HASH(key_col1) PARTITIONS 16
STORAGE(INITIAL 1M NEXT 1M);
CREATE INDEX target_pk ON targeti(key_col1);
CREATE TABLE targetn(key_col1          NUMBER           NOT NULL
                    ,non_key_col1             VARCHAR2(200)
                    )
PARTITION BY HASH(key_col1) PARTITIONS 16
STORAGE(INITIAL 1M NEXT 1M);
alter session force parallel dml parallel 16;
INSERT INTO targeti
SELECT ROWNUM
,      LPAD(TO_CHAR(ROWNUM),200,'X')
FROM   (SELECT ROWNUM
        FROM   dual
        CONNECT BY LEVEL <= 40000
       )
,      (SELECT ROWNUM
        FROM   dual
        CONNECT BY LEVEL <= 1000
       );
REM 184s
COMMIT;
alter session force parallel dml parallel 16;
INSERT INTO targetn
SELECT ROWNUM
,      LPAD(TO_CHAR(ROWNUM),200,'X')
FROM   (SELECT ROWNUM
        FROM   dual
        CONNECT BY LEVEL <= 40000
       )
,      (SELECT ROWNUM
        FROM   dual
        CONNECT BY LEVEL <= 1000
       );
REM 87s
COMMIT;
alter session force parallel dml parallel 16;
INSERT INTO source
SELECT ROWNUM
,      LPAD(TO_CHAR(ROWNUM),200,'Y')
FROM   dual
CONNECT BY LEVEL < 1200001;
COMMIT;
SELECT segment_name,sum(bytes)/(1024*1024*1024) GB FROM user_segments where segment_name in('TARGETI','TARGETN','SOURCE') group by segment_name;
exec dbms_stats.gather_Table_stats(ownname=>USER,tabname=>'SOURCE',degree=>16);
exec dbms_stats.gather_Table_stats(ownname=>USER,tabname=>'TARGETI',degree=>16,cascade=>TRUE);
exec dbms_stats.gather_Table_stats(ownname=>USER,tabname=>'TARGETN',degree=>16);
alter system flush buffer_cache;
alter session enable parallel dml;
alter session force parallel dml parallel 16;
alter session force parallel query parallel 16;
UPDATE targeti target
SET (target.non_key_col1) = (SELECT source.non_key_col1
                             FROM   source
                             WHERE  source.key_col1 = target.key_col1)
WHERE EXISTS(SELECT 1
             FROM   source
             WHERE  source.key_col1 = target.key_col1);
REM 6.1s
rollback;
alter system flush buffer_cache;
alter session enable parallel dml;
alter session force parallel dml parallel 16;
alter session force parallel query parallel 16;
UPDATE targetn target
SET (target.non_key_col1) = (SELECT source.non_key_col1
                             FROM   source
                             WHERE  source.key_col1 = target.key_col1)
WHERE EXISTS(SELECT 1
             FROM   source
             WHERE  source.key_col1 = target.key_col1);
REM 6.1s
rollback;
alter system flush buffer_cache;
alter session disable parallel dml;
alter session force parallel query parallel 16;
DECLARE
 CURSOR c IS SELECT key_col1,non_key_col1 FROM source;
BEGIN
 FOR r IN c LOOP
  UPDATE targeti target SET target.non_key_col1 = r.non_key_col1 WHERE target.key_col1 = r.key_col1;
 END LOOP;
END;
/
REM 9.9s
ROLLBACK;
alter system flush buffer_cache;
alter session disable parallel dml;
alter session force parallel query parallel 16;
DECLARE
 CURSOR c IS SELECT key_col1,non_key_col1 FROM source;
BEGIN
 FOR r IN c LOOP
  UPDATE targetn target SET target.non_key_col1 = r.non_key_col1 WHERE target.key_col1 = r.key_col1;
 END LOOP;
END;
/
REM 9.9s
ROLLBACK;


  UPDATE targeti target SET target.non_key_col1 = :non_key_col1 WHERE target.key_col1 = :key_col1;
  UPDATE targetn target SET target.non_key_col1 = :non_key_col1 WHERE target.key_col1 = :key_col1;
