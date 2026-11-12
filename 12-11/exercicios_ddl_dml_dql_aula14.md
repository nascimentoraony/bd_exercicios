# 📝 Lista de Exercícios Práticos: DDL, DML e DQL (PostgreSQL)

Este repositório contém uma lista estruturada de 20 exercícios práticos progressivos para serem executados no PostgreSQL, baseados no esquema empresarial e de e-commerce carregado via `script_simulacao_consultas_postgresql.sql`.

---

## 📌 Orientações Gerais

1. **Pré-requisito:** Certifique-se de ter executado previamente o script de criação e carga de dados (`script_simulacao_consultas_postgresql.sql`).
2. **Ambiente Recomendado:** DBeaver Community, pgAdmin 4 ou cliente CLI `psql`.
3. **Organização:** Resolva as questões em ordem, pois algumas manipulações de dados e alterações estruturais dependem do estado estabelecido nos exercícios anteriores.

---

## 🏗️ Bloco 1: DDL — Definição e Evolução de Esquema

### Exercício 01: Criação de Nova Tabela com Chave Primária
Para expandir o modelo de compras e cadeia de suprimentos, crie uma tabela chamada `fornecedor` contendo os seguintes campos:
- `id_fornecedor`: SERIAL e Chave Primária (`PRIMARY KEY`).
- `razao_social`: VARCHAR(120), obrigatório (`NOT NULL`).
- `cnpj`: VARCHAR(14), obrigatório (`NOT NULL`) e único (`UNIQUE`).
- `cidade`: VARCHAR(60).

```sql
CREATE TABLE fornecedor (
    id_fornecedor SERIAL PRIMARY KEY,
    razao_social VARCHAR(120) NOT NULL,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    cidade VARCHAR(60)
);
```

---

### Exercício 02: Adição de Chave Estrangeira em Tabela Existente
Altere a estrutura da tabela `produto` para adicionar a coluna `id_fornecedor` (inteiro) e crie uma restrição de integridade referencial (`CONSTRAINT fk_produto_fornecedor`) apontando para a tabela `fornecedor`.

```sql
ALTER TABLE produto ADD COLUMN id_fornecedor INT;
ALTER TABLE produto ADD CONSTRAINT fk_produto_fornecedor 
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor);
```

---

### Exercício 03: Restrição de Domínio (CHECK)
Garanta, por meio de uma restrição `CHECK` na tabela `funcionario`, que nenhum salário cadastrado no banco de dados seja inferior a R$ 1.412,00 (piso nacional).

```sql
ALTER TABLE funcionario ADD CONSTRAINT chk_salario_minimo 
    CHECK (salario >= 1412.00);
```

---

### Exercício 04: Validação Estrutural de Texto (CHECK)
Adicione uma restrição à tabela `cliente` para assegurar que a coluna de unidade federativa (`uf`) possua rigorosamente 2 caracteres e seja armazenada em letras maiúsculas.

```sql
ALTER TABLE cliente ADD CONSTRAINT chk_cliente_uf 
    CHECK (LENGTH(uf) = 2 AND uf = UPPER(uf));
```

---

### Exercício 05: Criação de Índice para Otimização de Busca
Pensando no alto volume de pesquisas de catálogo no sistema, crie um índice na coluna `nome` da tabela `produto` para acelerar consultas textuais.

```sql
CREATE INDEX idx_produto_nome ON produto(nome);
```

---

### Exercício 06: Remoção de Coluna Obsoleta
A gestão do sistema decidiu descontinuar a coluna `descricao` da tabela `categoria`. Remova essa coluna da tabela de forma definitiva.

```sql
ALTER TABLE categoria DROP COLUMN descricao;
```

---

## ✍️ Bloco 2: DML — Manipulação e Manutenção de Dados

### Exercício 07: Inserção Múltipla de Registros (INSERT INTO)
Cadastre dois novos fornecedores na tabela `fornecedor`:
1. "Tech Distribuidora LTDA" (CNPJ: 11222333000199, São Paulo).
2. "Mobiliária do Sul S/A" (CNPJ: 44555666000188, Curitiba).

```sql
INSERT INTO fornecedor (razao_social, cnpj, cidade) VALUES
    ('Tech Distribuidora LTDA', '11222333000199', 'São Paulo'),
    ('Mobiliária do Sul S/A', '44555666000188', 'Curitiba');
```

---

### Exercício 08: Associação de Registros via Chave Estrangeira (UPDATE)
Associe todos os produtos da categoria 'Eletrônicos' (`id_categoria = 1`) ao fornecedor de código `id_fornecedor = 1`.

```sql
UPDATE produto 
SET id_fornecedor = 1 
WHERE id_categoria = 1;
```

---

### Exercício 09: Reajuste Salarial por Departamento (UPDATE Condicional)
Conceda um dissídio coletivo de **7,5%** no salário de todos os colaboradores alocados no departamento de 'Tecnologia da Informação' (sigla 'TI').

```sql
UPDATE funcionario 
SET salario = ROUND(salario * 1.075, 2) 
WHERE id_departamento = (SELECT id_departamento FROM departamento WHERE sigla = 'TI');
```

---

### Exercício 10: Atualização em Lote de Status de Pedidos
Altere o status de todos os pedidos realizados antes de **10 de Novembro de 2026** que ainda estejam com status 'Pendente' para 'Cancelado'.

