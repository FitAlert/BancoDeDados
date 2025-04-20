CREATE DATABASE provador;
USE provador;

-- Criação das tabelas conforme o DER (Diagrama Entidade Relacionamento)

CREATE TABLE usuarios (
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nome_completo  VARCHAR(45) NOT NULL,
email VARCHAR(45) NOT NULL,
telefone CHAR(11),
senha VARCHAR(50) NOT NULL,
CONSTRAINT chkUsuarioEmail CHECK(email like '%@%');
);

CREATE TABLE lojas (
idLoja INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45) NOT NULL,
fkUsuario INT,
cnpj CHAR(18) NOT NULL,
fkLojaMatriz INT,
fkEndereco INT UNIQUE
);

create TABLE enderecos (
idEndereco INT PRIMARY KEY AUTO_INCREMENT,
uf CHAR(2) NOT NULL,
cidade VARCHAR(45) NOT NULL,
rua VARCHAR(45) NOT NULL,
numero VARCHAR(5) NOT NULL,
cep CHAR(9) NOT NULL
);

CREATE TABLE provadores (
idProvador int,
idLoja int,
sessao varchar(45) not null,
fkSensor int unique,
CONSTRAINT chkProvadorSessao CHECK(sessao in('Masculino', 'Feminino', 'Unissex'))
);


CREATE TABLE sensores (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
status_sensor VARCHAR(20) NOT NULL,
CONSTRAINT chkSensorStatus CHECK(status_sensor in('Inativo', 'Ativo', 'Manutenção'));
);

CREATE TABLE registros (
idRegistro INT PRIMARY KEY AUTO_INCREMENT,
fkSensor INT,
registro CHAR(1) NOT NULL,
data_entrada DATETIME DEFAULT CURRENT_TIMESTAMP,
data_saida DATETIME
);


SHOW TABLES;
DESC usuarios;
DESC enderecos;
DESC lojas;
DESC provadores;
DESC sensores;
DESC registros;

-- Declarando AS FKs e PKs das tabelas
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
ALTER TABLE lojas ADD CONSTRAINT fkLojaUsuario FOREIGN KEY (fkUsuario) REFERENCES usuarios(idUsuario);
ALTER TABLE lojas ADD CONSTRAINT fkLojaEndereco FOREIGN KEY (fkEndereco) REFERENCES enderecos(idEndereco);
ALTER TABLE lojas ADD CONSTRAINT fkLojaMatriz FOREIGN KEY (fkLojaMatriz) REFERENCES lojas(idLoja);
ALTER TABLE provadores ADD CONSTRAINT fkProvadorLoja FOREIGN KEY (idLoja) REFERENCES lojas(idLoja);
ALTER TABLE provadores ADD CONSTRAINT pkCompostaProvador PRIMARY KEY (idProvador, idLoja);
ALTER TABLE provadores ADD CONSTRAINT fkProvadorSensor FOREIGN KEY (fkSensor) REFERENCES sensores(idSensor);
ALTER TABLE registros ADD CONSTRAINT fkRegistroSensor FOREIGN KEY (fkSensor) REFERENCES sensores(idSensor);

-- Inserindo dados
INSERT INTO usuarios (nome_completo, email, telefone, senha) VALUES
	('Marcos Vinicius Silva de Oliveira', 'marcos.vinicius.oliveira@gmail.com', '11936728894', 'senhaSegura123');
SELECT * FROM usuarios;

INSERT INTO enderecos (uf, cidade, rua, numero, cep) VALUES
	('SP', 'Santo André', 'Rua dos Lagos', '237', '03711-008');
SELECT * FROM enderecos;

INSERT INTO lojas (nome, fkUsuario, cnpj, fkLojaMatriz, fkEndereco) VALUES
	('Vida Moda Central', 1, '43.937.819/0237-22', 1, 1);
SELECT * FROM lojas;

INSERT INTO sensores (status_sensor) VALUES
	('Ativo'),
    ('Inativo'),
    ('Manutenção');
SELECT * FROM sensores;

INSERT INTO provadores (idProvador, idLoja, sessao, fkSensor) VALUES
	(1, 1, 'Masculino', 1),
	(2, 1, 'Feminino', 2),
	(3, 1, 'Unissex', 3);
SELECT * FROM provadores;

-- Exibindo dados do usuario, loja vinculada, loja matriz e endereço
SELECT 
	u.nome_completo AS Usuário,
    u.email AS Email,
    u.telefone AS Telefone,
    l.nome AS Loja,
    l.cnpj AS CNPJ, 
    le.nome AS 'Loja Matriz',
    e.uf AS UF,
    e.cidade AS Cidade,
    e.rua AS Rua,
    e.numero AS Número,
    e.cep AS CEP
FROM usuarios AS u 
	JOIN lojas AS l
	ON u.idUsuario = l.fkUsuario
		JOIN lojas AS le
		ON le.idLoja = l.fkLojaMatriz
				JOIN enderecos AS e
                ON e.idEndereco = l.fkEndereco;
                
-- Exibir os dados dos provadores, qual loja estão, e qual sensor instalado
SELECT
	p.idProvador AS Provador,
    l.nome AS Loja,
    p.sessao AS Sessão,
    s.idSensor AS Sensor,
    s.status_sensor AS Status
FROM provadores AS p
	JOIN lojas AS l
    ON p.idLoja = l.idLoja
		JOIN sensores AS s
        ON p.fkSensor = s.idSensor;
        
-- Localizar o sensores em manutenção ou inativos 
SELECT
	p.idProvador AS Provador,
    l.nome AS Loja,
    p.sessao AS Sessão,
    s.idSensor AS Sensor,
    s.status_sensor AS Status
FROM provadores AS p
	JOIN lojas AS l
    ON p.idLoja = l.idLoja
		JOIN sensores AS s
        ON p.fkSensor = s.idSensor
where s.status_sensor = 'Inativo' OR s.status_sensor = 'Manutenção';

-- Localizar o sensor 3
SELECT 
	p.idProvador AS Provador,
    l.nome AS Loja,
    p.sessao AS Sessão,
    s.idSensor AS Sensor,
    s.status_sensor AS Status
FROM provadores AS p
	JOIN lojas AS l
    ON p.idLoja = l.idLoja
		JOIN sensores AS s
        ON p.fkSensor = s.idSensor
where s.idSensor = 3;

-- Exibir os dados do Registro e de qual Sensor está vindo
SELECT 
	r.idRegistro AS 'Nº Registro',
    s.idSensor AS 'Nº Sensor',
    r.registro AS Registro,
    r.data_entrada AS Entrada,
    r.data_saida AS Saída
FROM registros AS r
	JOIN sensores AS s
    ON r.fkSensor = s.idSensor;
    