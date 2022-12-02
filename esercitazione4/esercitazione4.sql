
create database esercitazione4;
use esercitazione4;


-- ***************************************************************************************************************************
-- *								FASE 1   UTILITY FUNCTION
-- ***************************************************************************************************************************
SET GLOBAL log_bin_trust_function_creators = 1;

-- scrivere una funzione che dati 2 intervalli interi restituisca un valore randomico compreso tra i 2 intervalli.
CREATE USER 'account'@'localhost' IDENTIFIED BY 'Massimobrutto' ;
GRANT EXECUTE
ON esercitazione4.*
TO 'account'@'localhost';
drop function if exists randnum;

delimiter $$
CREATE DEFINER='account'@'localhost' function RandNum ( 
 minimo int, massimo int
)
returns  int 
not deterministic

SQL SECURITY DEFINER 
begin
if(minimo is null or massimo is null)
then 
	SET @exception = 'PESCE METTIMI DEI NUMERI';
    signal sqlstate '45000'
	SET MESSAGE_TEXT = @exception,
	MYSQL_ERRNO= 1062;
END IF;
if(minimo = massimo)
then 
	set @mammt =1;
	SET @exception = 'PESCE sono identici';
    signal sqlstate '01000'
	SET MESSAGE_TEXT = @exception,
	MYSQL_ERRNO= 22023;
END IF;

return FLOOR(minimo + RAND()*(massimo - minimo + 1)) ; 
end $$
delimiter ;
select @mammt;
SELECT randnum(0,10);
show warnings;
-- TIP: questa query restituisce un numero randomico intero tra 5 e 10:
-- SELECT FLOOR(5 + RAND()*(10 - 5 + 1)) AS Random_Number;

-- la funzione deve generare un errore se i valori dell'intervallo sono null
-- la funzione deve generare un warning se i valori dell'intervallo sono uguali 
-- la funzione deve appoggiarsi ad un definer ad hoc e deve operare in definer-context

DROP TABLE IF EXISTS sensori;

CREATE TABLE IF NOT EXISTS sensori(
  id_sensor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(20) NOT NULL,
  brand VARCHAR(50) NOT NULL,
  UNIQUE(nome, brand)
);

INSERT INTO sensori VALUES (1,'EL-100','SAMSUNG');
INSERT INTO sensori VALUES (2,'DOOR-007','OBS');



DROP TABLE IF EXISTS data_sensori;

CREATE TABLE IF NOT EXISTS data_sensori(
     timestamp DATETIME NOT NULL,
     data JSON NOT NULL,
     id_sensor INT UNSIGNED NOT NULL,
     FOREIGN KEY (id_sensor) REFERENCES sensori(id_sensor)
);


                      --            ABBSADBASBBSA
delimiter $$
CREATE DEFINER='account'@'localhost' function RandNum ( 
 minimo int, massimo int
)
returns  int 
not deterministic

SQL SECURITY DEFINER 
begin
if(minimo is null or massimo is null)
then 
	SET @exception = 'PESCE METTIMI DEI NUMERI';
    signal sqlstate '45000'
	SET MESSAGE_TEXT = @exception,
	MYSQL_ERRNO= 1062;
END IF;
if(minimo = massimo)
then 
	set @mammt =1;
	SET @exception = 'PESCE sono identici';
    signal sqlstate '01000'
	SET MESSAGE_TEXT = @exception,
	MYSQL_ERRNO= 22023;
END IF;





drop function if exists inserimento;
delimiter &&
create function  inserimento
( measure varchar(25), unit varchar(25),_value int )
returns json
deterministic
begin
	declare a json; 
    set a = concat('{
									"values": [
									{
										"measure": "',measure,'",
										"unit": "',unit,'",
										"value": ',_value,'
									}
									]
								}');
	Return a;
end &&
delimiter ;
DROP EVENT IF EXISTS voltage_event;
DELIMITER $$
CREATE EVENT voltage_event
    ON SCHEDULE EVERY 1 SECOND
        STARTS now()
        ENDS now() + INTERVAL 40 SECOND
    ON COMPLETION PRESERVE
    DO BEGIN
        DECLARE execution INT;
        declare _timestamp timestamp;
        set _timestamp = now();
        SET execution = randnum(1,3);
        IF
            execution = 1
		THEN
            BEGIN
                DECLARE voltage_value INT; -- value
                DECLARE current_value INT;
                DECLARE voltage_value1 INT; -- value
                DECLARE current_value1 INT;-- valueS
                declare exe2 int;
                set exe2 = randnum(1,5);
                SET voltage_value = randnum(0,10);
                SET current_value = randnum(4,20);
                SET voltage_value1 = randnum(0,10);
                SET current_value1 = randnum(4,20);
                if
					exe2 = 1
				then	
					begin
						INSERT INTO data_sensori
						VALUES(
                       _timestamp,
                       inserimento( 'voltage', 'v', voltage_value1),
                       1
                      );
                    end;
				end if;
                INSERT INTO data_sensori
						VALUES(
                       _timestamp,
                       inserimento( 'voltage', 'v', voltage_value),
                       1
                      );
            END;
        END IF;


    END $$
