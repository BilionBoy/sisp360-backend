# API Auto-Gerada - SISP360 Backend

## Resumo da Implementação

Este documento descreve a API REST completa que foi **automaticamente gerada** a partir da análise do banco de dados PostgreSQL existente.

### O que foi gerado?

- **10 Models** completos com associations (relacionamentos)
- **10 Controllers** com CRUD completo, paginação e filtros
- **10 Serializers** para controle de JSON responses
- **60 Endpoints** RESTful (6 por recurso)
- Documentação completa e exemplos de uso

---

## Arquivos Gerados

### Models (D:\Projetos\WEB\sisp360-backend\app\models\)
```
auditoria.rb
bairro.rb
complexo_habitacional.rb
estatistica_bairro.rb
indicador_socioeconomico.rb
ocorrencia.rb (atualizado com associations)
pesquisa.rb
tipo_crime.rb
usuario.rb
zona.rb
```

### Controllers (D:\Projetos\WEB\sisp360-backend\app\controllers\api\v1\)
```
auditorias_controller.rb
bairros_controller.rb
complexos_habitacionais_controller.rb
estatisticas_bairro_controller.rb
indicadores_socioeconomicos_controller.rb
ocorrencias_controller.rb (já existia)
pesquisas_controller.rb
tipos_crime_controller.rb
usuarios_controller.rb
zonas_controller.rb
```

### Serializers (D:\Projetos\WEB\sisp360-backend\app\serializers\)
```
auditoria_serializer.rb
bairro_serializer.rb
complexo_habitacional_serializer.rb
estatistica_bairro_serializer.rb
indicador_socioeconomico_serializer.rb
ocorrencia_serializer.rb
pesquisa_serializer.rb
tipo_crime_serializer.rb
usuario_serializer.rb
zona_serializer.rb
```

### Documentação Gerada
```
GENERATED_API_SUMMARY.md - Resumo completo da API
API_TEST_EXAMPLES.http - Exemplos de requisições HTTP
README_API_GERADA.md - Este arquivo
lib/tasks/api_report.rake - Task para gerar relatórios
```

---

## Como Usar

### 1. Iniciar o Servidor

```bash
cd D:\Projetos\WEB\sisp360-backend
rails server
```

O servidor estará disponível em: `http://localhost:3000`

### 2. Testar Endpoints

#### Opção A: Usando curl

```bash
# Listar ocorrências
curl http://localhost:3000/api/v1/ocorrencias?page=1&items=10

# Buscar zona específica
curl http://localhost:3000/api/v1/zonas/9

# Filtrar bairros por zona
curl "http://localhost:3000/api/v1/bairros?id_zona=9"
```

#### Opção B: Usando o arquivo API_TEST_EXAMPLES.http

Se você usa VS Code com a extensão **REST Client**, abra o arquivo `API_TEST_EXAMPLES.http` e clique em "Send Request" acima de cada exemplo.

#### Opção C: Usando Postman/Insomnia

Importe as requisições do arquivo `API_TEST_EXAMPLES.http` ou crie manualmente.

### 3. Gerar Relatório Completo

```bash
rails api:report
```

Este comando exibe:
- Todas as tabelas e colunas
- Relationships (associations)
- Todos os endpoints disponíveis
- Contagem de registros por tabela

---

## Padrões Implementados

### Todos os Controllers Seguem o Padrão:

1. **CRUD Completo**
   - `index` - Listar todos (paginado)
   - `show` - Buscar por ID
   - `create` - Criar novo
   - `update` - Atualizar existente
   - `destroy` - Deletar

2. **Paginação Automática (Pagy)**
   - `page` - Número da página (padrão: 1)
   - `items` - Itens por página (padrão: 20)

   Response inclui:
   ```json
   {
     "current_page": 1,
     "per_page": 20,
     "total_pages": 5,
     "total_count": 100,
     "ocorrencias": [...]
   }
   ```

3. **Filtros Automáticos**
   - Filtre por qualquer campo usando query params
   - Exemplo: `/api/v1/ocorrencias?id_bairro=1&periodo_dia=Noite`

4. **Tratamento de Erros**
   - `404` - Registro não encontrado
   - `422` - Erro de validação
   - `500` - Erro do servidor

---

## Exemplos Práticos

### Listar Ocorrências de um Bairro Específico

```bash
GET /api/v1/ocorrencias?id_bairro=1&page=1&items=20
```

Response:
```json
{
  "current_page": 1,
  "per_page": 20,
  "total_pages": 10,
  "total_count": 200,
  "ocorrencias": [
    {
      "id_ocorrencia": 1,
      "numero_bo": "BO-2024-001",
      "id_tipo_crime": 17,
      "id_bairro": 1,
      "data_ocorrencia": "2024-10-15",
      "periodo_dia": "Noite",
      ...
    }
  ]
}
```

### Buscar Informações de um Bairro

```bash
GET /api/v1/bairros/1
```

Response:
```json
{
  "id_bairro": 1,
  "nome_bairro": "Centro",
  "id_zona": 9,
  "populacao": 50000,
  "latitude": -8.76077,
  "longitude": -63.90027,
  ...
}
```

### Criar Nova Zona

```bash
POST /api/v1/zonas
Content-Type: application/json

{
  "zona": {
    "nome_zona": "Zona Teste",
    "descricao": "Zona criada para teste",
    "area_km2": 100.5
  }
}
```

### Filtrar Tipos de Crime Ativos

```bash
GET /api/v1/tipos_crime?ativo=true
```

---

## Relacionamentos (Associations)

### Hierarquia Principal

