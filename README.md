# Vagas Públicas (Desafio Técnico)

Plataforma moderna para listagem e gerenciamento de vagas de emprego, construída com **Ruby on Rails 7 API** e **Nuxt 3**.

## 🚀 Tecnologias

Todo o projeto é containerizado com **Docker**, garantindo consistência entre ambientes de desenvolvimento e produção.

### Backend (API)

- **Ruby 3.3** + **Rails 7.2** (API Mode)
- **PostgreSQL 16** (Banco de dados)
- **JWT** (Autenticação segura)
- **Rspec/Minitest** (Testes automatizados)

### Frontend (Web)

- **Nuxt 3** (Vue 3 Framework)
- **Vuetify 3** (Component Library e Design System)
- **TypeScript** (Tipagem estática)
- **Pinia/Composables** (Gerenciamento de estado)

---

## 🛠️ Como Rodar o Projeto

Pré-requisitos: **Docker** e **Docker Compose** instalados.

1. **Clone o repositório:**

   ```bash
   git clone https://github.com/jaocastro/desafio-tecnico.git
   cd desafio-tecnico
   ```

2. **Inicie os containers:**
   Este comando irá construir as imagens e iniciar os serviços (API, Web e Database).

   ```bash
   docker-compose up --build
   ```

3. **Configure o Banco de Dados:**
   Em outro terminal, execute as migrações e popule o banco com dados iniciais:

   ```bash
   docker-compose run --rm api rails db:create db:migrate db:seed
   ```

   _O comando cria o banco, roda as migrações e executa o seed._

4. **Acesse a Aplicação:**
   - **Frontend**: [http://localhost:3001](http://localhost:3001)
   - **API**: [http://localhost:3000](http://localhost:3000)

---

## 🔐 Credenciais de Acesso

O seed cria um usuário administrador padrão para acesso à área restrita (`/admin`).

- **Email**: `admin@vagas.com`
- **Senha**: `123456`

---

## 📡 API Endpoints

A API segue os padrões RESTful. Abaixo estão os principais endpoints:

### Autenticação

- `POST /auth/login` - Retorna o token JWT.
- `GET /auth/me` - Retorna dados do usuário logado (requer token).

### Vagas (Jobs)

- `GET /jobs` - Lista vagas (público: apenas published; admin: todas).
  - Params: `page`, `per_page`, `q` (busca), `status` (filtro).
- `GET /jobs/:id` - Detalhes da vaga.
- `POST /jobs` - Criar vaga (requer token).
- `PUT /jobs/:id` - Atualizar vaga (requer token).
- `DELETE /jobs/:id` - Remover vaga (requer token).

### Exemplo de Request

**Criar Vaga (POST /jobs)**

```bash
curl -X POST http://localhost:3000/jobs \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <SEU_TOKEN_JWT>" \
  -d '{
    "job": {
      "title": "Desenvolvedor Full Stack Senior",
      "description": "Estamos buscando um desenvolvedor experiente em Rails e Vue...",
      "status": "draft",
      "employment_type": "full_time",
      "location": "Remoto"
    }
  }'
```

---

## 🧪 Desenvolvimento

### Comandos Úteis

- **Rodar Testes (Rails):**

  ```bash
  docker-compose run --rm api rails test
  ```

- **Acessar Console Rails:**

  ```bash
  docker-compose run --rm api rails console
  ```

- **Adicionar dependência (Gem):**
  Adicione ao Gemfile e rode:

  ```bash
  docker-compose run --rm api bundle install
  ```

- **Adicionar dependência (Npm):**
  ```bash
  docker-compose run --rm web npm install <package>
  ```
