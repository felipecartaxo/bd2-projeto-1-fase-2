-- Criação das tabelas
CREATE TYPE STATUS AS ENUM (
	'Perdido',
	'Cancelado',
	'Bloqueado',
	'Entregue',
	'Aguardando confirmação'
);
CREATE TABLE Fornecedor( -- ok
	idForn SERIAL PRIMARY KEY, -- Considere colocar o campo 'idForn' como FK em outras tabelas para futuras funcionalidades
	nomeForn VARCHAR(40) NOT NULL,
	cepForn CHAR(8) NOT NULL,
	emailForn VARCHAR(40) UNIQUE NOT NULL,
	foneForn VARCHAR(20) UNIQUE NOT NULL,
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
	(1, 1, '2023-01-15', 1, 'Entregue'),
	(2, 2, '2023-02-20', 2,  'Aguardando confirmação'),
	(3, 3, '2023-03-10', 10,  'Bloqueado'),
	(3, 3, '2023-03-10', 20,  'Bloqueado'),
	(1, 3, '2023-01-15', 1,  'Entregue');
	
SELECT * FROM Pedido;

INSERT INTO Avaliacao(idProd, idCli, notaAval, comentAval, dataAval) VALUES 
	(1, 1, 4.5, 'Ótimo produto!', '2023-01-20'),
	(2, 2, 3.0, 'Apresentou defeito em pouco tempo', '2023-02-25'),
	(3, 3, 5.0, NULL, '2023-03-15');

SELECT * FROM Avaliacao;

-- a) Consultas
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
		FROM Pedido; -- traz o valor total de cada pedido, baseado no preço do produto e a quantidade do pedido
		
		-- b) Views
		
		-- View para exibir dados de todos os pedidos em andamento (com a finalidade de acompanhar o fluxo de pedidos e, caso necessário, contatar a fornecedora/transportadora)
		CREATE OR REPLACE VIEW PedidosEmAndamento AS
		SELECT
				p.nomeProd AS "Nome do produto",
				c.nomeCli AS "Nome do cliente",
				(p.precoProd * pe.quantPed) AS "Valor total",
				pe.dataPed AS "Data do pedido",
				pe.quantPed AS "Quantidade de itens"
		FROM
				Pedido pe
		JOIN Produto p ON pe.idProd = p.idProd
		JOIN Cliente c ON pe.idCli = c.idCli
		WHERE
				pe.statusPed = 'Em andamento';
				
		SELECT * FROM PedidosEmAndamento;
		DROP VIEW PedidosEmAndamento;
		
		-- View para exibir dados sobre um pedido com avaliação negativa (visando recompensar o cliente com novas ofertas ou reembolso)
		CREATE OR REPLACE VIEW AvaliacoesNegativas AS
		SELECT
				a.idAval AS "Código da avaliação",
				a.dataAval AS "Data da avaliação",
				a.comentAval AS "Comentário",
				c.nomeCli AS "Nome do cliente",
				pe.idPed AS "Número do pedido",
				pe.dataPed AS "Data do pedido"
		FROM
				Avaliacao a
		JOIN Cliente c ON a.idCli = c.idCli
		JOIN Pedido pe ON a.idPed = pe.idPed -- Necessário setar um relacionamento entre 'Avaliacao' e 'Pedido'
		JOIN Produto p ON pe.idProd = p.idProd
		WHERE
				a.notaAval < 3; -- Considerei como negativa uma avaliação menor do que 3
		
		SELECT * FROM AvaliacoesNegativas;
		DROP VIEW AvaliacoesNegativas;
		
		-- View que exibe uma nota fiscal (várias informações do cliente, pedido e dos produtos)
		CREATE OR REPLACE VIEW NotaFiscal AS
		SELECT
				pe.idPed AS "Número do pedido",
				pe.dataPed AS "Data do pedido",
				c.nomeCli AS "Nome do cliente",
				c.emailCli AS "Email",
				pe.quantPed AS "Quantidade de itens",
				(p.precoProd * pe.quantPed) AS "Valor total"
		FROM
				Pedido pe
		JOIN Cliente c ON pe.idCli = c.idCli
		JOIN Produto p ON pe.idProd = p.idProd;
		
		SELECT * FROM NotaFiscal;
		DROP VIEW NotaFiscal;
	
		-- View para listar todos os produtos (e suas respectivas categorias), onde também é possível cadastrar novos itens pela própria view
		CREATE OR REPLACE VIEW ListaProdutos AS
		SELECT
				p.idProd AS "ID do Produto",
				p.nomeProd AS "Nome",
				p.precoProd AS "Preço",
				p.quantProd AS "Quantidade em estoque",
				c.descCateg AS "Categoria"
		FROM
				Produto p
		JOIN Categoria c ON p.idCateg = c.idCateg;
		
		SELECT * FROM ListaProdutos;
		DROP VIEW ListaProdutos;

		-- Exemplo de inserção na view NovosProdutosComCategoria
		INSERT INTO NovosProdutosComCategoria("Nome do Produto", "Preço do Produto", "Quantidade do Produto", "Categoria do Produto")
		VALUES
				('Novo Produto 1', 25.00, 5, 'Categoria A'),
				('Novo Produto 2', 35.00, 3, 'Categoria B');
		-- c) Índices
		CREATE INDEX idx_idProd ON Produto(idProd); -- Possui valores distintos e é constantemente utilizado com JOIN
		
		CREATE INDEX idx_descCateg ON Categoria(descCateg); -- Utilizado em filtros
		
		CREATE INDEX idx_precoProd ON Produto(precoProd); -- Também muito utilizado em filtros
		
		-- d) Reescrita de consultas
		-- ???
		
		-- e) Funções e procedures
			-- CREATE OR REPLACE FUNCTION calcular_frete()
			-- retornaria o dia estimado de entrega do pedido
			-- inserir a coluna "tipo_frete" na tabela "Pedido"
			-- "tipo_frete" poderia ser categorizado como A, B ou C
			-- daí cada tier teria um número x de dias para ser entregue
				
		-- f) Triggers
			CREATE OR REPLACE FUNCTION ValidarEmail()
			RETURNS TRIGGER AS $$
			BEGIN
				IF TG_TABLE_NAME = 'Cliente' THEN
					-- padrão :  (qualquer letra e numero) + @ + (qualquer letra e numero) + . + (qualquer letra e numero) 
					IF NEW.emailCli ~ E'^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,4}$' THEN
					RETURN NEW;
				ELSE
					RETURN NULL;
				END IF;
				ELSE
					IF NEW.emailForn ~ E'^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,4}$' THEN
					RETURN NEW;
				ELSE
					RETURN NULL;
				END IF;
				END IF;
			END;
			$$ LANGUAGE plpgsql;

			CREATE TRIGGER TriggerValidarEmail
			BEFORE INSERT OR UPDATE	ON Cliente, Fornecedor FOR EACH ROW
			EXECUTE FUNCTION ValidarEmail();
			
			--Verifica se a categoria que está sendo referenciada no produto existe na tabela categoria, caso não exista, irá criá-la
			CREATE OR REPLACE FUNCTION InsertViewCategoria()
			RETURNS TRIGGER AS $$
			DECLARE 
				new_idcateg INTEGER;
			BEGIN
				SELECT idcateg INTO new_idcateg FROM Categoria Ca
				WHERE Ca.desccateg = NEW."Categoria";
				IF NOT FOUND THEN
					INSERT INTO Categoria(desccateg)
					VALUES(NEW."Categoria") RETURNING idcateg INTO new_idcateg;
				END IF;
				INSERT INTO Produto(nomeProd, precoProd, quantProd, idCateg) 
				VALUES (NEW."Nome", NEW."Preço" ,NEW."Quantidade em estoque", new_idcateg);
				RETURN NEW;
			END;
			$$ LANGUAGE plpgsql;
				
			Create trigger InsListaProdutos
			Instead of insert on ListaProdutos for each row
			execute procedure InsertViewCategoria();
			
			insert into ListaProdutos( "Nome", "Preço", "Quantidade em estoque", "Categoria")
			values ('Fritadeira sem óleo', 70.00, 60, 'Eletrodomésticos');


select * from ListaProdutos;
select * from pedido;
SELECT * FROM PRODUTO;
select * from categoria;

DROP TABLE Avaliacao;
DROP TABLE Pedido;
DROP TABLE Produto;
DROP TABLE Categoria;
DROP TABLE Fornecedor;
DROP TABLE Cliente;
DROP TYPE STATUS;
