drop database if exists esercitazione3;
create database esercitazione3;

use esercitazione3;

create table categorie(
                          id_categoria int auto_increment primary key,
                          nome varchar(50) NOT NULL
);

create table treni(
                      id_treno int auto_increment primary key,
                      id_categoria int not null,
                      max_speed int not null,
                      data_costruzione date not null,
                      foreign key(id_categoria) references categorie(id_categoria)
);

create table vagoni(
                       id_vagone int auto_increment primary key,
                       id_treno int not null,
                       classe enum('BUSINESS','PRIMA','SECONDA'),
                       bagno boolean default false,
                       max_posti int not null,
                       foreign key(id_treno) references treni(id_treno)
);

create table city(
    id_city int auto_increment primary key,
    nome varchar(100) not null unique
);

create table tratte(
    id_tratta int auto_increment primary key,
    id_city_partenza int not null,
    id_city_arrivo int not null,
    foreign key(id_city_partenza) references city(id_city),
    foreign key(id_city_arrivo) references city(id_city)
);

create table tappe_intermedie(
    id_tratta int not null,
    id_city int not null, -- step
    foreign key(id_tratta) references tratte(id_tratta),
    foreign key(id_city) references city(id_city),
    unique(id_tratta,id_city)
);

create table tratte_treni(
    id_treno int not null,
    id_tratta int not null,
    partenza time not null,
    arrivo time not null,
    foreign key(id_treno) references treni(id_treno),
    foreign key(id_tratta) references tratte(id_tratta),
    unique(id_tratta,id_treno,partenza)
);


insert into categorie (nome) values
                                 ('Freccia Rossa'),
                                 ('Regionale'),
                                 ('Interregionale'),
                                 ('Merci');


insert into treni (id_treno, id_categoria, max_speed, data_costruzione) values
                                                                            (1,1,350,'2010-02-23'),
                                                                            (2,2,320,'1998-05-11'),
                                                                            (3,2,110,'1998-02-03'),
                                                                            (4,3,385,'1994-02-15'),
                                                                            (5,4,340,'2010-03-08'),
                                                                            (6,2,330,'2016-01-14'),
                                                                            (7,3,260,'2016-12-11'),
                                                                            (8,3,230,'2002-09-01'),
                                                                            (9,4,315,'1991-05-26'),
                                                                            (10,1,410,'2002-06-16'),
                                                                            (11,1,390,'2002-08-18'),
                                                                            (12,4,250,'1998-08-12');


insert into vagoni(id_vagone, classe, bagno, max_posti, id_treno) values
                                                            (1,'PRIMA',true,50,1), -- 1
                                                            (2,'PRIMA',true,60,1), -- 1
                                                            (3,'PRIMA',true,55,1), -- 1
                                                            (4,'PRIMA',true,50,2), -- 2
                                                            (5,'PRIMA',true,52,4),  -- 4
                                                            (6,'SECONDA',false,80,1), -- 1
                                                            (7,'SECONDA',false,70,1), -- 1
                                                            (8,'SECONDA',false,58,1), -- 1
                                                            (9,'SECONDA',false,88,2), -- 2
                                                            (10,'SECONDA',true,70,2), -- 2
                                                            (11,'SECONDA',false,102,2), -- 2
                                                            (12,'SECONDA',false,75,3), -- 3
                                                            (13,'SECONDA',false,80,3), -- 3
                                                            (14,'SECONDA',false,76,3), -- 3
                                                            (15,'SECONDA',true,80,4), -- 4
                                                            (16,'SECONDA',false,80,4), -- 4
                                                            (17,'BUSINESS',true,30,1), -- 1
                                                            (18,'BUSINESS',true,25,4), -- 4
                                                            (19,'SECONDA',false,78,4), -- 4
                                                            (20,'BUSINESS',false,60,4), -- 4
                                                            (21,'PRIMA',true,50,6), -- 1
                                                            (22,'PRIMA',true,60,6), -- 1
                                                            (23,'PRIMA',false,55,7), -- 1
                                                            (24,'PRIMA',true,50,7), -- 2
                                                            (25,'BUSINESS',true,52,7),  -- 4
                                                            (26,'SECONDA',false,80,6), -- 1
                                                            (27,'SECONDA',false,70,6), -- 1
                                                            (28,'SECONDA',true,58,7), -- 1
                                                            (29,'SECONDA',false,88,8), -- 2
                                                            (30,'SECONDA',true,70,8), -- 2
                                                            (32,'SECONDA',true,102,8), -- 2
                                                            (33,'SECONDA',false,75,8), -- 3
                                                            (34,'SECONDA',false,80,7), -- 3
                                                            (35,'BUSINESS',true,32,8), -- 3
                                                            (36,'BUSINESS',true,26,7), -- 4
                                                            (37,'BUSINESS',true,54,7), -- 4
                                                            (38,'BUSINESS',true,30,10), -- 1
                                                            (39,'BUSINESS',true,25,10), -- 4
                                                            (40,'SECONDA',false,110,10), -- 4
                                                            (41,'BUSINESS',true,60,10), -- 4
                                                            (42,'SECONDA',true,102,8), -- 2
                                                            (43,'SECONDA',false,78,3), -- 3
                                                            (44,'SECONDA',false,80,10), -- 3
                                                            (45,'PRIMA',true,60,11), -- 3
                                                            (46,'PRIMA',true,50,11), -- 4
                                                            (47,'PRIMA',true,84,11), -- 4
                                                            (48,'BUSINESS',true,30,11), -- 1
                                                            (49,'SECONDA',true,85,11), -- 4
                                                            (50,'SECONDA',true,78,11), -- 4
                                                            (51,'SECONDA',false,60,11); -- 4

