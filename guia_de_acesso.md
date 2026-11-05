# Guia de Acesso: PostgreSQL e pgAdmin 4

Instruções para conexão e uso do ambiente de banco de dados da disciplina.

---

## 1. Informações de Conexão

| Serviço | Endereço / Host | Porta | Base de Dados |
| :--- | :--- | :--- | :--- |
| **pgAdmin 4 (Interface Web)** | `http://141.94.20.16:8080` | `8080` | — |
| **PostgreSQL (Interno Docker)** | `postgres` | `5432` | `auladb` |
| **PostgreSQL (Acesso Externo)** | `141.94.20.16` | `5432` | `auladb` |

---

## 2. Passo a Passo para o Aluno

### Passo 1: Acessar o pgAdmin Web
1. Abra o navegador e acesse: [http://141.94.20.16:8080](http://141.94.20.16:8080)
2. Faça login com suas credenciais institucionais:
   * **Email / Username:** `nome.sobrenome@aula.com`
   * **Senha:** `primeironome` + `matrícula` *(em minúsculas, sem espaços ou acentos; ex.: `joao12345`)*

---

### Passo 2: Registrar o Servidor de Banco de Dados
1. Na barra lateral esquerda (**Explorador de Objeto**), clique com o botão direito em **Servers** > **Register** > **Server...** (ou no atalho **Adicionar Novo Servidor** no painel central).
2. Na aba **General (Geral)**:
   * **Name:** `Postgres - Aula`
3. Na aba **Connection (Ligação)**:
   * **Host name/address:** `postgres`
   * **Port:** `5432`
   * **Maintenance database:** `auladb`
   * **Username:** `seu.nome.sobrenome` *(sem o sufixo `@aula.com`)*
   * **Password:** sua senha *(primeironome + matrícula)*
   * Marque a opção **Save password? (Guardar palavra-passe?)**.
4. Clique em **Save (Guardar)**.

---

### Passo 3: Localizar o Schema Pessoal
1. No menu lateral, expanda a árvore:
   `Servers` > `Postgres - Aula` > `Databases` > `auladb` > `Schemas`
2. Localize o seu schema exclusivo (`seu_nome_sobrenome`).
3. O PostgreSQL está configurado para direcionar automaticamente suas consultas para o seu schema (`search_path`).

---

### Passo 4: Teste de Validação (Query Tool)
1. Clique com o botão direito sobre o banco `auladb` e selecione **Query Tool** (ou use o atalho `Alt + Shift + Q`).
2. Execute o script abaixo para validar permissões de escrita e consulta:

```sql
-- 1. Criação de tabela de teste
CREATE TABLE IF NOT EXISTS teste_validacao (
    id SERIAL PRIMARY KEY,
    mensagem TEXT NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Inserção de registro
INSERT INTO teste_validacao (mensagem) 
VALUES ('Ambiente conectado com sucesso!');

-- 3. Consulta de conferência
SELECT * FROM teste_validacao;
```

---

## 3. Regras de Isolamento e Boas Práticas

* **Isolamento de Dados:** Cada usuário possui permissões restritas ao seu próprio schema. Tentativas de consulta ou modificação em schemas de outros usuários serão recusadas pelo banco.
* **Schema Público (`public`):** A permissão de criação de novas tabelas no schema compartilhado foi desabilitada para evitar conflito de nomes.
* **Salvamento de Sessão:** Ao marcar a opção **Save password?**, o pgAdmin armazena com segurança a sessão no seu perfil, evitando solicitações repetidas de senha.
