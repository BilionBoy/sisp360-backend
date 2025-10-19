# Resumo da API Auto-Gerada - SISP360 Backend

**Data de geração:** 2025-10-19
**Banco de dados:** PostgreSQL (crimes_porto_velho)
**Total de tabelas implementadas:** 10

---

## Estrutura Gerada

### Models (app/models/)
- ✅ **Auditoria** (auditoria.rb) - id_auditoria
- ✅ **Bairro** (bairro.rb) - id_bairro
- ✅ **ComplexoHabitacional** (complexo_habitacional.rb) - id_complexo
- ✅ **EstatisticaBairro** (estatistica_bairro.rb) - id_estatistica
- ✅ **IndicadorSocioeconomico** (indicador_socioeconomico.rb) - id_indicador
- ✅ **Ocorrencia** (ocorrencia.rb) - id_ocorrencia
- ✅ **Pesquisa** (pesquisa.rb) - id_pesquisa
- ✅ **TipoCrime** (tipo_crime.rb) - id_tipo_crime
- ✅ **Usuario** (usuario.rb) - id_usuario
- ✅ **Zona** (zona.rb) - id_zona

### Controllers (app/controllers/api/v1/)
- ✅ **AuditoriasController** - CRUD completo com paginação
- ✅ **BairrosController** - CRUD completo com paginação
- ✅ **ComplexosHabitacionaisController** - CRUD completo com paginação
- ✅ **EstatisticasBairroController** - CRUD completo com paginação
- ✅ **IndicadoresSocioeconomicosController** - CRUD completo com paginação
- ✅ **OcorrenciasController** - CRUD completo com paginação (já existia)
- ✅ **PesquisasController** - CRUD completo com paginação
- ✅ **TiposCrimeController** - CRUD completo com paginação
- ✅ **UsuariosController** - CRUD completo com paginação
- ✅ **ZonasController** - CRUD completo com paginação

### Serializers (app/serializers/)
- ✅ Todos os serializers com atributos completos
- ✅ UsuarioSerializer não expõe senha_hash (segurança)

---

## Endpoints Disponíveis

### Base URL: `/api/v1`

#### 1. Auditorias
- **GET** `/api/v1/auditorias` - Listar todas as auditorias (paginado)
- **GET** `/api/v1/auditorias/:id` - Buscar auditoria específica
- **POST** `/api/v1/auditorias` - Criar nova auditoria
- **PATCH/PUT** `/api/v1/auditorias/:id` - Atualizar auditoria
- **DELETE** `/api/v1/auditorias/:id` - Deletar auditoria

**Filtros disponíveis:** `id_usuario`, `acao`, `tabela_afetada`, `id_registro_afetado`, `data_hora`

#### 2. Bairros
- **GET** `/api/v1/bairros` - Listar todos os bairros (paginado)
- **GET** `/api/v1/bairros/:id` - Buscar bairro específico
- **POST** `/api/v1/bairros` - Criar novo bairro
- **PATCH/PUT** `/api/v1/bairros/:id` - Atualizar bairro
- **DELETE** `/api/v1/bairros/:id` - Deletar bairro

**Filtros disponíveis:** `id_zona`, `nome_bairro`, `codigo_ibge`, `status_bairro`

#### 3. Complexos Habitacionais
- **GET** `/api/v1/complexos_habitacionais` - Listar todos os complexos (paginado)
- **GET** `/api/v1/complexos_habitacionais/:id` - Buscar complexo específico
- **POST** `/api/v1/complexos_habitacionais` - Criar novo complexo
- **PATCH/PUT** `/api/v1/complexos_habitacionais/:id` - Atualizar complexo
- **DELETE** `/api/v1/complexos_habitacionais/:id` - Deletar complexo

**Filtros disponíveis:** `id_bairro`, `tipo_complexo`, `nome_complexo`, `possui_seguranca`, `possui_controle_acesso`

#### 4. Estatísticas de Bairro
- **GET** `/api/v1/estatisticas_bairro` - Listar todas as estatísticas (paginado)
- **GET** `/api/v1/estatisticas_bairro/:id` - Buscar estatística específica
- **POST** `/api/v1/estatisticas_bairro` - Criar nova estatística
- **PATCH/PUT** `/api/v1/estatisticas_bairro/:id` - Atualizar estatística
- **DELETE** `/api/v1/estatisticas_bairro/:id` - Deletar estatística

