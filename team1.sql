
DROP database IF exists distributore;
CREATE database distributore;

USE distributore;

DROP TABLE IF EXISTS prodotti;
CREATE TABLE prodotti(
	nome VARCHAR(50) PRIMARY KEY NOT NULL,
	tipo ENUM("Bevanda","Merendina","Altro") NOT NULL,
    -- I prezzi hanno al massimo 2 cifre intere e 2 decimali e non possono essere negativi
	costo decimal(4,2) UNSIGNED
);

DROP TABLE IF EXISTS posti;
CREATE TABLE IF NOT EXISTS posti (
	slot INT UNSIGNED ,
	posizione INT UNSIGNED, 
    id_prod VARCHAR(50),
	PRIMARY KEY (slot, posizione),
    FOREIGN KEY (id_prod) REFERENCES prodotti(nome)
);

DROP TABLE IF EXISTS merendine;
CREATE TABLE  merendine(
	scadenza DATE,
	nome VARCHAR(50),
	FOREIGN KEY (nome) REFERENCES prodotti(nome)
);
	
DROP TABLE IF EXISTS chiavetta;
CREATE TABLE chiavetta(
    seriale VARCHAR(50) NOT NULL PRIMARY KEY,
	CF VARCHAR(16) NOT NULL UNIQUE,
	-- nome e cognome non possono essere stringhe vuote o nulle
    CONSTRAINT stringhe_svuote CHECK(nome != "" AND cognome != ""),
	nome VARCHAR(50) NOT NULL, 
	cognome VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS prodotto_venduto;
CREATE TABLE prodotto_venduto(
	nome VARCHAR(50),
	data_vendita datetime,
    seriale VARCHAR(50) NULL,
    PRIMARY KEY(nome,data_vendita),
    FOREIGN KEY (nome) REFERENCES prodotti(nome),
    foreign key (seriale) REFERENCES chiavetta(seriale)
);

