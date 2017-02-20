SPOOL c:\scripts\examples\DV_INSERTNew_vs_MERGE_vs_INSERTIgnoreErrors.log

DROP TABLE source PURGE;
DROP TABLE target PURGE;
CREATE TABLE source(business_key NUMBER NOT NULL);
CREATE TABLE target(hub_key RAW(32) NOT NULL,business_key NUMBER NOT NULL,load_date DATE NOT NULL,load_record_source VARCHAR2(100) NOT NULL);
ALTER TABLE target ADD CONSTRAINT tgt_pk PRIMARY KEY(hub_key);
ALTER TABLE target ADD CONSTRAINT tgt_uk UNIQUE(business_key);
REM Some good records...
INSERT INTO source SELECT rownum FROM dual CONNECT BY LEVEL < 1000001;
REM Now some dupes...
INSERT INTO source SELECT rownum FROM dual CONNECT BY LEVEL < 11;
COMMIT;
INSERT INTO target(hub_key,business_key,load_date,load_record_source)
SELECT DISTINCT dbms_crypto.hash(utl_raw.cast_to_raw(UPPER(TO_CHAR(src.business_key))||'^'),3)
,      src.business_key
,      SYSDATE
,      'ICE1.ICE.CUSTOMER.ICE_CUSTOMER_ID'
FROM   source src
,      target tgt
WHERE  src.business_key = tgt.business_key(+)
AND    tgt.business_key IS NULL
/
COMMIT;
INSERT INTO target(hub_key,business_key,load_date,load_record_source)
SELECT DISTINCT dbms_crypto.hash(utl_raw.cast_to_raw(UPPER(TO_CHAR(src.business_key))||'^'),3)
,      src.business_key
,      SYSDATE
,      'ICE1.ICE.CUSTOMER.ICE_CUSTOMER_ID'
FROM   source src
,      target tgt
WHERE  src.business_key = tgt.business_key(+)
AND    tgt.business_key IS NULL
/
COMMIT;
TRUNCATE TABLE target;
MERGE INTO target tgt
USING (SELECT DISTINCT business_key
       FROM   source
	  ) src
ON (src.business_key = tgt.business_key)
WHEN NOT MATCHED THEN
INSERT (hub_key,business_key,load_date,load_record_source)
VALUES(dbms_crypto.hash(utl_raw.cast_to_raw(UPPER(TO_CHAR(src.business_key))||'^'),3)
,      src.business_key
,      SYSDATE
,      'ICE1.ICE.CUSTOMER.ICE_CUSTOMER_ID')
/
COMMIT;
MERGE INTO target tgt
USING (SELECT DISTINCT business_key
       FROM   source
	  ) src
ON (src.business_key = tgt.business_key)
WHEN NOT MATCHED THEN
INSERT (hub_key,business_key,load_date,load_record_source)
VALUES(dbms_crypto.hash(utl_raw.cast_to_raw(UPPER(TO_CHAR(src.business_key))||'^'),3)
,      src.business_key
,      SYSDATE
,      'ICE1.ICE.CUSTOMER.ICE_CUSTOMER_ID')
/
COMMIT;
REM Following is very slow when doing subsequent runs because of recursive SQL calls
--TRUNCATE TABLE target;
--INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(target(business_key)) */ INTO target
--SELECT DISTINCT dbms_crypto.hash(utl_raw.cast_to_raw(UPPER(TO_CHAR(src.business_key))||'^'),3)
--,      src.business_key
--,      SYSDATE
--,      'ICE1.ICE.CUSTOMER.ICE_CUSTOMER_ID'
--FROM   source src
--/
--COMMIT;
--INSERT /*+ IGNORE_ROW_ON_DUPKEY_INDEX(target(business_key)) */ INTO target
--SELECT DISTINCT dbms_crypto.hash(utl_raw.cast_to_raw(UPPER(TO_CHAR(src.business_key))||'^'),3)
--,      src.business_key
--,      SYSDATE
--,      'ICE1.ICE.CUSTOMER.ICE_CUSTOMER_ID'
--FROM   source src
--/
--COMMIT;
SPOOL OFF