**Filtros disponíveis:** `id_bairro`, `ano`, `mes`, `ranking_bairro`

#### 5. Indicadores Socioeconômicos
- **GET** `/api/v1/indicadores_socioeconomicos` - Listar todos os indicadores (paginado)
- **GET** `/api/v1/indicadores_socioeconomicos/:id` - Buscar indicador específico
- **POST** `/api/v1/indicadores_socioeconomicos` - Criar novo indicador
- **PATCH/PUT** `/api/v1/indicadores_socioeconomicos/:id` - Atualizar indicador
- **DELETE** `/api/v1/indicadores_socioeconomicos/:id` - Deletar indicador

**Filtros disponíveis:** `id_bairro`, `ano_referencia`

#### 6. Ocorrências
- **GET** `/api/v1/ocorrencias` - Listar todas as ocorrências (paginado)
- **GET** `/api/v1/ocorrencias/:id` - Buscar ocorrência específica
- **POST** `/api/v1/ocorrencias` - Criar nova ocorrência
- **PATCH/PUT** `/api/v1/ocorrencias/:id` - Atualizar ocorrência
- **DELETE** `/api/v1/ocorrencias/:id` - Deletar ocorrência

**Filtros disponíveis:** `numero_bo`, `id_tipo_crime`, `id_bairro`, `data_ocorrencia`, `periodo_dia`, `status_ocorrencia`

#### 7. Pesquisas
- **GET** `/api/v1/pesquisas` - Listar todas as pesquisas (paginado)
- **GET** `/api/v1/pesquisas/:id` - Buscar pesquisa específica
- **POST** `/api/v1/pesquisas` - Criar nova pesquisa
- **PATCH/PUT** `/api/v1/pesquisas/:id` - Atualizar pesquisa
- **DELETE** `/api/v1/pesquisas/:id` - Deletar pesquisa

**Filtros disponíveis:** `id_complexo`, `id_bairro`, `data_pesquisa`, `escolaridade`, `faixa_renda`

#### 8. Tipos de Crime
- **GET** `/api/v1/tipos_crime` - Listar todos os tipos de crime (paginado)
- **GET** `/api/v1/tipos_crime/:id` - Buscar tipo de crime específico
- **POST** `/api/v1/tipos_crime` - Criar novo tipo de crime
- **PATCH/PUT** `/api/v1/tipos_crime/:id` - Atualizar tipo de crime
- **DELETE** `/api/v1/tipos_crime/:id` - Deletar tipo de crime

**Filtros disponíveis:** `codigo_senasp`, `categoria`, `gravidade`, `ativo`, `nome_crime`

#### 9. Usuários
- **GET** `/api/v1/usuarios` - Listar todos os usuários (paginado)
- **GET** `/api/v1/usuarios/:id` - Buscar usuário específico
- **POST** `/api/v1/usuarios` - Criar novo usuário
- **PATCH/PUT** `/api/v1/usuarios/:id` - Atualizar usuário
- **DELETE** `/api/v1/usuarios/:id` - Deletar usuário

**Filtros disponíveis:** `cpf`, `email`, `tipo_usuario`, `orgao`, `ativo`

**Nota de Segurança:** O serializer de usuários NÃO expõe o campo `senha_hash`

#### 10. Zonas
- **GET** `/api/v1/zonas` - Listar todas as zonas (paginado)
- **GET** `/api/v1/zonas/:id` - Buscar zona específica
- **POST** `/api/v1/zonas` - Criar nova zona
- **PATCH/PUT** `/api/v1/zonas/:id` - Atualizar zona
- **DELETE** `/api/v1/zonas/:id` - Deletar zona

**Filtros disponíveis:** `nome_zona`

---

## Funcionalidades Padrão de Todos os Endpoints

### Paginação (via Pagy)
Todos os endpoints de listagem retornam:
```json
{
  "current_page": 1,
  "per_page": 20,
  "total_pages": 5,
  "total_count": 100,
  "{recurso}": [...]
}
```

