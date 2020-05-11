CREATE OR REPLACE PROCEDURE crea_distribuzione(cf_amm VARCHAR, sz_data_inizio VARCHAR, sz_data_fine VARCHAR, sz_cod_gadget VARCHAR, iQuantita INTEGER)
AS 

dt_inizio_distr DATE := to_date(sz_data_inizio,'DD/MM/YYYY');
dt_fine_distr DATE := to_date(sz_data_fine,'DD/MM/YYYY');
cursor curs_localita_eve is SELECT localita FROM AMMINISTRATORE A join FILIALE on loc_filiale = localita WHERE A.cf_amm = cf_amm;
localita_eve VARCHAR(25);

BEGIN 
	open curs_localita_eve;
	FETCH curs_localita_eve into localita_eve;
	insert into evento VALUES(localita_eve,dt_inizio_distr,dt_fine_distr);
	insert into organizza VALUES(localita_eve,dt_inizio_distr, cf_amm);
	insert into distribuzione VALUES(dt_inizio_distr,localita_eve);
	insert into gadget_dist VALUES(sz_cod_gadget,localita_eve, iQuantita, dt_inizio_distr);
	close curs_localita_eve;
	COMMIT;
	
		
EXCEPTION
WHEN 	NO_DATA_FOUND	THEN
		DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND.');
END; 
/
show errors