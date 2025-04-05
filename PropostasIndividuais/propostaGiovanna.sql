CREATE DATABASE provador_bd;
USE provador_bd;

CREATE TABLE Empresa (
	id_empresa INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(50),
    cnpj CHAR(14) NOT NULL,
    email VARCHAR(50) NOT NULL,
    senha VARCHAR(50) NOT NULL,
    CONSTRAINT regra_email CHECK(email LIKE "%@%" AND email LIKE "%.com%")
);

CREATE TABLE Sensor (
	id_sensor INT AUTO_INCREMENT PRIMARY KEY,
    numero_serie INT NOT NULL UNIQUE,
    data_fabricacao DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL UNIQUE,
    status_sensor VARCHAR(40) DEFAULT "Inativo" NOT NULL UNIQUE,
    CONSTRAINT regra_ativacao CHECK(status_sensor IN ("Ativo", "Inativo"))
);

CREATE TABLE Loja (
	id_loja INT NOT NULL,
    fk_empresa INT NOT NULL,
    rua VARCHAR(50),
    bairro VARCHAR(50),
    cidade VARChAR(50),
    nome_unidade VARCHAR(50),
    CONSTRAINT regra_fk_empresa FOREIGN KEY(fk_empresa) REFERENCES Empresa(id_empresa),
    CONSTRAINT regra_concat_loja PRIMARY KEY(id_loja, fk_empresa)
);

CREATE TABLE Provador (
	id_provador INT NOT NULL,
    fk_loja INT NOT NULL,
    fk_sensor INT NOT NULL UNIQUE,
    CONSTRAINT regra_fk_sensor FOREIGN KEY(fk_sensor) REFERENCES Sensor(id_sensor),
    CONSTRAINT regra_concat_provador PRIMARY KEY(id_provador, fk_loja),
    CONSTRAINT regra_fk_loja FOREIGN KEY(fk_loja, fk_sensor) REFERENCES Loja(id_loja, fk_empresa)
    );

CREATE TABLE Registro (
    fk_provador INT NOT NULL,
    fk_loja INT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    registro BOOLEAN,
    PRIMARY KEY(fk_provador, fk_loja, data_hora),
    CONSTRAINT regra_fk_registro FOREIGN KEY(fk_provador, fk_loja) REFERENCES Provador(id_provador, fk_loja)
);











