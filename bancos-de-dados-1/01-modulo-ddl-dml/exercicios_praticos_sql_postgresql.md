# GUIA DE EXERCÍCIOS PRÁTICOS EM SQL (POSTGRESQL)
## Roteiro Progressivo de 40 Comandos DDL e DML a Partir de um Banco Vazio

---

### 📌 ORIENTAÇÕES PEDAGÓGICAS PARA EXECUÇÃO:
1. Ambientes recomendados: pgAdmin 4, DBeaver ou terminal psql conectado a um banco PostgreSQL.
2. Estado Inicial: O banco de dados deve estar completamente vazio antes do início da atividade.
3. Sequência de Execução: Os comandos foram organizados de forma dependente e encadeada. Execute um a um na ordem apresentada.
4. Testes de Integridade: Alguns comandos foram projetados intencionalmente para falhar (indicados com aviso), permitindo observar o disparo de restrições de integridade referencial e checagem (CHECK).

---


---

## FASE 1: Definição de Esquema e Estruturas Físicas (DDL)

### Comando 01: Criar tabela CATEGORIA
Crie a tabela 'categoria' contendo os campos 'id_categoria' como SERIAL e chave primária, e 'nome' como VARCHAR(50) obrigatório e único.

```sql
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);
```

### Comando 02: Criar tabela CLIENTE
Crie a tabela 'cliente' com 'id_cliente' (SERIAL, PK), 'nome' (VARCHAR(100), NOT NULL), 'email' (VARCHAR(100), UNIQUE) e 'data_cadastro' (DATE com valor padrão a data atual).

```sql
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    data_cadastro DATE DEFAULT CURRENT_DATE
);
```

### Comando 03: Criar tabela PRODUTO
Crie a tabela 'produto' contendo 'id_produto' (SERIAL, PK), 'nome' (VARCHAR(100), NOT NULL), 'preco' (NUMERIC(10,2) maior que zero) e 'id_categoria' (INT) como Chave Estrangeira referente a 'categoria'.

```sql
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco NUMERIC(10,2) CHECK (preco > 0),
    id_categoria INT,
    CONSTRAINT fk_produto_categoria FOREIGN KEY (id_categoria)
        REFERENCES categoria(id_categoria)
);
```

### Comando 04: Criar tabela PEDIDO
Crie a tabela 'pedido' com 'id_pedido' (SERIAL, PK), 'id_cliente' (INT, NOT NULL, FK referente a cliente), 'data_pedido' (TIMESTAMP padrão NOW) e 'status' (VARCHAR(20) padrão 'Pendente').

```sql
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pendente',
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente)
        REFERENCES cliente(id_cliente)
);
```

### Comando 05: Criar tabela ITEM_PEDIDO
Crie a tabela de ligação 'item_pedido' com 'id_pedido' (FK), 'id_produto' (FK), 'quantidade' (INT > 0) e 'preco_unitario' (NUMERIC(10,2) NOT NULL). Defina a chave primária composta (id_pedido, id_produto).

```sql
CREATE TABLE item_pedido (
    id_pedido INT,
    id_produto INT,
    quantidade INT CHECK (quantidade > 0),
    preco_unitario NUMERIC(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
);
```

### Comando 06: Adicionar coluna na tabela CLIENTE
Altere a tabela 'cliente' adicionando a coluna 'telefone' do tipo VARCHAR(20).

```sql
ALTER TABLE cliente ADD COLUMN telefone VARCHAR(20);
```

### Comando 07: Adicionar coluna BOOLEAN com valor padrão
Altere a tabela 'cliente' adicionando a coluna 'ativo' do tipo BOOLEAN com valor padrão TRUE.

```sql
ALTER TABLE cliente ADD COLUMN ativo BOOLEAN DEFAULT TRUE;
```

### Comando 08: Adicionar restrição CHECK em tabela existente
Adicione uma restrição CHECK na tabela 'pedido' garantindo que o status seja apenas 'Pendente', 'Pago', 'Enviado' ou 'Cancelado'.

```sql
ALTER TABLE pedido ADD CONSTRAINT chk_status_pedido 
    CHECK (status IN ('Pendente', 'Pago', 'Enviado', 'Cancelado'));
```

### Comando 09: Criar tabela temporária de Auditoria
Crie a tabela 'temp_logs' contendo 'id_log' (SERIAL, PK), 'mensagem' (TEXT) e 'data_log' (TIMESTAMP).

