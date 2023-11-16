-- Criação das tabelas
CREATE TABLE Fornecedor( -- ok
	idForn SERIAL PRIMARY KEY, -- Considere colocar o campo 'idForn' como FK em outras tabelas para futuras funcionalidades
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
	precoProd DECIMAL(6,2) NOT NULL,
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
	idProd INT NOT NULL,
	idCli INT NOT NULL, 
	dataPed DATE NOT NULL,
	quantPed INT NOT NULL DEFAULT 1,
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
SELECT * FROM Categoria;
SELECT * FROM Produto;
SELECT * FROM Cliente;
SELECT * FROM Pedido;
SELECT * FROM Avaliacao;

-- Inserindo dados nas tabelas
INSERT INTO Fornecedor(nomeForn, cepForn, emailForn, foneForn, tipoForn) VALUES 
	('TecnoComputers Ltda.', '12345678', 'tecnocomputers@email.com', '123456789', 'J'),
	('MobileTech Solutions', '87654321', 'mobiletech@email.com', '987654321', 'J'),
	('Maria Rebeca', '11112222', 'mariarebeca@email.com', '555555555', 'F'),
	('House of Mario', '58054755', 'nintendomario@email.com', '656829475', 'J');

SELECT * FROM Fornecedor;

INSERT INTO Categoria(descCateg) VALUES 
	('Computadores & Notebooks'),
	('Celulares & Smartphones'),
	('Periféricos'),
	('Videogames');

SELECT * FROM Categoria;

INSERT INTO Produto(nomeProd, precoProd, quantProd, idCateg) VALUES 
	('Computador', 4999.99, 5, 1),
	('Smartphone', 999.99, 50, 2),
	('Mouse USB', 29.99, 1000, 3),
	('Teclado Wireless', 69.99, 200, 3),
	('Nintendo Switch',2010.00,10,4);

SELECT * FROM Produto;

INSERT INTO Cliente(nomeCli, cepCli, emailCli, foneCli, generoCli) VALUES 
	('João', '12345678', 'joao@email.com', '111111111', 'M'),
	('Maria', '87654321', 'maria@email.com', '222222222', 'F'),
	('Paula', '11112222', 'paula@email.com', '333333333', 'F'),
	('Marcos', '98345123', 'marcus@email.com', '88889999', 'M');

SELECT * FROM Cliente;

INSERT INTO Pedido(idProd, idCli, dataPed, quantPed, statusPed) VALUES 
	(1, 1, '2023-01-15', 1, 'Em andamento'),
	(2, 2, '2023-02-20', 2,  'Entregue'),
	(3, 3, '2023-03-10', 10,  'Em processamento'),
	(3, 3, '2023-03-10', 20,  'Em processamento'),
	(1, 3, '2023-01-15', 1,  'Entregue');
	
SELECT * FROM Pedido;

INSERT INTO Avaliacao(idProd, idCli, notaAval, comentAval, dataAval) VALUES 
	(1, 1, 4.5, 'Ótimo produto!', '2023-01-20'),
	(2, 2, 3.0, 'Apresentou defeito em pouco tempo', '2023-02-25'),
	(3, 3, 5.0, NULL, '2023-03-15');

SELECT * FROM Avaliacao;

-- a) ii. Consultas
		-- 1 consulta utilizando BETWEEN
		SELECT p.nomeProd, p.precoProd, p.quantProd -- Consulta para verificar os produtos da categoria 'Periféricos' custando entre 20 e 50 reais
		FROM Produto p
		JOIN Categoria c ON p.idCateg = c.idCateg
		WHERE c.descCateg = 'Periféricos' AND p.precoProd BETWEEN 20 AND 50
		ORDER BY p.precoProd;

		-- 3 consultas utilizando JOIN
		SELECT p.nomeProd, p.quantProd, p.precoProd, c.descCateg as categoria -- Verifica quais produtos estão na categoria 'Periféricos'
		FROM Produto p
		JOIN Categoria c ON p.idCateg = c.idCateg
		WHERE c.descCateg = 'Periféricos'
		ORDER BY p.precoProd;
		
		SELECT Pedido.idPed, Pedido.idCli, Pedido.dataPed, Pedido.valorProd, Pedido.statusPed -- Verifica todos os pedidos em andamento de um determinado cliente
		FROM Pedido
		JOIN Cliente ON Pedido.idCli = Cliente.idCli
		WHERE Cliente.nomeCli = 'João' AND Pedido.statusPed = 'Em andamento';

		SELECT f.nomeFornp, p.nomeProd, p.precoProd, p.quantProd -- Consulta para verificar todos os produtos de uma determinada fornecedora
		FROM Produto p
		JOIN Fornecedor f ON p.fabricante = f.nome
		WHERE f.idForn = 1;
		
		-- 1 consulta com LEFT JOIN
		SELECT p.idProd, p.nomeProd, p.precoProd, p.quantProd, c.descCateg -- Lista todos os produtos cadastrados na plataforma
		FROM Produto p
		LEFT JOIN Categoria c ON p.idCateg = c.idCateg;
		
		
		-- 2 consultas usando GROUP BY
		SELECT p.nomeProd, COUNT(pe.idPed) AS totalPedidos -- Retorna os produtos mais procurados da plataforma
		FROM Produto p
		JOIN Pedido pe ON p.idProd = pe.idProd
		GROUP BY p.idProd, p.nomeProd
		ORDER BY totalPedidos DESC
		LIMIT 1; -- Garante que apenas o produto com mais pedidos seja retornado
		
		
		-- 1 consulta usando UNION/EXCEPT/INTERSECT
		SELECT nomeCli, foneCli, emailCli -- Encontra clientes cadastrados na plataforma, mas que não fizerem nenhum pedido, com a finalidade de enviar ofertas
		FROM Cliente
		EXCEPT
		SELECT c.nomeCli, c.foneCli, c.emailCli
		FROM Cliente c
		JOIN Pedido P ON C.idCli = P.idCli;
				
		-- 2 subconsultas
		SELECT idProd, notaAval, comentAval, dataAval -- Subconsulta para verificar as avaliações positivas (acima de 4) com o propósito de recompensar os melhores fornecedores da plataforma
		FROM Avaliacao
		WHERE notaAval IN (SELECT notaAval FROM Avaliacao WHERE notaAval > 4);
		
		SELECT nomeCli, -- Levantamento da quantidade de pedidos por cliente cadastrado no sistema
    	(SELECT COUNT(idPed) FROM Pedido WHERE idCli = Cliente.idCli) AS totalPedidos
		FROM Cliente;
		
		SELECT idped AS Id_pedido, quantped AS Quantidade,
		(SELECT precoprod FROM Produto WHERE idprod = Pedido.idprod) AS Preço,
		quantped* (SELECT precoprod FROM Produto WHERE idprod = Pedido.idprod) AS total
		FROM Pedido; -- trás o valor total de cada pedido, baseado no preço do produto e a quantidade do pedido.
-- b) Views
	
	

	





select * from pedido;

DROP TABLE Avaliacao;
DROP TABLE Pedido;
DROP TABLE Produto;
DROP TABLE Categoria;
DROP TABLE Fornecedor;
DROP TABLE Cliente;


