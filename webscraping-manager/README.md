# Web Scraping Manager

Sistema principal responsável pelo gerenciamento de tarefas de scraping, interface com o usuário e orquestração dos serviços.

## Responsabilidades

- Interface Web para usuários (Login, Registro, Dashboard).
- Gerenciamento de Tarefas (Criar, Listar, Detalhes, Excluir).
- Comunicação com `auth-service` para autenticação.
- Comunicação com `notification-service` para eventos.
- Enfileiramento de jobs no Redis para o `processing-service`.

## Requisitos

- Ruby 3.2+
- Rails 7.1+
- PostgreSQL
- Redis

## Configuração e Instalação

O projeto é configurado para rodar via Docker Compose, mas para execução local standalone:

1.  Instale as dependências:
    ```bash
    bundle install
    ```
2.  Configure as variáveis de ambiente (veja `.env.example` ou use os defaults).
3.  Prepare o banco de dados:
    ```bash
    rails db:create db:migrate
    ```

## Execução com Docker

Na raiz do projeto (onde está o `docker-compose.yml`), execute:

```bash
docker-compose up --build
```

O serviço estará disponível em: `http://localhost:3000`

## Variáveis de Ambiente

| Variável                   | Descrição                                      | Default                            |
| -------------------------- | ---------------------------------------------- | ---------------------------------- |
| `DATABASE_URL`             | URL do banco de dados local da aplicação       | `postgres://...`                   |
| `WEBSCRAPING_DB_URL`       | URL do banco de dados compartilhado de tarefas | `postgres://...`                   |
| `AUTH_SERVICE_URL`         | URL do microsserviço de autenticação           | `http://auth-service:3000`         |
| `NOTIFICATION_SERVICE_URL` | URL do microsserviço de notificações           | `http://notification-service:3000` |
| `REDIS_URL`                | URL do Redis para Sidekiq                      | `redis://redis:6379/1`             |

## Testes

Para rodar a suíte de testes:

```bash
bundle exec rspec
```