```sql
CREATE TABLE temp_logs (
    id_log SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Comando 10: Alterar tipo de dado de coluna existente
Altere a coluna 'telefone' da tabela 'cliente' aumentando sua capacidade para VARCHAR(25).

```sql
ALTER TABLE cliente ALTER COLUMN telefone TYPE VARCHAR(25);
```

### Comando 11: Renomear coluna de tabela
Renomeie a coluna 'ativo' da tabela 'cliente' para 'situacao_ativa'.

```sql
ALTER TABLE cliente RENAME COLUMN ativo TO situacao_ativa;
```

### Comando 12: Criar tabela para teste de exclusão
Crie uma tabela auxiliar chamada 'rascunho_notas' com 'id' SERIAL e 'conteudo' TEXT.

```sql
CREATE TABLE rascunho_notas (
    id SERIAL PRIMARY KEY,
    conteudo TEXT
);
```

### Comando 13: Excluir tabela com DROP TABLE
Remova a tabela 'rascunho_notas' permanentemente do banco de dados.

```sql
DROP TABLE rascunho_notas;
```

### Comando 14: Criar índice de desempenho
Crie um índice chamado 'idx_cliente_email' na coluna 'email' da tabela 'cliente' para otimizar buscas.

```sql
CREATE INDEX idx_cliente_email ON cliente(email);
```

### Comando 15: Remover índice de desempenho
Exclua o índice 'idx_cliente_email' da tabela 'cliente' utilizando a instrução DROP INDEX.

```sql
DROP INDEX idx_cliente_email;
```


---

## FASE 2: Inserção Inicial de Dados (DML - INSERT)

### Comando 16: Inserir categorias em lote (Multi-row INSERT)
Insira 3 categorias ('Eletrônicos', 'Livros', 'Vestuário') em um único comando INSERT.

```sql
INSERT INTO categoria (nome) VALUES 
    ('Eletrônicos'),
    ('Livros'),
    ('Vestuário');
```

### Comando 17: Inserir categorias adicionais
Insira mais 2 categorias no banco de dados ('Alimentos' e 'Móveis').

```sql
INSERT INTO categoria (nome) VALUES 
    ('Alimentos'),
    ('Móveis');
```

### Comando 18: Inserir clientes com dados completos
Insira 4 clientes na tabela 'cliente' especificando nome, email e telefone.

```sql
INSERT INTO cliente (nome, email, telefone) VALUES 
    ('Ana Silva', 'ana.silva@email.com', '11988887777'),
    ('Bruno Costa', 'bruno.costa@email.com', '21977776666'),
    ('Carla Souza', 'carla.souza@email.com', '31966665555'),
    ('Daniel Oliveira', 'daniel.oliveira@email.com', '41955554444');
```

### Comando 19: Inserir clientes omitindo colunas opcionais
Insira 2 clientes sem informar o telefone, permitindo a gravação do valor NULL padrão.

```sql
INSERT INTO cliente (nome, email) VALUES 
    ('Eduardo Santos', 'eduardo.santos@email.com'),
    ('Fernanda Lima', 'fernanda.lima@email.com');
```

### Comando 20: Inserir produtos com chave estrangeira válida
Insira 5 produtos vinculando-os a categorias existentes através do 'id_categoria'.

```sql
INSERT INTO produto (nome, preco, id_categoria) VALUES 
    ('Smartphone X', 2500.00, 1),
    ('Notebook Pro', 4800.00, 1),
    ('Livro Banco de Dados I', 120.00, 2),
    ('Camiseta Algodão', 59.90, 3),
    ('Mesa de Escritório', 450.00, 5);
```

### Comando 21: Inserir produtos sem categoria (FK Nula)
Insira 2 produtos sem associar a nenhuma categoria (id_categoria nulo).

```sql
INSERT INTO produto (nome, preco, id_categoria) VALUES 
    ('Fone de Ouvido Genérico', 35.00, NULL),
    ('Luminária de Mesa', 89.00, NULL);
```

### Comando 22: Tentar inserir produto violando restrição CHECK (Teste de Erro)
Tente executar a inserção de um produto com preço negativo (-50.00) e observe a mensagem de erro da restrição CHECK.

```sql
-- Este comando DEVE falhar intencionalmente:
INSERT INTO produto (nome, preco, id_categoria) 
VALUES ('Produto Inválido', -50.00, 1);
```

### Comando 23: Inserir registros de pedidos
Insira 3 pedidos para clientes cadastrados utilizando o id_cliente correspondente.

```sql
INSERT INTO pedido (id_cliente, status) VALUES 
    (1, 'Pendente'),
    (2, 'Pendente'),
    (3, 'Pendente');
