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
                                 ('Interreggionale'),
                                 ('Merci');


insert into treni (id_treno, id_categoria, max_speed, data_costruzione) values
                                                                            (1,1,350,'2010-02-23'),
                                                                            (2,2,320,'1998-05-11'),
                                                                            (3,2,110,'1998-02-03'),
                                                                            (4,3,240,'1994-02-15'),
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



