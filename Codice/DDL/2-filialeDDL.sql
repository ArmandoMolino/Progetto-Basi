--%%%%%		FILIALE
CREATE TABLE filiale(
	localita	VARCHAR(25) ,
	cap		CHAR(5)		NOT NULL,
	via		VARCHAR(30)		NOT NULL,
	CONSTRAINT 		pk_fil		PRIMARY KEY(localita)
);

--%%%%%		REPARTO
CREATE TABLE reparto(
	loc_reparto		VARCHAR(25) ,
	flag_reparto		CHAR(2) 	CHECK(flag_reparto in ( 'L', 'VE', 'VI' )), 
	CONSTRAINT 		pk_rep		PRIMARY KEY(loc_reparto,flag_reparto),
	CONSTRAINT 		fk_rep_fil		FOREIGN KEY(loc_reparto)	REFERENCES filiale(localita)
	ON DELETE CASCADE
);

--%%%%%		TAVOLO
CREATE TABLE tavolo(
	numero_tavolo	INT,
	conto_orario	FLOAT	NOT NULL,
	loc_rep		VARCHAR(25)	,
	flag_rep		CHAR(2) 	DEFAULT 'L' 	CHECK(flag_rep = 'L'), 
	CONSTRAINT	pk_tav	PRIMARY KEY(numero_tavolo, loc_rep, flag_rep),
	CONSTRAINT	fk_tav_rep		FOREIGN KEY(loc_rep, flag_rep)	REFERENCES reparto(loc_reparto, flag_reparto)
	ON DELETE CASCADE
);

--%%%%%		AFFITTA_TAVOLO
CREATE TABLE affitta_tavolo(
	numero_tav	INT	,
	cf_cliente_reg		CHAR(16),
	loc_rep		VARCHAR(25)	,
	flag_rep		CHAR(2) 	DEFAULT 'L' 	CHECK(flag_rep = 'L'), 
	ore_affitto		INT		NOT NULL 	CHECK(ore_affitto <= 6),
	data_ora_inizio		DATE	NOT NULL,
	CONSTRAINT	pk_aff_tav		PRIMARY KEY(numero_tav,loc_rep,flag_rep,cf_cliente_reg,data_ora_inizio),
	CONSTRAINT	fk_aff_tav		FOREIGN KEY(numero_tav,loc_rep,flag_rep)		REFERENCES tavolo(numero_tavolo,loc_rep,flag_rep)
	ON DELETE CASCADE,
	CONSTRAINT	fk_afftav_clireg		FOREIGN KEY(cf_cliente_reg)		REFERENCES cliente_reg(cf_cliente)
	ON DELETE CASCADE
);

--%%%%%		GIOCHI_TAVOLO_REP
CREATE TABLE giochi_tavolo_rep(
	loc_rep_tav		VARCHAR(25),
	flag_rep_tav		CHAR(2) 	DEFAULT 'L' 	CHECK(flag_rep_tav = 'L'), 
	nome	VARCHAR(25),
	CONSTRAINT	pk_giochi_tav		PRIMARY KEY(loc_rep_tav,flag_rep_tav,nome),
	CONSTRAINT	fk_giotav_rep		FOREIGN KEY(loc_rep_tav,flag_rep_tav)	REFERENCES reparto(loc_reparto,flag_reparto)
	ON DELETE CASCADE
);

--%%%%%		POSTAZIONE
CREATE TABLE postazione(
	numero_postazione	INT,
	conto_orario	FLOAT	NOT NULL,
	nome_console	VARCHAR(20)		NOT NULL	CHECK(nome_console in ( 'SNES Classic Mini', 'NES Classic Mini', 'Sega Megadrive Mini', 'PlayStation Classic', 'Xbox 360', 'PlayStation 3', 'Wii U', 'Xbox One', 'PlayStation 4', 'Nintendo Switch', 'PC' )),
	loc_rep		VARCHAR(25)	,
	flag_rep		CHAR(2) 	DEFAULT 'VI' 	CHECK(flag_rep = 'VI'), 
	CONSTRAINT	pk_pos	PRIMARY KEY(numero_postazione, loc_rep, flag_rep),
	CONSTRAINT	fk_pos_rep		FOREIGN KEY(loc_rep, flag_rep)	REFERENCES reparto(loc_reparto, flag_reparto)
	ON DELETE CASCADE
);

--%%%%%		AFFITTA_POSTAZIONE
CREATE TABLE affitta_postazione(
	numero_pos	INT	,
	cf_cliente_reg		CHAR(16),
	ore_affitto		INT		NOT NULL 	CHECK(ore_affitto <= 6),
	data_ora_inizio		DATE,
	loc_rep		VARCHAR(25),
	flag_rep		CHAR(2) 	DEFAULT 'VI' 	CHECK(flag_rep = 'VI'), 
	CONSTRAINT	pk_aff_pos		PRIMARY KEY(numero_pos,cf_cliente_reg,loc_rep,flag_rep),
	CONSTRAINT	fk_aff_pos		FOREIGN KEY(numero_pos,loc_rep,flag_rep)		REFERENCES postazione(numero_postazione,loc_rep,flag_rep)
	ON DELETE CASCADE,
	CONSTRAINT	fk_affpos_clireg		FOREIGN KEY(cf_cliente_reg)		REFERENCES cliente_reg(cf_cliente)
	ON DELETE CASCADE
);

--%%%%%		VIDEOGIOCHI_REP
CREATE TABLE videogiochi_rep(
	loc_rep_video		VARCHAR(25),
	flag_rep_pos		CHAR(2) 	DEFAULT 'VI' 	CHECK(flag_rep_pos = 'VI'), 	
	nome	VARCHAR(25),
	CONSTRAINT	pk_videogiochi		PRIMARY KEY(loc_rep_video,flag_rep_pos,nome),
	CONSTRAINT	fk_vidgio_rep		FOREIGN KEY(loc_rep_video,flag_rep_pos)	REFERENCES reparto(loc_reparto,flag_reparto)
	ON DELETE CASCADE
);