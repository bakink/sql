DROP TABLE test_cb PURGE
/
CREATE TABLE test_cb(employee_id   NUMBER     NOT NULL
                    ,manager_id    NUMBER     NULL
					)
/
INSERT INTO test_cb VALUES(1,NULL);
INSERT INTO test_cb VALUES(2,1);
INSERT INTO test_cb VALUES(3,1);
INSERT INTO test_cb VALUES(4,1);
INSERT INTO test_cb VALUES(5,2);
INSERT INTO test_cb VALUES(6,2);
INSERT INTO test_cb VALUES(7,2);
INSERT INTO test_cb VALUES(8,3);
INSERT INTO test_cb VALUES(9,3);
INSERT INTO test_cb VALUES(10,3);
INSERT INTO test_cb VALUES(11,4);
INSERT INTO test_cb VALUES(12,4);
INSERT INTO test_cb VALUES(13,4);
COMMIT;
COLUMN level HEADING "Level" FORMAT 999999
COLUMN translated_manager_id HEADING "Manager|ID" FORMAT A8
COLUMN employee_id HEADING "Employee|ID" FORMAT 999999999
COLUMN cycle HEADING "Cycle" FORMAT 99999
COLUMN isleaf HEADING "Is|Leaf?" FORMAT 99999
COLUMN last_manager_id HEADING "Last Mgr|ID" FORMAT 999999999
COLUMN last_employee_id HEADING "Last Emp|ID" FORMAT 999999999
COLUMN path_manager_id HEADING "Path Mgr|ID" FORMAT A8
REM CLEAR BREAKS
REM BREAK ON translated_manager_id
SELECT LEVEL "level" -- Gives the level in the hierarchy
,      LPAD(' ',(LEVEL-1)*2,' ')||manager_id translated_manager_id
,      employee_id
,      CONNECT_BY_ISCYCLE cycle  -- Indicates if the row is the beginning of an endless loop
,      CONNECT_BY_ISLEAF isleaf  -- Flag indicating if the row is a leaf node - 1 for Yes, 0 for No
,      CONNECT_BY_ROOT employee_id last_employee_id -- Gives the root of the hierarchy for the current row
,      SYS_CONNECT_BY_PATH(manager_id, '/') path_manager_id -- Gives the full path of the hierarchy
FROM   test_cb
START WITH employee_id = 1
CONNECT BY NOCYCLE PRIOR employee_id = manager_id
ORDER SIBLINGS BY employee_id
/