insert into city  values
                           (1,'Roma Termini'),
                           (2,'Roma Tiburtina'),
                           (3,'Milano'),
                           (4,'Torino'),
                           (5,'Firenze'),
                           (6,'Perugia'),
                           (7,'Terni'),
                           (8,'Napoli'),
                           (9,'Salerno'),
                           (10,'Orte'),
                           (12,'Pisa'),
                           (13,'Bologna'),
                           (14,'Verona'),
                           (15,'Padova'),
                           (16,'Reggio Emilia'),
                           (17,'Arezzo'),
                           (18,'Fiumicino');

insert into tratte (id_tratta, id_city_partenza, id_city_arrivo) VALUES
                                                        (1,1,3),
                                                        (2,1,4),
                                                        (3,1,5),
                                                        (4,1,8),
                                                        (5,1,14),
                                                        (6,1,18),
                                                        (7,2,6),
                                                        (8,2,7),
                                                        (9,2,15),
                                                        (10,3,1),
                                                        (11,3,4),
                                                        (12,3,6),
                                                        (13,3,8),
                                                        (14,3,16),
                                                        (15,4,1),
                                                        (16,4,13),
                                                        (17,4,14),
                                                        (18,5,6),
                                                        (19,5,9),
                                                        (20,6,5),
                                                        (21,6,2),
                                                        (22,6,8),
                                                        (23,7,6),
                                                        (24,8,1),
                                                        (25,8,3),
                                                        (26,8,4),
                                                        (27,8,5),
                                                        (28,8,6),
                                                        (29,8,9),
                                                        (30,8,14),
                                                        (31,8,15),
                                                        (32,9,2),
                                                        (33,9,8),
                                                        (34,14,2),
                                                        (35,14,3),
                                                        (36,14,4),
                                                        (37,15,14),
                                                        (38,17,5),
                                                        (39,18,1),
                                                        (40,18,2);


insert into tappe_intermedie (id_tratta, id_city) VALUES
                                                      (1,2),
                                                      (1,3),
                                                      (2,2),
                                                      (3,10),
                                                      (3,5),
                                                      (4,8),
                                                      (5,13),
                                                      (6,13),
                                                      (7,7),
                                                      (7,10),
                                                      (8,10),
                                                      (12,5),
                                                      (13,2),
                                                      (15,2),
                                                      (15,12),
                                                      (15,10),
                                                      (19,6),
                                                      (19,7),
                                                      (19,10),
                                                      (19,2),
                                                      (19,8),
                                                      (21,7),
                                                      (21,10),
                                                      (22,2),
                                                      (26,2),
                                                      (26,12),
                                                      (27,2),
                                                      (28,7),
                                                      (30,2),
                                                      (30,13),
                                                      (31,13),
                                                      (31,16),
                                                      (32,8),
                                                      (35,15),
                                                      (36,3);

