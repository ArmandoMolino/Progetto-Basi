--%%%%%		LAVORATORE
CREATE TABLE lavoratore(
	cf CHAR(16),
	data_di_nascita		DATE	NOT NULL,
	nome  	VARCHAR(15)		NOT NULL ,
	cognome 	VARCHAR(15)		NOT NULL ,
	secondo_nome 	VARCHAR(15)	,
	citta_residenza		VARCHAR(20)		NOT NULL ,
	data_assunzione		DATE	NOT NULL,
	CONSTRAINT		pk_lav		PRIMARY KEY(cf),
	CONSTRAINT		size_cf_lavoratore		CHECK( length(cf) = 16 )
	);


--%%%%%		IMPIEGATO
CREATE TABLE impiegato(
	cf_imp CHAR(16),
	reparto_loc_imp 	VARCHAR(20)		 NOT NULL,
	flag_rep_imp		CHAR(2) 	CHECK(flag_rep_imp in ( 'L', 'VE', 'VI' )),
	CONSTRAINT		pk_imp		PRIMARY KEY(cf_imp),
	CONSTRAINT 		fk_imp_rep		FOREIGN KEY(flag_rep_imp,reparto_loc_imp) 	REFERENCES reparto(flag_reparto,loc_reparto)
		ON DELETE CASCADE,
	CONSTRAINT 		fk_imp_lav		FOREIGN KEY(cf_imp) 	REFERENCES lavoratore(cf)
		ON DELETE CASCADE
	);


--%%%%%		DIRETTORE
CREATE TABLE direttore(
	cf_dir CHAR(16),
	reparto_loc_dir 	VARCHAR(20)		 NOT NULL,
	flag_rep_dir		CHAR(2) 	CHECK(flag_rep_dir in ( 'L', 'VE', 'VI' )),
	UNIQUE(reparto_loc_dir,flag_rep_dir),
	CONSTRAINT		pk_dir		PRIMARY KEY(cf_dir),
	CONSTRAINT 		fk_dir_rep		FOREIGN KEY(reparto_loc_dir,flag_rep_dir) 	REFERENCES reparto(loc_reparto,flag_reparto)
		ON DELETE CASCADE,
	CONSTRAINT 		fk_dir_lav		FOREIGN KEY(cf_dir) 	REFERENCES lavoratore(cf)
		ON DELETE CASCADE
	);


--%%%%%		AMMINISTRATORE
CREATE TABLE amministratore(
	cf_amm 	CHAR(16),
	loc_filiale 	VARCHAR(20)		NOT NULL,
	CONSTRAINT		pk_amm		PRIMARY KEY(cf_amm),
	CONSTRAINT 		fk_amm_fil		FOREIGN KEY(loc_filiale) 	REFERENCES filiale(localita)
		ON DELETE CASCADE,
	CONSTRAINT 		fk_amm_lav		FOREIGN KEY(cf_amm) 	REFERENCES lavoratore(cf)
		ON DELETE CASCADE
	);
	
	
--%%%%%		STIPENDIO
CREATE TABLE stipendio(
	numero_bollo	CHAR(16),
	denaro		FLOAT	NOT NULL,
	data_erogazione		DATE	NOT NULL,
	cf_lav		CHAR(16)	NOT NULL,
	CONSTRAINT 		pk_stip		PRIMARY KEY(numero_bollo),
	CONSTRAINT 		fk_stip_lav		FOREIGN KEY(cf_lav) 	REFERENCES lavoratore(cf)
	 	ON DELETE CASCADE
	);
	
CREATE UNIQUE INDEX stipendio_univoco
ON stipendio ( TRUNC ( data_erogazione ), cf_lav);