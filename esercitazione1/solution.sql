DROP DATABASE IF EXISTS distributore_solution;

CREATE DATABASE  IF NOT EXISTS distributore_solution;

USE distributore_solution;

CREATE TABLE IF NOT EXISTS prodotto(
    CONSTRAINT cp1_nome_non_vuoto CHECK(nome != ''),
    CONSTRAINT cp2_costo_other_minor10 CHECK(tipo != 'BEVANDA' OR tipo != 'MERENDINA' OR (tipo = 'ALTRO' AND costo <=10)),
    nome VARCHAR(50) PRIMARY KEY ,
    costo DECIMAL(4,2) UNSIGNED  NOT NULL,
    tipo ENUM('BEVANDA','MERENDINA','ALTRO') NOT NULL
);


CREATE TABLE IF NOT EXISTS posto(
    CONSTRAINT cposto_max5 CHECK(posizione<=5),
    CONSTRAINT ck_prodotto_not_empty CHECK(prodotto != ''),
    slot INT UNSIGNED NOT NULL,
    posizione  INT UNSIGNED NOT NULL,
    prodotto VARCHAR(50) NOT NULL,
    scadenza DATE NULL,
    PRIMARY KEY (slot,posizione),
    FOREIGN KEY(prodotto) REFERENCES prodotto(nome)
);

CREATE TABLE IF NOT EXISTS persona(
    CONSTRAINT ck_CF_exact_length16 CHECK (LENGTH(CF) = 16),
    CONSTRAINT ck_anagrafica_not_empty CHECK (nome != '' AND cognome != ''),
    CONSTRAINT ck_serial_format CHECK(LENGTH(seriale) = 6  AND seriale REGEXP '^[0-9a-zA-Z]{4}[0-9]{2}$'),
    CF VARCHAR(16) PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    cognome VARCHAR(50) NOT NULL,
    seriale VARCHAR(6) NOT NULL
);

CREATE TABLE IF NOT EXISTS prodotto_venduto(
    tempo_vendita TIME NOT NULL UNIQUE,
    prodotto VARCHAR(50) NOT NULL,
    CF VARCHAR(16) NULL,
    PRIMARY KEY(tempo_vendita,prodotto),
    FOREIGN KEY(CF) REFERENCES persona(CF),
    FOREIGN KEY(prodotto) REFERENCES prodotto(nome)
);

INSERT INTO prodotto VALUES('Fanta',2,'BEVANDA');
INSERT INTO prodotto VALUES('Coca',2,'BEVANDA');
INSERT INTO prodotto VALUES('Kinder Bueno',1.80,'MERENDINA');
INSERT INTO prodotto VALUES('Fiesta',0.90,'MERENDINA');
INSERT INTO prodotto VALUES('Succo di frutta (Pera)',1,'BEVANDA');
INSERT INTO prodotto VALUES('Succo di frutta (Mela)',1,'BEVANDA');
INSERT INTO prodotto VALUES('Succo di frutta (Pesca)',1,'BEVANDA');
INSERT INTO prodotto VALUES('Esta The',1.50,'BEVANDA');
INSERT INTO prodotto VALUES('Crostatina',0.60,'MERENDINA');
INSERT INTO prodotto VALUES('Patatine',1.20,'MERENDINA');
INSERT INTO prodotto VALUES('Succo di Frutta BIO Pesca',1.60,'BEVANDA');
INSERT INTO prodotto VALUES('Patatine Mela Bio',1.20,'MERENDINA');
INSERT INTO prodotto VALUES('Torta della nonna Bio',5.50,'MERENDINA');
INSERT INTO prodotto VALUES('Accendino',3,'ALTRO');
INSERT INTO prodotto VALUES('Cartine_lunghe',1,'ALTRO');

INSERT INTO posto VALUES(1,3,'Fanta',NULL);
INSERT INTO posto VALUES(3,5,'Coca',NULL);
INSERT INTO posto VALUES(5,1,'Kinder Bueno','2024-06-24');
INSERT INTO posto VALUES(2,2,'Accendino',NULL);
INSERT INTO posto VALUES(6,5,'Cartine_lunghe',NULL);
INSERT INTO posto VALUES(11,1,'Kinder Bueno','2024-06-24');
INSERT INTO posto VALUES(11,2,'Kinder Bueno','2024-06-25');
INSERT INTO posto VALUES(11,3,'Kinder Bueno','2026-06-26');
INSERT INTO posto VALUES(11,4,'Kinder Bueno','2027-06-22');
INSERT INTO posto VALUES(11,5,'Kinder Bueno','2024-08-11');
INSERT INTO posto VALUES(14,5,'Crostatina','2024-06-03');
INSERT INTO posto VALUES(15,3,'Crostatina','2024-08-13');
INSERT INTO posto VALUES(14,1,'Patatine','2025-03-21');
INSERT INTO posto VALUES(15,5,'Coca',NULL);

INSERT INTO persona VALUES('AAAAAAAAAAAAAAAA','Gino','Street','hgls57');
INSERT INTO persona VALUES('BBBBBBBBBBBBBBBB','Padre','Maronno','pgne67');
INSERT INTO persona VALUES('CCCCCCCCCCCCCCCC','Giulio','Pizzirilli','mspo50');
INSERT INTO persona VALUES('DDDDDDDDDDDDDDDD','Giggio','Sandreotti','psot78');

INSERT INTO prodotto_venduto VALUES('15:20','Fanta','AAAAAAAAAAAAAAAA');
INSERT INTO prodotto_venduto VALUES('20:01','Crostatina','CCCCCCCCCCCCCCCC');
INSERT INTO prodotto_venduto VALUES('13:56','Fanta','AAAAAAAAAAAAAAAA');
INSERT INTO prodotto_venduto VALUES('14:16','Crostatina',NULL);
INSERT INTO prodotto_venduto VALUES('14:29','Kinder Bueno',NULL);
INSERT INTO prodotto_venduto VALUES('16:40','Kinder Bueno','DDDDDDDDDDDDDDDD');
INSERT INTO prodotto_venduto VALUES('09:15','Accendino','CCCCCCCCCCCCCCCC');
INSERT INTO prodotto_venduto VALUES('09:21','Crostatina','CCCCCCCCCCCCCCCC');

show tables;

SELECT * from prodotto;


-- Quanti prodotti venduti in totale
SELECT COUNT(*) FROM prodotto_venduto;

-- L'elenco di tutte le persone registrate nel sistema ordinate per Cognome-Nome.
SELECT cognome,nome FROM persona ORDER BY cognome,nome;

-- Quante persone diverse hanno comprato dalla macchinetta
SELECT COUNT(DISTINCT CF) FROM prodotto_venduto;

-- Le prime 3 bevande più costose
SELECT nome, costo FROM prodotto ORDER BY costo DESC LIMIT 3;

-- Tutti i prodotti che contengono la parola "bio" con un range di prezzo tra 1 e 5 euro.
SELECT nome, costo FROM prodotto WHERE nome LIKE '%bio%' AND costo < 5;

-- L'articolo non alimentare meno costoso.
SELECT nome, costo FROM prodotto ORDER BY costo LIMIT 1;

-- Il numero degli acquisti effettuati senza chiavetta.
SELECT COUNT(*) FROM prodotto_venduto WHERE CF IS NULL;