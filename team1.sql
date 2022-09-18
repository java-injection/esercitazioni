
CREATE database distributore;

USE distributore

DROP TABLE IF EXISTS posti;

CREATE TABLE IF NOT EXISTS posti (

slot INT UNSIGNED ,
posizione INT UNSIGNED, 
PRIMARY KEY (slot, posizione)
);

-- I prezzi hanno al massimo 2 cifre intere e 2 decimali
-- e non possono essere numeri negativi

DROP TABLE IF EXISTS prodotti;

CREATE TABLE prodotti(

nome VARCHAR(50) PRIMARY KEY NOT NULL,
tipo VARCHAR(50) NOT NULL,
costo INT UNSIGNED 

);


DROP TABLE IF EXISTS merendine;
CREATE TABLE  merendine(

scadenza VARCHAR(50),
nome VARCHAR(50),
FOREIGN KEY (nome) REFERENCES prodotti(nome)

);

--  nomi e cognomi delle persone
--  non possono essere nulli o stringhe vuote

DROP TABLE IF EXISTS persone;

CREATE TABLE  persone(

-- controllo se nome e cognome sono stringhe vuote :)
CONSTRAINT stringhe_svuote CHECK(nome != "" AND cognome != ""),

CF VARCHAR(16) NOT NULL PRIMARY KEY,

-- nome e cognome non possono essere stringhe vuote :)
nome VARCHAR(50) NOT NULL, 
cognome VARCHAR(50) NOT NULL

);








