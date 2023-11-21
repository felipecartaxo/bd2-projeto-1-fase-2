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
		
		SELECT pe.idPed as "Número do pedido", c.nomeCli as "Nome do cliente", pe.dataPed as "Data do pedido", p.precoProd as "Preço", pe.statusPed as "Status do pedido" -- Verifica todos os pedidos que foram ENTREGUES do cliente 'João'
		FROM Pedido pe
		JOIN Cliente c
		ON pe.idCli = c.idCli
		JOIN Produto p
		on p.idProd = pe.idProd
		WHERE c.nomeCli = 'João' AND pe.statusPed = 'Entregue';

		SELECT f.nomeForn, p.nomeProd, p.precoProd -- Consulta para verificar todos os produtos da fornecedora 'TecnoComputers Ltda.'
		FROM Produto p
		JOIN Fornecedor f
		ON p.idForn = f.idForn
		WHERE f.idForn = 1;
		
		-- 1 consulta com LEFT JOIN
		SELECT p.idProd AS "Número do produto", p.nomeProd AS "Nome do produto", p.precoProd AS "Preço do produto", p.quantProd AS "Quantidade em estoque", f.nomeForn AS "Nome do fornecedor", c.descCateg AS "Categoria" -- Lista todos os produtos cadastrados na plataforma
		FROM Produto p
		LEFT JOIN Categoria c ON p.idCateg = c.idCateg
		LEFT JOIN Fornecedor f ON f.idForn = p.idForn;
		
		SELECT pe.idPed as "Número do pedido", pe.dataPed as "Data do pedido", pe.tipoEntrega as "Tipo de envio", pe.quantPed as "Quantidade", pe.statusPed as "Situação do pedido", p.precoProd as "Preço", c.nomeCli as "Nome do cliente", c.emailCli as "Email do cliente", c.foneCli AS "Fone" -- Lista todos os pedidos feitos na plataforma
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
		
		SELECT p.idProd AS "Número do produto", p.nomeProd AS "Nome do produto", ROUND(AVG(A.notaAval), 2) AS "Nota média", a.comentAval AS "Comentário do cliente" -- Retorna a média de avaliações por produto
		FROM Produto p
		LEFT JOIN Avaliacao a ON p.idProd = a.idProd
		GROUP BY p.idProd, p.nomeProd, a.comentAval;
				
		-- 1 consulta usando UNION/EXCEPT/INTERSECT
		SELECT nomeCli AS "Nome do cliente", foneCli AS "Telefone do cliente", emailCli AS "Email do cliente" -- Encontra clientes cadastrados na plataforma, mas que não fizeram nenhum pedido (com a finalidade de, eventualmente, enviar ofertas
		FROM Cliente
		EXCEPT
		SELECT c.nomeCli, c.foneCli, c.emailCli
		FROM Cliente c
		JOIN Pedido P ON C.idCli = P.idCli;
				
		-- 2 subconsultas
		SELECT f.nomeForn AS "Nome do fornecedor", p.idProd AS "Número do produto", p.nomeProd AS "Nome do produto", (SELECT ROUND(AVG(a.notaAval), 2)
		FROM Avaliacao a
		WHERE a.idProd = p.idProd) AS Media -- Subconsulta para verificar os 5 produtos com as melhores avaliações (com o intuito de recompensar os respectivos fornecedores)
		FROM Produto p
		JOIN Fornecedor f ON p.idForn = f.idForn
		ORDER BY Media DESC
		LIMIT 5;
				
		SELECT nomeCli AS "Nome do Cliente", -- Levantamento da quantidade de pedidos por cliente cadastrado no sistema
    	(SELECT COUNT(idPed) FROM Pedido WHERE idCli = Cliente.idCli) AS "Número de pedidos"
		FROM Cliente
		ORDER BY "Número de pedidos" DESC;
		
		SELECT idped AS Id_pedido, quantped AS Quantidade,
		(SELECT precoprod FROM Produto WHERE idprod = Pedido.idprod) AS Preço,
		quantped* (SELECT precoprod FROM Produto WHERE idprod = Pedido.idprod) AS total
		FROM Pedido; -- Retorna o valor total de cada pedido, baseado no preço do produto e a quantidade do pedido
		
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
		
		-- View que exibe o levantamento de todos os pedidos realizados (entregues ou não)
		CREATE OR REPLACE VIEW NotaFiscal AS
		SELECT
				pe.idPed AS "Número do pedido",
				pe.dataPed AS "Data do pedido",
				c.nomeCli AS "Nome do cliente",
				c.emailCli AS "Email",
				pe.quantPed AS "Quantidade de itens",
				(p.precoProd * pe.quantPed) AS "Valor total"
		FROM Pedido pe
		JOIN Cliente c ON pe.idCli = c.idCli
		JOIN Produto p ON pe.idProd = p.idProd;
		
		SELECT * FROM NotaFiscal;
		DROP VIEW NotaFiscal;
	
		-- View que permita inserção
		
				
		-- c) Índices
		CREATE INDEX idx_idProdPedido ON Pedido(idProd); -- Frequentemente utilizado em consultas
		CREATE INDEX idx_idCliPedido ON Pedido(idCli); -- Frequentemente utilizado em consultas
		CREATE INDEX idx_quantPedido ON Pedido(quantPed); -- Muito utilizado em filtros
		CREATE INDEX idx_statusPedido ON Pedido(statusPed); -- Muito utilizado em filtros
		CREATE INDEX idx_descCateg ON Categoria(descCateg); -- Utilizado em filtros
		CREATE INDEX idx_precoProd ON Produto(precoProd); -- Também muito utilizado em filtros
		
		-- d) Reescrita de consultas
		
		/*
		SELECT f.nomeForn, p.nomeProd, p.precoProd, p.quantProd -- Consulta para verificar todos os produtos de uma determinada fornecedora
		FROM Produto p
		JOIN Fornecedor f
		ON p.idForn = f.idForn
		WHERE f.idForn = 1;
		
		Motivo: juntar duas tabelas que são consideravelmente grandes para pegar um nome não é uma boa estratégia
		*/
		
		SELECT
		(SELECT nomeForn FROM Fornecedor WHERE idForn = 1) AS nomeForn,
			p.nomeProd,
			p.precoProd,
			p.quantProd
		FROM Produto p
		WHERE p.idForn = (SELECT idForn FROM Fornecedor WHERE idForn = 1);
		
		/*
		SELECT 
			pe.idPed as "Número do pedido", 
			c.nomeCli as "Nome do cliente", 
			pe.dataPed as "Data do pedido", 
			p.precoProd as "Preço", 
			pe.statusPed as "Status do pedido" -- Verifica todos os pedidos que foram ENTREGUES de um determinado cliente
		FROM Pedido pe
		JOIN Cliente c
		ON pe.idCli = c.idCli
		JOIN Produto p
		on p.idProd = pe.idProd
		WHERE c.nomeCli = 'João' AND pe.statusPed = 'Entregue';
		
		versão piorada:
		SELECT -- Verifica todos os pedidos que foram ENTREGUES de um determinado cliente
			pe.idPed as "Número do pedido",
			(SELECT nomeCli FROM Cliente WHERE idCli = pe.idCli) as "Nome do cliente",
			pe.dataPed as "Data do pedido",
			(SELECT precoProd FROM Produto WHERE idProd = pe.idProd) as "Preço",
			pe.statusPed as "Status do pedido"
		FROM Pedido pe
		WHERE pe.statusPed = 'Entregue' AND pe.idCli = (SELECT idCli FROM Cliente WHERE nomeCli = 'João');
		*/
		
		
		/*
		SELECT
			nomeCli AS "Nome do Cliente",
			(SELECT COUNT(idPed) FROM Pedido WHERE idCli = Cliente.idCli) AS "Número de pedidos"
		FROM Cliente;

		--versão piorada
		SELECT
			c.nomeCli AS "Nome do Cliente",
			COUNT(p.idPed) AS "Número de pedidos"
		FROM Cliente c
		LEFT JOIN Pedido p ON c.idCli = p.idCli
		GROUP BY c.nomeCli;
		*/
		
		/*
		SELECT idped AS Id_pedido, quantped AS Quantidade,
		(SELECT precoprod FROM Produto WHERE idprod = Pedido.idprod) AS Preço,
		quantped* (SELECT precoprod FROM Produto WHERE idprod = Pedido.idprod) AS total
		FROM Pedido; -- traz o valor total de cada pedido, baseado no preço do produto e a quantidade do pedido
		
		Motivo: No exemplo de subquery, é feito mais duas consultas de select, podendo ser um potencial problema, caso a tabela fique maior
		*/
		
		SELECT
			p.idPed AS Id_pedido,
			p.quantPed AS Quantidade,
			pr.precoprod AS Preço,
			p.quantPed * pr.precoprod AS total
		FROM Pedido p
		JOIN Produto pr ON p.idProd = pr.idProd;

		-- e) Funções e procedures
		
		-- 2 Funções
		CREATE OR REPLACE FUNCTION calcular_valor_total(IN v_idPedido INT) -- Calcula o valor total de um determinado pedido passado como parâmetro
		RETURNS DECIMAL(10, 2) AS $$
			DECLARE
				v_valorTotal DECIMAL(10, 2);
			BEGIN
				SELECT SUM(pe.quantPed * pr.precoProd)
				INTO v_valorTotal
				FROM Pedido pe
				LEFT JOIN Produto pr ON pe.idProd = pr.idProd
				WHERE pe.idPed = v_idPedido;
				
				RAISE NOTICE 'Valor total do pedido = R$ %', v_valorTotal;
				RETURN v_valorTotal;
			END;
		$$ LANGUAGE plpgsql;

		SELECT calcular_valor_total(6);
		DROP FUNCTION calcular_valor_total;
		
		CREATE OR REPLACE FUNCTION calcular_frete(IN v_idPedido INT) -- Calcula a data estimada de entrega de um determinado pedido (de acordo com o tipo de entrega)
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

		-- 1 Função que use SUM, MAX, MIN, AVG ou COUNT
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

		-- 1 Procedure
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
		
			-- Verifica se o email está no padrão
			CREATE OR REPLACE FUNCTION ValidarEmail()
			RETURNS TRIGGER AS $$
			BEGIN
				IF TG_TABLE_NAME = 'Cliente' THEN
					-- Padrão:  (qualquer letra e numero) + @ + (qualquer letra e numero) + . + (qualquer letra e numero) 
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
			
			-- Verifica se a categoria que está sendo referenciada no produto existe na tabela categoria, caso não exista, irá criá-la
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
			
			-- Verifica se o estoque está dentro do pedido
			CREATE OR REPLACE FUNCTION verificar_estoque_trigger()
			RETURNS TRIGGER AS $$
			DECLARE
				v_quantidadeEstoque INT;
			BEGIN
				SELECT quantProd INTO v_quantidadeEstoque FROM Produto
				WHERE idProd = NEW.idProd;
				IF v_quantidadeEstoque >= NEW.quantPed THEN
					RETURN NEW;
				ELSE
					RAISE EXCEPTION 'Falta de estoque.';
					RETURN NULL;
				END IF;					
			END;
			$$ LANGUAGE plpgsql;
		
			CREATE TRIGGER trigger_verificar_estoque
			BEFORE INSERT OR UPDATE ON Pedido FOR EACH ROW
			EXECUTE FUNCTION verificar_estoque_trigger();
			
			INSERT INTO Pedido(idProd, idCli, dataPed, tipoEntrega, quantPed, statusPed) VALUES 
			(1, 1, '2023-01-15', 'Drone', 1000, 'Entregue');
			
			INSERT INTO Pedido(idProd, idCli, dataPed, tipoEntrega, quantPed, statusPed) VALUES 
			(1, 1, '2023-01-15', 'Drone', 1, 'Entregue');

SELECT * FROM ListaProdutos;
SELECT * FROM pedido;
SELECT * FROM PRODUTO;
SELECT * FROM categoria;

DROP VIEW ListaProdutos;
DROP TABLE Avaliacao;
DROP TABLE Pedido;
DROP TABLE Produto;
DROP TABLE Categoria;
DROP TABLE Fornecedor;
DROP TABLE Cliente;
DROP TYPE STATUS;
