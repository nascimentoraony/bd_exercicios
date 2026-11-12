-- ============================================================================
-- SCRIPT DE SIMULAÇÃO DE CONSULTAS (DQL) - POSTGRESQL
-- Banco de Dados I - Carga Completa de Esquema e Dados Fictícios
-- ============================================================================
-- Cenário: Gestão Empresarial e E-Commerce
-- Permite simulações ricas de:
--   - Projeção e Seleção (SELECT ... WHERE)
--   - Operadores lógicos (AND, OR, NOT) e relacionais
--   - Filtros de padrão e faixa (LIKE, ILIKE, BETWEEN, IN, IS NULL)
--   - Ordenação (ORDER BY ASC/DESC, LIMIT, OFFSET)
--   - Funções de Agregação (COUNT, SUM, AVG, MIN, MAX)
--   - Agrupamento e Filtro de Grupos (GROUP BY, HAVING)
-- ============================================================================

-- 1. LIMPEZA PREVENTIVA DE TABELAS
DROP TABLE IF EXISTS item_pedido CASCADE;
DROP TABLE IF EXISTS pedido CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS categoria CASCADE;
DROP TABLE IF EXISTS funcionario CASCADE;
DROP TABLE IF EXISTS departamento CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;

-- ============================================================================
-- 2. CRIAÇÃO DAS TABELAS (DDL)
-- ============================================================================

-- Tabela: DEPARTAMENTO
CREATE TABLE departamento (
    id_departamento SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    sigla VARCHAR(10) NOT NULL,
    orcamento_anual NUMERIC(12,2) CHECK (orcamento_anual >= 0)
);

-- Tabela: FUNCIONARIO
CREATE TABLE funcionario (
    id_funcionario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    cargo VARCHAR(50) NOT NULL,
    salario NUMERIC(10,2) CHECK (salario > 0),
    data_admissao DATE NOT NULL,
    id_departamento INT REFERENCES departamento(id_departamento),
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela: CATEGORIA
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT
);

-- Tabela: PRODUTO
CREATE TABLE produto (
    id_produto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco_unitario NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),
    estoque_qtd INT NOT NULL DEFAULT 0 CHECK (estoque_qtd >= 0),
    id_categoria INT REFERENCES categoria(id_categoria),
    codigo_sku VARCHAR(30) UNIQUE,
    data_cadastro DATE DEFAULT CURRENT_DATE
);

-- Tabela: CLIENTE
CREATE TABLE cliente (
    id_cliente SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    estado CHAR(2) NOT NULL,
    pontos_fidelidade INT DEFAULT 0,
    data_nascimento DATE,
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela: PEDIDO
CREATE TABLE pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL REFERENCES cliente(id_cliente),
    id_funcionario_vendedor INT REFERENCES funcionario(id_funcionario),
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Pendente', 'Faturado', 'Enviado', 'Entregue', 'Cancelado')),
    valor_frete NUMERIC(8,2) DEFAULT 0.00 CHECK (valor_frete >= 0)
);

-- Tabela: ITEM_PEDIDO
CREATE TABLE item_pedido (
    id_pedido INT REFERENCES pedido(id_pedido) ON DELETE CASCADE,
    id_produto INT REFERENCES produto(id_produto),
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_venda NUMERIC(10,2) NOT NULL CHECK (preco_venda > 0),
    desconto_unitario NUMERIC(10,2) DEFAULT 0.00 CHECK (desconto_unitario >= 0),
    PRIMARY KEY (id_pedido, id_produto)
);

-- ============================================================================
-- 3. CARGA DE DADOS FICTÍCIOS (DML)
-- ============================================================================

-- Inserindo Departamentos
INSERT INTO departamento (nome, sigla, orcamento_anual) VALUES
('Tecnologia da Informação', 'TI', 350000.00),
('Vendas e Comercial', 'VEND', 500000.00),
('Marketing Digital', 'MKT', 180000.00),
('Recursos Humanos', 'RH', 120000.00),
('Logística e Operações', 'LOG', 280000.00);