```
Zona
 └── Bairro (belongs_to :zona)
      ├── Ocorrencia (belongs_to :bairro, :tipo_crime)
      ├── ComplexoHabitacional (belongs_to :bairro)
      ├── EstatisticaBairro (belongs_to :bairro)
      ├── IndicadorSocioeconomico (belongs_to :bairro)
      └── Pesquisa (belongs_to :bairro, :complexo_habitacional)

TipoCrime
 └── Ocorrencia (belongs_to :tipo_crime)

Usuario
 └── Auditoria (belongs_to :usuario)
```

---

## Dados Disponíveis no Banco

| Tabela | Registros |
|--------|-----------|
| Zonas | 4 |
| Bairros | 69 |
| Tipos de Crime | 8 |
| Usuários | 2 |
| Complexos Habitacionais | 0 |
| **Ocorrências** | **4,002** |
| Estatísticas de Bairro | 0 |
| **Indicadores Socioeconômicos** | **69** |
| Pesquisas | 0 |
| **Auditorias** | **4,002** |

**Total:** 8,156 registros

---

## Filtros Disponíveis por Endpoint

### Auditorias
`id_usuario`, `acao`, `tabela_afetada`, `id_registro_afetado`, `data_hora`

### Bairros
`id_zona`, `nome_bairro`, `codigo_ibge`, `status_bairro`

### Complexos Habitacionais
`id_bairro`, `tipo_complexo`, `nome_complexo`, `possui_seguranca`, `possui_controle_acesso`

### Estatísticas de Bairro
`id_bairro`, `ano`, `mes`, `ranking_bairro`

### Indicadores Socioeconômicos
`id_bairro`, `ano_referencia`

### Ocorrências
`numero_bo`, `id_tipo_crime`, `id_bairro`, `data_ocorrencia`, `periodo_dia`, `status_ocorrencia`

### Pesquisas
`id_complexo`, `id_bairro`, `data_pesquisa`, `escolaridade`, `faixa_renda`

### Tipos de Crime
`codigo_senasp`, `categoria`, `gravidade`, `ativo`, `nome_crime`

### Usuários
`cpf`, `email`, `tipo_usuario`, `orgao`, `ativo`

### Zonas
`nome_zona`

---

## Segurança

### Implementado
- UsuarioSerializer NÃO expõe o campo `senha_hash`
- Validação de registros não encontrados (404)
- Tratamento de erros de validação (422)

### Ainda NÃO Implementado (IMPORTANTE!)
- Autenticação (JWT, Devise, etc.)
- Autorização (CanCanCan, Pundit, etc.)
- Rate Limiting (Rack::Attack)
- CORS configurado para produção
- Validações de negócio nos models

**ATENÇÃO:** Esta API está aberta e sem autenticação. NÃO use em produção sem implementar segurança!

---

## Próximos Passos Recomendados

### Alta Prioridade
1. Implementar autenticação (JWT ou Devise)
2. Adicionar autorização (roles: admin, operador, visualizador)
3. Configurar CORS para frontend específico
4. Adicionar validações de negócio nos models
5. Implementar testes automatizados (RSpec)

### Média Prioridade
6. Adicionar rate limiting
7. Implementar cache (Redis)
8. Documentação OpenAPI/Swagger
9. Seeds para desenvolvimento/testes
10. Logging estruturado

### Baixa Prioridade
11. Versionamento de API (v2, v3...)
12. GraphQL endpoint (opcional)
13. Webhooks (opcional)
14. Jobs assíncronos para operações pesadas
15. Soft deletes (paranoia gem)

---

## Comandos Úteis

### Desenvolvimento

```bash
# Iniciar servidor
rails server

# Console Rails
rails console

# Gerar relatório completo
rails api:report

# Ver todas as rotas
rails routes | grep "api/v1"

# Verificar conexão com banco
rails runner "puts ActiveRecord::Base.connection.tables"
```

### Testes Rápidos

```bash
# Contar ocorrências
rails runner "puts Ocorrencia.count"

# Listar zonas
rails runner "Zona.all.each { |z| puts z.nome_zona }"

# Buscar bairros de uma zona
rails runner "puts Bairro.where(id_zona: 9).count"
```

---

## Troubleshooting

### Erro: "Couldn't find X with 'id'=Y"
- Verifique se o ID existe no banco
- Use o endpoint de listagem para ver IDs disponíveis

### Erro: "PG::ConnectionBad"
- Verifique se o DATABASE_URL no `.env` está correto
- Confirme que o servidor PostgreSQL está acessível

### Paginação não funciona
- Certifique-se que a gem `pagy` está instalada
- Execute `bundle install` se necessário

### Filtros não funcionam
- Use exatamente o nome do campo do banco
- Exemplo correto: `id_bairro=1` (não `bairro_id`)

---

## Estrutura de Diretórios

```
sisp360-backend/
├── app/
│   ├── controllers/
│   │   └── api/
│   │       └── v1/          # 10 controllers
│   ├── models/              # 10 models
│   └── serializers/         # 10 serializers
├── config/
│   └── routes.rb            # 60 endpoints
├── lib/
│   └── tasks/
│       └── api_report.rake  # Task de relatório
├── GENERATED_API_SUMMARY.md
├── API_TEST_EXAMPLES.http
└── README_API_GERADA.md     # Este arquivo
```

---

## Licença e Autoria

**Projeto:** SISP360 Backend
**Data de Geração:** 2025-10-19
**Gerado por:** Script de auto-geração a partir do banco PostgreSQL
**Banco de Dados:** crimes_porto_velho

---

## Suporte

Para questões técnicas:
1. Consulte `GENERATED_API_SUMMARY.md` para detalhes completos
2. Use `API_TEST_EXAMPLES.http` para exemplos práticos
3. Execute `rails api:report` para relatório atualizado
4. Verifique logs em `log/development.log`

---

**Última atualização:** 2025-10-19
