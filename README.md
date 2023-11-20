# ClickShop - Documentação do Banco de Dados

## Descrição Geral

A ClickShop é uma plataforma de comércio eletrônico projetada para proporcionar uma experiência intuitiva e eficiente tanto para fornecedores quanto para clientes. A seguir, apresentamos uma visão geral das regras do negócio e das expectativas relacionadas à aplicação e ao banco de dados.

### Funcionalidades Principais

1. **Cadastro de Fornecedores:**
   - Os fornecedores podem registrar-se na plataforma, fornecendo informações essenciais sobre seus negócios.

2. **Gestão de Catálogo de Produtos:**
   - Os fornecedores têm a capacidade de atualizar regularmente o catálogo de produtos, organizando-os por categorias.

3. **Vitrine Virtual:**
   - Destaque de mercadorias dos fornecedores em uma vitrine virtual organizada por categorias.

4. **Exploração e Compra:**
   - Os clientes podem explorar produtos, adicionar itens aos seus pedidos e ajustar quantidades conforme necessário.

5. **Gestão de Estoque e Preços:**
   - Funcionalidades robustas para o gerenciamento de estoque e configuração de preços por parte dos fornecedores.

6. **Acompanhamento de Pedidos:**
   - Os clientes podem acompanhar o status de seus pedidos, desde a saída do produto até a entrega.

7. **Avaliações e Comentários:**
   - Incentivamos os clientes a compartilharem suas experiências por meio de avaliações, notas e comentários sobre os produtos adquiridos.

8. **Autenticidade de Avaliações:**
   - Garantimos a autenticidade das avaliações, exibindo um ícone de verificação para indicar que a compra foi efetuada.

## Requisitos Funcionais

### Para Fornecedores

1. **Registrar Produto:**
   - Permitir o registro de novos produtos, incluindo informações detalhadas e categorias associadas.

2. **Renovar Estoque:**
   - Facilitar a renovação de estoque, atualizando a quantidade disponível de produtos.

### Para Clientes

1. **Realizar Cadastro:**
   - Possibilitar que os clientes se cadastrem na plataforma, fornecendo informações pessoais básicas.

2. **Realizar Pedido:**
   - Permitir que os clientes selecionem produtos, ajustem quantidades e efetuem pedidos.

3. **Efetuar Pagamento:**
   - Oferecer métodos seguros para os clientes realizarem o pagamento de seus pedidos.

4. **Cancelar Pedido:**
   - Opção para os clientes cancelarem pedidos antes da entrega.

5. **Avaliar o Produto:**
   - Capacidade de os clientes avaliarem os produtos adquiridos e deixarem comentários.

## Feito:

### ✅ a. Criação e uso de objetos básicos:

 i. Tabelas e constraints (PK, FK, UNIQUE, campos que não podem ter valores nulos, checks de validação) de acordo com as regras de negócio do projeto.✅

 ii. 10 consultas variadas de acordo com requisitos da aplicação, com justificativa semântica e conforme critérios seguintes: ✅
- 1 consulta com uma tabela usando operadores básicos de filtro (e.g., IN,
between, is null, etc). ✅
- 3 consultas com inner JOIN na cláusula FROM (pode ser self join, caso o domínio indique esse uso).✅
- 1 consulta com left/right/full outer join na cláusula FROM ✅
- 2 consultas usando Group By (e possivelmente o having) ✅
- 1 consulta usando alguma operação de conjunto (union, except ou
intersect) ✅
- 2 consultas que usem subqueries. ✅

### ✅ b. Visões:
- 1 visão que permita inserção ✅
- 2 visões robustas (e.g., com vários joins) com justificativa semântica, de acordo com os requisitos da aplicação. ✅

### ✅ c. Índices:
- 3 índices para campos indicados com justificativa dentro do contexto das consultas formuladas na questão 3a.✅

### ✅ d. Reescrita de consultas 

- Identificar 2 exemplos de consultas dentro do contexto da aplicação (questão 2.a) que
possam e devam ser melhoradas. Reescrevê-las. Justificar a reescrita.
### ❌ e. Funções e procedures armazenadas:
- 1 função que use SUM, MAX, MIN, AVG ou COUNT
- 2 funções e 1 procedure com justificativa semântica, conforme os requisitos da aplicação
**Pelo menos uma função ou procedure deve ter tratamento de exceção** e 
**As funções desta seção não são as mesmas das funções de triggers**

### ⚠️ f. Triggers:
- 3 diferentes triggers com justificativa semântica, de acordo com os requisitos da aplicação. ⚠️ 2/3