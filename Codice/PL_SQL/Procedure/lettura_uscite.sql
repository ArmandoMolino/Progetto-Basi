CREATE OR REPLACE PROCEDURE lettura_uscite(szFiliale VARCHAR, szMese VARCHAR, szAnno VARCHAR)
AS 

dtUserDate DATE;
fTotSomme FLOAT;
fSommaStipendi stipendio.denaro%TYPE;
fSommaCostoForniture fornitura.costo%TYPE;
fSommaPremiTorneo torneo.premio%TYPE;
iNumFiliali INTEGER;

BEGIN 
	dtUserDate := to_date(szMese||'-'||szAnno,'MM/YYYY');
	SELECT sum(denaro) into fSommaStipendi from (select reparto_loc_imp, cf_imp from impiegato union select reparto_loc_dir, cf_dir from direttore union select loc_filiale,cf_amm from amministratore) join stipendio on cf_imp = cf_lav where to_char(data_erogazione,'MM/YYYY') = to_char(dtUserDate,'MM/YYYY') and reparto_loc_imp = szFiliale;
	if (fSommaStipendi is null) then fSommaStipendi := 0; end if;
	
	SELECT count (*) into iNumFiliali from filiale;
	SELECT sum(costo) into fSommaCostoForniture from fornitura where (to_char(data,'MM/YYYY') = to_char(dtUserDate,'MM/YYYY'));
	if (fSommaCostoForniture is null) then fSommaCostoForniture := 0;else fSommaCostoForniture := fSommaCostoForniture/iNumFiliali; end if;
	
	SELECT sum(premio) into fSommaPremiTorneo from torneo where (to_char(data_inizio_torneo,'MM/YYYY') = to_char(dtUserDate,'MM/YYYY')) and localita_torneo = szFiliale;
	if (fSommaPremiTorneo is null) then fSommaPremiTorneo := 0; end if;
	
	fTotSomme := (fSommaStipendi+fSommaCostoForniture+fSommaPremiTorneo);
	
	DBMS_OUTPUT.PUT_LINE('La somma delle uscite del '||to_char(dtUserDate,'MM/YYYY')||' e di '|| TO_CHAR(fTotSomme)||' Euro.');
	
END; 
/
show errors
