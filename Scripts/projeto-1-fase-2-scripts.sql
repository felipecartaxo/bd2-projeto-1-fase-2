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

INSERT INTO Categoria(descCateg) VALUES 
	('Computadores & Notebooks'),
	('Celulares & Smartphones'),
	('Periféricos'),
	('Videogames');

INSERT INTO Produto(nomeProd, precoProd, quantProd, idCateg, idForn) VALUES 
	('Computador', 4999.99, 5, 1, 1),
	('Smartphone', 999.99, 50, 2, 2),
	('Mouse USB', 29.99, 1000, 3, 3),
	('Teclado Wireless', 69.99, 200, 3, 3),
	('Nintendo Switch',2010.00,10, 4, 4);

INSERT INTO Cliente(nomeCli, cepCli, emailCli, foneCli, generoCli) VALUES 
	('João', '12345678', 'joao@email.com', '111111111', 'M'),
	('Maria', '87654321', 'maria@email.com', '222222222', 'F'),
	('Paula', '11112222', 'paula@email.com', '333333333', 'F'),
	('Marcos', '98345123', 'marcus@email.com', '88889999', 'M');

INSERT INTO Pedido(idProd, idCli, dataPed, tipoEntrega, quantPed, statusPed) VALUES 
	(1, 1, '2023-01-15', 'Drone', 1, 'Entregue'),
	(2, 2, '2023-02-20', 'Correio', 2,  'Aguardando confirmação'),
	(3, 3, '2023-03-10', 'Transportadora Veloz', 10,  'Bloqueado'),
	(3, 3, '2023-03-10', 'Transportadora Veloz', 20,  'Bloqueado'),
	(1, 3, '2023-01-15', 'Correio', 1, 'Entregue'),
	(3, 4, '2023-03-10', 'Transportadora Veloz', 20,  'Entrega em andamento'),
	(1, 4, '2023-01-15', 'Correio', 1, 'Entrega em andamento');
	
INSERT INTO Avaliacao(idProd, idCli, notaAval, comentAval, dataAval) VALUES 
	(1, 1, 4.5, 'Ótimo produto!', '2023-01-20'),
	(2, 2, 3.0, 'Apresentou defeito em pouco tempo', '2023-02-25'),
	(3, 3, 5.0, NULL, '2023-03-15');

SELECT * FROM Fornecedor;
SELECT * FROM Categoria;
SELECT * FROM Produto;
SELECT * FROM Cliente;
SELECT * FROM Pedido;
SELECT * FROM Avaliacao;

