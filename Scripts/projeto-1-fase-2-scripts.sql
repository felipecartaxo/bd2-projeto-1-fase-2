-- Criação das tabelas
CREATE TABLE Fornecedor( -- ok
	idForn SERIAL PRIMARY KEY,
	nomeForn VARCHAR(40) NOT NULL,
	cepForn CHAR(8) NOT NULL,
	emailForn VARCHAR(40) UNIQUE NOT NULL,
	foneForn VARCHAR(20) NOT NULL,
	tipoForn CHAR(1) NOT NULL CHECK (tipoForn IN ('J', 'F'))
);

CREATE TABLE Categoria( -- ok
	idCateg SERIAL PRIMARY KEY,
	descCateg VARCHAR(40) NOT NULL
);

CREATE TABLE Produto( -- ok
	idProd SERIAL PRIMARY KEY,
	nomeProd VARCHAR(40) NOT NULL,
	precoProd NUMERIC NOT NULL,
	quantProd INT NOT NULL DEFAULT 0,
	idCateg INT NOT NULL,
	FOREIGN KEY (idCateg) REFERENCES Categoria(idCateg)
);

CREATE TABLE Cliente( -- ok
	idCli SERIAL PRIMARY KEY,
	nomeCli VARCHAR(40) NOT NULL,
	cepCli CHAR(8) NOT NULL,
	emailCli VARCHAR(40) UNIQUE NOT NULL,
	foneCli VARCHAR(20) NOT NULL,
	generoCli CHAR(1) CHECK (generoCli IN ('M', 'F')) -- 'M' para masculino, 'F' para feminino
);

CREATE TABLE Pedido(
	idPed SERIAL PRIMARY KEY,
	idProd SERIAL NOT NULL,
	idCli SERIAL NOT NULL, 
	dataPed DATE NOT NULL,
	quantPed INT NOT NULL,
	valorPed DECIMAL(5, 2) NOT NULL,
	statusPed VARCHAR(40) NOT NULL, -- Estado atual do pedido (ex.: Se já foi entregue, se está a caminho, se foi coletado pela transportadora, etc...)
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

-- Verificando as tabelas
SELECT * FROM Fornecedor;
SELECT * FROM Produto;
SELECT * FROM Categoria;
SELECT * FROM Pedido;
SELECT * FROM Cliente;
SELECT * FROM Avaliacao;

-- Inserindo dados nas tabelas
INSERT INTO Fornecedor(nome, cep, email, fone, tipoPessoa) VALUES 
	('TecnoComputers Ltda.', '12345678', 'tecnocomputers@email.com', '123456789', 'J'),
	('MobileTech Solutions', '87654321', 'mobiletech@email.com', '987654321', 'J'),
	('Maria Rebeca', '11112222', 'mariarebeca@email.com', '555555555', 'F');
	
SELECT * FROM Fornecedor;

INSERT INTO Categoria(descCateg) VALUES 
	('Computadores & Notebooks'),
	('Celulares & Smartphones'),
	('Periféricos');
	
SELECT * FROM Categoria;

INSERT INTO Produto(nome, preco, quantEst, fabricante, idCateg, idPedido) VALUES 
	('Computador', 4999.99, 5, 'Pichau', 1, 1)
	('Smartphone', 999.99, 50, 'Apple', 2, 2),
	('Mouse USB', 29.99, 1000, 'HyperX', 3, 3),
	('Teclado Wireless', 69.99, 200, 'Logitech', 3, 3);
	
SELECT * FROM Produto;

INSERT INTO Pedido(data, quant, valor, situacao, idProd) VALUES 
	('2023-01-15', 1, 4999.99, 'Em andamento', 1),
	('2023-02-20', 2, 1999.99, 'Entregue', 2),
	('2023-03-10', 10, 299.99, 'Em processamento', 3);
	('2023-03-10', 20, 1399.99, 'Em processamento', 4);
	
SELECT * FROM Pedido;

INSERT INTO Cliente(nome, cep, email, fone, genero, idPedido) VALUES 
	('ClienteA', '12345678', 'clienteA@email.com', '111111111', 'M', 1),
	('ClienteB', '87654321', 'clienteB@email.com', '222222222', 'F', 2),
	('ClienteC', '11112222', 'clienteC@email.com', '333333333', 'M', NULL);
	
SELECT * FROM Cliente;

INSERT INTO Avaliacao(idProd, idCliente, nota, comentario, data) VALUES 
	(1, 1, 4.5, 'Ótimo produto!', '2023-01-20'),
	(2, 2, 3.0, 'Apresentou defeito em pouco tempo', '2023-02-25'),
	(3, 3, 5.0, NULL, '2023-03-15');


SELECT * FROM Avaliacao;

-- a) ii. Consultas
		-- 1 consulta utilizando BETWEEN
		SELECT p.nome, p.preco, p.quantEst, p.fabricante -- Consulta para verificar os produtos da categoria 'Moda' custando entre 20 e 100 reais
		FROM Produto p
		JOIN Categoria c ON p.idCateg = c.idCateg
		WHERE c.descCateg = 'Moda' AND p.preco BETWEEN 20 AND 100
		ORDER BY p.preco;

		-- 3 consultas utilizando JOIN
		SELECT p.idProd, p.nome, c.descCateg as categoria -- Consulta para verificar quais produtos estão na categoria 'Eletrônicos'
		FROM Produto p
		JOIN Categoria c ON p.idCateg = c.idCateg
		WHERE c.descCateg = 'Eletrônicos';
		
		SELECT p.nome, p.preco, p.quantEst, p.fabricante -- Consulta para verificar todos os produtos de uma determinada fornecedora
		FROM Produto p
		JOIN Fornecedor f ON p.fabricante = f.nome
		WHERE f.idForn = 1;
		
		-- falta mais uma com join :s
		
		-- 2 subconsultas
		SELECT * -- Subconsulta para verificar as avaliações positivas (acima de 4)
		FROM Avaliacao
		WHERE nota IN (SELECT nota FROM Avaliacao WHERE nota > 4);
		
		

