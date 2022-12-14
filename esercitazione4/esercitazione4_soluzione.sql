
create database esercitazione4;
use esercitazione4;


-- ***************************************************************************************************************************
-- *								FASE 1   UTILITY FUNCTION
-- ***************************************************************************************************************************

-- scrivere una funzione che dati 2 intervalli interi restituisca un valore randomico compreso tra i 2 intervalli.

-- TIP: questa query restituisce un numero randomico intero tra 5 e 10:
-- SELECT FLOOR(5 + RAND()*(10 - 5 + 1)) AS Random_Number;

-- la funzione deve generare un errore se i valori dell'intervallo sono null
-- la funzione deve generare un warning se i valori dell'intervallo sono uguali 
-- la funzione deve appoggiarsi ad un definer ad hoc e deve operare in definer-context

SET GLOBAL log_bin_trust_function_creators = 1;

DROP FUNCTION IF EXISTS RAND_INTERVAL;

DELIMITER $$
CREATE FUNCTION RAND_INTERVAL( 
 minimo INT,
 massimo INT
)
RETURNS INT 
NOT DETERMINISTIC
BEGIN
    IF
        (minimo IS NULL OR massimo IS NULL)
    THEN
        SET @exception = 'Non posso eseguire RAND_INTERVAL con minimo o massimo con valori NULL';
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = @exception,
        MYSQL_ERRNO= 1062;
    END IF;
    IF
        (minimo = massimo)
    THEN
        CALL warn('minimo e massimo sono uguali..','INFO');
    END IF;
    RETURN FLOOR(minimo + RAND()*(massimo - minimo + 1)) ;
END $$
DELIMITER ;

SELECT RAND_INTERVAL(3,3);

show warnings;

CREATE TABLE warnings(
	timestamp DATETIME NOT NULL,
    message VARCHAR(255),
    level ENUM('INFO','MEDIUM','HIGH')
);

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

SELECT RAND_INTERVAL(NULL,3);

show warnings;

-- ***************************************************************************************************************************
-- *								FASE 2   SIMULAZIONE
-- ***************************************************************************************************************************
-- TIP1: figlio di Jonny. (5)

CREATE TABLE sensor(
    id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    UNIQUE(name,brand)
);

INSERT INTO sensor VALUES (1,'EL-100','SAMSUNG');
INSERT INTO sensor VALUES (2,'DOOR-007','OBS');

DROP TABLE IF EXISTS sensor_values;

CREATE TABLE sensor_values(
    timestamp DATETIME NOT NULL,
    data JSON,
    id_sensor INT,
    FOREIGN KEY(id_sensor) REFERENCES sensor(id_sensor)
);




-- EVENTO SENSOR_1
-- creare un evento che simula un sensore che produce dati di misurazione di corrente elettrica su un dispositivo
-- il sensore produce due tipi di dato:
	-- voltage con valori da 0 a 10 V
	-- current con valori da 4 a 20 mA 
-- Vanno memorizzati i valori del sensore e il timestamp e l'unit?? di misura che in genere ?? "volt". 
-- L'evento simulante deve produrre un dato nuovo ogni 1-3 secondi.


DROP EVENT IF EXISTS sensor1_simulation;

DELIMITER %%
CREATE EVENT sensor1_simulation
    ON SCHEDULE EVERY 1 SECOND
    STARTS CURRENT_TIMESTAMP
    ENDS CURRENT_TIMESTAMP + INTERVAL 5 MINUTE
ON COMPLETION PRESERVE
DO BEGIN
    DECLARE execution INT;
    SET execution = RAND_INTERVAL(1,3);
    IF
        execution = 1 -- un terzo delle possibilit??
    THEN
        BEGIN
        DECLARE voltage_value INT; -- value
        DECLARE current_value INT; -- value
        SET voltage_value = RAND_INTERVAL(0,10);
        SET current_value = RAND_INTERVAL(4,20);
        INSERT INTO sensor_values VALUES(
                                         NOW(),
                                         CONCAT('{
                                                    "values": [
                                                      {
                                                        "measure": "voltage",
                                                        "unit": "V",
                                                        "value": ',voltage_value,'
                                                      },
                                                      {
                                                        "measure": "current",
                                                        "unit": "mA",
                                                        "value": ',current_value,'
                                                      }
                                                    ]
                                                }'),
                                         1);
        END;
    END IF;

END %%
DELIMITER ;

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


-- ***** RISOLUZIONE 2. 
-- Creazione di una tabella temporanea per variabili fuori sessione

DROP TABLE IF EXISTS states;

CREATE TABLE states(
	_key CHAR(20) PRIMARY KEY,
    _value CHAR(50)
) ENGINE = MEMORY;


DELIMITER %%
CREATE FUNCTION S2_LAST_VALUE_KEY()
RETURNS CHAR(20)
DETERMINISTIC
BEGIN
	RETURN "s2_last_value";
END %%
DELIMITER ;

DELIMITER %%
CREATE FUNCTION S2_EVENT_COUNT()
RETURNS CHAR(20)
DETERMINISTIC
BEGIN
	RETURN "s2_event_count";
END %%
DELIMITER ;

DROP EVENT IF EXISTS sensor2_simulation;

DELIMITER %%
CREATE EVENT sensor2_simulation
    ON SCHEDULE EVERY 1 SECOND
    STARTS CURRENT_TIMESTAMP
    ENDS CURRENT_TIMESTAMP + INTERVAL 5 MINUTE
