DROP table target PURGE;
REM Legacy key is COL_LEGACY_PK, SCD2 key is therefore (COL_LEGACY_PK+DW_FROM_DATE)
CREATE TABLE target(col_legacy_pk   NUMBER NOT NULL
                   ,dw_from_date    DATE NOT NULL
                   ,col_non_pk1     VARCHAR2(200) 
                   ,dw_to_date      DATE
                   );
INSERT INTO target VALUES(1,'01-JAN-2013','row 1','31-JAN-2013');
INSERT INTO target VALUES(1,'01-FEB-2013','row 1 amended',NULL);
INSERT INTO target VALUES(2,'28-FEB-2013','row 2',NULL);
COMMIT;
MERGE INTO target a
    USING (SELECT 1 col_legacy_pk,'01-FEB-2013' dw_from_date,'row 1 amended' col_non_pk1,'28-FEB-2013' dw_to_date FROM dual UNION ALL
           SELECT 1 col_legacy_pk,'01-MAR-2013' dw_from_date,'row 1 amended again' col_non_pk1,NULL dw_to_date FROM dual UNION ALL
           SELECT 3 col_legacy_pk,'01-MAR-2013' dw_from_date,'row 3' col_non_pk1,NULL dw_to_date FROM dual 
           UNION ALL SELECT 3 col_legacy_pk,'01-MAR-2013' dw_from_date,'row 3b' col_non_pk1,NULL dw_to_date FROM dual
          ) b
    ON (a.col_legacy_pk = b.col_legacy_pk
        AND a.dw_from_date = b.dw_from_date)
  WHEN MATCHED THEN
    UPDATE SET a.dw_to_date        = b.dw_to_date
  WHEN NOT MATCHED THEN
    INSERT (col_legacy_pk, dw_from_date, col_non_pk1)
    VALUES (b.col_legacy_pk, b.dw_from_date, b.col_non_pk1);
select * from target order by 1,2
rollback;
desc ae_stg_gsd.stg_gsd_v_pa_delta
