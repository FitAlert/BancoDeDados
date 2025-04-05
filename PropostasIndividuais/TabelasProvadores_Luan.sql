create database provadores;
use provadores;


-- Tabela Usuários (quem vai se cadastrar no site).
create table usuario (
idUsuario int primary key auto_increment,
nome_completo varchar(45) not null,
email varchar(120)  not null, -- (email deve conter "@" e finalizar com ".com")
	constraint chkEmail check(email like '%@%' and email like '%.com'),
senha varchar(45) not null,
fkLoja int
);


-- Tabela Lojas (cadastro da loja vinculado com o usuário).
-- idLoja começa em 500.
create table loja (
idLoja int primary key auto_increment,
nome_loja varchar(45) not null,
cnpj char(14) not null,
estado varchar(45) not null,
cidade varchar(45) not null,
rua varchar(45) not null,
numero int not null,
cep char(8) not null
) auto_increment = 500;

-- FK em fkLoja da tabela usuario = idLoja da tabela loja.
alter table usuario add 
	constraint fkUsuarioLoja 
	foreign key (fkLoja) 
	references loja(idLoja);


-- Tabela de provadores (dependencia com tabela loja).
create table provador (
idProvador int,
idLoja int, -- (PK e FK de loja.idLoja).
sessao varchar(20), -- (masculino, feminino ou unissex)
	constraint pkComposta primary key(idProvador, idLoja)
);

-- FK em idLoja da tabela provador = idLoja da tabela loja.
alter table provador add 
	constraint fkProvadorLoja 
	foreign key (idLoja) 
	references loja(idLoja);


-- Tabela de sensores (localizar e ver o status do sensor).
-- idSensor começa em 1000.
create table sensor (
idSensor int primary key auto_increment,
status_sensor varchar(20) not null, -- (Ativo, Inativo ou em Manutenção)
	constraint chkStatusSensor check(status_sensor in ('Ativo', 'Inativo', 'Manutenção')),
fkProvador int,
fkLoja int
) auto_increment = 1000;

-- FK em fkProvador da tabela sensor = idProvador da tabela provador.
alter table sensor add 
	constraint fkSensorProvador 
	foreign key (fkProvador) 
	references provador(idProvador);
    
-- FK em fkLoja da tabela sensor = idLoja da tabela provador.
alter table sensor add 
	constraint fkSensorLoja 
	foreign key (fkLoja) 
	references provador(idLoja);
    
    
-- Tabela registro (API coleta dados do sensor e insere nesta tabela)
-- idRegistro começa em 5000
create table registro (
idRegistro int primary key auto_increment,
registro char(1) not null,
data_hora datetime default current_timestamp,
fkSensor int
) auto_increment = 5000;

-- FK em fkSensor da tabela registro = idSensor da tabela sensor.
alter table registro add
	constraint fkRegistroSensor
    foreign key (fkSensor)
    references sensor(idSensor);
    
show tables;
desc usuario;
desc loja;
desc provador;
desc sensor;
desc registro;