ON COMPLETION PRESERVE
DO BEGIN
	DECLARE msg TEXT;
    DECLARE execution INT;
    DECLARE door_value BOOL;
    DECLARE errno INT;
    -- ***** HANDLER ******
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
		GET DIAGNOSTICS CONDITION 1 
		errno = MYSQL_ERRNO,
        msg = MESSAGE_TEXT;
		CALL warn(CONCAT('ERRNO=',errno,', error=',msg),"HIGH");
    END;

    SET execution = RAND_INTERVAL(1,5);
    IF
        execution = 1 -- un quinto delle possibilit??
    THEN
        BEGIN
			DECLARE door_value BOOL; -- value
            DECLARE first_rand INT;
			SET door_value = (SELECT _value FROM states WHERE _key = S2_LAST_VALUE_KEY());
            SET first_rand = door_value;
			SET door_value = COALESCE(door_value, RAND_INTERVAL(0,1));
			SET door_value = NOT door_value;
            IF 
				first_rand IS NULL
            THEN
				INSERT INTO states VALUES(S2_LAST_VALUE_KEY(),door_value);
			ELSE
				UPDATE states SET _value=door_value WHERE _key = S2_LAST_VALUE_KEY();
			END IF;
			INSERT INTO sensor_values VALUES(
                                         NOW(),
                                         CONCAT('{
                                                    "values": [
                                                      {
                                                        "measure": "door state",
                                                        "unit": "open/closed",
                                                        "value": ',door_value,'
                                                      }
                                                    ]
                                                }'),
                                         2);
        END;
    END IF;

END %%
DELIMITER ;


DROP PROCEDURE IF EXISTS cleanup;

DELIMITER $$
CREATE PROCEDURE cleanup()
BEGIN
	DELETE FROM sensor_values;
    DELETE FROM states;
    DELETE FROM warnings;
    SELECT * FROM sensor_values;
    SELECT * FROM states;
    SELECT * FROM warnings;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS test;

DELIMITER $$
CREATE PROCEDURE test()
BEGIN
		DECLARE errno INT;
		DECLARE msg TEXT;
        DECLARE door_value BOOL; -- value
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET CURRENT DIAGNOSTICS CONDITION 1 
			  errno = MYSQL_ERRNO,
			  msg = MESSAGE_TEXT;
			CALL warn(msg,"HIGH");
		END;
		        
			SET door_value = (SELECT _value FROM states WHERE _key = "s2_last_value");
			SET door_value = COALESCE(door_value, RAND_INTERVAL(0,1));
			SET door_value = NOT door_value;
            INSERT INTO states VALUES("s2_last_value",door_value);
			INSERT INTO sensor_values VALUES(
                                         NOW(),
                                         CONCAT('{
                                                    "values": [
                                                      {
                                                        "measure": "door state",
                                                        "unit": "open/closed",
                                                        "value": ',door_value,'
                                                      }
                                                    ]
                                                }'),
                                         2);
                                         
END $$
DELIMITER ;





-- ***************************************************************************************************************************
-- *								FASE 3   RILEVAZIONE AUTOMATICA DI ANOMALIE 1 e 2
-- ***************************************************************************************************************************

-- creare un trigger che automaticamente rilevi le anomalie di tipo 1 e 2 e ne impedisca l'inserimento nella tabella dei valori. 
-- una volta individuate vanno loggate in una tabella di auditing a parte. E' importante che venga registrato il timestamp dell'anomalia, 
-- a quale sensore si riferisce e la tipologia di anomalia. 

-- ***************************************************************************************************************************
-- *								FASE 4   ANOMALIA 3 e AGGIORNAMENTO TABELLA VALORI SENSORI
-- ***************************************************************************************************************************

-- col tempo ci si accorge che c'?? anche una terza anomalia che riguarda solo il sensore 1, ovvero che arrivino dei valori a distanza
-- di tempo ma con valore uguale, ad esempio due true a distanza di qualche minuto. Come pu?? una porta aprirsi due volte ? se si apre
-- si dovrebbe solo chiudere.. Tuttavia ?? impossibile decidere quale dato rimuovere e quindi questa anomalia va segnalata direttamente
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




DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (c1 TEXT NOT NULL);
DROP PROCEDURE IF EXISTS p;
delimiter //
CREATE PROCEDURE p ()
BEGIN
  -- Declare variables to hold diagnostics area information
  DECLARE errcount INT;
  DECLARE errno INT;
  DECLARE msg TEXT;
  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    -- Here the current DA is nonempty because no prior statements
    -- executing within the handler have cleared it
    GET CURRENT DIAGNOSTICS CONDITION 1
      errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
    SELECT 'current DA before mapped insert' AS op, errno, msg;
    GET STACKED DIAGNOSTICS CONDITION 1
      errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
    SELECT 'stacked DA before mapped insert' AS op, errno, msg;

    -- Map attempted NULL insert to empty string insert
    INSERT INTO t1 (c1) VALUES('');

    -- Here the current DA should be empty (if the INSERT succeeded),
    -- so check whether there are conditions before attempting to
    -- obtain condition information
    GET CURRENT DIAGNOSTICS errcount = NUMBER;
    IF errcount = 0
    THEN
      SELECT 'mapped insert succeeded, current DA is empty' AS op;
    ELSE
      GET CURRENT DIAGNOSTICS CONDITION 1
        errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
      SELECT 'current DA after mapped insert' AS op, errno, msg;
    END IF ;
    GET STACKED DIAGNOSTICS CONDITION 1
      errno = MYSQL_ERRNO, msg = MESSAGE_TEXT;
    SELECT 'stacked DA after mapped insert' AS op, errno, msg;
  END;
  INSERT INTO t1 (c1) VALUES('string 1');
  INSERT INTO t1 (c1) VALUES(NULL);
END;
//
delimiter ;
CALL p();
SELECT * FROM t1;
 