insert into tratte_treni(id_treno, id_tratta, partenza, arrivo) VALUES
                                                                    (1,1,'09:30','13:00'),
                                                                    (1,10,'15:00','20:00'),
                                                                    (2,7,'07:50','10:00'),
                                                                    (2,20,'10:20','14:00'),
                                                                    (2,18,'14:20','17:00'),
                                                                    (2,22,'17:30','22:15'),
                                                                    (3,6,'12:00','12:45'),
                                                                    (3,40,'14:30','15:10'),
                                                                    (4,2,'11:45','17:20'),
                                                                    (4,15,'18:00','23:40'),
                                                                    (5,25,'06:20','15:30'),
                                                                    (5,10,'17:00','23:10'),
                                                                    (6,14,'08:00','11:00'),
                                                                    (6,37,'12:05','13:12'),
                                                                    (6,35,'13:36','15:45'),
                                                                    (6,10,'17:26','22:45'),
                                                                    (7,5,'08:55','14:05'),
                                                                    (7,34,'14:20','18:17'),
                                                                    (7,9,'18:30','21:00'),
                                                                    (7,37,'21:20','22:13'),
                                                                    (8,20,'07:45','10:30'),
                                                                    (8,19,'10:55','16:07'),
                                                                    (8,33,'16:40','18:10'),
                                                                    (8,26,'18:31','23:08'),
                                                                    (9,33,'05:10','07:00'),
                                                                    (9,24,'07:40','10:40'),
                                                                    (9,4,'11:20','13:33'),
                                                                    (9,25,'14:00','19:04'),
                                                                    (9,14,'21:30','23:22'),
                                                                    (10,11,'07:10','08:18'),
                                                                    (10,17,'08:30','10:50'),
                                                                    (10,36,'11:10','12:36'),
                                                                    (10,16,'13:10','16:55'),
                                                                    (11,3,'09:10','12:29'),
                                                                    (11,18,'13:00','16:11'),
                                                                    (11,21,'16:44','18:15'),
                                                                    (11,7,'19:00','21:25'),
                                                                    (11,21,'21:36','23:41');





show tables;

select * from categorie;

select * from treni;

select * from vagoni;


-- ESERCIZI

#1  Listare tutte le città, e per ogni città quelle il cui numero di tratte che partono da quella città ( non considerare le
#  fermate intermedie) sia superiore a 4.
#   Le città vanno ordinate in ordine alfabetico.

+--------------+----------+
| nome         | partenze |
+--------------+----------+
| Milano       |        5 |
| Napoli       |        8 |
| Roma Termini |        6 |
+--------------+----------+
3 rows in set (0.00 sec)



#2 stampare per ogni categoria di treno il numero di tratte esistenti, e infine il totale generale come nell'esempio

+-----------------+---------------+
| categoria       | numero tratte |
+-----------------+---------------+
| Freccia Rossa   |            11 |
| Interreggionale |            10 |
| Merci           |             7 |
| Regionale       |            10 |
| totale generale |            38 |
+-----------------+---------------+
5 rows in set (0.00 sec)


#3 stampare la lista delle tratta con id, nome della città di partenza e nome della città di arrivo, il tutto ordinato
# per id

