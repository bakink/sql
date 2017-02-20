DROP TABLE drop_column_test PURGE;
CREATE TABLE drop_column_test(col1 VARCHAR2(1) NOT NULL
                             ,col2 VARCHAR2(1) NOT NULL
                             ,col3 VARCHAR2(1) NOT NULL
                             ,col4 VARCHAR2(1) NOT NULL
                             ,col5 VARCHAR2(1) NULL
                             ,col6 VARCHAR2(1) NULL
                             ,col7 VARCHAR2(1) NULL
							 );
ALTER TABLE drop_column_test SET UNUSED(col2);
ALTER TABLE drop_column_test SET UNUSED(col3,col4);
ALTER TABLE drop_column_test DROP UNUSED COLUMNS;
ALTER TABLE drop_column_test DROP COLUMN col5;
ALTER TABLE drop_column_test DROP (col6,col7);

DROP TABLE drop_column_compressed_test PURGE;
CREATE TABLE drop_column_compressed_test(col1 VARCHAR2(1) NOT NULL
                             ,col2 VARCHAR2(1) NOT NULL
                             ,col3 VARCHAR2(1) NOT NULL
                             ,col4 VARCHAR2(1) NOT NULL
                             ,col5 VARCHAR2(1) NULL
                             ,col6 VARCHAR2(1) NULL
                             ,col7 VARCHAR2(1) NULL
							 )
COMPRESS;
ALTER TABLE drop_column_compressed_test SET UNUSED(col2);
ALTER TABLE drop_column_compressed_test SET UNUSED(col3,col4);
ALTER TABLE drop_column_compressed_test DROP UNUSED COLUMNS;
ALTER TABLE drop_column_compressed_test DROP COLUMN col5;
ALTER TABLE drop_column_compressed_test DROP (col6,col7);
