-- Criação das tabelas
CREATE TYPE STATUS AS ENUM (
	'Aguardando confirmação',
	'Entrega em andamento',
	'Entregue',
	'Cancelado',
	'Bloqueado'
);

CREATE TABLE Fornecedor(
	idForn SERIAL PRIMARY KEY,
	nomeForn VARCHAR(40) NOT NULL,
	cepForn CHAR(8) NOT NULL,
	emailForn VARCHAR(40) UNIQUE NOT NULL,
	foneForn VARCHAR(20) UNIQUE NOT NULL,
	tipoForn CHAR(1) NOT NULL CHECK (tipoForn IN ('J', 'F'))
);

CREATE TABLE Categoria(
	idCateg SERIAL PRIMARY KEY,
	descCateg VARCHAR(40) NOT NULL
);

CREATE TABLE Produto(
	idProd SERIAL PRIMARY KEY,
	nomeProd VARCHAR(40) NOT NULL,
	precoProd DECIMAL(6,2) NOT NULL,
	quantProd INT NOT NULL DEFAULT 0,
	idCateg INT NOT NULL,
	idForn INT NOT NULL,
	FOREIGN KEY (idCateg) REFERENCES Categoria(idCateg),
	FOREIGN KEY (idForn) REFERENCES Fornecedor(idForn) -- Relacionamento para ser utilizado em futuras funcionalidades (como exibir todos os produtos de um determinado fornecedor)
);

CREATE TABLE Cliente(
	idCli SERIAL PRIMARY KEY,
	nomeCli VARCHAR(40) NOT NULL,
	cepCli CHAR(8) NOT NULL,
	emailCli VARCHAR(40) UNIQUE NOT NULL,
	foneCli VARCHAR(20) NOT NULL,
	generoCli CHAR(1) CHECK (generoCli IN ('M', 'F')) -- 'M' para masculino, 'F' para feminino
);

CREATE TABLE Pedido(
	idPed SERIAL PRIMARY KEY,
	idProd INT NOT NULL,
	idCli INT NOT NULL, 
	dataPed DATE NOT NULL,
	tipoEntrega VARCHAR(20) NOT NULL DEFAULT 'Correio', -- Os tipos de entrega serão "Correio", "Transportadora Veloz" e "Drone", onde cada uma delas resultará em valor x de dias para ser entregue
	quantPed INT NOT NULL DEFAULT 1,
	statusPed STATUS NOT NULL DEFAULT 'Aguardando confirmação', -- Estado atual do pedido (ex.: Se já foi entregue, se está a caminho, se foi coletado pela transportadora, etc...)
	FOREIGN KEY(idProd) REFERENCES Produto(idProd),
	FOREIGN KEY(idCli) REFERENCES Cliente(idCli)
);

CREATE TABLE Avaliacao(
	idAval SERIAL PRIMARY KEY,
	idProd INT NOT NULL,
	idCli INT NOT NULL,
	notaAval NUMERIC,
	comentAval TEXT,
	dataAval DATE NOT NULL,
	FOREIGN KEY (idProd) REFERENCES Produto(idProd),
	FOREIGN KEY (idCli) REFERENCES Cliente(idCli)
);

-- Populando as tabelas
INSERT INTO Fornecedor(nomeForn, cepForn, emailForn, foneForn, tipoForn) VALUES -- ok 
	('TecnoComputers Ltda.', '12345678', 'tecnocomputers@email.com', '123456789', 'J'),
	('MobileTech Solutions', '87654321', 'mobiletech@email.com', '987654321', 'J'),
	('Maria Rebeca', '11112222', 'mariarebeca@email.com', '555555555', 'F'),
	('House of Mario', '58054755', 'nintendomario@email.com', '656829475', 'J'),
	('TechSupply Ltda.', '98765432', 'techsupply@email.com', '555558888', 'J'),
	('PhoneMasters', '11223344', 'phonemasters@email.com', '666666666', 'J');

INSERT INTO Categoria(descCateg) VALUES -- ok
	('Computadores & Notebooks'),
	('Impressoras'),
	('Celulares & Smartphones'),
	('Acessórios para Celulares'),
	('Periféricos'),
	('Videogames');

INSERT INTO Produto(nomeProd, precoProd, quantProd, idCateg, idForn) VALUES -- ok
	('Computador', 4999.99, 5, 1, 1),
	('Notebook', 2499.99, 20, 1, 1),
	('Impressora Laser', 899.99, 10, 2, 6),
	('Cartuchos de tinta', 24.99, 1000, 2, 5),
	('Smartphone', 1999.99, 50, 3, 2),
	('Capa para Celular', 19.99, 500, 4, 5),
	('Mouse USB', 29.99, 800, 5, 3),
	('Teclado Wireless', 69.99, 400, 5, 3),
	('Nintendo Switch',2010.00, 10, 6, 4),
	('PS5', 3699, 50, 6, 4);

