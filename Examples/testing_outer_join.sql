DROP TABLE mand PURGE;
DROP TABLE opt PURGE;
CREATE TABLE mand(pk_col NUMBER NOT NULL
                 ,fk_col NUMBER NOT NULL
				 );
CREATE TABLE opt(fk_col NUMBER NOT NULL
                ,new_fk_col NUMBER NOT NULL
                ,master_flag VARCHAR2(1) NOT NULL
				);
INSERT INTO mand VALUES(1,10);
INSERT INTO mand VALUES(2,20);
INSERT INTO mand VALUES(3,30);
INSERT INTO mand VALUES(4,40);
INSERT INTO opt VALUES(20,200,'N');
INSERT INTO opt VALUES(30,200,'Y');
INSERT INTO opt VALUES(40,200,'N');
COMMIT;
SELECT mand.pk_col
,      mand.fk_col
,      opt.fk_col
,      opt.new_fk_col
,      opt.master_flag
FROM   mand
,      opt
WHERE  mand.fk_col = opt.fk_col(+)
--AND    NVL(opt.master_flag(+),'Y') = 'Y'
AND    opt.master_flag(+) = 'Y'
ORDER BY mand.pk_col
/
