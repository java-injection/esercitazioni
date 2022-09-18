
CREATE database distributore;

DROP TABLE IF EXISTS posti;

CREATE TABLE IF NOT EXISTS posti (

slot INT UNSIGNED ,
posizione INT UNSIGNED, 
PRIMARY KEY (slot, posizione)
);

-- I prezzi hanno al massimo 2 cifre intere e 2 decimali
-- e non possono essere numeri negativi

CREATE TABLE IF NOT EXISTS prodotti(

nome VARCHAR(50) PRIMARY KEY NOT NULL,
tipo VARCHAR(50) NOT NULL,
costo INT UNSIGNED 

);


CREATE TABLE  merendine(

scadenza VARCHAR(50),
nome VARCHAR(50),
FOREIGN KEY (nome) REFERENCES prodotti(nome)

);




--  nomi e cognomi delle persone
--  non possono essere nulli o stringhe vuote
CREATE TABLE IF NOT EXISTS persone(

-- controllo se nome e cognome sono stringhe vuote :)
CONSTRAINT stringhe_svuote CHECK(nome != "" AND cognome != ""),

CF VARCHAR(16) NOT NULL PRIMARY KEY,

-- nome e cognome non possono essere stringhe vuote :)
nome VARCHAR(50) NOT NULL, 
cognome VARCHAR(50) NOT NULL

);