INSERT INTO Cliente(nomeCli, cepCli, emailCli, foneCli, generoCli) VALUES -- ok
	('Felipe', '58085370', 'felipecartaxo1@gmail.com', '986716883', 'M'),
	('Karen', '58084683', 'karenneraky@gmail.com', '988215446', 'F'),
	('Lídia Maria', '58199442', 'lidiamaria@hotmail.com', '988034845', 'F'),
	('João', '12345678', 'joao@outlook.com', '111111111', 'M'),
	('Maria', '87654321', 'maria@gmail.com', '222222222', 'F'),
	('Paula', '11112222', 'paula@yahoo.com', '333333333', 'F'),
	('Marcos', '98345123', 'marcus@yahoo.com', '88889999', 'M'),
	('Fernanda', '87654321', 'fernanda@gmail.com', '777777777', 'F'),
	('Roberto', '11223344', 'roberto@outlook.com', '888888888', 'M'),
	('Carol', '63012589', 'carol@hotmail.com', '32245871', 'F');

INSERT INTO Pedido(idProd, idCli, dataPed, tipoEntrega, quantPed, statusPed) VALUES -- ok
	(1, 1, '2023-01-15', 'Drone', 1, 'Entregue'), -- 1 pc
	(2, 2, '2023-02-20', 'Correio', 2, 'Aguardando confirmação'), -- 2 notebooks
	(3, 3, '2023-03-10', 'Transportadora Veloz', 2,  'Bloqueado'), -- 2 impressoras
	(4, 3, '2023-03-10', 'Transportadora Veloz', 10,  'Bloqueado'), -- 10 cartuchos
	(5, 4, '2023-01-15', 'Correio', 1, 'Entregue'), -- 1 smartphone
	(6, 5, '2023-01-15', 'Correio', 1, 'Entregue'), -- 1 capa de celular
	(7, 6, '2023-03-10', 'Transportadora Veloz', 20,  'Entrega em andamento'), -- 20 mouses
	(8, 6, '2023-03-10', 'Transportadora Veloz', 20,  'Entrega em andamento'), -- 20 teclados
	(9, 7, '2023-01-15', 'Drone', 1, 'Entrega em andamento'), -- 1 n switch
	(10, 8, '2023-04-05', 'Correio', 2, 'Aguardando confirmação'), -- 2 ps5
	(6, 10, '2023-04-10', 'Correio', 100, 'Bloqueado'), -- 100 capas para celular
	(3, 1, '2023-05-02', 'Transportadora Veloz', 1, 'Entrega em andamento'), -- 1 impressora
	(4, 1, '2023-05-02', 'Transportadora Veloz', 2, 'Entrega em andamento'), -- 2 cartuchos
	(4, 2, '2023-06-10', 'Correio', 1, 'Entregue'); -- 1 cartucho
	
INSERT INTO Avaliacao(idProd, idCli, notaAval, comentAval, dataAval) VALUES -- ok
	(1, 1, 4.5, 'Ótimo computador! Rodou todos os programas que preciso!', '2023-01-20'),
	(2, 2, 3.0, 'Apresentou defeito em pouco tempo', '2023-02-25'),
	(3, 3, 5.0, NULL, '2023-03-15'),
	(4, 1, 3.0, 'Com pouco tempo de uso as impressões já estavam borrando', '2023-06-10'),
	(5, 4, 2.5, 'Celular travando desde o começo...não recomendo', '2023-04-08'),
	(6, 5, 5.0, 'Produto de alta qualidade', '2023-04-12'),
	(7, 6, 4.8, 'Comprei os mouses para colocar no meu setor de TI e minha equipe adorou!', '2023-04-02'),
	(8, 6, 3.6, NULL, '2023-04-02'),
	(9, 7, 0.0, 'Paguei caro, mas veio com defeito e encontrei dificuldades para entrar em contato com a fornecedora...', '2023-01-20'),
	(10, 8, 5.0, 'Dei de presente para os meus filhos e eles adoraram!!!', '2023-04-30');

-- Verificando as tabelas e os inserts
SELECT * FROM Fornecedor;
SELECT * FROM Categoria;
SELECT * FROM Produto;
SELECT * FROM Cliente;
SELECT * FROM Pedido;
SELECT * FROM Avaliacao;
