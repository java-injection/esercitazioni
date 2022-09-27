
DROP DATABASE IF EXISTS spedizionedb;
CREATE DATABASE IF NOT EXISTS  spedizionedb;
USE spedizionedb;

DROP TABLE IF EXISTS destinazioni, esploratori, attrezzature, squadre, spedizioni, squadre_esploratori, attrezzature_esploratori, squadre_spedizioni;

    -- spedizione ( data,oraI,oraF, sigla_destinazione,settore_destinazione,nome_squadra)
    -- destinazione(sigla,settore)
    -- squadra(nome,tipo,codice,ID_esploratore_capitano)
    -- esploratore(ID)
    -- attrezzature(ID)
    -- composta(nome_squadra,ID_esploratore,ruolo)
    -- dispone(ID_esploratore,ID_attrezzatura)

CREATE TABLE IF NOT EXISTS destinazioni(

    destinazioni_id INT UNSIGNED PRIMARY KEY,
    sigla VARCHAR(10) NOT NULL,
    settore VARCHAR(10) NOT NULL
);

    INSERT INTO destinazioni VALUES (1,'UNK-84','alpha');
    INSERT INTO destinazioni VALUES (2,'UNK-84','beta');
    INSERT INTO destinazioni VALUES (3,'UNK-84','gamma');
    INSERT INTO destinazioni VALUES (4,'UNK-83','alpha');
    INSERT INTO destinazioni VALUES (5,'UNK-83','beta');
    INSERT INTO destinazioni VALUES (6,'UNK-83','gamma');
    INSERT INTO destinazioni VALUES (7,'UNK-90','alpha');
    INSERT INTO destinazioni VALUES (8,'UNK-99','beta');
    INSERT INTO destinazioni VALUES (9,'UNK-99','gamma');
    INSERT INTO destinazioni VALUES (10,'UNK-99','delta');



CREATE TABLE IF NOT EXISTS esploratori(

    CONSTRAINT c1_vuote CHECK (nome != '' AND cognome != ''),
    esploratori_id INT UNSIGNED AUTO_INCREMENT  PRIMARY KEY,
    CF VARCHAR(16),
    nome VARCHAR(100) NOT NULL,
    cognome VARCHAR(100) NOT NULL
);

INSERT INTO esploratori(CF, nome, cognome) VALUES
                                               ('AAA','Giovanni','Buscio'),
                                               ('BBB','Hulk','Benspar'),
                                               ('CCC','Gonzalo','Geriz'),
                                               ('DDD','Gonzalo','Almenchi'),
                                               ('EEE','Kim','Ahiosky'),
                                               ('FFF','Kevin','Vinnegard'),
                                               ('GGG','Mary','Red'),
                                               ('HHH','Simon','Renegade'),
                                               ('LLL','Johanna','De Vito'),
                                               ('III','Monica','Lombroso'),
                                               ('MMM','Ortis','Tannis'),
                                               ('NNN','Simone','Fasullini'),
                                               ('OOO','Tanja','Gottemberg'),
                                               ('PPP','Fred','Mallister');

CREATE TABLE IF NOT EXISTS squadre(
    squadre_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('M','S','G') NOT NULL,
    capo_id INT UNSIGNED NOT NULL, -- capo
    FOREIGN KEY (capo_id) REFERENCES esploratori(esploratori_id)
);

INSERT INTO squadre(nome, tipo, capo_id)VALUES
                                          ('Alpha Team','M',2),  --  Hulk Benspar
                                          ('Beta Providers','S',3), -- Gonzalo Geriz
                                          ('Team Defence','M',13),  -- Tanja Gottemberg
                                          ('Gamma Deliver','G',8); -- Simon','Renegade

CREATE TABLE IF NOT EXISTS attrezzature(
    attrezzature_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) UNIQUE
);

INSERT INTO attrezzature (nome) VALUES
                                    ('Biotrapano Chadder 20'),
                                    ('Iono Picker X78'),
                                    ('AK47'),
                                    ('Avvitatore Ikea'),
                                    ('Contatore Geiger'),
                                    ('Multidenser Optimizer'),
                                    ('Crio-stabilizzatore II livello');