DELIMITER ;


set @door_value = null;


																					-- tester

drop procedure if exists tester;
DELIMITER $$
create procedure tester()
begin
DECLARE voltage_value INT;
DECLARE _timestamp timestamp;
set _timestamp = now();
set voltage_value = 5;
INSERT INTO data_sensori
						VALUES(
                       _timestamp,
                       inserimento( 'voltage', 'v', voltage_value),
						1
                      );
end $$
DELIMITER ;





delimiter ;


DROP EVENT IF EXISTS sensor_2;

DELIMITER $$
CREATE EVENT IF NOT EXISTS sensor_2
    ON SCHEDULE EVERY 1 SECOND
        STARTS now()
        ENDS now() + INTERVAL 40 SECOND
    ON COMPLETION PRESERVE
    DO BEGIN
	
		DECLARE execution INT;
		SET execution = randnum(1,5);
		IF
				execution = 1
		THEN 
			BEGIN
				set @door_value=coalesce(@door_value,randnum(0,1));
				set @door_value = not @door_value;
				call tester();
				INSERT INTO data_sensori
				VALUES(
						  NOW(),
						  CONCAT(' {
										"values": [
										  {
											"measure": "open_closed",
											"unit":"open",
											"value": ',@door_value,'
										  }
										]
									}'),

						  2
					  );
		END;
    END IF;
END $$
DELIMITER ;








											
	
										-- procedure cleanup
drop procedure if exists cleanup;
DELIMITER $$
CREATE PROCEDURE cleanup()
BEGIN
    DELETE FROM data_sensori;
    DELETE FROM states;
    DELETE FROM warnings;
    drop event if exists voltage_event;
    drop event if exists voltage_event;
    SELECT * FROM data_sensori;
    SELECT * FROM states;
    SELECT * FROM warnings;
END $$
DELIMITER ;

create table warnings(
	timestamp datetime not null,
    message varchar(255),
    level enum('INFO','MEDIUM','HIGH','LUCACHAD')
)
											-- procedure warnings
delimiter $$
create procedure warn(
	message varchar(255),
    level enum('INFO','MEDIUM','HIGH','LUCACHAD')
)
begin 
	insert into warnings values(now(),message,level);
	
end ;
delimiter ;

create table states(
	chiave char(15) primary key,
	valore char(75) 
)engine memory;

DELIMITER &&
CREATE FUNCTION S2_LAST_VALUE_KEY()
RETURNS CHAR(15)
DETERMINISTIC
BEGIN
    RETURN 's2_last_value';
END &&
DELIMITER ;
-- procedura che disabilita tutti gli eventi dei sensori
DROP PROCEDURE IF EXISTS disable_all_events;
DELIMITER $$
CREATE PROCEDURE disable_all_events()
BEGIN
    ALTER EVENT voltage_event DISABLE;
    ALTER EVENT sensor_2 DISABLE;
END $$
DELIMITER ;

-- procedura che abilita tutti gli eventi dei sensori
DROP PROCEDURE IF EXISTS enable_all_events;
DELIMITER $$
CREATE PROCEDURE enable_all_events()
BEGIN
DECLARE errno INT;
    DECLARE msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            errno = MYSQL_ERRNO,
            msg = MESSAGE_TEXT;
        CALL warn(CONCAT('ERRNO=',errno,', error=',msg),'HIGH');
    END;
    ALTER EVENT voltage_event ENABLE;
    ALTER EVENT sensor_2 ENABLE;
END $$
DROP PROCEDURE IF EXISTS enable_events;

DELIMITER $$
CREATE PROCEDURE enable_events(
    enable_sensor1 BOOL,
    enable_sensor2 BOOL
)
BEGIN
    IF
        enable_sensor1
    THEN
        ALTER EVENT voltage_event ENABLE;
    ELSE
        ALTER EVENT voltage_event DISABLE;
    END IF;
    IF
        enable_sensor2
    THEN
        ALTER EVENT sensor_2 ENABLE;
    ELSE
        ALTER EVENT sensor_2 DISABLE;
    END IF;
end $$
DELIMITER ;

DROP PROCEDURE IF EXISTS warn;

