--%%%%%		EVENTO
CREATE TABLE evento
(
	localita_evento	VARCHAR(25),
	data_inizio		DATE,
	data_fine		DATE	NOT	NULL,	
	CONSTRAINT	pk_eve	PRIMARY KEY(data_inizio, localita_evento),
	CONSTRAINT	fk_eve_filiale	FOREIGN KEY(localita_evento) 		REFERENCES filiale(localita)
		ON DELETE CASCADE,
	CONSTRAINT	data_ok_evento		CHECK(data_fine > data_inizio)
);

--%%%%%		TORNEO
CREATE TABLE torneo
(
	data_inizio_torneo	DATE,
	localita_torneo	 VARCHAR(25),
	quota	FLOAT		NOT NULL,
	premio		INTEGER		NOT NULL,
	nome_gioco		VARCHAR(30)		NOT NULL,
	piattaforma		VARCHAR(20)		NOT NULL,
	max_partecipanti	INTEGER		DEFAULT	15,
	CONSTRAINT		max_ammessi		CHECK ( max_partecipanti > 4 AND max_partecipanti < 31 ),
	CONSTRAINT		piattaforma_ammessa 	CHECK( piattaforma in ( 'SNES Classic Mini', 'NES Classic Mini', 'Sega Megadrive Mini', 'PlayStation Classic', 'Xbox 360', 'PlayStation 3', 'Wii U', 'Xbox One', 'PlayStation 4', 'Nintendo Switch', 'PC' )),
	CONSTRAINT		pk_tor		PRIMARY KEY(data_inizio_torneo,localita_torneo),
	CONSTRAINT		fk_tor_eve		FOREIGN KEY(data_inizio_torneo,localita_torneo)		REFERENCES evento(data_inizio,localita_evento)
		ON DELETE CASCADE
);

--%%%%%		DISTRIBUZIONE
CREATE TABLE distribuzione
(
	data_inizio_distribuzione	DATE,
	localita_distribuzione	VARCHAR(25),
	CONSTRAINT		pk_distr		PRIMARY KEY(data_inizio_distribuzione,localita_distribuzione),
	CONSTRAINT		fk_distr_eve		FOREIGN KEY(data_inizio_distribuzione,localita_distribuzione)	 	REFERENCES evento(data_inizio,localita_evento)
		ON DELETE CASCADE
);

--%%%%%		PARTECIPA
CREATE TABLE partecipa
(
	loc_eve	VARCHAR(25),
	cf_cliente_reg	CHAR(16) ,
	data_inizio		DATE,
	CONSTRAINT		pk_part	PRIMARY KEY(cf_cliente_reg,data_inizio,loc_eve),
	CONSTRAINT		fk_part_eve		FOREIGN KEY(data_inizio,loc_eve)	 	REFERENCES evento(data_inizio,localita_evento)
		ON DELETE CASCADE,
	CONSTRAINT		fk_part_clireg		FOREIGN KEY(cf_cliente_reg)	 	REFERENCES cliente_reg(cf_cliente)
		ON DELETE CASCADE
);

--%%%%%		GADGET_DIST
CREATE TABLE gadget_dist
(
	codice_gad	 VARCHAR(16) ,
	loc_dist	VARCHAR(25),
	quantita	INTEGER		NOT NULL,
	data_distribuzione	DATE,
	CONSTRAINT 	pk_gad_dist 		PRIMARY KEY(codice_gad,loc_dist,data_distribuzione),
	CONSTRAINT 	fk_gad_dist_gad	 	FOREIGN KEY(codice_gad) 	REFERENCES gadget(codice_gadget) 
		ON DELETE CASCADE,
	CONSTRAINT 	fk_gad_dist_dist	 	FOREIGN KEY(data_distribuzione,loc_dist) 	REFERENCES distribuzione(data_inizio_distribuzione,localita_distribuzione) 
		ON DELETE CASCADE
);


--%%%%%		OFFERTA
CREATE TABLE offerta
(
	codice_offerta	INTEGER,
	data_inizio		DATE	NOT NULL,
	data_fine		DATE	NOT	NULL,	
	CONSTRAINT	pk_off		PRIMARY KEY(codice_offerta)
);

--%%%%%		OTTIENE
CREATE TABLE ottiene
(
	cod_off		INTEGER,
	cf_cliente_reg	CHAR(16),
	CONSTRAINT	pk_ott		PRIMARY KEY(cod_off,cf_cliente_reg),
	CONSTRAINT		fk_ott_clireg		FOREIGN KEY(cf_cliente_reg)	 	REFERENCES cliente_reg(cf_cliente)
		ON DELETE CASCADE,
	CONSTRAINT		fk_ott_off		FOREIGN KEY(cod_off)	 	REFERENCES offerta(codice_offerta)
		ON DELETE CASCADE
);

--%%%%%		CREA
CREATE TABLE crea
(
	cod_off		INTEGER,
	cf_org	CHAR(16),
	CONSTRAINT	pk_cre		PRIMARY KEY(cf_org,cod_off),
	CONSTRAINT		fk_cre_clireg		FOREIGN KEY(cod_off)	 	REFERENCES offerta(codice_offerta)
		ON DELETE CASCADE,
	CONSTRAINT		fk_amm_cre		FOREIGN KEY(cf_org)	 	REFERENCES amministratore(cf_amm)
		ON DELETE CASCADE
);

--%%%%%		ORGANIZZA
CREATE TABLE organizza
(
	loc_eve	VARCHAR(25),
	data_inizio_eve		DATE,
	cf_org	CHAR(16),
	CONSTRAINT	pk_org		PRIMARY KEY(data_inizio_eve,cf_org),
	CONSTRAINT		fk_org_eve		FOREIGN KEY(data_inizio_eve,loc_eve)	 	REFERENCES evento(data_inizio,localita_evento)
		ON DELETE CASCADE,
	CONSTRAINT		fk_amm_eve		FOREIGN KEY(cf_org)	 	REFERENCES amministratore(cf_amm)
		ON DELETE CASCADE
);

--%%%%%		SOGGETTO
CREATE TABLE soggetto
(
	cod_off		INTEGER,
	cod_prod	VARCHAR(16),
	CONSTRAINT 	pk_sog	PRIMARY KEY(cod_off,cod_prod),
	CONSTRAINT		fk_sog_off		FOREIGN KEY(cod_off)	 	REFERENCES offerta(codice_offerta)
		ON DELETE CASCADE,
	CONSTRAINT		fk_sog_prod		FOREIGN KEY(cod_prod)	 	REFERENCES prodotto(codice_prodotto)
		ON DELETE CASCADE
);