CREATE TABLE IF NOT EXISTS spedizioni(
    spedizioni_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    data_inizio DATETIME NOT NULL,
    data_fine DATETIME NULL,
    destinazioni_id INT UNSIGNED,

    FOREIGN KEY(destinazioni_id) REFERENCES destinazioni(destinazioni_id),
    UNIQUE (data_inizio, destinazioni_id)
);

INSERT INTO spedizioni(data_inizio, data_fine, destinazioni_id) VALUES
                                                                    ('2108-12-06 - 16:00', '2108-12-07 - 13:00',2),
                                                                    ('2108-12-06 - 16:00', '2108-12-07 - 13:00',3),
                                                                    ('2108-12-06 - 16:00', '2108-12-07 - 13:00',4),
                                                                    ('2109-11-06 - 16:00', '2109-12-07 - 18:00',4),
                                                                    ('2110-01-11 - 12:00', '2110-01-13 - 12:00',8), -- 5
                                                                    ('2110-02-14 - 12:00', '2110-02-18 - 09:00',8), -- 6
                                                                    ('2110-01-11 - 12:00', '2110-01-13 - 19:00',9); -- 7

CREATE TABLE IF NOT EXISTS squadre_esploratori(
    squadre_id INT UNSIGNED NOT NULL,
    esploratori_id INT UNSIGNED NOT NULL,
    roulo VARCHAR(20) NOT NULL,

    FOREIGN KEY(squadre_id) REFERENCES squadre(squadre_id),
    FOREIGN KEY(esploratori_id) REFERENCES esploratori(esploratori_id),
    PRIMARY KEY(squadre_id, esploratori_id)
);

INSERT INTO squadre_esploratori (squadre_id, esploratori_id, roulo) VALUES    -- 2, 3 , 13, 8
                                                                        (1,1,'explorer'),
                                                                        (1,2,'leader'),
                                                                        (2,3,'leader'),
                                                                        (2,4,'explorer'),
                                                                        (2,5,'explorer'),
                                                                        (2,6,'explorer'),
                                                                        (2,1,'explorer'),
                                                                        (3,4,'explorer'),
                                                                        (3,5,'digger'),
                                                                        (3,6,'explorer'),
                                                                        (3,8,'explorer'),
                                                                        (4,13,'leader'),
                                                                        (4,10,'explorer'),
                                                                        (4,11,'explorer'),
                                                                        (4,3,'explorer');


CREATE TABLE IF NOT EXISTS attrezzature_esploratori(
    attrezzature_id INT UNSIGNED NOT NULL,
    esploratori_id INT UNSIGNED NOT NULL,

    FOREIGN KEY(attrezzature_id) REFERENCES attrezzature(attrezzature_id),
    FOREIGN KEY(esploratori_id) REFERENCES esploratori(esploratori_id),
    PRIMARY KEY(attrezzature_id, esploratori_id)
);


INSERT INTO attrezzature_esploratori (esploratori_id, attrezzature_id) VALUES
                                                                           (1,2),
                                                                           (1,3),
                                                                           (2,5),
                                                                           (3,2),
                                                                           (6,3),
                                                                           (8,5),
                                                                           (8,6),
                                                                           (7,3),
                                                                           (7,4),
                                                                           (9,2),
                                                                           (13,1);




CREATE TABLE IF NOT EXISTS squadre_spedizioni(
    squadre_id INT UNSIGNED NOT NULL,
    spedizioni_id INT UNSIGNED NOT NULL,

    FOREIGN KEY(squadre_id) REFERENCES squadre(squadre_id),
    FOREIGN KEY(spedizioni_id) REFERENCES spedizioni(spedizioni_id),
    PRIMARY KEY(squadre_id, spedizioni_id)
);

INSERT INTO squadre_spedizioni (squadre_id, spedizioni_id) VALUES
                                                               (1,1),
                                                               (2,1),
                                                               (3,1),
                                                               (1,2),
                                                               (1,3),
                                                               (4,4),
                                                               (1,5),
                                                               (3,4),
                                                               (3,5),
                                                               (2,6),
                                                               (2,7),
                                                               (1,6);








