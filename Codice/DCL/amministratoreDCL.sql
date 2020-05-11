GRANT CONNECT, CREATE SESSION 	TO amministratore;
GRANT SELECT		ON impiegato			TO amministratore;
GRANT SELECT		ON direttore			TO amministratore;
GRANT INSERT		ON offerta				TO amministratore;
GRANT INSERT		ON approvviggionamento	TO amministratore;
GRANT INSERT		ON consiste				TO amministratore;

GRANT EXECUTE		ON inserisci_torneo			TO amministratore;
GRANT EXECUTE		ON crea_distribuzione		TO amministratore;
GRANT EXECUTE 		ON lettura_entrate			TO amministratore;
GRANT EXECUTE 		ON lettura_uscite			TO amministratore;