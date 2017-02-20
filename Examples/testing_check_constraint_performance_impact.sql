REM Test the impact of having a check constraint on performance.
DROP TABLE check_constraint_test PURGE
/
CREATE TABLE check_constraint_test(dw_from_date    DATE              NOT NULL
				                  ,dw_to_date      DATE              NOT NULL
					              )
/
REM First insert without any constraints
INSERT INTO check_constraint_test
SELECT TO_DATE('01-JAN-2013','DD-MON-YYYY')
,      TO_DATE('02-JAN-2013','DD-MON-YYYY')
FROM   dual
CONNECT BY LEVEL < 10000001
/
COMMIT
/
REM Now put a CHECK constraint on and try again...
TRUNCATE TABLE check_constraint_test
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk1 CHECK(dw_from_date<=dw_to_date)
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk2 CHECK(dw_from_date<=dw_to_date)
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk3 CHECK(dw_from_date<=dw_to_date)
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk4 CHECK(dw_from_date<=dw_to_date)
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk5 CHECK(dw_from_date<=dw_to_date)
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk6 CHECK(dw_from_date<=dw_to_date)
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk7 CHECK(dw_from_date<=dw_to_date)
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk8 CHECK(dw_from_date<=dw_to_date)
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk9 CHECK(dw_from_date<=dw_to_date)
/
ALTER TABLE check_constraint_test ADD CONSTRAINT check_constraint_test_chk10 CHECK(dw_from_date<=dw_to_date)
/
INSERT INTO check_constraint_test
SELECT TO_DATE('01-JAN-2013','DD-MON-YYYY')
,      TO_DATE('02-JAN-2013','DD-MON-YYYY')
FROM   dual
CONNECT BY LEVEL < 10000001
/
COMMIT
/
