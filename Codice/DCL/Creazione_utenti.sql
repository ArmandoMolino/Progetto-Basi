CREATE USER db_owner IDENTIFIED BY ADMIN ;
CREATE USER proprietari_catena IDENTIFIED BY GAMESTOP ;
CREATE USER direttore IDENTIFIED BY MIDUSER ;
CREATE USER amministratore IDENTIFIED BY SUPERUSER ;
CREATE USER impiegato IDENTIFIED BY LOWUSER;
GRANT ALL PRIVILEGES TO db_owner ;