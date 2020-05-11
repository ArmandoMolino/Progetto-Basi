CREATE OR REPLACE PROCEDURE registra_cliente(szCF in VARCHAR, szEmail in VARCHAR) AS

codTesseraSeed INTEGER;
szRandomString VARCHAR(10);

BEGIN

INSERT INTO	cliente_reg	 VALUES(szCF,szEmail,sysdate); 
SELECT ORA_HASH(LOWER(szCF),999999) into codTesseraSeed from DUAL;
DBMS_RANDOM.seed(codTesseraSeed);
SELECT dbms_random.string('x',10) into szRandomString from DUAL;
INSERT INTO tessera	VALUES(szRandomString,sysdate+366,szCF); 
COMMIT;


END;
/
show errors