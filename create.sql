create database tuttotutor;
use tuttotutor;
create table persona(
	id int primary key auto_increment ,
    nome varchar(50) not null, constraint nomenotcognome check (nome != cognome),
    cognome varchar(50) not null,
    
);
create table numero(
	numero int primary key,
    IdPersona int not null,
    prefisso int not null,
    foreign key(IdPersona) references persona(id),
	foreign key(prefisso) references nazione(prefisso)
    );
create table nazione(
	prefisso int primary key, 
    nazione varchar(30) not null 
);
drop database tuttotutor;