--%%%%%		CLIENTE
CREATE TABLE cliente
(
	cf CHAR(16)	,
	data_di_nascita		DATE	NOT NULL,
	nome  	VARCHAR(15)		NOT NULL ,
	cognome 	VARCHAR(15)		NOT NULL ,
	secondo_nome 	VARCHAR(15)		 ,
	citta_residenza		VARCHAR(25)		NOT NULL ,
	CONSTRAINT pk_cli	PRIMARY KEY(cf),
	CONSTRAINT		size_cf_cliente		CHECK( length(cf) = 16 )
);
	
--%%%%%		CLIENTE REGISTRATO
CREATE TABLE cliente_reg
(
	cf_cliente 		CHAR(16),
	email 		VARCHAR(35) 	NOT NULL ,
	data_registrazione 		DATE		NOT NULL ,
	CONSTRAINT pk_cli_reg 	PRIMARY KEY(cf_cliente) ,
	CONSTRAINT fk_reg_cli FOREIGN KEY(cf_cliente) REFERENCES cliente(cf) 
		ON DELETE CASCADE,
	CONSTRAINT email_valide	CHECK( email like '%@%.com' or email like '%@%.net' or email like '%@%.it' or email like '%@%.org')
);

--%%%%%		TESSERA
CREATE TABLE tessera
(
	cod_tessera 	CHAR(10),
	data_scadenza 	DATE	NOT NULL,
	cf_cli_reg 		CHAR(16),
	CONSTRAINT		pk_tessera 	PRIMARY KEY(cod_tessera,cf_cli_reg), 
	CONSTRAINT 		fk_tes_reg	 FOREIGN KEY(cf_cli_reg) 	REFERENCES cliente_reg(cf_cliente)
		ON DELETE CASCADE
);	