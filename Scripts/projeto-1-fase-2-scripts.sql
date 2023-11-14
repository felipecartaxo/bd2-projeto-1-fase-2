-- Banco de Dados referente ao segundo projeto da disciplina de BD2, do curso de Sistemas para Internet, 3º período

-- Criando tabelas do banco
CREATE TABLE Fornecedor(
	idForn SERIAL NOT NULL,
	nome VARCHAR(40) NOT NULL,
	cep CHAR(8) NOT NULL,
	email VARCHAR(20) NOT NULL,
	fone VARCHAR(20) NOT NULL,
	tipo VARCHAR(8) NOT NULL -- acredito que o atributo 'tipo' se refira ao tipo de pessoa (jurídica ou física)
);

CREATE TABLE Produto(
	idProd SERIAL NOT NULL,
	nome VARCHAR(20) NOT NULL,
	preco NUMERIC NOT NULL,
	quantEst INT NOT NULL,
	fabricante VARCHAR(20) NOT NULL,
	idCateg INT NOT NULL,
	idPedido INT NOT NULL
);

CREATE TABLE Categoria(
	idCateg SERIAL NOT NULL,
	descCateg VARCHAR(20) NOT NULL
);

CREATE TABLE Pedido(
	idPedido SERIAL NOT NULL,
	data VARCHAR(10) NOT NULL,
	quant INT NOT NULL,
	valor NUMERIC NOT NULL,
	situacao VARCHAR(10) NOT NULL -- Estado atual do pedido (ex.: Se já foi entregue, se está a caminho, se foi coletado pela transportadora, etc...)
);

CREATE TABLE Cliente(
	idCliente SERIAL NOT NULL,
	nome VARCHAR(40) NOT NULL,
	cep CHAR(8) NOT NULL,
	email VARCHAR(20) NOT NULL,
	fone VARCHAR(20) NOT NULL,
	genero VARCHAR(9),
	idPedido INT NOT NULL
);

CREATE TABLE Avaliacao(
	idProd INT NOT NULL,
	idCliente INT NOT NULL,
	nota NUMERIC,
	comentario VARCHAR(100),
	data VARCHAR(10)
);

-- Configurando as constraints das tabelas
ALTER TABLE Fornecedor ADD CONSTRAINT pkForn PRIMARY KEY(idForn);
ALTER TABLE Produto ADD CONSTRAINT pkProd PRIMARY KEY(idProd);
ALTER TABLE Categoria ADD CONSTRAINT pkCateg PRIMARY KEY(idCateg);
ALTER TABLE Pedido ADD CONSTRAINT pkPedido PRIMARY KEY(idPedido);
ALTER TABLE Avaliacao ADD CONSTRAINT pkAvaliacao PRIMARY KEY(idProd, idCliente);

ALTER TABLE Categoria ADD CONSTRAINT fkCategoria FOREIGN KEY(idCateg) REFERENCES Categoria;
ALTER TABLE Pedido ADD CONSTRAINT fkPedido FOREIGN KEY(idPedido) REFERENCES Pedido;

-- Verificando as tabelas
SELECT * FROM Fornecedor;
SELECT * FROM Produto;
SELECT * FROM Categoria;
SELECT * FROM Pedido;
SELECT * FROM Cliente;
SELECT * FROM Avaliacao;

-- Populando as tabelas