# L'elenco di tutti i partecipanti ai team di tipo S o M
SELECT e.nome, e.cognome from esploratori e JOIN squadre s ON e.esploratori_id = s.squadre_id WHERE tipo = 'M' OR tipo = 'S';

# L'elenco di tutte le spedizioni attive nei settori 'alpha' e 'beta' sull'oggetto "UNK-99".
select spedizioni_id from spedizioni s join destinazioni d using(destinazioni_id) where (d.settore = 'alpha' OR d.settore = 'beta') AND d.sigla = 'UNK-99';

# Il luogo che ha ricevuto la spedizione più lunga e il nome del team che l'ha eseguita.
select d.sigla as destinazione, t.nome as team, TIMESTAMPDIFF(HOUR, s.data_inizio, s.data_fine) AS durata, s.spedizioni_id
from squadre t
join squadre_spedizioni ss using(squadre_id)
join spedizioni s using(spedizioni_id)
join destinazioni d using(destinazioni_id)
ORDER BY durata desc limit 1;

# L'elenco di tutte le spedizioni che hanno interessato luoghi con codice che inizia per "UNK"
select s.spedizioni_id
from spedizioni s
join destinazioni d using(destinazioni_id)
where d.sigla REGEXP '^UNK.*$';


# L'elenco in ordine alfabetico di tutti gli esploratori in grado di usare almeno un attrezzatura speciale
select distinct e.nome, e.cognome
from esploratori e
join attrezzature_esploratori ae using(esploratori_id)
order by e.nome, e.cognome;



# L'elenco dei capisquadra che sanno usare uno o più attrezzature speciali
select distinct e.nome, e.cognome
from esploratori e
join attrezzature_esploratori ae using(esploratori_id)
join squadre s using(capo_id)
order by e.nome, e.cognome;

# Il numero di spedizioni fatte su "UNK-83"
select COUNT(s.spedizioni_id) AS 'num spedizioni su UNK-83'
from spedizioni s
join destinazioni d using(destinazioni_id)
where d.sigla = 'UNK-83';

# Si visualizzi la lista delle squadre e dei rispettivi capi squadra
# Ad es:
# Squadra Alpha - Gonzalo Geriz
# Team Defence - Kim Ahiosky
# Gamma Deliver - Simon Renegade

select s.nome as 'squadra', e.nome, e.cognome from squadre s
join esploratori e using(capo_id);


# L'elenco dei Team che hanno partecipato a spedizioni che si sono recate presso il luogo "UNK-84" settore beta.

select t.nome 'team', d.sigla 'luogo', d.settore from squadre t
join squadre_spedizioni using(squadre_id)
join spedizioni using(spedizioni_id)
join destinazioni d using(destinazioni_id)
where d.sigla = 'UNK-84' AND d.settore = 'beta';

# L'elenco di tutti gli strumenti speciali che i team delle spedizioni su UNK-99 potevano portare con se

    select distinct a.nome from attrezzature a
    join attrezzature_esploratori ae using(attrezzature_id)
    join esploratori e using(esploratori_id)
    join squadre_esploratori se using(esploratori_id)
    join squadre s on se.esploratori_id = s.esploratori_id
    join squadre_spedizioni ss on s.squadre_id = ss.squadre_id
    join spedizioni sp using(spedizioni_id)
    join destinazioni d using(destinazioni_id);
 --   WHERE d.settore = 'UNK-99';

    select distinct a.nome from attrezzature a
    join attrezzature_esploratori ae ON a.attrezzature_id = ae.attrezzature_id
    join esploratori e ON ae.esploratori_id = e.esploratori_id
    join squadre_esploratori se ON e.esploratori_id = se.esploratori_id
    join squadre s ON se.esploratori_id = s.esploratori_id
    join squadre_spedizioni ss on s.squadre_id = ss.squadre_id
    join spedizioni sp using(spedizioni_id)
    join destinazioni d using(destinazioni_id);
    -- WHERE d.settore = 'UNK-99';