+-----------+----------------+----------------+
| id_tratta | nome           | nome           |
+-----------+----------------+----------------+
|         1 | Roma Termini   | Milano         |
|         2 | Roma Termini   | Torino         |
|         3 | Roma Termini   | Firenze        |
|         4 | Roma Termini   | Napoli         |
|         5 | Roma Termini   | Verona         |
|         6 | Roma Termini   | Fiumicino      |
|         7 | Roma Tiburtina | Perugia        |
|         8 | Roma Tiburtina | Terni          |
|         9 | Roma Tiburtina | Padova         |
|        10 | Milano         | Roma Termini   |
|        11 | Milano         | Torino         |
|        12 | Milano         | Perugia        |
|        13 | Milano         | Napoli         |
|        14 | Milano         | Reggio Emilia  |
|        15 | Torino         | Roma Termini   |
|        16 | Torino         | Bologna        |
|        17 | Torino         | Verona         |
|        18 | Firenze        | Perugia        |
|        19 | Firenze        | Salerno        |
|        20 | Perugia        | Firenze        |
|        21 | Perugia        | Roma Tiburtina |
|        22 | Perugia        | Napoli         |
|        23 | Terni          | Perugia        |
|        24 | Napoli         | Roma Termini   |
|        25 | Napoli         | Milano         |
|        26 | Napoli         | Torino         |
|        27 | Napoli         | Firenze        |
|        28 | Napoli         | Perugia        |
|        29 | Napoli         | Salerno        |
|        30 | Napoli         | Verona         |
|        31 | Napoli         | Padova         |
|        32 | Salerno        | Roma Tiburtina |
|        33 | Salerno        | Napoli         |
|        34 | Verona         | Roma Tiburtina |
|        35 | Verona         | Milano         |
|        36 | Verona         | Torino         |
|        37 | Padova         | Verona         |
|        38 | Arezzo         | Firenze        |
|        39 | Fiumicino      | Roma Termini   |
|        40 | Fiumicino      | Roma Tiburtina |
+-----------+----------------+----------------+
40 rows in set (0.01 sec)


#4 Elencare tutte le tratte che non partono o non arrivano e nemmeno passano da nessuna stazione di roma.
#  Le tratte vanno elencate come per la query 1 -> id, città di partenza, città di arrivo

+-----------+---------+---------------+
| id_tratta | nome    | nome          |
+-----------+---------+---------------+
|        11 | Milano  | Torino        |
|        12 | Milano  | Perugia       |
|        14 | Milano  | Reggio Emilia |
|        16 | Torino  | Bologna       |
|        17 | Torino  | Verona        |
|        18 | Firenze | Perugia       |
|        20 | Perugia | Firenze       |
|        23 | Terni   | Perugia       |
|        25 | Napoli  | Milano        |
|        28 | Napoli  | Perugia       |
|        29 | Napoli  | Salerno       |
|        31 | Napoli  | Padova        |
|        33 | Salerno | Napoli        |
|        35 | Verona  | Milano        |
|        36 | Verona  | Torino        |
|        37 | Padova  | Verona        |
|        38 | Arezzo  | Firenze       |
+-----------+---------+---------------+

#5 Elencare le prime cinque tratte con il numero più alto in percorrenza. Si stampi anche le città di partenza, arrivo e
# tempo di percorrenza. In fondo ai risultati aggiungere anche la media dei tempi di percorrenza
# di tutte le tratte e anche la tratta che impiega più tempo di tutte. Infine aggiungere delle decorazioni di asterischi
# esattamente nei punti come mostrati nell'esempio.

-- TIP usare questa funzione per la stampa e il calcolo delle differenze temporali select TIMEDIFF(arrivo,partenza) from tratte_treni;
-- TIP2  usare SEC_TO_TIME(AVG(TIME_TO_SEC(TIMEDIFF(arrivo,partenza)))) per prettystampare la media di una differenza temporale
-- TIP3 ()()()()()()()()()()()()()()()()()()()()

+-----------------+-----------------+------------------+-----------------+
| nome            | nome            | numero_treni     | durata          |
+-----------------+-----------------+------------------+-----------------+
| Milano          | Roma Termini    | 3                | 05:00:00        |
| Milano          | Reggio Emilia   | 2                | 03:00:00        |
| Firenze         | Perugia         | 2                | 02:40:00        |
| Perugia         | Firenze         | 2                | 03:40:00        |
| Roma Tiburtina  | Perugia         | 2                | 02:10:00        |
| *************** | *************** | ***************  | *************** |
| --------        | --------        | media durate     | 03:14:17.3684   |
| Napoli          | Milano          | tratta più lunga | 09:10:00        |
| *************** | *************** | ***************  | *************** |
+-----------------+-----------------+------------------+-----------------+
9 rows in set (0.00 sec)