-- Inserindo Funcionários
INSERT INTO funcionario (nome, cpf, cargo, salario, data_admissao, id_departamento, ativo) VALUES
('Carlos Eduardo Lima', '111.222.333-01', 'Desenvolvedor Pleno', 6500.00, '2023-01-15', 1, TRUE),
('Mariana Rocha Alencar', '222.333.444-02', 'Gerente de Vendas', 9200.00, '2021-06-10', 2, TRUE),
('Lucas Fernando Santos', '333.444.555-03', 'Consultor de Vendas', 3800.00, '2024-02-01', 2, TRUE),
('Beatriz Mendes Castro', '444.555.666-04', 'Analista de Marketing', 4500.00, '2023-08-20', 3, TRUE),
('Roberto Dias Oliveira', '555.666.777-05', 'Coordenador de Logística', 5800.00, '2022-04-12', 5, TRUE),
('Fernanda Silveira', '666.777.888-06', 'Analista de RH', 4200.00, '2024-05-15', 4, TRUE),
('Juliana Paes Fontes', '777.888.999-07', 'Consultora de Vendas', 3950.00, '2023-11-01', 2, TRUE),
('Thiago Henrique Ramos', '888.999.000-08', 'DBA PostgreSQL', 8500.00, '2022-09-01', 1, TRUE),
('Patrícia Gomes Neves', '999.000.111-09', 'Assistente Administrativo', 2600.00, '2025-01-10', 4, TRUE),
('Marcos Vinícius Prado', '000.111.222-10', 'Consultor de Vendas', 3800.00, '2024-07-22', 2, FALSE);

-- Inserindo Categorias
INSERT INTO categoria (nome, descricao) VALUES
('Hardware', 'Componentes e peças para montagem e upgrade'),
('Periféricos', 'Teclados, mouses, fones e acessórios de entrada/saída'),
('Smartphones', 'Aparelhos móveis e smart devices'),
('Monitores & Áudio', 'Telas de alta taxa de atualização e caixas acústicas'),
('Games & Consoles', 'Acessórios gamer e jogos digitais'),
('Redes & Conectividade', 'Roteadores, switches e adaptadores Wi-Fi');

-- Inserindo Produtos
INSERT INTO produto (nome, preco_unitario, estoque_qtd, id_categoria, codigo_sku, data_cadastro) VALUES
('Processador Ryzen 7 7800X3D', 2499.90, 25, 1, 'PROC-RYZ7-78', '2024-01-10'),
('Placa de Vídeo RTX 4070 12GB', 4199.00, 14, 1, 'GPU-RTX4070-12', '2024-02-15'),
('Memória RAM DDR5 32GB (2x16GB)', 789.90, 45, 1, 'RAM-DDR5-32G', '2024-03-01'),
('SSD NVMe 1TB Gen4 HighSpeed', 450.00, 80, 1, 'SSD-NVME-1TB', '2024-01-20'),
('Teclado Mecânico RGB Switch Blue', 289.90, 60, 2, 'TEC-MEC-RGB', '2024-04-05'),
('Mouse Gamer Sem Fio 16000 DPI', 199.90, 95, 2, 'MOU-GAM-SF', '2024-04-10'),
('Headset Gamer 7.1 Surround', 320.00, 40, 2, 'HDS-71-SUR', '2024-05-12'),
('Smartphone Galaxy S24 Ultra 256GB', 6299.00, 18, 3, 'CEL-S24U-256', '2024-06-01'),
('Smartphone iPhone 15 Pro 128GB', 6899.00, 12, 3, 'CEL-IP15P-128', '2024-06-15'),
('Monitor UltraWide 34 Pol 144Hz', 2150.00, 22, 4, 'MON-UW-34-144', '2024-02-28'),
('Monitor Gamer 24 Pol 165Hz IPS', 899.00, 50, 4, 'MON-24-165-IPS', '2024-03-15'),
('Cadeira Gamer Ergonômica', 950.00, 15, 2, 'CAD-GAM-ERG', '2024-05-01'),
('Roteador Wi-Fi 6 Gigabit Mesh', 399.00, 35, 6, 'ROT-WIFI6-MESH', '2024-07-08'),
('Webcam 4K Ultra HD Pro Stream', 420.00, 30, 2, 'CAM-4K-STREAM', '2024-08-01'),
('Controle Wireless Bluetooth', 249.90, 65, 5, 'CTR-WRL-BT', '2024-08-20');

