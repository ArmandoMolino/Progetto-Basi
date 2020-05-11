--%%%%%		FORNITORE
CREATE TABLE fornitore
(
	partita_iva 	CHAR(11), 
	nome 	VARCHAR(16) 	NOT NULL,
	nazionalita		VARCHAR(16) 	NOT NULL,
	CONSTRAINT 	pk_fornitore 	PRIMARY KEY(partita_iva)
);

--%%%%%		FORNITURA
CREATE TABLE fornitura
(
	data DATE,
	partita_iva_for 	CHAR(11) 	NOT NULL, 
	costo 	FLOAT ,
	CONSTRAINT 	pk_fornitura 	PRIMARY KEY(data,partita_iva_for),
	CONSTRAINT 	fk_fornitura_fornitore 	FOREIGN KEY(partita_iva_for) REFERENCES fornitore(partita_iva) 
		ON DELETE CASCADE
);

--%%%%%		PRODOTTI_CONTENUTI
CREATE TABLE prodotti_contenuti
(
	data_for	DATE,
	partita_iva_for		CHAR(11) ,
	codice_prod 	VARCHAR(16),
	quantita 	INTEGER 	DEFAULT(1),
	CONSTRAINT 	pk_prodcont 	PRIMARY KEY(data_for,partita_iva_for,codice_prod),
	CONSTRAINT	fk_prodcont_fornitura	FOREIGN KEY(data_for,partita_iva_for)	REFERENCES fornitura(data,partita_iva_for)
		ON DELETE CASCADE,
	CONSTRAINT	fk_prodcont_prod	FOREIGN KEY(codice_prod)	REFERENCES prodotto(codice_prodotto)
		ON DELETE CASCADE
);

--%%%%%		APPROVVIGGIONAMENTO
CREATE TABLE approvviggionamento
(
	data	DATE,
	loc_filiale 	VARCHAR(25),
	CONSTRAINT	pk_app	PRIMARY KEY(data,loc_filiale),
	CONSTRAINT	fk_app_cons		FOREIGN KEY(loc_filiale)	REFERENCES filiale(localita)
		ON DELETE CASCADE
);

--%%%%%		CONSISTE
CREATE TABLE consiste
(
	data_app	DATE,
	loc_fil 	VARCHAR(25),
	codice_prod		VARCHAR(16),
	quantita 	INTEGER,
	CONSTRAINT	pk_cons		PRIMARY KEY(data_app,loc_fil,codice_prod),
	CONSTRAINT	fk_cons_app		FOREIGN KEY(data_app,loc_fil)	REFERENCES approvviggionamento(data,loc_filiale)
		ON DELETE CASCADE,
	CONSTRAINT	fk_cons_prod		FOREIGN KEY(codice_prod)	REFERENCES prodotto(codice_prodotto)
		ON DELETE CASCADE
);