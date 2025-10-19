# SISP360 API - Documentação Swagger/OpenAPI

## Visão Geral

Este documento descreve a configuração e uso da documentação Swagger/OpenAPI para a API SISP360.

A documentação foi implementada usando a gem **rswag**, que gera automaticamente documentação OpenAPI 3.0 a partir de specs RSpec.

## Acesso à Documentação

### Swagger UI Interativa

Após iniciar o servidor Rails, acesse a interface Swagger UI em:

```
http://localhost:3000/api-docs
```

A interface Swagger UI permite:
- Visualizar todos os endpoints da API
- Testar endpoints diretamente pelo navegador (Try it out)
- Ver schemas de request e response
- Verificar parâmetros obrigatórios e opcionais
- Consultar exemplos de uso

### Especificação OpenAPI (YAML)

A especificação OpenAPI em formato YAML está disponível em:

```
http://localhost:3000/api-docs/v1/swagger.yaml
```

Você pode usar este arquivo para:
- Importar em ferramentas como Postman, Insomnia
- Gerar clientes de API automaticamente
- Integrar com ferramentas de CI/CD

## Recursos Documentados

A documentação cobre todos os 10 recursos principais da API:

### 1. Ocorrências (`/api/v1/ocorrencias`)
- **GET** `/api/v1/ocorrencias` - Lista ocorrências com paginação
- **GET** `/api/v1/ocorrencias/:id` - Detalhes de uma ocorrência
- **POST** `/api/v1/ocorrencias` - Cria nova ocorrência
- **PATCH/PUT** `/api/v1/ocorrencias/:id` - Atualiza ocorrência
- **DELETE** `/api/v1/ocorrencias/:id` - Remove ocorrência

**Filtros disponíveis:**
- `numero_bo` - Número do Boletim de Ocorrência
- `id_tipo_crime` - ID do tipo de crime
- `id_bairro` - ID do bairro
- `data_ocorrencia` - Data da ocorrência (YYYY-MM-DD)
- `periodo_dia` - Período do dia (Madrugada, Manhã, Tarde, Noite)
- `status_ocorrencia` - Status (Registrada, Em Investigação, Resolvida, Arquivada)

### 2. Bairros (`/api/v1/bairros`)
- **GET** `/api/v1/bairros` - Lista bairros
- **GET** `/api/v1/bairros/:id` - Detalhes de um bairro
- **POST** `/api/v1/bairros` - Cria novo bairro
- **PATCH/PUT** `/api/v1/bairros/:id` - Atualiza bairro
- **DELETE** `/api/v1/bairros/:id` - Remove bairro

**Filtros disponíveis:**
- `id_zona` - ID da zona
- `nome_bairro` - Nome do bairro
- `codigo_ibge` - Código IBGE
- `status_bairro` - Status (Oficial, Não Oficial, Em Processo)

### 3. Zonas (`/api/v1/zonas`)
- **GET** `/api/v1/zonas` - Lista zonas
- **GET** `/api/v1/zonas/:id` - Detalhes de uma zona
- **POST** `/api/v1/zonas` - Cria nova zona
- **PATCH/PUT** `/api/v1/zonas/:id` - Atualiza zona
- **DELETE** `/api/v1/zonas/:id` - Remove zona

**Filtros disponíveis:**
- `nome_zona` - Nome da zona

### 4. Tipos de Crime (`/api/v1/tipos_crime`)
- **GET** `/api/v1/tipos_crime` - Lista tipos de crime
- **GET** `/api/v1/tipos_crime/:id` - Detalhes de um tipo de crime
- **POST** `/api/v1/tipos_crime` - Cria novo tipo de crime
- **PATCH/PUT** `/api/v1/tipos_crime/:id` - Atualiza tipo de crime
- **DELETE** `/api/v1/tipos_crime/:id` - Remove tipo de crime

**Filtros disponíveis:**
- `codigo_senasp` - Código SENASP
- `categoria` - Categoria (CVP, CVLI, Outros)
- `gravidade` - Gravidade (Baixa, Média, Alta, Altíssima)
- `ativo` - Se está ativo (true/false)
- `nome_crime` - Nome do crime

### 5. Usuários (`/api/v1/usuarios`)
- **GET** `/api/v1/usuarios` - Lista usuários
- **GET** `/api/v1/usuarios/:id` - Detalhes de um usuário
- **POST** `/api/v1/usuarios` - Cria novo usuário
- **PATCH/PUT** `/api/v1/usuarios/:id` - Atualiza usuário
- **DELETE** `/api/v1/usuarios/:id` - Remove usuário

**Nota:** O campo `senha_hash` não é retornado nas respostas por segurança.

**Filtros disponíveis:**
- `tipo_usuario` - Tipo (Admin, Analista, Operador, Consulta)
- `ativo` - Se está ativo
- `email` - Email do usuário

