CREATE OR REPLACE PROCEDURE iscrizione_torneo(cf VARCHAR,localita VARCHAR,str_data VARCHAR)
IS
	scadenza date;
	dt_inizio date := to_date(str_data,'DD/MM/YYYY');
	is_torneo  date;
	tessera_scaduta			EXCEPTION;
	troppo_tardi			EXCEPTION;
BEGIN
	select data_scadenza into scadenza
	from tessera
	where cf_cli_reg=cf;
	
	if scadenza <= SYSDATE then
		raise tessera_scaduta;
	end if;
	
	if dt_inizio <= SYSDATE then 
		raise troppo_tardi;
	end if;
	
	select data_inizio_torneo into is_torneo
	from torneo
	where data_inizio_torneo=dt_inizio and localita_torneo = localita;
	insert into partecipa values(localita,cf,dt_inizio);
	COMMIT;
	


EXCEPTION
WHEN 	NO_DATA_FOUND	THEN
		DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND.');
WHEN	tessera_scaduta		THEN
		DBMS_OUTPUT.PUT_LINE('Tessera scaduta il '|| scadenza ||'. Non e''possibile effetuare l''iscrizione al torneo');
WHEN	troppo_tardi		THEN
		DBMS_OUTPUT.PUT_LINE('Periodo d''iscrizione terminato.');
END;
/
show errors;