**Query Params de Paginação:**
- `page` - Número da página (padrão: 1)
- `items` - Itens por página (padrão: 20)

### Filtros Automáticos
Use query params para filtrar resultados:
```
GET /api/v1/ocorrencias?id_bairro=5&periodo_dia=Noite
GET /api/v1/bairros?id_zona=1&status_bairro=Ativo
```

### Ordenação
Todos os endpoints ordenam por sua primary key por padrão.

### Tratamento de Erros
- **404 Not Found** - Registro não encontrado
- **422 Unprocessable Entity** - Erro de validação
- **500 Internal Server Error** - Erro do servidor

---

## Relacionamentos (Associations)

### Bairro
- `belongs_to :zona`
- `has_many :complexos_habitacionais`
- `has_many :estatisticas_bairros`
- `has_many :indicadores_socioeconomicos`
- `has_many :ocorrencias`
- `has_many :pesquisas`

### Zona
- `has_many :bairros`

### TipoCrime
- `has_many :ocorrencias`

### ComplexoHabitacional
- `belongs_to :bairro`
- `has_many :pesquisas`

### Ocorrencia
- `belongs_to :bairro`
- `belongs_to :tipo_crime`

### EstatisticaBairro
- `belongs_to :bairro`

### IndicadorSocioeconomico
- `belongs_to :bairro`

### Pesquisa
- `belongs_to :bairro`
- `belongs_to :complexo_habitacional`

### Usuario
- `has_many :auditorias`

### Auditoria
- `belongs_to :usuario`

---

## Estatísticas do Banco de Dados

| Tabela | Total de Registros |
|--------|-------------------|
| Zonas | 4 |
| Bairros | 69 |
| Tipos de Crime | 8 |
| Usuários | 2 |
| Complexos Habitacionais | 0 |
| Ocorrências | 4,002 |
| Estatísticas de Bairro | 0 |
| Indicadores Socioeconômicos | 69 |
| Pesquisas | 0 |
| Auditorias | 4,002 |

**Total:** 8,156 registros

---

## Exemplos de Uso

### Listar Ocorrências com Paginação
```bash
curl http://localhost:3000/api/v1/ocorrencias?page=1&items=10
```

### Buscar Bairro Específico
```bash
curl http://localhost:3000/api/v1/bairros/5
```

### Filtrar Ocorrências por Bairro e Período
```bash
curl "http://localhost:3000/api/v1/ocorrencias?id_bairro=10&periodo_dia=Noite"
```

### Criar Nova Zona
```bash
curl -X POST http://localhost:3000/api/v1/zonas \
  -H "Content-Type: application/json" \
  -d '{
    "zona": {
      "nome_zona": "Zona Norte",
      "descricao": "Região norte da cidade",
      "area_km2": 150.5
    }
  }'
```

---

## Notas Importantes

1. **Autenticação:** Os endpoints atualmente NÃO possuem autenticação. Implemente antes de produção.

2. **Validações:** Os models não possuem validações além das constraints do banco.

3. **CORS:** Configure CORS no `config/initializers/cors.rb` se necessário.

4. **Serialização:** Usando ActiveModel Serializers para controle fino do JSON.

5. **Primary Keys Customizadas:** Todos os models usam as primary keys corretas do banco (ex: `id_ocorrencia`, `id_bairro`).

6. **Segurança:**
   - UsuarioSerializer NÃO expõe `senha_hash`
   - Implemente autenticação/autorização antes de produção
   - Configure rate limiting

---

## Próximos Passos Recomendados

1. **Implementar Autenticação** (JWT, Devise, etc.)
2. **Adicionar Validações** nos models
3. **Configurar CORS** para frontend
4. **Implementar Testes** (RSpec)
5. **Adicionar Rate Limiting** (Rack::Attack)
6. **Documentação OpenAPI/Swagger**
7. **Implementar Seeds** para desenvolvimento
8. **Configurar CI/CD**
9. **Adicionar Logging e Monitoring**
10. **Implementar Soft Deletes** se necessário

---

**Gerado automaticamente em:** 2025-10-19
**Versão da API:** v1
**Framework:** Ruby on Rails (API-only mode)
