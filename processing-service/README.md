# Processing Service

Microsserviço responsável pelo processamento assíncrono de tarefas de web scraping.

## Responsabilidades

- Processar tarefas de scraping de forma assíncrona via Sidekiq.
- Coletar dados de anúncios da Webmotors (marca, modelo, preço).
- Armazenar resultados no banco de dados.
- Notificar o `notification-service` sobre conclusão ou falha.

## Requisitos

- Ruby 3.3+
- Rails 8.1+
- PostgreSQL
- Redis (para Sidekiq)

## Stack de Scraping

| Biblioteca   | Função           |
| ------------ | ---------------- |
| **HTTParty** | Requisições HTTP |
| **Nokogiri** | Parsing de HTML  |

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
# Servidor Rails (API)
rails server -p 3002

# Worker Sidekiq (em outro terminal)
bundle exec sidekiq
```

## Variáveis de Ambiente

| Variável                   | Descrição                              | Default                            |
| -------------------------- | -------------------------------------- | ---------------------------------- |
| `DATABASE_URL`             | URL do banco de dados                  | `postgres://...`                   |
| `REDIS_URL`                | URL do Redis para Sidekiq              | `redis://redis:6379/1`             |
| `NOTIFICATION_SERVICE_URL` | URL do microsserviço de notificações   | `http://notification-service:3000` |
| `PROXY_URL`                | Proxy residencial para bypass anti-bot | (opcional)                         |

## API Endpoints

### 1. `POST /scraping_tasks`

Cria uma nova tarefa de scraping.

**Body:**

```json
{
  "scraping_task": {
    "url": "https://www.webmotors.com.br/comprar/..."
  }
}
```

**Response (201):**

```json
{
  "id": 1,
  "url": "...",
  "status": "pending",
  "created_at": "..."
}
```

### 2. `GET /scraping_tasks/:id`

Retorna o status e resultado de uma tarefa.

**Response (200):**

```json
{
  "id": 1,
  "url": "...",
  "status": "completed",
  "result": { "brand": "Renault", "model": "Kwid", "price": "R$ 65.000" }
}
```

## Sobre Anti-Bot

O site Webmotors utiliza **PerimeterX** para proteção contra bots. Em ambientes de produção, é necessário configurar um **proxy residencial** via variável `PROXY_URL` para contornar o bloqueio.

## Testes

```bash
bundle exec rspec
```
