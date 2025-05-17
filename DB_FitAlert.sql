CREATE DATABASE DB_FitAlert;
USE DB_FitAlert;

-- Criação das tabelas conforme o DER (Diagrama Entidade Relacionamento)

CREATE TABLE TB_Enderecos (
idEndereco INT PRIMARY KEY AUTO_INCREMENT,
uf CHAR(2) NOT NULL,
municipio VARCHAR(45) NOT NULL,
logradouro VARCHAR(45) NOT NULL,
numero VARCHAR(5) NOT NULL,
cep CHAR(8) NOT NULL,
fkEmpresa INT
);

CREATE TABLE TB_Empresas (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
razaoSocial VARCHAR(45) NOT NULL,
cnpj CHAR(14) NOT NULL,
fkEmpresaMatriz INT,
codigoAtivacao VARCHAR(50),
CONSTRAINT fkEmpresaMatriz FOREIGN KEY (fkEmpresaMatriz) REFERENCES TB_Empresas(idEmpresa)
);

ALTER TABLE tb_enderecos ADD CONSTRAINT fkEnderecoEmpresa FOREIGN KEY (fkEmpresa) REFERENCES TB_Empresas(idEmpresa);

CREATE TABLE TB_Usuarios (
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nomeUsuario  VARCHAR(45) NOT NULL,
fkEmpresa INT,
email VARCHAR(45) NOT NULL UNIQUE,
telefone CHAR(11)  NOT NULL UNIQUE,
senha VARCHAR(50) NOT NULL,
CONSTRAINT chkUsuarioEmail CHECK(email like '%@%'),
FOREIGN KEY (fkEmpresa) references TB_Empresas(idEmpresa)
);

CREATE TABLE TB_Sensores (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
status_sensor VARCHAR(20) NOT NULL,
CONSTRAINT chkSensorStatus CHECK(status_sensor in('Inativo', 'Ativo', 'Manutenção'))
);

CREATE TABLE TB_Provadores (
idProvador INT,
idEmpresa INT,
secao VARCHAR(45) NOT NULL,
fkSensor INT UNIQUE,
PRIMARY KEY (idProvador, idEmpresa),
CONSTRAINT chkProvadorSecao CHECK(secao in('Masculino', 'Feminino', 'Unissex')),
CONSTRAINT fkProvadorEmpresa FOREIGN KEY (idEmpresa) REFERENCES TB_Empresas(idEmpresa),
CONSTRAINT fkProvadorSensor FOREIGN KEY (fkSensor) REFERENCES TB_Sensores(idSensor)
);

CREATE TABLE TB_Registros (
idRegistro INT PRIMARY KEY AUTO_INCREMENT,
fkSensor INT,
ativo CHAR(1) NOT NULL,
data_entrada DATETIME DEFAULT CURRENT_TIMESTAMP,
data_saida DATETIME,
CONSTRAINT fkRegistroSensor FOREIGN KEY (fkSensor) REFERENCES TB_Sensores(idSensor)
);

CREATE TABLE TB_Avisos (
	idAviso INT PRIMARY KEY AUTO_INCREMENT,
	titulo VARCHAR(100),
	descricao VARCHAR(150),
	fkUsuario INT,
	FOREIGN KEY (fkUsuario) REFERENCES TB_Usuarios(idUsuario)
);

ALTER TABLE TB_Usuarios ADD CONSTRAINT chkUsuarioEmpresa FOREIGN KEY (fkEmpresa) REFERENCES TB_Empresas(idEmpresa);

insert into TB_Sensores values (default, 'Ativo');
-- SHOW TABLES;
-- DESC TB_Usuarios;
-- DESC TB_Enderecos;
-- DESC TB_Empresas;
-- DESC TB_Provadores;
-- DESC TB_Sensores;
-- DESC TB_Registros;


/* 
REGRAS DE NEGÓCIO 
- Email deve conter @. 

- 1 Usuário só pode ter 1 Empresa
- 1 Empresa pode er monitorada por vários usuários.
  
- 1 Empresa tem somente 1 Endereço
- 1 Endereço é de somente 1 Empresa. 

- 1 Matriz pode ter várias Empresas
- 1 Empresa pertence a somenta 1 Matriz. 

- 1 Empresa pode ter vários Provadores
- 1 Provador pertence somente a 1 Empresas
- 1 Provador depende de somente 1 Empresas para existir
- Sessão do provador pode ser somente Masculino, Feminino ou Unissex. 

- 1 Sensor só pode estar em 1 Provador
- 1 Provador pode ter somente 1 Sensor
- Sensor só pode ter o status Inativo, Ativo ou Manutenção.  

- 1 Registro é de 1 Sensor
- 1 Sensor fornece vários Registros.  
*/

