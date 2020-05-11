CREATE OR REPLACE PROCEDURE lettura_entrate(szFiliale VARCHAR, szMese VARCHAR, szAnno VARCHAR)
AS 

dtUserDate VARCHAR(10);
fTotSomme FLOAT;
fSommaProdottiVenduti prodotto.prezzo%TYPE;
fSommaQuoteTorneo torneo.quota%TYPE;
fSommaRicaviAffittoTavolo tavolo.conto_orario%type;
fSommaRicaviAffittoPostazione postazione.conto_orario%type;


BEGIN 
	dtUserDate := szMese||'-'||szAnno;
	
	SELECT sum(prezzo * quantita) into fSommaProdottiVenduti from vende join prodotto on cod_prod = codice_prodotto where to_char(data_e_ora,'MM-YYYY') = dtUserDate and loc_rep = szFiliale;
	if (fSommaProdottiVenduti is null) then fSommaProdottiVenduti := 0; end if;
	
	SELECT count(*) * quota into fSommaQuoteTorneo from torneo join partecipa on data_inizio = data_inizio_torneo where to_char(data_inizio_torneo,'MM-YYYY') = dtUserDate and localita_torneo = szFiliale  group by quota,localita_torneo;
	if (fSommaQuoteTorneo is null) then fSommaQuoteTorneo := 0; end if;
	
	SELECT sum(conto_orario * ore_affitto) into fSommaRicaviAffittoTavolo from affitta_tavolo aft join tavolo ta on aft.loc_rep = ta.loc_rep where aft.loc_rep = szFiliale and aft.numero_tav = ta.numero_tavolo and to_char(data_ora_inizio, 'MM-YYYY') = dtUserDate;
	if (fSommaRicaviAffittoTavolo is null) then fSommaRicaviAffittoTavolo := 0; end if;
	
	
	SELECT sum(conto_orario * ore_affitto) into fSommaRicaviAffittoPostazione from affitta_postazione afp join postazione pos on afp.loc_rep = pos.loc_rep where afp.loc_rep = szFiliale and afp.numero_pos = pos.numero_postazione and to_char(data_ora_inizio, 'MM-YYYY') = dtUserDate;
	if (fSommaRicaviAffittoPostazione is null) then fSommaRicaviAffittoPostazione := 0; end if;
	
	fTotSomme := (fSommaProdottiVenduti+fSommaQuoteTorneo+fSommaRicaviAffittoTavolo+fSommaRicaviAffittoPostazione);
	
	DBMS_OUTPUT.PUT_LINE('La somma delle entrate del '|| dtUserDate ||' e di '|| TO_CHAR(fTotSomme)||' Euro.');
	
END; 
/
show errors

