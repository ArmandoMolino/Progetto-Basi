--1	questo trigger controlla se la data di scadenza immessa per una tessera sia successiva,
-- 	di almeno un anno, dalla data di registrazione dell'utente.
create or replace trigger scadenza_tessera
after insert or update of data_scadenza on tessera
for each row
declare
	dataReg		cliente_reg.data_registrazione%TYPE;
begin
	select data_registrazione into dataReg	
		from cliente_reg 
		where cf_cliente = :new.cf_cli_reg;
	if(:new.data_scadenza < ADD_MONTHS(dataReg,12)) then
		raise_application_error(-20200,'data scadenza non successiva di almeno un anno dalla registrazione.');
	end if;
end;
/


--2	questo trigger controlla se la data di scadenza di un offerta sia successiva alla data
--	di inizio dell'offerta
create or replace trigger scadenza_offerta
after insert or update of data_fine on offerta
for each row
declare 
	
begin
	if( :new.data_fine < :new.data_inizio ) then 
		raise_application_error(-20210,'data scadenza non successiva alla data inizio.');
	elsif( :new.data_fine < :new.data_inizio + 7) then
		raise_application_error(-20211,'data scadenza non successiva di almeno una settimana dalla data inizio.');
	end if;
end;
/

--3 vede se un tavolo puo essere occupato oppure se a quel'ora il locale è aperto	orari: dalle 9:00 alle 21:00
create or replace trigger tavolo_occupato
before insert on affitta_tavolo
for each row
declare 
	cf		cliente.cf%TYPE;
	ora_inizio decimal(4,2) := to_number(replace(to_char(:new.data_ora_inizio,'hh24:mi'),':','.'),'99.99');
	cursor occupato IS 
		select cf_cliente_reg 
		from affitta_tavolo
		where 	loc_rep = :new.loc_rep and numero_tav = :new.numero_tav
				and 
				((data_ora_inizio between :new.data_ora_inizio and :new.data_ora_inizio + :new.ore_affitto)
				or
				(:new.data_ora_inizio between data_ora_inizio and data_ora_inizio + ore_affitto));
begin
	if ( ora_inizio < 9.00 or ora_inizio > 21.00 or (ora_inizio + :new.ore_affitto) > 21.00) then
		raise_application_error(-20220,'A quell orario siamo chiusi');
	end if;
	open occupato;
	fetch occupato into cf;
	if occupato%FOUND then
		raise_application_error(-20221,'tavolo numero:'|| :new.numero_tav ||' non disponibile per la prenotazione');
	end if;
	close occupato;
end;
/

--4 vede se una postazione puo essere occupata oppure se a quel'ora il locale è aperto	orari: dalle 9:00 alle 21:00
create or replace trigger postazione_occupata
before insert on affitta_postazione
for each row
declare 
	cf		cliente.cf%TYPE;
	ora_inizio decimal(4,2) := to_number(replace(to_char(:new.data_ora_inizio,'hh24:mi'),':','.'),'99.99');
	cursor occupato IS 
		select cf_cliente_reg 
		from affitta_postazione
		where 	loc_rep = :new.loc_rep and numero_pos = :new.numero_pos
				and 
				((data_ora_inizio between :new.data_ora_inizio and :new.data_ora_inizio + :new.ore_affitto)
				or
				(:new.data_ora_inizio between data_ora_inizio and data_ora_inizio + ore_affitto));
begin	
	if ( ora_inizio < 9.00 or ora_inizio > 21.00 or (ora_inizio + :new.ore_affitto) > 21.00) then
		raise_application_error(-20230,'A quell orario siamo chiusi');
	end if;
	open occupato;
	fetch occupato into cf;
	if occupato%FOUND then
		raise_application_error(-20231,'postazione numero:'|| :new.numero_pos ||' non disponibile per la prenotazione');
	end if;
	close occupato;
end;
/


--5	questo trigger controlla se è possibile aggiungere un partecipante ad un torneo
create or replace trigger controllo_partecipanti
before insert on partecipa
for each row
declare 
	counter	int;
	max_part int;
begin
	select count(*) into counter
		from partecipa
		where	data_inizio = :new.data_inizio;
		
	select max_partecipanti into max_part
		from torneo
		where data_inizio_torneo = :new.data_inizio;
	if ( counter = max_part ) then
		raise_application_error(-20240,'raggiunto numero massimo iscrizioni al torneo.');
	end if;