-- Inserindo Clientes
INSERT INTO cliente (nome, email, cidade, estado, pontos_fidelidade, data_nascimento, ativo) VALUES
('Ana Clara Albuquerque', 'ana.albuquerque@gmail.com', 'São Paulo', 'SP', 350, '1995-03-12', TRUE),
('Bruno Matos Fonseca', 'bruno.fonseca@yahoo.com.br', 'Rio de Janeiro', 'RJ', 120, '1988-07-25', TRUE),
('Camila Rodrigues Diniz', 'camila.diniz@outlook.com', 'Belo Horizonte', 'MG', 680, '1992-11-04', TRUE),
('Danilo Barbosa Freitas', 'danilo.freitas@gmail.com', 'Curitiba', 'PR', 90, '2001-01-30', TRUE),
('Elaine Cristina Soares', 'elaine.soares@hotmail.com', 'São Paulo', 'SP', 1450, '1985-09-18', TRUE),
('Felipe Augusto Moreira', 'felipe.moreira@gmail.com', 'Porto Alegre', 'RS', 420, '1990-05-08', TRUE),
('Gabriela Torres Lima', 'gabi.torres@empresa.com.br', 'Florianópolis', 'SC', 890, '1997-12-14', TRUE),
('Henrique Vasconcelos', 'henrique.vasc@uol.com.br', 'Campinas', 'SP', 40, '1982-04-20', FALSE),
('Isabela Brandão Nogueira', 'isabela.nogueira@gmail.com', 'Belo Horizonte', 'MG', 510, '1999-08-09', TRUE),
('João Pedro Rezende', 'joao.rezende@gmail.com', 'Salvador', 'BA', 200, '2003-02-17', TRUE),
('Larissa Monteiro Cruz', 'larissa.cruz@yahoo.com.br', 'Goiânia', 'GO', 730, '1994-06-29', TRUE),
('Marcelo Pires Tavares', 'marcelo.tavares@gmail.com', 'Fortaleza', 'CE', 110, '1989-10-02', TRUE);

-- Inserindo Pedidos
INSERT INTO pedido (id_cliente, id_funcionario_vendedor, data_pedido, status, valor_frete) VALUES
(1, 3, '2024-09-01 10:15:00', 'Entregue', 25.00),
(2, 7, '2024-09-03 14:30:00', 'Entregue', 35.00),
(3, 3, '2024-09-05 09:20:00', 'Entregue', 0.00),
(5, 7, '2024-09-10 16:45:00', 'Entregue', 40.00),
(4, 3, '2024-09-15 11:10:00', 'Cancelado', 20.00),
(6, 7, '2024-09-18 17:05:00', 'Entregue', 15.00),
(7, 3, '2024-09-22 13:40:00', 'Entregue', 0.00),
(1, 7, '2024-10-02 15:25:00', 'Entregue', 18.00),
(9, 3, '2024-10-08 10:50:00', 'Faturado', 30.00),
(10, 7, '2024-10-14 18:15:00', 'Enviado', 22.00),
(11, 3, '2024-10-20 12:00:00', 'Pendente', 0.00),
(3, 7, '2024-10-25 14:10:00', 'Pendente', 19.50);

-- Inserindo Itens dos Pedidos
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_venda, desconto_unitario) VALUES
-- Pedido 1 (Ana Clara)
(1, 1, 1, 2499.90, 50.00),
(1, 3, 2, 789.90, 0.00),
-- Pedido 2 (Bruno Matos)
(2, 5, 1, 289.90, 10.00),
(2, 6, 1, 199.90, 0.00),
-- Pedido 3 (Camila Rodrigues)
(3, 2, 1, 4199.00, 100.00),
(3, 4, 2, 450.00, 20.00),
-- Pedido 4 (Elaine Cristina)
(4, 8, 1, 6299.00, 200.00),
-- Pedido 5 (Danilo - Cancelado)
(5, 7, 1, 320.00, 0.00),
-- Pedido 6 (Felipe Augusto)
(6, 10, 1, 2150.00, 50.00),
(6, 5, 1, 289.90, 0.00),
-- Pedido 7 (Gabriela Torres)
(7, 9, 1, 6899.00, 150.00),
(7, 6, 1, 199.90, 0.00),
-- Pedido 8 (Ana Clara - Segunda compra)
(8, 4, 1, 450.00, 0.00),
(8, 7, 1, 320.00, 15.00),
-- Pedido 9 (Isabela Brandão)
(9, 11, 1, 899.00, 30.00),
(9, 13, 1, 399.00, 0.00),
-- Pedido 10 (João Pedro)
(10, 15, 2, 249.90, 10.00),
-- Pedido 11 (Larissa Monteiro)
(11, 12, 1, 950.00, 50.00),
-- Pedido 12 (Camila Rodrigues - Segunda compra)
(12, 14, 1, 420.00, 20.00);
