CREATE TABLE test
  (
     column1    INTEGER NOT NULL 
    ,virtual_column1 INTEGER AS ( column1 ) VIRTUAL NOT NULL 
  )
/
CREATE TABLE test
  (
     column1    INTEGER NOT NULL 
    ,virtual_column1 INTEGER AS ( column1 + 0 ) VIRTUAL NOT NULL 
  )
/
DROP TABLE test PURGE
/
CREATE TABLE test
  (
     column1    INTEGER NOT NULL 
    ,virtual_column1 INTEGER AS ( column1 + 0 ) VIRTUAL NOT NULL 
    ,virtual_column2 INTEGER AS ( column1 + 0 ) VIRTUAL NOT NULL 
  )
/
CREATE TABLE test
  (
     column1    INTEGER NOT NULL 
    ,virtual_column1 INTEGER AS ( column1 + 0 ) VIRTUAL NOT NULL 
    ,virtual_column2 INTEGER AS ( column1 + 1 - 1 ) VIRTUAL NOT NULL 
  )
/
DROP TABLE test PURGE
/