```sql
UPDATE pedido 
SET status = 'Cancelado' 
WHERE data_pedido < '2026-11-10 00:00:00' 
  AND status = 'Pendente';
```

---

### Exercício 11: Controle e Baixa de Estoque (UPDATE)
Realize a baixa manual de 5 unidades no estoque físico do produto com identificador `id_produto = 3`.

```sql
UPDATE produto 
SET estoque = estoque - 5 
WHERE id_produto = 3;
```

---

### Exercício 12: Exclusão Segura Respeitando Integridade (DELETE)
Exclua do banco de dados o cliente chamado 'Eduardo Santos', garantindo que ele não possua nenhum registro histórico de pedidos vinculado antes da remoção.

```sql
DELETE FROM cliente 
WHERE nome = 'Eduardo Santos' 
  AND id_cliente NOT IN (SELECT DISTINCT id_cliente FROM pedido);
```

---

## 🔍 Bloco 3: DQL — Consultas, Filtros e Agrupamentos

### Exercício 13: Seleção e Ordenação com Projeção Específica
Exiba o nome, e-mail e salário de todos os funcionários, ordenando do maior para o menor salário. Para salários idênticos, ordene em ordem alfabética de nome.

```sql
SELECT nome, email, salario 
FROM funcionario 
ORDER BY salario DESC, nome ASC;
```

---

### Exercício 14: Filtro por Faixa de Valores e Padrão de Texto (BETWEEN e ILIKE)
Liste o nome e o preço de todos os produtos cujo preço esteja compreendido entre **R$ 50,00 e R$ 800,00** e cujo nome contenha o termo 'Mesa' ou 'Cadeira' (sem diferenciação de maiúsculas/minúsculas).

```sql
SELECT nome, preco 
FROM produto 
WHERE preco BETWEEN 50.00 AND 800.00 
  AND (nome ILIKE '%Mesa%' OR nome ILIKE '%Cadeira%');
```

---

### Exercício 15: Verificação de Conjunto e Nulos (IN e IS NOT NULL)
Selecione o nome, a cidade e a UF de todos os clientes que residem nos estados de São Paulo ('SP'), Rio de Janeiro ('RJ') ou Minas Gerais ('MG'), filtrando apenas aqueles que possuem a data de nascimento devidamente preenchida.

```sql
SELECT nome, cidade, uf 
FROM cliente 
WHERE uf IN ('SP', 'RJ', 'MG') 
  AND data_nascimento IS NOT NULL;
```

---

### Exercício 16: Métricas Estatísticas Globais
Calcule em uma única instrução SQL: a quantidade total de produtos cadastrados, o preço médio dos produtos, o menor preço e o maior preço registrado na loja.

```sql
SELECT 
    COUNT(*) AS total_produtos,
    ROUND(AVG(preco), 2) AS preco_medio,
    MIN(preco) AS menor_preco,
    MAX(preco) AS maior_preco
FROM produto;
```

---

### Exercício 17: Agrupamento por Categoria (GROUP BY)
Exiba o identificador da categoria (`id_categoria`), a soma total de itens em estoque e o preço médio dos produtos pertencentes a cada categoria.

```sql
SELECT 
    id_categoria, 
    SUM(estoque) AS estoque_total, 
    ROUND(AVG(preco), 2) AS preco_medio
FROM produto 
GROUP BY id_categoria 
ORDER BY id_categoria;
```

---

### Exercício 18: Filtragem de Grupos Agregados (HAVING)
Apresente o código do departamento e a média salarial dos funcionários, listando exclusivamente os departamentos cuja média de salário seja **superior a R$ 4.000,00**.

```sql
SELECT 
    id_departamento, 
    ROUND(AVG(salario), 2) AS media_salarial
FROM funcionario 
GROUP BY id_departamento 
HAVING AVG(salario) > 4000.00;
```

---

### Exercício 19: Cruzamento Relacional Básico (INNER JOIN)
Liste o número do pedido, o nome do cliente que realizou a compra, a data da operação e o valor total, exibindo apenas pedidos com status 'Pago' ou 'Enviado'. Ordene a listagem da data mais recente para a mais antiga.

```sql
SELECT 
    p.id_pedido, 
    c.nome AS nome_cliente, 
    p.data_pedido, 
    p.valor_total
FROM pedido p
INNER JOIN cliente c ON p.id_cliente = c.id_cliente
WHERE p.status IN ('Pago', 'Enviado')
ORDER BY p.data_pedido DESC;
```

---

### Exercício 20: Relatório Analítico de Vendas por Cliente (JOIN + GROUP BY)
Gere um relatório consolidado que apresente o nome de cada cliente, a quantidade total de pedidos finalizados e a soma do valor gasto no sistema (considerando apenas pedidos com status 'Pago'). Ordene os clientes do maior volume financeiro para o menor.

```sql
SELECT 
    c.nome AS cliente, 
    COUNT(p.id_pedido) AS total_pedidos,
    COALESCE(SUM(p.valor_total), 0.00) AS total_gasto
FROM cliente c
INNER JOIN pedido p ON c.id_cliente = p.id_cliente
WHERE p.status = 'Pago'
GROUP BY c.id_cliente, c.nome
ORDER BY total_gasto DESC;
```
