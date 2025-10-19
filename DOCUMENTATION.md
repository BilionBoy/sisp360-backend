# SISP360 Backend - Documentação Completa

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Tecnologias Utilizadas](#tecnologias-utilizadas)
3. [Arquitetura do Sistema](#arquitetura-do-sistema)
4. [Configuração e Instalação](#configuração-e-instalação)
5. [Estrutura do Banco de Dados](#estrutura-do-banco-de-dados)
6. [Endpoints da API](#endpoints-da-api)
7. [Sistema de Notificações em Tempo Real](#sistema-de-notificações-em-tempo-real)
8. [Modelos e Relacionamentos](#modelos-e-relacionamentos)
9. [Serviços](#serviços)
10. [Otimizações de Performance](#otimizações-de-performance)
11. [Testes](#testes)
12. [Deploy e Produção](#deploy-e-produção)

---

## 🎯 Visão Geral

**SISP360** é um sistema de análise e gestão de crimes em Porto Velho, desenvolvido em **Ruby on Rails 7.2.2** como uma API RESTful. O sistema oferece funcionalidades para:

- **Registro e Gestão de Ocorrências Criminais**
- **Análise Estatística de Criminalidade por Bairro/Zona**
- **Indicadores Socioeconômicos**
- **Notificações em Tempo Real via WebSocket**
- **Sistema de Auditoria**
- **Pesquisas de Campo**

### Características Principais

- ✅ **API-Only**: Servidor backend puro sem views
- ✅ **PostgreSQL 17**: Banco de dados com extensões GIS
- ✅ **Action Cable**: WebSocket para notificações em tempo real
- ✅ **Paginação Otimizada**: Pagy com cache e contagem aproximada
- ✅ **Documentação Swagger**: API Docs interativa
- ✅ **Docker**: Containerização completa
- ✅ **Compressão Gzip**: Redução de 70-90% no payload

---

## 🛠️ Tecnologias Utilizadas

### Backend Framework
- **Ruby**: 3.3.0
- **Rails**: 7.2.2+
- **Puma**: Servidor HTTP de alta performance

### Banco de Dados
- **PostgreSQL**: 17 Alpine
- **Extensões**:
  - `pg_trgm`: Busca de texto fuzzy
  - `plpgsql`: Funções e triggers
  - Tipos ENUM customizados

### Gems Principais
```ruby
gem "rails", "~> 7.2.2"
gem "pg", "~> 1.5.9"              # PostgreSQL adapter
gem "puma", ">= 5.0"               # Web server
gem "rack-cors"                    # CORS handling
gem "ransack", "~> 4.1"            # Filtros e busca avançada
gem "pagy"                         # Paginação performática
gem "dotenv-rails"                 # Variáveis de ambiente
gem "rswag", "rswag-api", "rswag-ui", "rswag-specs"  # Swagger/OpenAPI
gem "bootsnap"                     # Reduz tempo de boot
```

### Ferramentas de Desenvolvimento
```ruby
gem "debug"                        # Debugger
gem "brakeman"                     # Análise de segurança
gem "rubocop-rails-omakase"        # Linting
gem "rspec-rails"                  # Testes
```

### Infraestrutura
- **Docker**: Containerização
- **Docker Compose**: Orquestração de serviços

---

## 🏗️ Arquitetura do Sistema

### Padrão MVC (Model-View-Controller)

```
sisp360-backend/
├── app/
│   ├── channels/              # WebSocket channels (Action Cable)
│   │   ├── application_cable/
│   │   └── notifications_channel.rb
│   ├── controllers/           # Controladores da API
│   │   ├── application_controller.rb
│   │   └── api/v1/            # API versão 1
│   │       ├── auditorias_controller.rb
│   │       ├── bairros_controller.rb
│   │       ├── complexos_habitacionais_controller.rb
│   │       ├── estatisticas_bairro_controller.rb
│   │       ├── indicadores_socioeconomicos_controller.rb
│   │       ├── notifications_controller.rb
│   │       ├── ocorrencias_controller.rb
│   │       ├── pesquisas_controller.rb
│   │       ├── tipos_crime_controller.rb
│   │       ├── usuarios_controller.rb
│   │       └── zonas_controller.rb
│   ├── models/                # Modelos Active Record
│   │   ├── application_record.rb
│   │   ├── agente.rb
│   │   ├── auditoria.rb
│   │   ├── bairro.rb
│   │   ├── complexo_habitacional.rb
│   │   ├── descricao.rb
│   │   ├── estatistica_bairro.rb
│   │   ├── indicador_socioeconomico.rb
│   │   ├── ocorrencia.rb
│   │   ├── pesquisa.rb
│   │   ├── tipo_crime.rb
│   │   ├── usuario.rb
│   │   └── viatura.rb
│   ├── services/              # Serviços de negócio
│   │   └── notifications_service.rb
│   ├── jobs/                  # Background jobs
│   └── mailers/               # Emails
├── config/                    # Configurações
│   ├── routes.rb              # Definição de rotas
│   ├── application.rb         # Config principal
│   ├── database.yml           # Config do banco
│   ├── cable.yml              # Config do Action Cable
│   └── environments/          # Config por ambiente
├── db/                        # Database
│   ├── migrate/               # Migrations
│   ├── schema.rb              # Schema do banco
│   └── seeds.rb               # Dados iniciais
├── lib/                       # Bibliotecas customizadas
├── spec/                      # Testes RSpec
├── swagger/                   # Documentação Swagger
└── public/                    # Arquivos estáticos
```

### Camadas da Aplicação

1. **Rotas** (`config/routes.rb`): Define endpoints HTTP
2. **Controllers** (`app/controllers/api/v1/`): Recebe requests, chama serviços, retorna JSON
3. **Models** (`app/models/`): Lógica de domínio e acesso ao banco
4. **Services** (`app/services/`): Lógica de negócio complexa
5. **Channels** (`app/channels/`): Comunicação WebSocket em tempo real

---

## ⚙️ Configuração e Instalação

### Pré-requisitos

- **Ruby** 3.3.0+
- **PostgreSQL** 17+ (ou Docker)
- **Bundler**

### Opção 1: Instalação Local

#### 1. Clone o Repositório
```bash
git clone <repository-url>
cd sisp360-backend
```

#### 2. Instale as Dependências
```bash
bundle install
```

#### 3. Configure o Banco de Dados

Copie o arquivo `.env.example` para `.env`:
```bash
cp .env.example .env
```

Edite `.env` e configure a variável `DATABASE_URL`:
```env
DATABASE_URL=postgres://usuario:senha@localhost:5432/crimes_porto_velho
RAILS_ENV=development
```

#### 4. Crie e Configure o Banco de Dados
```bash
rails db:create
rails db:migrate
rails db:seed  # (opcional) Popula dados iniciais
```

#### 5. Inicie o Servidor
```bash
rails server
# ou
rails s
```

Servidor disponível em: `http://localhost:3000`

### Opção 2: Instalação com Docker (Recomendado)

#### 1. Suba os Serviços
```bash
docker-compose up -d
```

Isso irá:
- Criar container PostgreSQL na porta `5432`
- Configurar banco de dados automaticamente
- Persistir dados em volume Docker

#### 2. Execute as Migrations (primeira vez)
```bash
docker-compose exec rails rails db:migrate
```

#### 3. Verifique o Status
```bash
docker-compose ps
```

### Variáveis de Ambiente

| Variável | Descrição | Exemplo |
|----------|-----------|---------|
| `DATABASE_URL` | URL de conexão PostgreSQL | `postgres://user:pass@host:port/db` |
| `RAILS_ENV` | Ambiente Rails | `development`, `production`, `test` |
| `SECRET_KEY_BASE` | Chave secreta (produção) | Gerado por `rails secret` |
| `RAILS_MAX_THREADS` | Threads máximas do Puma | `10` |
| `WEB_CONCURRENCY` | Workers do Puma | `2` |

---

## 🗄️ Estrutura do Banco de Dados

### Diagrama Entidade-Relacionamento

```
zonas (1) ─────┐
               │
               ├──< bairros (N)
               │       │
               │       ├──< complexos_habitacionais (N)
               │       │       │
               │       │       └──< pesquisas (N)
               │       │
               │       ├──< estatisticas_bairro (N)
               │       ├──< indicadores_socioeconomicos (N)
               │       └──< ocorrencias (N)
               │               │
               └───────────────┘
                               │
tipos_crime (1) ───────────────┘

usuarios (1) ──< auditoria (N)
```

### Tabelas Principais

#### 1. **zonas**
Divisão administrativa de Porto Velho.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_zona` | Serial (PK) | ID único |
| `nome_zona` | String(50) | Nome da zona |
| `area_km2` | Decimal | Área em km² |
| `populacao_estimada` | Integer | População estimada |
| `latitude_centro`, `longitude_centro` | Decimal | Coordenadas do centro |

#### 2. **bairros**
Bairros vinculados a zonas.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_bairro` | Serial (PK) | ID único |
| `nome_bairro` | String(100) | Nome do bairro |
| `id_zona` | Integer (FK) | Referência a zona |
| `codigo_ibge` | String(20) | Código IBGE |
| `populacao` | Integer | População do bairro |
| `area_km2` | Decimal | Área em km² |
| `densidade_populacional` | Virtual | `populacao / area_km2` |
| `latitude`, `longitude` | Decimal | Coordenadas |
| `status_bairro` | Enum | `Oficial`, `Não Oficial`, `Em Processo` |

**Índices**: GIN espacial, nome, zona, coordenadas

#### 3. **ocorrencias**
Registros de crimes.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_ocorrencia` | BigInt (PK) | ID único |
| `numero_bo` | String(50) | Boletim de Ocorrência (único) |
| `id_tipo_crime` | Integer (FK) | Tipo de crime |
| `id_bairro` | Integer (FK) | Bairro da ocorrência |
| `data_ocorrencia` | Date | Data do crime |
| `hora_ocorrencia` | Time | Hora do crime |
| `dia_semana` | Enum | Segunda, Terça, ..., Domingo |
| `periodo_dia` | Enum | Madrugada, Manhã, Tarde, Noite |
| `latitude_ocorrencia`, `longitude_ocorrencia` | Decimal | Coordenadas |
| `logradouro` | String(255) | Endereço |
| `descricao_ocorrencia` | Text | Descrição detalhada |
| `vitimas` | Integer | Número de vítimas |
| `valor_prejuizo` | Decimal | Valor do prejuízo |
| `status_ocorrencia` | Enum | `Registrada`, `Em Investigação`, `Resolvida`, `Arquivada` |
| `origem_registro` | Enum | `PM`, `PC`, `Sistema Integrado`, `Outro` |

**Índices**: Full-text search (português), GIN espacial, datas, bairro+data, tipo+data

#### 4. **tipos_crime**
Categorização de crimes.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_tipo_crime` | Serial (PK) | ID único |
| `codigo_senasp` | String(20) | Código SENASP (único) |
| `nome_crime` | String(100) | Nome do crime |
| `categoria` | Enum | `CVP`, `CVLI`, `Outros` |
| `gravidade` | Enum | `Baixa`, `Média`, `Alta`, `Altíssima` |
| `ativo` | Boolean | Se o tipo está ativo |

#### 5. **estatisticas_bairro**
Estatísticas mensais por bairro.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_estatistica` | Serial (PK) | ID único |
| `id_bairro` | Integer (FK) | Referência ao bairro |
| `ano`, `mes` | Integer | Período de referência |
| `total_ocorrencias` | Integer | Total de crimes |
| `total_crimes_cvp` | Integer | Crimes contra o patrimônio |
| `taxa_criminalidade_100k` | Decimal | Taxa por 100k habitantes |
| `ranking_bairro` | Integer | Posição no ranking |

**Unique**: `id_bairro`, `ano`, `mes`

#### 6. **indicadores_socioeconomicos**
Indicadores socioeconômicos por bairro.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_indicador` | Serial (PK) | ID único |
| `id_bairro` | Integer (FK) | Referência ao bairro |
| `ano_referencia` | Integer | Ano de referência |
| `indice_socioeconomico` | Decimal(4,2) | Índice geral (0-10) |
| `renda_media_mensal` | Decimal | Renda média |
| `taxa_desemprego` | Decimal(5,2) | Percentual de desemprego |
| `percentual_ensino_superior` | Decimal(5,2) | % com ensino superior |
| `iluminacao_publica` | Decimal(4,2) | Índice (0-10) |
| `presenca_policial` | Decimal(4,2) | Índice (0-10) |

**Constraints**: Índices entre 0 e 10

#### 7. **complexos_habitacionais**
Condomínios e conjuntos habitacionais.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_complexo` | Serial (PK) | ID único |
| `nome_complexo` | String(150) | Nome |
| `tipo_complexo` | Enum | `Condomínio Privado`, `Conjunto Habitacional Popular`, `Residencial Minha Casa Minha Vida` |
| `id_bairro` | Integer (FK) | Bairro |
| `numero_unidades` | Integer | Número de unidades |
| `populacao_estimada` | Integer | População estimada |
| `possui_seguranca` | Boolean | Tem segurança? |

#### 8. **pesquisas**
Pesquisas de campo com moradores.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_pesquisa` | Serial (PK) | ID único |
| `id_complexo` | Integer (FK, nullable) | Complexo habitacional |
| `id_bairro` | Integer (FK) | Bairro |
| `data_pesquisa` | Date | Data da pesquisa |
| `escolaridade` | Enum | Nível de escolaridade |
| `faixa_renda` | Enum | Faixa de renda |
| `interesse_mudanca` | Boolean | Deseja se mudar? |

#### 9. **usuarios**
Usuários do sistema.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_usuario` | Serial (PK) | ID único |
| `nome_completo` | String(150) | Nome |
| `cpf` | String(14) | CPF (único) |
| `email` | String(100) | Email (único) |
| `senha_hash` | String(255) | Hash da senha |
| `tipo_usuario` | Enum | `Admin`, `Analista`, `Operador`, `Consulta` |
| `orgao` | String(100) | Órgão vinculado |
| `ativo` | Boolean | Usuário ativo? |

#### 10. **auditoria**
Logs de auditoria.

| Coluna | Tipo | Descrição |
|--------|------|-----------|
| `id_auditoria` | BigInt (PK) | ID único |
| `id_usuario` | Integer (FK, nullable) | Usuário que executou |
| `acao` | String(100) | Ação realizada |
| `tabela_afetada` | String(50) | Tabela modificada |
| `id_registro_afetado` | Integer | ID do registro |
| `dados_anteriores`, `dados_novos` | JSONB | Snapshot dos dados |
| `ip_origem` | Inet | IP de origem |
| `user_agent` | Text | User agent |

**Índices**: GIN em `dados_novos`, usuário, tabela, data

### Tipos ENUM Customizados

```sql
tipo_categoria_crime: ["CVP", "CVLI", "Outros"]
tipo_complexo: ["Condomínio Privado", "Conjunto Habitacional Popular", "Residencial Minha Casa Minha Vida"]
tipo_dia_semana: ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"]
tipo_escolaridade: ["Fundamental Incompleto", "Fundamental Completo", "Médio Incompleto", "Médio Completo", "Superior Incompleto", "Superior Completo", "Pós-graduação"]
tipo_faixa_renda: ["Até 1 SM", "1-3 SM", "3-6 SM", "6-9 SM", "Acima de 9 SM"]
tipo_gravidade: ["Baixa", "Média", "Alta", "Altíssima"]
tipo_origem_registro: ["PM", "PC", "Sistema Integrado", "Outro"]
tipo_periodo_dia: ["Madrugada", "Manhã", "Tarde", "Noite"]
tipo_status_bairro: ["Oficial", "Não Oficial", "Em Processo"]
tipo_status_ocorrencia: ["Registrada", "Em Investigação", "Resolvida", "Arquivada"]
tipo_usuario: ["Admin", "Analista", "Operador", "Consulta"]
```

---

## 🌐 Endpoints da API

Base URL: `http://localhost:3000/api/v1`

### 1. Auditorias

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/auditorias` | Lista auditorias |
| `GET` | `/api/v1/auditorias/:id` | Detalhes de auditoria |
| `POST` | `/api/v1/auditorias` | Cria auditoria |

### 2. Bairros

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/bairros` | Lista bairros |
| `GET` | `/api/v1/bairros/:id` | Detalhes do bairro |
| `POST` | `/api/v1/bairros` | Cria bairro |
| `PATCH/PUT` | `/api/v1/bairros/:id` | Atualiza bairro |
| `DELETE` | `/api/v1/bairros/:id` | Remove bairro |

**Filtros**: `?nome_bairro=X`, `?id_zona=Y`

### 3. Complexos Habitacionais

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/complexos_habitacionais` | Lista complexos |
| `GET` | `/api/v1/complexos_habitacionais/:id` | Detalhes do complexo |
| `POST` | `/api/v1/complexos_habitacionais` | Cria complexo |
| `PATCH/PUT` | `/api/v1/complexos_habitacionais/:id` | Atualiza complexo |
| `DELETE` | `/api/v1/complexos_habitacionais/:id` | Remove complexo |

### 4. Estatísticas de Bairro

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/estatisticas_bairro` | Lista estatísticas |
| `GET` | `/api/v1/estatisticas_bairro/:id` | Detalhes da estatística |

**Filtros**: `?id_bairro=X`, `?ano=2024`, `?mes=1`

### 5. Indicadores Socioeconômicos

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/indicadores_socioeconomicos` | Lista indicadores |
| `GET` | `/api/v1/indicadores_socioeconomicos/:id` | Detalhes do indicador |
| `POST` | `/api/v1/indicadores_socioeconomicos` | Cria indicador |
| `PATCH/PUT` | `/api/v1/indicadores_socioeconomicos/:id` | Atualiza indicador |

### 6. Ocorrências (Principal)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/ocorrencias` | Lista ocorrências |
| `GET` | `/api/v1/ocorrencias/:id` | Detalhes da ocorrência |
| `POST` | `/api/v1/ocorrencias` | Cria ocorrência |
| `PATCH/PUT` | `/api/v1/ocorrencias/:id` | Atualiza ocorrência |
| `DELETE` | `/api/v1/ocorrencias/:id` | Remove ocorrência |

**Paginação**: `?page=1&items=25` (max: 5000)

**Filtros**:
- `?numero_bo=12345/2024`
- `?id_tipo_crime=1`
- `?id_bairro=5`
- `?data_ocorrencia=2024-01-15`
- `?periodo_dia=Noite`
- `?status_ocorrencia=Registrada`

**Exemplo de Resposta**:
```json
{
  "current_page": 1,
  "per_page": 25,
  "total_pages": 40,
  "total_count": 1000,
  "ocorrencias": [
    {
      "id_ocorrencia": 1,
      "numero_bo": "12345/2024",
      "id_tipo_crime": 3,
      "id_bairro": 10,
      "data_ocorrencia": "2024-01-15",
      "hora_ocorrencia": "22:30:00",
      "dia_semana": "Segunda",
      "periodo_dia": "Noite",
      "latitude_ocorrencia": -8.76,
      "longitude_ocorrencia": -63.9,
      "status_ocorrencia": "Registrada",
      "vitimas": 1,
      "recuperado": false
    }
  ]
}
```

### 7. Pesquisas

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/pesquisas` | Lista pesquisas |
| `GET` | `/api/v1/pesquisas/:id` | Detalhes da pesquisa |
| `POST` | `/api/v1/pesquisas` | Cria pesquisa |

### 8. Tipos de Crime

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/tipos_crime` | Lista tipos |
| `GET` | `/api/v1/tipos_crime/:id` | Detalhes do tipo |
| `POST` | `/api/v1/tipos_crime` | Cria tipo |
| `PATCH/PUT` | `/api/v1/tipos_crime/:id` | Atualiza tipo |

### 9. Usuários

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/usuarios` | Lista usuários |
| `GET` | `/api/v1/usuarios/:id` | Detalhes do usuário |
| `POST` | `/api/v1/usuarios` | Cria usuário |
| `PATCH/PUT` | `/api/v1/usuarios/:id` | Atualiza usuário |

### 10. Zonas

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/api/v1/zonas` | Lista zonas |
| `GET` | `/api/v1/zonas/:id` | Detalhes da zona |
| `POST` | `/api/v1/zonas` | Cria zona |

### 11. Notificações (WebSocket)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/api/v1/notifications/broadcast` | Envia notificação customizada |
| `POST` | `/api/v1/notifications/sistema` | Envia notificação de sistema |
| `POST` | `/api/v1/notifications/test` | Envia notificação de teste |
| `GET` | `/api/v1/notifications/status` | Status do Action Cable |

**Exemplo - Broadcast para Dispositivos Específicos**:
```bash
POST /api/v1/notifications/broadcast
Content-Type: application/json

{
  "type": "alert",
  "title": "Alerta de Segurança",
  "message": "Nova ocorrência registrada na Zona Sul",
  "device_types": ["web", "mobile"],
  "data": {
    "ocorrencia_id": 123,
    "bairro": "Centro"
  }
}
```

**Exemplo - Notificação de Sistema**:
```bash
POST /api/v1/notifications/sistema
Content-Type: application/json

{
  "message": "Manutenção programada para 02:00",
  "level": "warning"
}
```

### 12. Utilitários

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/up` | Health check |
| `GET` | `/api-docs` | Swagger UI |
| `WS` | `/cable` | WebSocket endpoint |

---

## 🔔 Sistema de Notificações em Tempo Real

### Arquitetura WebSocket (Action Cable)

O sistema utiliza **Action Cable** para comunicação bidirecional em tempo real.

#### Canais de Transmissão

1. **Canal Geral**: `notifications`
   - Todas as notificações são transmitidas aqui

2. **Canal por Tipo de Dispositivo**: `notifications:{device_type}`
   - Exemplos: `notifications:web`, `notifications:mobile`, `notifications:tablet`

3. **Canal por Dispositivo Individual**: `notifications:device:{device_id}`
   - Para notificações direcionadas a um dispositivo específico

4. **Canal por Usuário**: `notifications:user:{user_id}` (futuro)
   - Para notificações personalizadas por usuário

#### Conexão do Cliente

**JavaScript (Web)**:
```javascript
import { createConsumer } from "@rails/actioncable"

const cable = createConsumer("ws://localhost:3000/cable")

const subscription = cable.subscriptions.create(
  {
    channel: "NotificationsChannel",
    device_type: "web",
    device_id: "unique-device-id-12345"
  },
  {
    connected() {
      console.log("Conectado ao canal de notificações")
    },

    disconnected() {
      console.log("Desconectado do canal")
    },

    received(data) {
      console.log("Notificação recebida:", data)

      switch(data.type) {
        case "ocorrencia_criada":
          exibirAlerta(`Nova ocorrência: ${data.data.numero_bo}`)
          break
        case "sistema":
          exibirNotificacaoSistema(data.message, data.level)
          break
      }
    }
  }
)

// Enviar ping
subscription.ping({ message: "hello" })
```

#### Tipos de Notificações

| Tipo | Descrição | Dados |
|------|-----------|-------|
| `ocorrencia_criada` | Nova ocorrência registrada | `id`, `numero_bo`, `status`, `tipo_crime_id`, `bairro_id`, `data_ocorrencia`, `latitude`, `longitude` |
| `ocorrencia_atualizada` | Ocorrência modificada | `id`, `numero_bo`, `status`, `changes` |
| `ocorrencia_finalizada` | Ocorrência resolvida | `id`, `numero_bo`, `status`, `data_ocorrencia` |
| `ocorrencia_removida` | Ocorrência deletada | `id`, `numero_bo` |
| `sistema` | Notificação do sistema | `message`, `level` (info/warning/error) |
| `custom` | Notificação customizada | Definido pelo usuário |

#### Exemplo de Payload Recebido

```json
{
  "type": "ocorrencia_criada",
  "title": "Nova Ocorrência Registrada",
  "message": "Ocorrência #12345/2024 foi registrada",
  "data": {
    "id": 123,
    "numero_bo": "12345/2024",
    "status": "Registrada",
    "tipo_crime_id": 5,
    "bairro_id": 10,
    "data_ocorrencia": "2024-10-19",
    "latitude": -8.7611,
    "longitude": -63.9004
  },
  "timestamp": "2024-10-19T14:30:00.000Z"
}
```

#### NotificationsService (app/services/notifications_service.rb:1)

Centraliza toda lógica de envio de notificações:

**Métodos Principais**:

```ruby
# Broadcast de criação de ocorrência
NotificationsService.broadcast_ocorrencia_criada(ocorrencia)

# Broadcast de atualização
NotificationsService.broadcast_ocorrencia_atualizada(ocorrencia, changes)

# Broadcast de finalização
NotificationsService.broadcast_ocorrencia_finalizada(ocorrencia)

# Broadcast de remoção
NotificationsService.broadcast_ocorrencia_removida(ocorrencia_id, numero_bo)

# Notificação customizada
NotificationsService.broadcast_custom(
  type: :alert,
  title: "Alerta",
  message: "Mensagem",
  data: {}
)

# Notificação de sistema
NotificationsService.broadcast_sistema(
  message: "Servidor em manutenção",
  level: "warning"
)

# Enviar para dispositivos específicos
NotificationsService.broadcast_to_devices(
  device_types: ["web", "mobile"],
  type: :alert,
  title: "Título",
  message: "Mensagem"
)

# Apenas para web
NotificationsService.broadcast_to_web(...)

# Apenas para mobile
NotificationsService.broadcast_to_mobile(...)

# Para dispositivo específico
NotificationsService.broadcast_to_device_id(
  device_id: "abc-123",
  type: :custom,
  title: "Título",
  message: "Mensagem"
)

# Para usuário específico (futuro)
NotificationsService.broadcast_to_user(
  user_id: 42,
  ...
)
```

#### Integração Automática

O sistema envia notificações automaticamente quando:

1. **Ocorrência criada** (`POST /api/v1/ocorrencias`)
2. **Ocorrência atualizada** (`PATCH /api/v1/ocorrencias/:id`)
   - Detecta mudanças de status (ex: Registrada → Resolvida)
3. **Ocorrência removida** (`DELETE /api/v1/ocorrencias/:id`)

---

## 📦 Modelos e Relacionamentos

### Active Record Models

#### Relacionamentos

```ruby
# Zona
class Zona < ApplicationRecord
  has_many :bairros, foreign_key: "id_zona"
end

# Bairro
class Bairro < ApplicationRecord
  belongs_to :zona, foreign_key: "id_zona"
  has_many :ocorrencias, foreign_key: "id_bairro"
  has_many :complexos_habitacionais, foreign_key: "id_bairro"
  has_many :estatisticas_bairro, foreign_key: "id_bairro"
  has_many :indicadores_socioeconomicos, foreign_key: "id_bairro"
  has_many :pesquisas, foreign_key: "id_bairro"
end

# TipoCrime
class TipoCrime < ApplicationRecord
  has_many :ocorrencias, foreign_key: "id_tipo_crime"
end

# Ocorrencia
class Ocorrencia < ApplicationRecord
  belongs_to :bairro, foreign_key: "id_bairro"
  belongs_to :tipo_crime, foreign_key: "id_tipo_crime"
end

# ComplexoHabitacional
class ComplexoHabitacional < ApplicationRecord
  belongs_to :bairro, foreign_key: "id_bairro"
  has_many :pesquisas, foreign_key: "id_complexo"
end

# Pesquisa
class Pesquisa < ApplicationRecord
  belongs_to :bairro, foreign_key: "id_bairro"
  belongs_to :complexo_habitacional, foreign_key: "id_complexo", optional: true
end

# Usuario
class Usuario < ApplicationRecord
  has_many :auditorias, foreign_key: "id_usuario"
end

# Auditoria
class Auditoria < ApplicationRecord
  belongs_to :usuario, foreign_key: "id_usuario", optional: true
end
```

### Primary Keys Customizadas

Todos os modelos utilizam primary keys customizadas (não `id` padrão):

```ruby
class Ocorrencia < ApplicationRecord
  self.table_name = "ocorrencias"
  self.primary_key = "id_ocorrencia"
end

class Bairro < ApplicationRecord
  self.table_name = "bairros"
  self.primary_key = "id_bairro"
end

# ... e assim por diante
```

---

## ⚙️ Serviços

### NotificationsService (app/services/notifications_service.rb:1)

**Responsabilidade**: Gerenciar envio de notificações via Action Cable.

**Constantes**:
```ruby
NOTIFICATION_TYPES = {
  ocorrencia_criada: "ocorrencia_criada",
  ocorrencia_atualizada: "ocorrencia_atualizada",
  ocorrencia_finalizada: "ocorrencia_finalizada",
  ocorrencia_removida: "ocorrencia_removida",
  sistema: "sistema"
}
```

**Métodos Públicos**:
- `broadcast_ocorrencia_criada(ocorrencia)`
- `broadcast_ocorrencia_atualizada(ocorrencia, changes = {})`
- `broadcast_ocorrencia_finalizada(ocorrencia)`
- `broadcast_ocorrencia_removida(ocorrencia_id, numero_bo)`
- `broadcast_custom(type:, title:, message:, data: {})`
- `broadcast_sistema(message:, level: "info", data: {})`
- `broadcast_to_devices(device_types:, type:, title:, message:, data: {})`
- `broadcast_to_web(type:, title:, message:, data: {})`
- `broadcast_to_mobile(type:, title:, message:, data: {})`
- `broadcast_to_device_id(device_id:, type:, title:, message:, data: {})`
- `broadcast_to_user(user_id:, type:, title:, message:, data: {})`

**Exemplo de Uso**:
```ruby
# No controller
def create
  @ocorrencia = Ocorrencia.new(ocorrencia_params)

  if @ocorrencia.save
    # Notificação automática
    NotificationsService.broadcast_ocorrencia_criada(@ocorrencia)

    render json: @ocorrencia, status: :created
  else
    render json: @ocorrencia.errors, status: :unprocessable_entity
  end
end
```

---

## ⚡ Otimizações de Performance

### 1. Paginação com Pagy

**Biblioteca**: `pagy` (mais rápida que Kaminari/will_paginate)

**Implementação** (app/controllers/api/v1/ocorrencias_controller.rb:19):
```ruby
limit = [params[:items].to_i, params[:per_page].to_i, 25].max
limit = [limit, 5000].min  # Máximo de 5000 registros

pagy, ocorrencias = pagy(
  records.select(selected_fields).order(:id_ocorrencia),
  limit: limit
)
```

**Resposta**:
```json
{
  "current_page": 1,
  "per_page": 25,
  "total_pages": 40,
  "total_count": 1000,
  "ocorrencias": [...]
}
```

### 2. Contagem Aproximada (app/controllers/api/v1/ocorrencias_controller.rb:154)

Para queries grandes sem filtros, usa estatísticas do PostgreSQL:

```ruby
def get_fast_count(records)
  if params.keys.any? { |k| filterable_fields.include?(k) }
    return records.count  # Contagem exata com filtros
  end

  # Contagem aproximada MUITO mais rápida
  Rails.cache.fetch("ocorrencias_total_count", expires_in: 1.hour) do
    Ocorrencia.connection.execute(
      "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='ocorrencias'"
    )[0]["estimate"].to_i
  end
end
```

**Ganho**: 1000x mais rápido em tabelas com milhões de registros.

### 3. Cache de Response (app/controllers/api/v1/ocorrencias_controller.rb:26)

```ruby
cache_key = generate_cache_key(limit)

result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
  # Query e serialização
end

render json: result
```

Cache baseado em:
- Filtros aplicados
- Página atual
- Limite de registros

### 4. Seleção de Campos (app/controllers/api/v1/ocorrencias_controller.rb:177)

Busca apenas campos essenciais:

```ruby
def selected_fields
  %w[
    id_ocorrencia numero_bo id_tipo_crime id_bairro
    data_ocorrencia hora_ocorrencia dia_semana periodo_dia
    latitude_ocorrencia longitude_ocorrencia
    status_ocorrencia vitimas recuperado
  ]
end

records.select(selected_fields)  # Omite campos pesados
```

**Ganho**: Reduz transferência de rede em até 70%.

### 5. Compressão Gzip (config/application.rb:21)

```ruby
config.middleware.use Rack::Deflater
```

**Ganho**: Reduz payloads JSON em 70-90%.

### 6. Índices do Banco de Dados

**Full-text Search**:
```sql
CREATE INDEX idx_ocorrencias_descricao_fts
ON ocorrencias USING GIN (to_tsvector('portuguese', descricao_ocorrencia));
```

**Índices Geoespaciais** (GiST):
```sql
CREATE INDEX idx_ocorrencias_geom
ON ocorrencias USING GIST (point(longitude_ocorrencia, latitude_ocorrencia));
```

**Índices Compostos**:
```sql
CREATE INDEX idx_ocorrencias_bairro_data ON ocorrencias (id_bairro, data_ocorrencia);
CREATE INDEX idx_ocorrencias_tipo_data ON ocorrencias (id_tipo_crime, data_ocorrencia);
```

### 7. Configurações PostgreSQL (docker-compose.yml:28)

```yaml
command: >
  postgres
  -c max_connections=100
  -c shared_buffers=256MB
  -c effective_cache_size=1GB
  -c maintenance_work_mem=128MB
  -c checkpoint_completion_target=0.9
  -c random_page_cost=1.1
  -c effective_io_concurrency=200
```

---

## 🧪 Testes

### Framework: RSpec

**Instalação**:
```bash
bundle exec rspec
```

**Estrutura**:
```
spec/
├── controllers/
├── models/
├── requests/
├── services/
└── channels/
```

### Exemplos de Testes

**Model Spec**:
```ruby
# spec/models/ocorrencia_spec.rb
require 'rails_helper'

RSpec.describe Ocorrencia, type: :model do
  it { should belong_to(:bairro) }
  it { should belong_to(:tipo_crime) }

  it "valida presença de numero_bo" do
    ocorrencia = Ocorrencia.new
    expect(ocorrencia.valid?).to be_falsy
  end
end
```

**Request Spec**:
```ruby
# spec/requests/api/v1/ocorrencias_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Ocorrencias", type: :request do
  describe "GET /api/v1/ocorrencias" do
    it "retorna lista de ocorrências" do
      get "/api/v1/ocorrencias"

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to have_key("ocorrencias")
    end
  end
end
```

---

## 🚀 Deploy e Produção

### Variáveis de Ambiente (Produção)

```env
DATABASE_URL=postgres://user:pass@host:5432/db
RAILS_ENV=production
SECRET_KEY_BASE=<gerado por rails secret>
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

### Build Docker para Produção

**Dockerfile** (multi-stage):
```dockerfile
FROM ruby:3.3-alpine AS builder

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

FROM ruby:3.3-alpine
WORKDIR /app
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
```

**Build**:
```bash
docker build -t sisp360-backend:latest .
docker run -p 3000:3000 --env-file .env.production sisp360-backend:latest
```

### Migrations em Produção

```bash
rails db:migrate RAILS_ENV=production
```

### Health Check

Endpoint: `GET /up`

Retorna `200 OK` se o servidor estiver saudável.

### Logs

**Visualizar logs**:
```bash
tail -f log/production.log
```

**Logs Docker**:
```bash
docker-compose logs -f
```

---

## 📚 Recursos Adicionais

### Swagger/OpenAPI

Acesse a documentação interativa:
```
http://localhost:3000/api-docs
```

### Scripts de Teste

**PowerShell** (Windows):
```powershell
.\test_notifications.ps1
.\test_device_differentiation.ps1
```

**Bash** (Linux/Mac):
```bash
./test_notifications.sh
./test_device_differentiation.sh
```

### Exemplos de Requisições HTTP

Arquivo: `API_TEST_EXAMPLES.http`

Contém exemplos de requisições para testar todos os endpoints.

---

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

---

## 📄 Licença

Este projeto é propriedade do governo de Porto Velho e destina-se exclusivamente ao uso interno.

---

## 📞 Contato

Para dúvidas ou suporte, entre em contato com a equipe de desenvolvimento.

---

**Última Atualização**: 19 de Outubro de 2024
**Versão da Documentação**: 1.0.0
