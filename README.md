# Web Scraping Challenge

Sistema de gerenciamento de tarefas de web scraping desenvolvido com arquitetura de microsserviços.

## Arquitetura

O projeto é composto por 4 microsserviços:

| Serviço                  | Descrição                           | Porta |
| ------------------------ | ----------------------------------- | ----- |
| **webscraping-manager**  | Sistema principal com interface web | 3000  |
| **auth-service**         | Autenticação via JWT                | 3001  |
| **processing-service**   | Processamento de scraping (Sidekiq) | 3002  |
| **notification-service** | Registro de eventos/notificações    | 3003  |

### Diagrama de Arquitetura

```
┌─────────────────────────────────────────────────────────────────────┐
│                         USUÁRIO (Browser)                           │
└─────────────────────────────────┬───────────────────────────────────┘
                                  │
                                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    WEBSCRAPING-MANAGER (:3000)                      │
│                  Interface Web + Orquestrador                       │
└───────┬─────────────────────┬───────────────────────┬───────────────┘
        │                     │                       │
        ▼                     ▼                       ▼
┌───────────────┐    ┌────────────────┐    ┌──────────────────┐
│ AUTH-SERVICE  │    │    REDIS       │    │  NOTIFICATION-   │
│   (:3001)     │    │   (Queue)      │    │  SERVICE (:3003) │
│  JWT Auth     │    └───────┬────────┘    │   Eventos        │
└───────────────┘            │             └──────────────────┘
                             ▼
               ┌──────────────────────────┐
               │  PROCESSING-SERVICE      │
               │       (:3002)            │
               │  Sidekiq + Scraper       │
               │  (Nokogiri + HTTParty)   │
               └────────────┬─────────────┘
                            │
                            ▼
               ┌──────────────────────────┐
               │     WEBMOTORS.COM.BR     │
               │    (Site Alvo)           │
               └──────────────────────────┘
```

## Stack Tecnológica

- **Ruby on Rails** - Framework principal
- **PostgreSQL** - Banco de dados
- **Redis** - Cache e filas (Sidekiq)
- **JWT** - Autenticação
- **Nokogiri + HTTParty** - Web scraping
- **Sidekiq** - Processamento assíncrono
- **Docker + Docker Compose** - Containerização

## Como Executar

### Subir todos os serviços:

```bash
docker compose up --build
```

### Acessar a aplicação:

- **Interface Web**: http://localhost:3000
- **API Auth**: http://localhost:3001
- **API Processing**: http://localhost:3002
- **API Notifications**: http://localhost:3003

## Serviços

### 1. Web Scraping Manager (Principal)

Interface web para gerenciamento de tarefas:

- Login e registro de usuários
- Criar, listar, visualizar e excluir tarefas
- Dashboard com status das tarefas

### 2. Auth Service

API de autenticação:

- `POST /auth/register` - Registrar usuário
- `POST /auth/login` - Login (retorna JWT)
- `POST /auth/verify` - Validar token

### 3. Processing Service

Serviço de scraping:

- Processa tarefas via Sidekiq
- Coleta dados de veículos (marca, modelo, preço)
- Usa Nokogiri + HTTParty

### 4. Notification Service

Registro de eventos:

- `POST /notifications` - Registrar evento
- Tipos: `task_created`, `task_completed`, `task_failed`

## Variáveis de Ambiente

| Variável                   | Descrição                    |
| -------------------------- | ---------------------------- |
| `DATABASE_URL`             | URL do PostgreSQL            |
| `REDIS_URL`                | URL do Redis                 |
| `AUTH_SERVICE_URL`         | URL do auth-service          |
| `NOTIFICATION_SERVICE_URL` | URL do notification-service  |
| `PROXY_URL`                | Proxy residencial (opcional) |

## Sobre Web Scraping

O site Webmotors utiliza **PerimeterX** para proteção anti-bot. Para uso em produção, configure um **proxy residencial** via `PROXY_URL`.

## Documentação Detalhada

Cada serviço possui seu próprio README com documentação específica:

- [webscraping-manager/README.md](./webscraping-manager/README.md)
- [auth-service/README.md](./auth-service/README.md)
- [processing-service/README.md](./processing-service/README.md)
- [notification-service/README.md](./notification-service/README.md)

## Testes

```bash
# Em cada serviço
bundle exec rspec
```