### 6. Auditorias (`/api/v1/auditorias`)
- **GET** `/api/v1/auditorias` - Lista registros de auditoria
- **GET** `/api/v1/auditorias/:id` - Detalhes de uma auditoria
- **POST** `/api/v1/auditorias` - Cria registro de auditoria
- **PATCH/PUT** `/api/v1/auditorias/:id` - Atualiza auditoria
- **DELETE** `/api/v1/auditorias/:id` - Remove auditoria

**Filtros disponíveis:**
- `id_usuario` - ID do usuário
- `acao` - Tipo de ação
- `tabela_afetada` - Tabela afetada

### 7. Complexos Habitacionais (`/api/v1/complexos_habitacionais`)
- **GET** `/api/v1/complexos_habitacionais` - Lista complexos
- **GET** `/api/v1/complexos_habitacionais/:id` - Detalhes de um complexo
- **POST** `/api/v1/complexos_habitacionais` - Cria novo complexo
- **PATCH/PUT** `/api/v1/complexos_habitacionais/:id` - Atualiza complexo
- **DELETE** `/api/v1/complexos_habitacionais/:id` - Remove complexo

**Filtros disponíveis:**
- `id_bairro` - ID do bairro
- `tipo_complexo` - Tipo (Condomínio Privado, Conjunto Habitacional Popular, Residencial Minha Casa Minha Vida)

### 8. Estatísticas de Bairro (`/api/v1/estatisticas_bairro`)
- **GET** `/api/v1/estatisticas_bairro` - Lista estatísticas
- **GET** `/api/v1/estatisticas_bairro/:id` - Detalhes de uma estatística
- **POST** `/api/v1/estatisticas_bairro` - Cria estatística
- **PATCH/PUT** `/api/v1/estatisticas_bairro/:id` - Atualiza estatística
- **DELETE** `/api/v1/estatisticas_bairro/:id` - Remove estatística

**Filtros disponíveis:**
- `id_bairro` - ID do bairro
- `ano` - Ano
- `mes` - Mês

### 9. Indicadores Socioeconômicos (`/api/v1/indicadores_socioeconomicos`)
- **GET** `/api/v1/indicadores_socioeconomicos` - Lista indicadores
- **GET** `/api/v1/indicadores_socioeconomicos/:id` - Detalhes de um indicador
- **POST** `/api/v1/indicadores_socioeconomicos` - Cria indicador
- **PATCH/PUT** `/api/v1/indicadores_socioeconomicos/:id` - Atualiza indicador
- **DELETE** `/api/v1/indicadores_socioeconomicos/:id` - Remove indicador

**Filtros disponíveis:**
- `id_bairro` - ID do bairro
- `ano_referencia` - Ano de referência

### 10. Pesquisas (`/api/v1/pesquisas`)
- **GET** `/api/v1/pesquisas` - Lista pesquisas
- **GET** `/api/v1/pesquisas/:id` - Detalhes de uma pesquisa
- **POST** `/api/v1/pesquisas` - Cria pesquisa
- **PATCH/PUT** `/api/v1/pesquisas/:id` - Atualiza pesquisa
- **DELETE** `/api/v1/pesquisas/:id` - Remove pesquisa

**Filtros disponíveis:**
- `id_bairro` - ID do bairro
- `id_complexo` - ID do complexo
- `data_pesquisa` - Data da pesquisa (YYYY-MM-DD)

## Paginação

Todos os endpoints de listagem (GET `/api/v1/{resource}`) suportam paginação através dos seguintes parâmetros de query:

- `page` (integer, opcional): Número da página (default: 1)
- `items` (integer, opcional): Quantidade de itens por página (default: 25)

### Exemplo de Requisição com Paginação

```bash
GET /api/v1/ocorrencias?page=2&items=50
```

### Formato de Resposta Paginada

```json
{
  "current_page": 2,
  "per_page": 50,
  "total_pages": 10,
  "total_count": 500,
  "ocorrencias": [
    {
      "id_ocorrencia": 51,
      "numero_bo": "BO-2024-001234",
      "id_tipo_crime": 1,
      "id_bairro": 5,
      ...
    },
    ...
  ]
}
```

## Schemas (Modelos de Dados)

A documentação inclui schemas completos para todos os 10 modelos de dados:

1. **Ocorrencia** - Registros de ocorrências criminais
2. **Bairro** - Dados de bairros de Porto Velho
3. **Zona** - Divisões geográficas administrativas
4. **TipoCrime** - Categorização de crimes (SENASP)
5. **Usuario** - Usuários do sistema
6. **Auditoria** - Logs de auditoria
7. **ComplexoHabitacional** - Conjuntos habitacionais
8. **EstatisticaBairro** - Estatísticas agregadas por bairro
9. **IndicadorSocioeconomico** - Indicadores socioeconômicos
10. **Pesquisa** - Dados de pesquisas sociais

