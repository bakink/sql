REM https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:6071446400346871004
select replace( replace( replace( X , ' ', ' @'), '@ ', ''), ' @', ' ')
from (select 'hello                                                 world' x from dual )
/