```

### Comando 24: Inserir itens do Pedido 1
Insira 2 itens para o pedido com id_pedido = 1 especificando produto, quantidade e preço unitário.

```sql
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES 
    (1, 1, 1, 2500.00),
    (1, 3, 2, 120.00);
```

### Comando 25: Inserir itens dos Pedidos 2 e 3
Insira itens de compra para os pedidos 2 e 3.

```sql
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES 
    (2, 2, 1, 4800.00),
    (3, 4, 3, 59.90);
```


---

## FASE 3: Atualização Condicional de Dados (DML - UPDATE)

### Comando 26: Atualizar campo individual com WHERE por Chave Primária
Atualize o telefone do cliente com id_cliente = 5 para '11911112222'.

```sql
UPDATE cliente 
SET telefone = '11911112222' 
WHERE id_cliente = 5;
```

### Comando 27: Atualizar preços em lote por categoria
Reajuste o preço de todos os produtos da categoria 1 ('Eletrônicos') em +10%.

```sql
UPDATE produto 
SET preco = preco * 1.10 
WHERE id_categoria = 1;
```

### Comando 28: Alterar status de pedido
Altere o status do pedido id_pedido = 1 de 'Pendente' para 'Pago'.

```sql
UPDATE pedido 
SET status = 'Pago' 
WHERE id_pedido = 1;
```

### Comando 29: Atualizar múltiplos pedidos
Altere o status do pedido id_pedido = 2 para 'Enviado'.

```sql
UPDATE pedido 
SET status = 'Enviado' 
WHERE id_pedido = 2;
```

### Comando 30: Atualizar múltiplas colunas simultaneamente
Atualize o email e a situação ativa da cliente 'Carla Souza' em uma única instrução UPDATE.

```sql
UPDATE cliente 
SET email = 'carla.nova@email.com', situacao_ativa = FALSE 
WHERE id_cliente = 3;
```

### Comando 31: Fixar preço específico de produto
Atualize o preço do produto 'Livro Banco de Dados I' para 99.90.

```sql
UPDATE produto 
SET preco = 99.90 
WHERE id_produto = 3;
```

### Comando 32: Tentar atualizar status com valor inválido (Teste de Erro)
Tente alterar o status do pedido 3 para 'Em Processamento' e observe o bloqueio pela restrição CHECK.

```sql
-- Este comando DEVE falhar intencionalmente:
UPDATE pedido 
SET status = 'Em Processamento' 
WHERE id_pedido = 3;
```


---

## FASE 4: Exclusão, Limpeza e Integridade Referencial (DML - DELETE / TRUNCATE)

### Comando 33: Tentar excluir categoria com produtos associados (Teste de Erro FK)
Tente excluir a categoria 'Eletrônicos' (id_categoria = 1) e observe o bloqueio por restrição de Chave Estrangeira.

```sql
-- Este comando DEVE falhar intencionalmente por integridade referencial:
DELETE FROM categoria WHERE id_categoria = 1;
```

### Comando 34: Excluir produto sem itens vinculados
Exclua o produto 'Luminária de Mesa' (id_produto = 7) que não está associado a nenhum pedido.

```sql
DELETE FROM produto WHERE id_produto = 7;
```

### Comando 35: Excluir cliente sem pedidos cadastrados
Exclua a cliente 'Fernanda Lima' (id_cliente = 6) que não possui nenhum registro de pedido.

```sql
DELETE FROM cliente WHERE id_cliente = 6;
```

### Comando 36: Excluir itens de um pedido antes do cancelamento
Exclua todos os itens associados ao pedido id_pedido = 3.

```sql
DELETE FROM item_pedido WHERE id_pedido = 3;
```

### Comando 37: Excluir pedido após remoção de dependências
Exclua o registro do pedido id_pedido = 3 da tabela 'pedido'.

```sql
DELETE FROM pedido WHERE id_pedido = 3;
```

### Comando 38: Popular tabela temporária de logs para teste de limpeza
Insira 3 registros na tabela 'temp_logs'.

```sql
INSERT INTO temp_logs (mensagem) VALUES 
    ('Log de teste 1'),
    ('Log de teste 2'),
    ('Log de teste 3');
```

### Comando 39: Esvaziar tabela rapidamente com TRUNCATE
Execute o comando TRUNCATE TABLE na tabela 'temp_logs' para remover todos os registros com alta performance.

```sql
TRUNCATE TABLE temp_logs;
```

### Comando 40: Remover tabela temporária de logs com DROP TABLE
Finalize a sessão removendo definitivamente a tabela 'temp_logs' do esquema.

```sql
DROP TABLE temp_logs;
```
