--%%%%%%% JOB CHE ELIMINA GLI EVENTI DOPO UN ANNO DAL LORO INIZIO, GLI APPROVVIGIONAMENTI E LE FORNITURE DOPO 3 ANNI ED ELIMINA GLI STIPENDI DOPO 10 ANNI DALLA LORO EROGAZIONE.
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
   job_name			=>	'Rollout',
   job_type			=>	'PLSQL_BLOCK',
   job_action		=>	'BEGIN 
									DELETE FROM evento 
									WHERE SYSDATE > data_inizio + 365;
									
									DELETE FROM fornitura 
									WHERE SYSDATE > data + (365 * 3);
									
									DELETE FROM approvviggionamento 
									WHERE SYSDATE > data + (365 * 3);
									
									DELETE FROM stipendio 
									WHERE SYSDATE > data_erogazione + 3650;
						END;
						/',
   start_date		=> TO_DATE('01-GEN-2020','DD-MON-YYYY'),
   repeat_interval	=> 'FREQ=DAILY', 
   enabled			=>	TRUE,
   comments			=>	'Cancellazione dei dati vecchi');
END;
/