end;
/


--6 Non possono essere inviati approvviggionamenti a filiali senza reparto vendita
create or replace trigger direzione_approv
after insert or update of loc_filiale on approvviggionamento
for each row
declare 
	cursor reparto_vendita is 
		select	*
		from reparto
		where flag_reparto = 'VE' and loc_reparto = :new.loc_filiale;
	rep_vendita		reparto%ROWTYPE;
begin
	open reparto_vendita;
	fetch reparto_vendita into rep_vendita;
	if( reparto_vendita%NOTFOUND ) then
		raise_application_error(-20250,'Reparto vendita non presente in questa filiale. Impossibile mandare approvvigionamento.');
	end if;
	close reparto_vendita;
end;
/

--7 Non posso esserci 2 tornei nello stesso periodo
create or replace trigger organizzazione_tornei
before insert or update of data_inizio_torneo on torneo
for each row
declare 
	loc_tor VARCHAR(25);
	data_inizio		DATE;
	data_fine	DATE;
	data_fine_torneo	evento.data_fine%TYPE;
	cursor eventi is
		select data_inizio_torneo,data_fine, localita_torneo
		from torneo join evento on data_inizio=data_inizio_torneo
		where nome_gioco = :new.nome_gioco and piattaforma = :new.piattaforma;

begin
	select data_fine into data_fine_torneo
		from evento
		where data_inizio = :new.data_inizio_torneo and localita_evento = :new.localita_torneo;
	open eventi;
	loop
		fetch eventi into data_inizio,data_fine,loc_tor;
		exit when eventi%NOTFOUND;
		if ( loc_tor = :new.localita_torneo and ((data_inizio > :new.data_inizio_torneo and data_inizio < data_fine_torneo) or (:new.data_inizio_torneo > data_inizio and :new.data_inizio_torneo < data_fine))) then
			raise_application_error(-20260,'è già in corso un torneo riguardante ' || :new.nome_gioco || ' su ' || :new.piattaforma );
			exit;
		end if;
	end loop;
	close eventi;
end;
/

--8 Non posso esserci 2 distribuzioni nello stesso periodo
create or replace trigger organizzazione_gadget
before insert or update of data_inizio_distribuzione on distribuzione
for each row
declare 

	loc_dist VARCHAR(25);
	data_inizio		DATE;
	data_fine	DATE;
	data_fine_distribuzione	evento.data_fine%TYPE;
	codice_gadget VARCHAR(16);
	cursor eventi is
		select data_inizio_distribuzione,data_fine,codice_gad, localita_distribuzione
		from (distribuzione join evento on data_inizio=data_inizio_distribuzione) join gadget_dist on data_distribuzione=data_inizio_distribuzione
		where codice_gad = (select codice_gad from gadget_dist where data_distribuzione = :new.data_inizio_distribuzione);

begin
	select data_fine into data_fine_distribuzione
		from evento
		where data_inizio = :new.data_inizio_distribuzione and localita_evento = :new.localita_distribuzione;
	open eventi;
	loop
		fetch eventi into data_inizio, data_fine, codice_gadget,loc_dist;
		exit when eventi%NOTFOUND;
		if ( loc_dist = :new.localita_distribuzione and (data_inizio > :new.data_inizio_distribuzione and data_inizio < data_fine_distribuzione) or (:new.data_inizio_distribuzione > data_inizio and :new.data_inizio_distribuzione < data_fine)) then
			raise_application_error(-20270,'è già in corso una distribuzione riguardante il gadget con cod: ' || codice_gadget );
			exit;
		end if;
	end loop;
	close eventi;
end;
/ 

--9   calcola automaticamente la generazione
CREATE OR REPLACE TRIGGER set_generazione
before INSERT ON console 
FOR EACH ROW
DECLARE
	nome_console prodotto.nome%TYPE;
BEGIN
	select lower(nome) into nome_console
		from prodotto
		where codice_prodotto = :new.codice_console;
	if nome_console in ('nintendo ds','nintendo ds lite','nintendo dsi','nintendo dsi xl','playstation portable','xbox 360','nintendo wii','playstation 3') then
		:new.generazione := 7;
	elsif nome_console in ('nintendo 3ds','nintendo 2ds','playstation vita','wiiu','nintendo switch','nintendo switch lite','playstation 4', 'xbox one') then
		:new.generazione := 8;
	else
		:new.generazione := 6;
	end if;
END;
/