DELIMITER $$ 
CREATE PROCEDURE warn( 
    message VARCHAR(255), 
    level ENUM('INFO','MEDIUM','HIGH') 
) 
BEGIN
    INSERT INTO warnings VALUES(NOW(),message,level);
END $$
DELIMITER ;
-- ***************************************************************************************************************************
-- *								FASE 2   SIMULAZIONE
-- ***************************************************************************************************************************
-- EVENTO SENSOR_1

-- creare un evento che simula un sensore che produce dati di misurazione di corrente elettrica su un dispositivo
-- il sensore produce due tipi di dato:
	-- voltage con valori da 0 a 10 V
	-- current con valori da 4 a 20 mA 
-- Vanno memorizzati i valori del sensore e il timestamp e l'unità di misura che in genere è "volt". 
-- L'evento simulante deve produrre un dato nuovo ogni 1-3 secondi. 

-- EVENTO SENSOR_2
-- creare un evento che simula un sensore di apertura/chiusura porta. 
-- Il sensore prodce dati booleani con true = porta aperta, false = porta chiusa. 
-- Per ogni dato va memorizzato il valore e il timestamp. 
-- L'evento simulante deve produrre un dato nuovo ogni 1-5 secondi. 

-- Per ognuno dei due sensori si deve simulare la generazione di due anomalie:
-- ANOMALIA 1: 
	-- il sensore produce due dati con valori qualsiasi nello stesso timestamp
-- ANOMALIA 2:
	-- il sensore produce un dato con il valore principale NULL. 
    
-- Nella generazione dell'evento si faccia in modo che l'anomalia 1 si presenti per il 20% dei casi e l'anomalia 2 per il 30%. 

-- si definisca una tabella "sensori" con le specifiche dei sensori: id, nome, tipologia e quant'altro serve
-- si definisca una tabella "sensor_values" che raccola i valori dei sensori, 
-- ogni valore deve essere collegato al rispettivo sensore di appartenenza


-- ***************************************************************************************************************************
-- *								FASE 3   RILEVAZIONE AUTOMATICA DI ANOMALIE 1 e 2
-- ***************************************************************************************************************************

-- creare un trigger che automaticamente rilevi le anomalie di tipo 1 e 2 e ne impedisca l'inserimento nella tabella dei valori. 
-- una volta individuate vanno loggate in una tabella di auditing a parte. E' importante che venga registrato il timestamp dell'anomalia, 
-- a quale sensore si riferisce e la tipologia di anomalia. 

-- ***************************************************************************************************************************
-- *								FASE 4   ANOMALIA 3 e AGGIORNAMENTO TABELLA VALORI SENSORI
-- ***************************************************************************************************************************

-- col tempo ci si accorge che c'è anche una terza anomalia che riguarda solo il sensore 1, ovvero che arrivino dei valori a distanza
-- di tempo ma con valore uguale, ad esempio due true a distanza di qualche minuto. Come può una porta aprirsi due volte ? se si apre
-- si dovrebbe solo chiudere.. Tuttavia è impossibile decidere quale dato rimuovere e quindi questa anomalia va segnalata direttamente
-- sui valori dei sensori. 

-- Alterare quindi la tabella dei valori con una nuova colonna "anomaly3" di tipo booleano inizializzata a false. 

-- ***************************************************************************************************************************
-- *								FASE 5   AUTO-DETECT DELLE ANOMALIE 3
-- ***************************************************************************************************************************

-- Modificare il trigger di fase 3 in modo che riconosca anche le anomalie 3
-- quando due dati soffrono di anomalia 3, il campo "anomaly3" dei due dati va settato a true, e il nuovo dato va comunque inserito
-- nella tabella principale e va inserito un evento anche nella tabella di audit. 

-- TIP1: @
-- TIP2: @
-- TIP3: si in mysql ci sono i cicli for, ma se siete svegli non vi serve :>


-- ***************************************************************************************************************************
-- *								FASE 6   EMERGENCY CLEAN UP PROCEDURE
-- ***************************************************************************************************************************

-- creare una procedura che verifichi che nella tabella valori non esista nessuna anomalia di tipo 1 e 2. Se vengono trovate
-- vengono instantanemante cancellati i valori dalla tabella e viene inserita una unica riga di audit in una nuova tabella a parte
-- chiamata "log", avente come campi: timestamp, procedure, result . 
--                  ad es.            '03-11-2022 10:45 | CLEANUP | SUCCESS
--                  ad es.            '03-11-2022 10:50 | CLEANUP | SUCCESS
--                  ad es.            '03-11-2022 10:55 | CLEANUP | FAIL
-- il campo result indica se la procedura fallisce o no. Fallisce quando trova almeno un anomalia indicando il fallimento del trigger. 
-- la procedura deve agire in invoker-context



 