-- -- Inserindo dados
-- INSERT INTO TB_Usuarios (nomeUsuario, email, telefone, senha) VALUES
-- 	('Marcos Vinicius Silva de Oliveira', 'marcos.vinicius.oliveira@gmail.com', '11936728894', 'senhaSegura123');
-- SELECT * FROM TB_Usuarios;

-- INSERT INTO TB_Enderecos (uf, cidade, rua, numero, cep) VALUES
-- 	('SP', 'Santo André', 'Rua dos Lagos', '237', '03711008');
-- SELECT * FROM TB_Enderecos;

-- INSERT INTO TB_Empresas (nomeFantasia, razaoSocial, cnpj, fkEmpresaMatriz, fkEndereco, codigoAtivacao) VALUES
-- 	('Vida Moda Central', 'Moda', '43937819023722', 1, 1, 'ED145B');
-- SELECT * FROM TB_Empresas;

-- UPDATE TB_Usuarios SET fkEmpresa = 1 WHERE idUsuario = 1;

-- INSERT INTO TB_Sensores (status_sensor) VALUES
-- 	('Ativo'),
--     ('Inativo'),
--     ('Manutenção');
-- SELECT * FROM TB_Sensores;

-- INSERT INTO TB_Provadores (idProvador, idEmpresa, secao, fkSensor) VALUES
-- 	(1, 1, 'Masculino', 1),
-- 	(2, 1, 'Feminino', 2),
-- 	(3, 1, 'Unissex', 3);
-- SELECT * FROM TB_Provadores;

-- -- Exibindo dados do usuario, Empresa vinculada, Empresa matriz e endereço
-- SELECT 
-- 	u.nomeUsuario AS Usuário,
--     u.email AS Email,
--     u.telefone AS Telefone,
--     l.nomeFantasia AS Empresa,
--     l.cnpj AS CNPJ, 
--     le.nomeFantasia AS 'Empresa Matriz',
--     e.uf AS UF,
--     e.cidade AS Cidade,
--     e.rua AS Rua,
--     e.numero AS Número,
--     e.cep AS CEP
-- FROM TB_Usuarios AS u 
-- 	JOIN TB_Empresas AS l
-- 	ON u.fkEmpresa = l.idEmpresa
-- 		JOIN TB_Empresas AS le
-- 		ON le.idEmpresa = l.fkEmpresaMatriz
-- 				JOIN TB_Enderecos AS e
--                 ON e.idEndereco = l.fkEndereco;
                
-- -- Exibir os dados dos provadores, qual empresa estão, e qual sensor instalado
-- SELECT
-- 	p.idProvador AS Provador,
--     l.nomeFantasia AS Empresa,
--     p.secao AS Seção,
--     s.idSensor AS Sensor,
--     s.status_sensor AS Status
-- FROM TB_Provadores AS p
-- 	JOIN TB_Empresas AS l
--     ON p.idEmpresa = l.idEmpresa
-- 		JOIN TB_Sensores AS s
--         ON p.fkSensor = s.idSensor;
        
-- -- Localizar o sensores em manutenção ou inativos 
-- SELECT
-- 	p.idProvador AS Provador,
--     l.nomeFantasia AS Empresa,
--     p.secao AS Seção,
--     s.idSensor AS Sensor,
--     s.status_sensor AS Status
-- FROM TB_Provadores AS p
-- 	JOIN TB_Empresas AS l
--     ON p.idEmpresa = l.idEmpresa
-- 		JOIN TB_Sensores AS s
--         ON p.fkSensor = s.idSensor
-- where s.status_sensor = 'Inativo' OR s.status_sensor = 'Manutenção';

-- -- Localizar o sensor 3
-- SELECT 
-- 	p.idProvador AS Provador,
--     l.nomeFantasia AS Empresa,
--     p.secao AS Seção,
--     s.idSensor AS Sensor,
--     s.status_sensor AS Status
-- FROM TB_Provadores AS p
-- 	JOIN TB_Empresas AS l
--     ON p.idEmpresa = l.idEmpresa
-- 		JOIN TB_Sensores AS s
--         ON p.fkSensor = s.idSensor
-- where s.idSensor = 3;

-- -- Exibir os dados do Registro e de qual Sensor está vindo
-- SELECT 
-- 	r.idRegistro AS 'Nº Registro',
--     s.idSensor AS 'Nº Sensor',
--     r.ativo AS Registro,
--     r.data_entrada AS Entrada,
--     r.data_saida AS Saída
-- FROM TB_Registros AS r
-- 	JOIN TB_Sensores AS s
--     ON r.fkSensor = s.idSensor;