-- Criação das tabelas
CREATE TABLE Fornecedor(
	idForn SERIAL PRIMARY KEY,
	nome VARCHAR(40) NOT NULL,
	cep CHAR(8) NOT NULL,
	email VARCHAR(40) UNIQUE NOT NULL,
	fone VARCHAR(20) NOT NULL,
	tipoPessoa CHAR(1) NOT NULL CHECK (tipoPessoa IN ('J', 'F'))
);

CREATE TABLE Categoria(
	idCateg SERIAL PRIMARY KEY,
	descCateg VARCHAR(40) NOT NULL
);

CREATE TABLE Produto(
	idProd SERIAL PRIMARY KEY,
	nome VARCHAR(40) NOT NULL,
	preco NUMERIC NOT NULL,
	quantEst INT NOT NULL,
	fabricante VARCHAR(40) NOT NULL,
	idCateg INT NOT NULL,
	idPedido INT, -- Um produto pode não estar associado a um pedido, logo pode ser null
	FOREIGN KEY (idCateg) REFERENCES Categoria(idCateg)
);

CREATE TABLE Pedido(
	idPedido SERIAL PRIMARY KEY,
	data DATE NOT NULL,
	quant INT NOT NULL,
	valor NUMERIC NOT NULL,
	situacao VARCHAR(40) NOT NULL, -- Estado atual do pedido (ex.: Se já foi entregue, se está a caminho, se foi coletado pela transportadora, etc...)
	idProd INT NOT NULL,
	FOREIGN KEY (idProd) REFERENCES Produto(idProd)
);

CREATE TABLE Cliente(
	idCliente SERIAL PRIMARY KEY,
	nome VARCHAR(40) NOT NULL,
	cep CHAR(8) NOT NULL,
	email VARCHAR(40) UNIQUE NOT NULL,
	fone VARCHAR(20) NOT NULL,
	genero CHAR(1) CHECK (genero IN ('M', 'F')), -- 'M' para masculino, 'F' para feminino
	idPedido INT, -- Permite clientes que ainda não fizeram pedidos
	FOREIGN KEY (idPedido) REFERENCES Pedido(idPedido)
);

CREATE TABLE Avaliacao(
	idProd INT NOT NULL,
	idCliente INT NOT NULL,
	nota NUMERIC,
	comentario VARCHAR(100),
	data DATE,
	PRIMARY KEY (idProd, idCliente),
	FOREIGN KEY (idProd) REFERENCES Produto(idProd),
	FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
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
		
		

