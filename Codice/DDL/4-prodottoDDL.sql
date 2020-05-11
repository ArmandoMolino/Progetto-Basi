--%%%%%		CASAPRODUTTRICE
CREATE TABLE casaproduttrice
(
	partita_iva 	CHAR(11),
	nome	VARCHAR(20) 	NOT NULL,
	nazionalita		VARCHAR(16) 	NOT NULL,
	CONSTRAINT 	pk_casaproduttrice 	PRIMARY KEY(partita_iva)
);

--%%%%%		PRODOTTO
CREATE TABLE prodotto
(
	codice_prodotto 	VARCHAR(16),
	anno_produzione	 DATE 	NOT NULL,
	prezzo 	FLOAT 	NOT NULL,
	nome 	VARCHAR(80)	 NOT NULL,
	partita_iva_casaprod 	CHAR(11) 	NOT NULL, 
	CONSTRAINT pk_prod PRIMARY KEY(codice_prodotto),
	CONSTRAINT fk_imp_casaprod 	FOREIGN KEY(partita_iva_casaprod) 	REFERENCES	casaproduttrice(partita_iva)
		ON DELETE CASCADE
);

--%%%%%		VENDE
CREATE TABLE vende
(
	loc_rep 	VARCHAR(25) ,
	flag_rep		CHAR(2) 	DEFAULT  'VE' 	CHECK(flag_rep = 'VE'),
	cod_prod	VARCHAR(16),
	cf_cli 	CHAR(16) ,
	data_e_ora 	DATE 	NOT NULL,
	quantita 	INTEGER		NOT NULL,
	CONSTRAINT pk_vende 	PRIMARY KEY(loc_rep,cod_prod,flag_rep,cf_cli,data_e_ora),
	CONSTRAINT fk_vende_cli 	FOREIGN KEY(cf_cli) 	REFERENCES cliente(cf)
		ON DELETE CASCADE,
	CONSTRAINT fk_vende_rep 	FOREIGN KEY(loc_rep,flag_rep) 	REFERENCES reparto(loc_reparto,flag_reparto)
		ON DELETE CASCADE,
	CONSTRAINT fk_vende_prod	 FOREIGN KEY(cod_prod) REFERENCES prodotto(codice_prodotto)
		ON DELETE CASCADE
);

--%%%%%		GADGET
CREATE TABLE gadget
(
	codice_gadget VARCHAR(16) ,
	tipo VARCHAR(20),
	CONSTRAINT 	pk_gad 		PRIMARY KEY(codice_gadget),
	CONSTRAINT 	fk_gad_prod	 	FOREIGN KEY(codice_gadget) 	REFERENCES prodotto(codice_prodotto) 
		ON DELETE CASCADE
);

--%%%%%		PERIFERICA
CREATE TABLE periferica
(
	codice_periferica 	VARCHAR(16),
	CONSTRAINT 		pk_per	 PRIMARY KEY(codice_periferica),
	CONSTRAINT 		fk_per_prod 	FOREIGN KEY(codice_periferica) REFERENCES prodotto(codice_prodotto) 
		ON DELETE CASCADE
);

--%%%%%		CONSOLE
CREATE TABLE console
(
	codice_console VARCHAR(16) NOT NULL,
	generazione INTEGER,
	CONSTRAINT pk_console  PRIMARY KEY(codice_console),
	CONSTRAINT fk_console_prod FOREIGN KEY(codice_console) REFERENCES prodotto(codice_prodotto) 
		ON DELETE CASCADE
);

--%%%%%		GIOCO_TAVOLO
CREATE TABLE gioco_tavolo
(
	codice_gioco_tavolo 	VARCHAR(16),
	pegi 	INTEGER 	NOT NULL,
	CONSTRAINT 		pk_gio_tav 		PRIMARY KEY(codice_gioco_tavolo),
	CONSTRAINT 		fk_gio_tav_prod		 FOREIGN KEY(codice_gioco_tavolo) REFERENCES prodotto(codice_prodotto) 
		ON DELETE CASCADE
);

--%%%%%		VIDEOGIOCO
CREATE TABLE videogioco
(
	codice_videogioco VARCHAR(16),
	pegi 	INTEGER	 	NOT NULL,
	CONSTRAINT pk_vid PRIMARY KEY(codice_videogioco),
	CONSTRAINT fk_vid_prodotto FOREIGN KEY(codice_videogioco) REFERENCES prodotto(codice_prodotto) 
		ON DELETE CASCADE
);

--%%%%%		GENERE
CREATE TABLE genere
(
	codice_prodotto VARCHAR(16) NOT NULL,
	tipo VARCHAR(30),
	CONSTRAINT pk_gen PRIMARY KEY(codice_prodotto,tipo),
	CONSTRAINT fk_gen_prod FOREIGN KEY(codice_prodotto) REFERENCES prodotto(codice_prodotto) 
		ON DELETE CASCADE
);