#6 Listare tutte le tratte senza alcuna fermata intermedia

+-----------+----------------+----------------+
| id_tratta | nome           | nome           |
+-----------+----------------+----------------+
|         9 | Roma Tiburtina | Padova         |
|        10 | Milano         | Roma Termini   |
|        11 | Milano         | Torino         |
|        14 | Milano         | Reggio Emilia  |
|        16 | Torino         | Bologna        |
|        17 | Torino         | Verona         |
|        18 | Firenze        | Perugia        |
|        20 | Perugia        | Firenze        |
|        23 | Terni          | Perugia        |
|        24 | Napoli         | Roma Termini   |
|        25 | Napoli         | Milano         |
|        29 | Napoli         | Salerno        |
|        33 | Salerno        | Napoli         |
|        34 | Verona         | Roma Tiburtina |
|        37 | Padova         | Verona         |
|        38 | Arezzo         | Firenze        |
|        39 | Fiumicino      | Roma Termini   |
|        40 | Fiumicino      | Roma Tiburtina |
+-----------+----------------+----------------+
18 rows in set (0.00 sec)


#7 Elencare tutte le città da cui partono treni intereggionali di velocità superiore alla media di treni freccia rossa
# **** non usare direttamente l'id della categoria dei frecciarosa. ****

+--------------+
| nome         |
+--------------+
| Roma Termini |
| Torino       |
+--------------+
2 rows in set (0.00 sec)


# 8 listare i treni (id e classe) che vanno e vengono da milano ( partenza, arrivo, non tappe intermedie) con il numero di vagoni collegati.
# Anche i treni merci devono comparire ma con 0 vagoni. Il tutto va ordinato in ordine decrescente per numero vagoni.

# tip (* è brutto)

+----------+---------------+------------+
| id_treno | nome          | num_vagoni |
+----------+---------------+------------+
|        1 | Freccia Rossa |          7 |
|       10 | Freccia Rossa |          5 |
|        6 | Regionale     |          4 |
|        5 | Merci         |          0 |  -- eheh
|        9 | Merci         |          0 |  -- uahuah vi viene sempre 1 vero ? :D
+----------+---------------+------------+
5 rows in set (0.00 sec)


#9 si stampi per ogni treno, id, classe, data costruzione,  il numero di vagoni in business class, il numero di bagni e se il treno
# ha meno di 3 bagni si scriva "vergognoso" viceversa "regolare"
# Quanto sopra vale per tutti i treni costruiti prima del 2005. Per gli altri l'etichetta sarà "nuovi e profumati"
# a prescindere da tutto.
#I treni vanno listati in ordine di data costruzione, dal più nuovo al più vecchio.

+----------+----------------+------------------+--------------+--------------------+-------------------+
| id_treno | nome           | data_costruzione | numero_bagni | vagoni in business | status            |
+----------+----------------+------------------+--------------+--------------------+-------------------+
|        7 | Interregionale | 2016-12-11       |            5 |                  3 | nuovi e profumati |
|        6 | Regionale      | 2016-01-14       |            2 |                  0 | nuovi e profumati |
|        5 | Merci          | 2010-03-08       |            0 |                  0 | nuovi e profumati |
|        1 | Freccia Rossa  | 2010-02-23       |            4 |                  1 | nuovi e profumati |
|        8 | Interregionale | 2002-09-01       |            4 |                  1 | regolare          |
|       11 | Freccia Rossa  | 2002-08-18       |            6 |                  1 | regolare          |
|       10 | Freccia Rossa  | 2002-06-16       |            3 |                  3 | regolare          |
|       12 | Merci          | 1998-08-12       |            0 |                  0 | vergognoso        |
|        2 | Regionale      | 1998-05-11       |            2 |                  0 | vergognoso        |
|        3 | Regionale      | 1998-02-03       |            0 |                  0 | vergognoso        |
|        4 | Interregionale | 1994-02-15       |            3 |                  2 | regolare          |
|        9 | Merci          | 1991-05-26       |            0 |                  0 | vergognoso        |
+----------+----------------+------------------+--------------+--------------------+-------------------+
12 rows in set (0.00 sec)


