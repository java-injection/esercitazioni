DROP DATABASE IF EXISTS distributore_solution;

CREATE DATABASE  IF NOT EXISTS distributore_solution;

USE distributore_solution;


CREATE TABLE IF NOT EXISTS prodotto(
    nome VARCHAR(50) PRIMARY KEY CHECK(nome != ''),
    costo DECIMAL(4,2) UNSIGNED CHECK(costo <=10) NOT NULL,
    tipo ENUM('bevanda','merendina','altro') NOT NULL
);


CREATE TABLE IF NOT EXISTS posto(
    slot INT UNSIGNED NOT NULL,
    posizione  INT UNSIGNED NOT NULL CHECK(posizione<=5),
    prodotto VARCHAR(50) NOT NULL CHECK(prodotto <> ''),
    scadenza DATE NULL CHECK(scadenza > CURDATE()), -- controlla che la scadenza sia in avanti rispetto a oggi
    PRIMARY KEY (prodotto,posizione),
    FOREIGN KEY(prodotto) REFERENCES prodotto(nome)
);

CREATE TABLE IF NOT EXISTS persona(
    CF VARCHAR(50) NOT NULL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL CHECK(nome <> ''),
    cognome VARCHAR(50) NOT NULL CHECK(cognome <> ''),
    seriale TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS prodotto_venduto(
    tempo_vendita DECIMAL(4,2) UNSIGNED NOT NULL UNIQUE,
    nome VARCHAR(50) NOT NULL CHECK(nome <> '') REFERENCES prodotto(nome),
    CF VARCHAR(50) NOT NULL REFERENCES persona(CF),
    PRIMARY KEY(tempo_vendita,nome)
);

INSERT INTO prodotto VALUES('Fanta',3.5,'bevanda');
INSERT INTO prodotto VALUES('Coca',4,'bevanda');
INSERT INTO prodotto VALUES('kinder',5,'merendina');
INSERT INTO prodotto VALUES('accendino',7,'altro');
INSERT INTO prodotto VALUES('cartine_lunghe',1,'altro');

INSERT INTO posto VALUES(1,3,'Fanta');
INSERT INTO posto VALUES(3,5,'Coca');
INSERT INTO posto VALUES(5,1,'knder');
INSERT INTO posto VALUES(2,2,'accendino');
INSERT INTO posto VALUES(6,5,'cartine_lunghe');

INSERT INTO merendina VALUES('1990-05-14','kinde bueno');

INSERT INTO persona VALUES('PSNDNEJ50KSKDM501I','Gino','Street','hgls57');
INSERT INTO persona VALUES('PSODNSDNESKDSND53I','Padre','Maronno','pgne67');
INSERT INTO persona VALUES('SSSIDJSEIJD£DM501I','Giulio','Pizzirilli','mspo50');
INSERT INTO persona VALUES('SSSSKRFGIJD£DM501I','Giggio','Sandreotti','psot78');

INSERT INTO prodotto_venduto VALUES('15.20','Fanta','SSSSKRFGIJD£DM501I');
INSERT INTO prodotto_venduto VALUES('20.05','kinder','PSODNSDNESKDSND53I');
INSERT INTO prodotto_venduto VALUES('15.22','Fanta','PSNDNEJ50KSKDM501I');

use distributore;
show tables;

select * from merendina;

SELECT DISTINCT tipo FROM prodotto;
SELECT * FROM posto;
SELECT COUNT(*) FROM posto WHERE posizione=5;