-- a) Consultas

		-- 1 consulta utilizando BETWEEN
		SELECT p.nomeProd, p.precoProd, p.quantProd -- Consulta para verificar os produtos da categoria 'Periféricos' custando entre 20 e 50 reais
		FROM Produto p
		JOIN Categoria c ON p.idCateg = c.idCateg
		WHERE c.descCateg = 'Periféricos' AND p.precoProd BETWEEN 20 AND 50
		ORDER BY p.precoProd;
		
		SELECT p.nomeProd as "Nome do produto", p.precoProd as "Preço", p.quantProd as "Quantidade em estoque", c.descCateg as "Categoria"-- Levantamente dos pedidos com "sobra" no estoque (para realização de queima de estoque na Black Friday)
		FROM Produto p
		join Categoria c
		on p.idCateg = c.idCateg
		WHERE quantProd BETWEEN 100 AND 1000;
		
		SELECT * -- Levantamentos dos pedidos realizados em Janeiro de 2023
		FROM Pedido
		WHERE dataPed BETWEEN '2023-01-01' AND '2023-01-31';

		-- 3 consultas utilizando JOIN
		SELECT p.nomeProd as "Nome do produto", p.precoProd as "Preço", c.descCateg as "Categoria", p.quantProd as "Quantidade em estoque" -- Verifica quais produtos estão na categoria 'Periféricos'
		FROM Produto p
		JOIN Categoria c ON p.idCateg = c.idCateg
		WHERE c.descCateg = 'Periféricos'
		ORDER BY p.precoProd;
		
		SELECT pe.idPed as "Número do pedido", c.nomeCli as "Nome do cliente", pe.dataPed as "Data do pedido", p.precoProd as "Preço", pe.statusPed as "Status do pedido" -- Verifica todos os pedidos que foram ENTREGUES de um determinado cliente
		FROM Pedido pe
		JOIN Cliente c
		ON pe.idCli = c.idCli
		JOIN Produto p
		on p.idProd = pe.idProd
		WHERE c.nomeCli = 'João' AND pe.statusPed = 'Entregue';

		SELECT f.nomeForn, p.nomeProd, p.precoProd, p.quantProd -- Consulta para verificar todos os produtos de uma determinada fornecedora
		FROM Produto p
		JOIN Fornecedor f
		ON p.idForn = f.idForn
		WHERE f.idForn = 1;
		
		-- 1 consulta com LEFT JOIN
		SELECT p.idProd AS "Número do produto", p.nomeProd AS "Nome do produto", p.precoProd AS "Preço do produto", p.quantProd AS "Quantidade em estoque", f.nomeForn AS "Nome do fornecedor", c.descCateg AS "Categoria" -- Lista todos os produtos cadastrados na plataforma
		FROM Produto p
		LEFT JOIN Categoria c ON p.idCateg = c.idCateg
		LEFT JOIN Fornecedor f ON f.idForn = p.idForn;
		
		SELECT pe.idPed as "Número do pedido", pe.dataPed as "Data do pedido", pe.tipoEntrega as "Tipo de envio", pe.quantPed as "Quantidade", pe.statusPed as "Situação do pedido", p.precoProd as "Preço", c.nomeCli as "Nome do cliente", c.emailCli as "Email do cliente", c.foneCli AS "Fone"-- Lista todos os pedidos feitos na plataforma
		FROM Pedido pe
		LEFT JOIN Produto p ON p.idProd = pe.idProd
		LEFT JOIN Cliente c ON pe.idCli = c.idCli;
		
		-- 2 consultas usando GROUP BY
		SELECT p.nomeProd AS "Nome do produto", p.precoProd AS "Preço do produto", COUNT(pe.idPed) AS totalPedidos -- Retorna os produtos mais procurados da plataforma
		FROM Produto p
		JOIN Pedido pe ON p.idProd = pe.idProd
		GROUP BY p.idProd, p.nomeProd
		ORDER BY totalPedidos DESC
		LIMIT 1; -- Garante que apenas o produto com mais pedidos seja retornado
		
		SELECT p.idProd AS "Número do produto", p.nomeProd AS "Nome do produto", ROUND(AVG(A.notaAval), 2)  AS "Nota média" -- Retorna a média de avaliações por produto
		FROM Produto p
		LEFT JOIN Avaliacao a ON p.idProd = a.idProd
		GROUP BY p.idProd, p.nomeProd;
				
		-- 1 consulta usando UNION/EXCEPT/INTERSECT
		SELECT nomeCli AS "Nome do cliente", foneCli AS "Telefone do cliente", emailCli AS "Email do cliente" -- Encontra clientes cadastrados na plataforma, mas que não fizeram nenhum pedido (com a finalidade de, eventualmente, enviar ofertas
		FROM Cliente
		EXCEPT
		SELECT c.nomeCli, c.foneCli, c.emailCli
		FROM Cliente c
		JOIN Pedido P ON C.idCli = P.idCli;
				
		-- 2 subconsultas
		SELECT f.nomeForn AS "Nome do fornecedor", p.idProd AS "Número do produto", p.nomeProd AS "Nome do produto", p.precoProd AS "Preço do produto", (SELECT ROUND(AVG(A.notaAval), 2) FROM Avaliacao A WHERE A.idProd = P.idProd) AS "Média das avaliações" -- Subconsulta para verificar os produtos com melhores avaliações (com o intuito de recompensar os respectivos fornecedores)
		FROM Produto p
		JOIN Fornecedor f ON p.idForn = f.idForn;
				
		SELECT nomeCli AS "Nome do Cliente", -- Levantamento da quantidade de pedidos por cliente cadastrado no sistema
    	(SELECT COUNT(idPed) FROM Pedido WHERE idCli = Cliente.idCli) AS "Número de pedidos"
		FROM Cliente;
		
		SELECT idped AS Id_pedido, quantped AS Quantidade,
		(SELECT precoprod FROM Produto WHERE idprod = Pedido.idprod) AS Preço,
		quantped* (SELECT precoprod FROM Produto WHERE idprod = Pedido.idprod) AS total
		FROM Pedido; -- traz o valor total de cada pedido, baseado no preço do produto e a quantidade do pedido
		
		-- b) Views
		
		-- View para exibir dados de todos os pedidos em andamento
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
				pe.statusPed = 'Entrega em andamento';
				
		SELECT * FROM PedidosEmAndamento;
		DROP VIEW PedidosEmAndamento;
		
		-- View para exibir dados sobre um produto com avaliação negativa (visando recompensar o cliente com novas ofertas ou reembolso)
		CREATE OR REPLACE VIEW AvaliacoesNegativas AS
		SELECT
				a.idAval AS "Código da avaliação",
				a.dataAval AS "Data da avaliação",
				a.comentAval AS "Comentário",
				c.nomeCli AS "Nome do cliente",
				p.nomeProd AS "Nome do produto"
		FROM
				Avaliacao a
		JOIN Cliente c ON a.idCli = c.idCli
		JOIN Produto p ON p.idProd = a.idProd
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
	
		-- View que permita inserção
		
				
		-- c) Índices
		CREATE INDEX idx_idProd ON Produto(idProd); -- Possui valores distintos e é constantemente utilizado com JOIN
		
		CREATE INDEX idx_descCateg ON Categoria(descCateg); -- Utilizado em filtros
		
		CREATE INDEX idx_precoProd ON Produto(precoProd); -- Também muito utilizado em filtros
		
		-- d) Reescrita de consultas
		-- ???
		
		-- e) Funções e procedures
		
		-- 2 Funções
		CREATE OR REPLACE FUNCTION calcular_frete(IN v_idPedido INT) -- Função para calcular a data estimada de entrega de um determinado pedido (de acordo com o tipo de entrega)
			RETURNS DATE AS $$
		DECLARE
				v_dataPedido DATE;
				v_tipoEntrega VARCHAR(20);
				v_tempoEstimado INT;
				v_dataEntrega DATE;
		BEGIN
				SELECT dataPed, tipoEntrega
				INTO v_dataPedido, v_tipoEntrega
				FROM Pedido
				WHERE idPed = v_idPedido;

				CASE v_tipoEntrega
						WHEN 'Correio' THEN
								v_tempoEstimado := 20;
						WHEN 'Transportadora Veloz' THEN
								v_tempoEstimado := 10;
						WHEN 'Drone' THEN
								v_tempoEstimado := 3;
						ELSE
								RAISE EXCEPTION 'Erro inesperado. Favor entrar em contato com os desenvolvedores.';
				END CASE;
				
			v_dataEntrega := v_dataPedido + v_tempoEstimado;
			
			RAISE NOTICE 'Seu pedido será entregue no dia %', v_dataEntrega;
			RETURN v_dataEntrega;
		END;
		$$ LANGUAGE plpgsql;

		SELECT calcular_frete(2);
		DROP FUNCTION calcular_frete;
		
		CREATE OR REPLACE FUNCTION verificar_estoque_disponivel(IN v_idProduto INT, IN v_quantidadePedida INT) -- Função para verificar se há disponibilidade de um determinado produto em estoque
			RETURNS BOOLEAN AS $$
		DECLARE
				v_quantidadeEstoque INT;
				v_estoqueDisponivel BOOLEAN;
		BEGIN
				SELECT quantProd
				INTO v_quantidadeEstoque
				FROM Produto
				WHERE idProd = v_idProduto;
				
				IF v_quantidadeEstoque >= v_quantidadePedida THEN
						v_estoqueDisponivel := TRUE;
						RAISE NOTICE 'É possível realizar o pedido';
						RAISE NOTICE 'Quantidade no estoque: %', v_quantidadeEstoque;
						RAISE NOTICE 'Quantidade solicitada: %', v_quantidadePedida;
				ELSE
						v_estoqueDisponivel := FALSE;
						RAISE EXCEPTION 'Não é possível realizar o pedido';
				END IF;

				RETURN v_estoqueDisponivel;
		END;
		$$ LANGUAGE plpgsql;
		
		SELECT verificar_estoque_disponivel(1, 10); -- false
		SELECT verificar_estoque_disponivel(4, 10); -- true
		DROP FUNCTION verificar_estoque_disponivel;
		
		-- 1 função que use SUM, MAX, MIN, AVG ou COUNT
		CREATE OR REPLACE FUNCTION quantidade_pedidos_cliente(IN v_idCliente INT) -- Calcula a quantidade total de pedidos de um determinado cliente
			RETURNS INT AS $$
			DECLARE
				v_quantidadePedidos INT;
				v_nomeCli Cliente.nomeCli%type;
			BEGIN
					SELECT COUNT(idPed)
					INTO v_quantidadePedidos
					FROM Pedido
					WHERE idCli = v_idCliente;
					
					SELECT nomeCli
					INTO v_nomeCli
					FROM Cliente
					WHERE idCli = v_idCliente;
					
					RAISE NOTICE 'O cliente % efetuou % pedidos', v_nomeCli, v_quantidadePedidos; 
					RETURN v_quantidadePedidos;
			END;
		$$ LANGUAGE plpgsql;
		
		SELECT quantidade_pedidos_cliente(4);
		SELECT quantidade_pedidos_cliente(2);

		DROP FUNCTION quantidade_pedidos_cliente;

		-- 1 procedure
		CREATE OR REPLACE PROCEDURE cancelar_pedido(IN v_idPedido INT)
			AS $$
				DECLARE
					v_idProduto INT;
					v_quantidadePedida INT;
				BEGIN
						IF NOT EXISTS (SELECT 1 FROM Pedido WHERE idPed = v_idPedido AND statusPed IN ('Aguardando confirmação', 'Entrega em andamento')) THEN -- Verificando se o pedido existe e está em um estado cancelável
								RAISE EXCEPTION 'Pedido não encontrado ou não pode ser cancelado.';
						END IF;

						SELECT idProd, quantPed -- Obtendo informações do pedido
						INTO v_idProduto, v_quantidadePedida
						FROM Pedido
						WHERE idPed = v_idPedido;

						UPDATE Pedido -- Atualizando o status do pedido para 'Cancelado'
						SET statusPed = 'Cancelado'
						WHERE idPed = v_idPedido;

						UPDATE Produto -- Atualizando a quantidade de produtos no estoque
						SET quantProd = quantProd + v_quantidadePedida
						WHERE idProd = v_idProduto;

						RAISE NOTICE 'Pedido cancelado com sucesso';
				END;
		$$ LANGUAGE plpgsql;

		CALL cancelar_pedido(7);
		DROP PROCEDURE cancelar_pedido;
		
		SELECT * FROM Pedido; -- Verifique se o produto foi setado como 'Cancelado'
		SELECT * FROM Produto; -- Verifique se a quantidade em estoque foi atualizada

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