Cada schema inclui:
- Todos os campos do modelo
- Tipos de dados
- Campos obrigatórios vs opcionais
- Valores default
- Enums para campos com valores limitados
- Campos read-only (gerados automaticamente)

## Estrutura de Arquivos

```
sisp360-backend/
├── spec/
│   ├── swagger_helper.rb              # Configuração principal do Swagger
│   ├── rails_helper.rb                # Helper do RSpec
│   ├── spec_helper.rb                 # Helper geral do RSpec
│   └── integration/
│       └── api/
│           └── v1/
│               ├── ocorrencias_spec.rb
│               ├── bairros_spec.rb
│               ├── zonas_spec.rb
│               ├── tipos_crime_spec.rb
│               ├── usuarios_spec.rb
│               ├── auditorias_spec.rb
│               ├── complexos_habitacionais_spec.rb
│               ├── estatisticas_bairro_spec.rb
│               ├── indicadores_socioeconomicos_spec.rb
│               └── pesquisas_spec.rb
├── swagger/
│   └── v1/
│       └── swagger.yaml               # Especificação OpenAPI gerada
└── config/
    └── initializers/
        ├── rswag_api.rb               # Configuração da API rswag
        └── rswag_ui.rb                # Configuração da UI rswag
```

## Como Usar

### 1. Visualizar a Documentação

Inicie o servidor Rails:

```bash
rails s
```

Acesse no navegador:

```
http://localhost:3000/api-docs
```

### 2. Testar Endpoints

Na interface Swagger UI:

1. Clique em um endpoint para expandir
2. Clique em **"Try it out"**
3. Preencha os parâmetros necessários
4. Clique em **"Execute"**
5. Veja a resposta abaixo

### 3. Exportar para Postman/Insomnia

1. Acesse `http://localhost:3000/api-docs/v1/swagger.yaml`
2. Salve o arquivo YAML
3. Importe no Postman/Insomnia usando "Import > File"

### 4. Gerar Clientes de API

Use ferramentas como **OpenAPI Generator** para gerar clientes automaticamente:

```bash
# Instalar OpenAPI Generator
npm install @openapitools/openapi-generator-cli -g

# Gerar cliente JavaScript
openapi-generator-cli generate \
  -i http://localhost:3000/api-docs/v1/swagger.yaml \
  -g javascript \
  -o ./api-client

# Gerar cliente Python
openapi-generator-cli generate \
  -i http://localhost:3000/api-docs/v1/swagger.yaml \
  -g python \
  -o ./api-client-python
```

## Manutenção da Documentação

### Atualizar Documentação Após Mudanças na API

Se você modificar algum endpoint ou modelo, atualize os arquivos de spec correspondentes em `spec/integration/api/v1/`.

Por exemplo, se você adicionar um novo campo ao modelo `Ocorrencia`:

1. Atualize o schema em `spec/swagger_helper.rb`
2. Atualize os exemplos em `spec/integration/api/v1/ocorrencias_spec.rb`
3. Regere a documentação (opcional, pois o arquivo `swagger.yaml` já existe)

### Adicionar Novo Recurso

Para documentar um novo recurso:

1. Crie um novo arquivo spec em `spec/integration/api/v1/{recurso}_spec.rb`
2. Adicione o schema em `spec/swagger_helper.rb` > `components > schemas`
3. Documente todos os endpoints (index, show, create, update, destroy)
4. Adicione filtros específicos do recurso

## Resolução de Problemas

### Swagger UI não carrega

Verifique se o servidor Rails está rodando:

```bash
rails s
```

Verifique se as rotas estão montadas:

```bash
rails routes | grep api-docs
```

Deve retornar:

```
rswag_ui        /api-docs      Rswag::Ui::Engine
rswag_api       /api-docs      Rswag::Api::Engine
```

### Documentação desatualizada

O arquivo `swagger/v1/swagger.yaml` contém a especificação completa da API. Se necessário, você pode editá-lo diretamente para incluir novos endpoints ou schemas.

## Referências

- [Rswag GitHub](https://github.com/rswag/rswag)
- [OpenAPI Specification](https://swagger.io/specification/)
- [Swagger UI](https://swagger.io/tools/swagger-ui/)
- [OpenAPI Generator](https://openapi-generator.tech/)

## Suporte

Para dúvidas ou problemas relacionados à documentação da API, consulte:
- Documentação oficial do rswag
- Especificação OpenAPI 3.0
- Este README

---

Desenvolvido para o **SISP360 - Sistema de Informação de Segurança Pública de Porto Velho/RO**
