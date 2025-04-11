create database provador;
use provador;

-- Criação das tabelas conforme o DER (Diagrama Entidade Relacionamento)

create table usuarios (
idUsuario int primary key auto_increment,
nome_completo varchar(45) not null,
email varchar(45) not null,
telefone char(11),
senha varchar(50) not null
);

create table lojas (
idLoja int primary key auto_increment,
nome varchar(45) not null,
fkUsuario int,
cnpj char(18) not null,
fkLojaMatriz int,
fkEndereco int unique
);

create table enderecos (
idEndereco int primary key auto_increment,
uf char(2) not null,
cidade varchar(45) not null,
rua varchar(45) not null,
numero varchar(5) not null,
cep char(9) not null
);

create table provadores (
idProvador int,
idLoja int,
sessao varchar(45) not null,
fkSensor int unique
);


create table sensores (
idSensor int primary key auto_increment,
status_sensor varchar(20) not null
);

create table registros (
idRegistro int primary key auto_increment,
fkSensor int,
registro char(1) not null,
data_entrada datetime default current_timestamp,
data_saida datetime
);


show tables;
desc usuarios;
desc enderecos;
desc lojas;
desc provadores;
desc sensores;
desc registros;

-- Declarando as FKs e PKs das tabelas
/* 
REGRAS DE NEGÓCIO 
- Email deve conter @. 

- 1 Usuário pode cadastrar várias Lojas
- 1 Loja pertence somente a 1 Usuário.
  
- 1 Loja tem somente 1 Endereço
- 1 Endereço é de somente 1 Loja. 

- 1 Matriz pode ter várias Lojas
- 1 Loja pertence a somenta 1 Matriz. 

- 1 Loja pode ter vários Provadores
- 1 Provador pertence somente a 1 Loja
- 1 Provador depende de somente 1 Loja para existir
- Sessão do provador pode ser somente Masculino, Feminino ou Unissex. 

- 1 Sensor só pode estar em 1 Provador
- 1 Provador pode ter somente 1 Sensor
- Sensor só pode ter o status Inativo, Ativo ou Manutenção.  

- 1 Registro é de 1 Sensor
- 1 Sensor fornece vários Registros.  
*/

alter table usuarios add constraint chkUsuarioEmail check(email like '%@%');
alter table lojas add constraint fkLojaUsuario foreign key (fkUsuario) references usuarios(idUsuario);
alter table lojas add constraint fkLojaEndereco foreign key (fkEndereco) references enderecos(idEndereco);
alter table lojas add constraint fkLojaMatriz foreign key (fkLojaMatriz) references lojas(idLoja);
alter table provadores add constraint fkProvadorLoja foreign key (idLoja) references lojas(idLoja);
alter table provadores add constraint pkCompostaProvador primary key (idProvador, idLoja);
alter table provadores add constraint fkProvadorSensor foreign key (fkSensor) references sensores(idSensor);
alter table provadores add constraint chkProvadorSessao check(sessao in('Masculino', 'Feminino', 'Unissex'));
alter table sensores add constraint chkSensorStatus check(status_sensor in('Inativo', 'Ativo', 'Manutenção'));
alter table registros add constraint fkRegistroSensor foreign key (idSensor) references sensores(idSensor);

-- Inserindo dados
insert into usuarios (nome_completo, email, telefone, senha) values
	('Marcos Vinicius Silva de Oliveira', 'marcos.vinicius.oliveira@gmail.com', '11936728894', 'senhaSegura123');
select * from usuarios;

insert into enderecos (uf, cidade, rua, numero, cep) values
	('SP', 'Santo André', 'Rua dos Lagos', '237', '03711-008');
select * from enderecos;

insert into lojas (nome, fkUsuario, cnpj, fkLojaMatriz, fkEndereco) values
	('Vida Moda Central', 1, '43.937.819/0237-22', 1, 1);
select * from lojas;

insert into sensores (status_sensor) values
	('Ativo'),
    ('Inativo'),
    ('Manutenção');
select * from sensores;

insert into provadores (idProvador, idLoja, sessao, fkSensor) values
	(1, 1, 'Masculino', 1),
	(2, 1, 'Feminino', 2),
	(3, 1, 'Unissex', 3);
select * from provadores;

-- Exibindo dados do usuario, loja vinculada, loja matriz e endereço
select 
	u.nome_completo as Usuário,
    u.email as Email,
    u.telefone as Telefone,
    l.nome as Loja,
    l.cnpj as CNPJ, 
    le.nome as 'Loja Matriz',
    e.uf as UF,
    e.cidade as Cidade,
    e.rua as Rua,
    e.numero as Número,
    e.cep as CEP
from usuarios as u 
	join lojas as l
	on u.idUsuario = l.fkUsuario
		join lojas as le
		on le.idLoja = l.fkLojaMatriz
				join enderecos as e
                on e.idEndereco = l.fkEndereco;
                
-- Exibir os dados dos provadores, qual loja estão, e qual sensor instalado
select
	p.idProvador as Provador,
    l.nome as Loja,
    p.sessao as Sessão,
    s.idSensor as Sensor,
    s.status_sensor as Status
from provadores as p
	join lojas as l
    on p.idLoja = l.idLoja
		join sensores as s
        on p.fkSensor = s.idSensor;
        
-- Localizar o sensores em manutenção ou inativos 
select
	p.idProvador as Provador,
    l.nome as Loja,
    p.sessao as Sessão,
    s.idSensor as Sensor,
    s.status_sensor as Status
from provadores as p
	join lojas as l
    on p.idLoja = l.idLoja
		join sensores as s
        on p.fkSensor = s.idSensor
where s.status_sensor = 'Inativo' or s.status_sensor = 'Manutenção';

-- Localizar o sensor 3
select 
	p.idProvador as Provador,
    l.nome as Loja,
    p.sessao as Sessão,
    s.idSensor as Sensor,
    s.status_sensor as Status
from provadores as p
	join lojas as l
    on p.idLoja = l.idLoja
		join sensores as s
        on p.fkSensor = s.idSensor
where s.idSensor = 3;

-- Exibir os dados do Registro e de qual Sensor está vindo
select 
	r.idRegistro as 'Nº Registro',
    s.idSensor as 'Nº Sensor',
    r.registro as Registro,
    r.data_hora as Data
from registros as r
	join sensores as s
    on r.fkSensor = s.idSensor;
    