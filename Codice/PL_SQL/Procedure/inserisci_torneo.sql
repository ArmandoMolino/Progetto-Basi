CREATE OR REPLACE PROCEDURE inserisci_torneo(cf_amm VARCHAR, sz_data_inizio VARCHAR, sz_data_fine VARCHAR, fQuota FLOAT, iPremio INTEGER, szNomeGioco VARCHAR,szPiattaforma VARCHAR, iMaxPartecipanti INTEGER)
AS 

dt_inizio_torneo DATE := to_date(sz_data_inizio,'DD/MM/YYYY');
dt_fine_torneo DATE := to_date(sz_data_fine,'DD/MM/YYYY');
cursor curs_localita_eve is SELECT localita FROM AMMINISTRATORE A join FILIALE on loc_filiale = localita WHERE A.cf_amm = cf_amm;
localita_eve VARCHAR(25);


BEGIN 
	open curs_localita_eve;
	FETCH curs_localita_eve into localita_eve;
	insert into evento VALUES(localita_eve,dt_inizio_torneo,dt_fine_torneo);
	insert into organizza VALUES(localita_eve,dt_inizio_torneo, cf_amm);
	insert into torneo VALUES(dt_inizio_torneo,localita_eve,fQuota,iPremio,szNomeGioco,szPiattaforma,iMaxPartecipanti);
	close curs_localita_eve;
	COMMIT;
	
	
EXCEPTION
WHEN 	NO_DATA_FOUND	THEN
		DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND.');
END; 
/
show errors