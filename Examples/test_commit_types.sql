REM DROP TABLE commit_test PURGE;
REM CREATE TABLE commit_test(id NUMBER,description VARCHAR2(250));
DECLARE
PROCEDURE do_loop (p_type IN VARCHAR2) AS
 l_start NUMBER;
 l_loops NUMBER := 10000;
 v1 NUMBER;
 v2 NUMBER;
BEGIN
 EXECUTE IMMEDIATE 'ALTER SESSION SET COMMIT_WRITE="' || p_type || '"';
 EXECUTE IMMEDIATE 'TRUNCATE TABLE commit_test REUSE STORAGE';
 EXECUTE IMMEDIATE 'select TOTAL_WAITS from v$system_event where event like ''log file sync%''' into v1;

 l_start := DBMS_UTILITY.get_time;
 FOR i IN 1 .. l_loops LOOP
  INSERT INTO commit_test (id, description)
  VALUES (i, 'Description for ' || i);
  COMMIT;
 END LOOP;
 EXECUTE IMMEDIATE 'select TOTAL_WAITS - ' || v1 || ' from v$system_event where event like ''log file sync%'' ' into v2;
 DBMS_OUTPUT.put_line(RPAD('COMMIT_WRITE=' || p_type, 30) || ': ' || (DBMS_UTILITY.get_time - l_start) || ' — TOTAL WAITS: ' || v2 );
END;

BEGIN
 do_loop('WAIT');
 do_loop('NOWAIT');
 do_loop('BATCH');
 do_loop('IMMEDIATE');
 do_loop('BATCH,WAIT');
 do_loop('BATCH,NOWAIT');
 do_loop('IMMEDIATE,WAIT');
 do_loop('IMMEDIATE,NOWAIT');
END;
/
