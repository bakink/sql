DROP TABLE jeff_source PURGE;
DROP TABLE jeff_target PURGE;
DROP SEQUENCE jeff_seq;
CREATE SEQUENCE jeff_seq;
CREATE TABLE jeff_source(non_key_col_value NUMBER NOT NULL) TABLESPACE ae_scratch;
INSERT INTO jeff_source
SELECT level non_key_col_value
FROM   dual
CONNECT BY level < 11;
COMMIT;
SELECT * FROM jeff_source;

CREATE TABLE jeff_target(surrogate_key_col NUMBER
                        ,non_key_col1 NUMBER NOT NULL) TABLESPACE ae_scratch;
INSERT INTO jeff_target(surrogate_key_col,non_key_col1)
SELECT jeff_seq.nextval
,      non_key_col_value
FROM   jeff_source;
COMMIT;
SELECT * FROM jeff_target;
INSERT INTO jeff_target(surrogate_key_col,non_key_col1)
SELECT jeff_seq.nextval
,      non_key_col_value 
FROM (
SELECT non_key_col_value
FROM   jeff_source
UNION ALL
SELECT non_key_col_value
FROM   jeff_source
)
;
COMMIT;
SELECT * FROM jeff_target;
