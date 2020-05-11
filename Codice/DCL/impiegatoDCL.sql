GRANT CONNECT, CREATE SESSION 	TO impiegato;
GRANT INSERT		ON vende			TO impiegato;
GRANT INSERT		ON cliente			TO impiegato;
GRANT INSERT		ON affitta_tavolo			TO impiegato;
GRANT INSERT		ON affitta_postazione			TO impiegato;
GRANT UPDATE		ON tessera			TO impiegato;

GRANT EXECUTE		ON registra_cliente			TO impiegato;
GRANT EXECUTE		ON iscrizione_torneo			TO impiegato;