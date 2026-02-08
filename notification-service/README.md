# Notification Service

Microsserviço responsável por centralizar e registrar eventos do sistema como notificações.

## Responsabilidades

- Receber eventos de criação, conclusão e falha de tarefas.
- Armazenar histórico de notificações.
- (Futuro) Enviar e-mail ou push notifications.

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
rails server -p 3003
```

## Variáveis de Ambiente

| Variável       | Descrição                        | Default          |
| -------------- | -------------------------------- | ---------------- |
| `DATABASE_URL` | URL do banco de dados PostgreSQL | `postgres://...` |
| `RAILS_ENV`    | Ambiente Rails                   | `development`    |

## API Endpoints

### 1. `POST /notifications`

Cria uma nova notificação/evento.

**Request:**

```json
{
  "notification": {
    "event_type": "task_completed",
    "task_id": 123,
    "user_data": { "user_id": 1 },
    "data": { "brand": "Honda", "price": "R$ 50.000" }
  }
}
```

**Response (201):**

```json
{ "message": "Notification received" }
```

### Tipos de Eventos

| event_type       | Descrição                      |
| ---------------- | ------------------------------ |
| `task_created`   | Nova tarefa de scraping criada |
| `task_completed` | Tarefa finalizada com sucesso  |
| `task_failed`    | Tarefa falhou durante execução |

## Testes

Para executar a suíte de testes:

```bash
bundle exec rspec
```
