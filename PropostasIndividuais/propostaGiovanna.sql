CREATE DATABASE Provador;
USE Provador;

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
    data_fabricacao DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status_sensor VARCHAR(40) DEFAULT "Inativo" NOT NULL,
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
    PRIMARY KEY(id_loja, fk_empresa)
);

CREATE TABLE Provador (
	id_provador INT NOT NULL,
    fk_loja INT NOT NULL,
    fk_empresa INT NOT NULL,
    fk_sensor INT NOT NULL UNIQUE,
    CONSTRAINT fk_lojaProvador FOREIGN KEY(fk_loja) REFERENCES Loja(id_loja),
    CONSTRAINT fk_empresaProvador FOREIGN KEY(fk_empresa) REFERENCES Empresa(id_empresa),
    CONSTRAINT fk_sensorProvador FOREIGN KEY(fk_sensor) REFERENCES Sensor(id_sensor),
    PRIMARY KEY(id_provador, fk_loja, fk_empresa)
    );

CREATE TABLE Registro (
    fk_provador INT NOT NULL,
    fk_loja INT NOT NULL,
    fk_empresa INT NOT NULL,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    registro BOOLEAN,
    PRIMARY KEY(fk_provador, fk_loja, fk_empresa, data_hora),
    CONSTRAINT fk_provadorRegistro FOREIGN KEY(fk_provador) REFERENCES Provador(id_provador),
    CONSTRAINT fk_lojaRegistro FOREIGN KEY(fk_loja) REFERENCES Loja(id_loja), 
    CONSTRAINT fk_empresaRegistro FOREIGN KEY(fk_empresa) REFERENCES Empresa(id_empresa)
);











