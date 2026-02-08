# Auth Service

Microsserviço responsável pela autenticação de usuários via JWT.

## Responsabilidades

- Registro de novos usuários.
- Login e emissão de JWT.
- Validação de tokens JWT.

## Requisitos

- Ruby 3.3+
- Rails 8.1+ (API Mode)
- PostgreSQL

## Instalação

1.  Instale as dependências:
    ```bash
    bundle install
    ```
2.  Prepare o banco de dados:
    ```bash
    rails db:create db:migrate
    ```

## Execução

Via Docker Compose (integrado ao projeto principal) ou:

```bash
rails server -p 3001
```

## Variáveis de Ambiente

| Variável       | Descrição                         | Default          |
| -------------- | --------------------------------- | ---------------- |
| `DATABASE_URL` | URL do banco de dados PostgreSQL  | `postgres://...` |
| `JWT_SECRET`   | Chave secreta para assinatura JWT | `secret`         |
| `RAILS_ENV`    | Ambiente Rails                    | `development`    |

## API Endpoints

### 1. `POST /auth/register`

Registra um novo usuário.

**Request:**

```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response (201):**

```json
{ "message": "User created successfully" }
```

### 2. `POST /auth/login`

Autentica um usuário e retorna um JWT.

**Request:**

```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response (200):**

```json
{ "token": "eyJhbGciOiJIUzI1NiJ9..." }
```

### 3. `POST /auth/verify`

Valida um token recebido.

**Request:**

```json
{ "token": "eyJhbGciOiJIUzI1NiJ9..." }
```

**Response (200):**

```json
{ "user_id": 1 }
```

## Testes

Para executar a suíte de testes:

```bash
bundle exec rspec
```
