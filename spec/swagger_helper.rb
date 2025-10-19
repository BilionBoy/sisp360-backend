# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'SISP360 API - Sistema de Informação de Segurança Pública de Porto Velho',
        version: '1.0.0',
        description: <<~DESC
          API RESTful para o sistema SISP360 de análise e gestão de dados de criminalidade em Porto Velho/RO.

          ## Recursos Principais

          - **Ocorrências**: Registro e consulta de ocorrências criminais
          - **Bairros e Zonas**: Informações geográficas e administrativas
          - **Tipos de Crime**: Categorização baseada em SENASP
          - **Estatísticas**: Dados agregados por bairro e período
          - **Indicadores Socioeconômicos**: Correlação com criminalidade
          - **Complexos Habitacionais**: Dados de conjuntos residenciais
          - **Pesquisas**: Dados de pesquisas sociais
          - **Usuários e Auditoria**: Gestão de usuários e logs de auditoria

          ## Paginação

          Todos os endpoints de listagem (GET /api/v1/{resource}) suportam paginação via query parameters:
          - `page` (integer): Número da página (default: 1)
          - `items` (integer): Itens por página (default: 25)

          A resposta inclui metadados de paginação:
          - `current_page`: Página atual
          - `per_page`: Itens por página
          - `total_pages`: Total de páginas
          - `total_count`: Total de registros

          ## Filtros

          Endpoints de listagem suportam filtros via query parameters específicos de cada recurso.
        DESC
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Servidor de desenvolvimento local'
        },
        {
          url: 'https://{production-host}',
          description: 'Servidor de produção',
          variables: {
            'production-host': {
              default: 'api.sisp360.gov.br'
            }
          }
        }
      ],
      components: {
        schemas: {
          Ocorrencia: {
            type: :object,
            properties: {
              id_ocorrencia: { type: :integer, readOnly: true },
              numero_bo: { type: :string, nullable: true },
              id_tipo_crime: { type: :integer },
              id_bairro: { type: :integer },
              data_ocorrencia: { type: :string, format: :date },
              hora_ocorrencia: { type: :string, format: :time, nullable: true },
              dia_semana: {
                type: :string,
                enum: ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'],
                nullable: true
              },
              periodo_dia: {
                type: :string,
                enum: ['Madrugada', 'Manhã', 'Tarde', 'Noite'],
                nullable: true
              },
              latitude_ocorrencia: { type: :number, format: :float, nullable: true },
              longitude_ocorrencia: { type: :number, format: :float, nullable: true },
              logradouro: { type: :string, nullable: true },
              numero_endereco: { type: :string, nullable: true },
              ponto_referencia: { type: :string, nullable: true },
              descricao_ocorrencia: { type: :string, nullable: true },
              vitimas: { type: :integer, default: 1 },
              valor_prejuizo: { type: :number, format: :float, nullable: true },
              recuperado: { type: :boolean, default: false },
              status_ocorrencia: {
                type: :string,
                enum: ['Registrada', 'Em Investigação', 'Resolvida', 'Arquivada'],
                default: 'Registrada'
              },
              origem_registro: {
                type: :string,
                enum: ['PM', 'PC', 'Sistema Integrado', 'Outro'],
                default: 'PM'
              },
              data_registro: { type: :string, format: 'date-time', readOnly: true },
              usuario_registro: { type: :string, nullable: true }
            },
            required: %w[id_tipo_crime id_bairro data_ocorrencia]
          },
          Bairro: {
            type: :object,
            properties: {
              id_bairro: { type: :integer, readOnly: true },
              nome_bairro: { type: :string },
              id_zona: { type: :integer },
              codigo_ibge: { type: :string, nullable: true },
              populacao: { type: :integer, default: 0 },
              area_km2: { type: :number, format: :float, nullable: true },
              densidade_populacional: { type: :number, format: :float, readOnly: true },
              latitude: { type: :number, format: :float },
              longitude: { type: :number, format: :float },
              status_bairro: {
                type: :string,
                enum: ['Oficial', 'Não Oficial', 'Em Processo'],
                default: 'Oficial'
              },
              data_criacao_bairro: { type: :string, format: :date, nullable: true },
              lei_criacao: { type: :string, nullable: true },
              observacoes: { type: :string, nullable: true },
              data_criacao: { type: :string, format: 'date-time', readOnly: true },
              data_atualizacao: { type: :string, format: 'date-time', readOnly: true }
            },
            required: %w[nome_bairro id_zona latitude longitude]
          },
          Zona: {
            type: :object,
            properties: {
              id_zona: { type: :integer, readOnly: true },
              nome_zona: { type: :string },
              descricao: { type: :string, nullable: true },
              area_km2: { type: :number, format: :float, nullable: true },
              populacao_estimada: { type: :integer, nullable: true },
              percentual_populacao: { type: :number, format: :float, nullable: true },
              latitude_centro: { type: :number, format: :float, nullable: true },
              longitude_centro: { type: :number, format: :float, nullable: true },
              data_criacao: { type: :string, format: 'date-time', readOnly: true },
              data_atualizacao: { type: :string, format: 'date-time', readOnly: true }
            },
            required: %w[nome_zona]
          },
          TipoCrime: {
            type: :object,
            properties: {
              id_tipo_crime: { type: :integer, readOnly: true },
              codigo_senasp: { type: :string, nullable: true },
              nome_crime: { type: :string },
              categoria: {
                type: :string,
                enum: ['CVP', 'CVLI', 'Outros'],
                default: 'CVP'
              },
              descricao: { type: :string, nullable: true },
              gravidade: {
                type: :string,
                enum: ['Baixa', 'Média', 'Alta', 'Altíssima'],
                default: 'Média'
              },
              ativo: { type: :boolean, default: true },
              data_criacao: { type: :string, format: 'date-time', readOnly: true }
            },
            required: %w[nome_crime]
          },
          Usuario: {
            type: :object,
            properties: {
              id_usuario: { type: :integer, readOnly: true },
              nome_completo: { type: :string },
              cpf: { type: :string, nullable: true },
              email: { type: :string, format: :email },
              tipo_usuario: {
                type: :string,
                enum: ['Admin', 'Analista', 'Operador', 'Consulta'],
                default: 'Consulta'
              },
              orgao: { type: :string, nullable: true },
              cargo: { type: :string, nullable: true },
              ativo: { type: :boolean, default: true },
              ultimo_acesso: { type: :string, format: 'date-time', nullable: true },
              data_criacao: { type: :string, format: 'date-time', readOnly: true },
              data_atualizacao: { type: :string, format: 'date-time', readOnly: true }
            },
            required: %w[nome_completo email]
          },
          Auditoria: {
            type: :object,
            properties: {
              id_auditoria: { type: :integer, readOnly: true },
              id_usuario: { type: :integer, nullable: true },
              acao: { type: :string },
              tabela_afetada: { type: :string, nullable: true },
              id_registro_afetado: { type: :integer, nullable: true },
              dados_anteriores: { type: :object, nullable: true },
              dados_novos: { type: :object, nullable: true },
              ip_origem: { type: :string, format: :ipv4, nullable: true },
              user_agent: { type: :string, nullable: true },
              data_hora: { type: :string, format: 'date-time', readOnly: true }
            },
            required: %w[acao]
          },
          ComplexoHabitacional: {
            type: :object,
            properties: {
              id_complexo: { type: :integer, readOnly: true },
              nome_complexo: { type: :string },
              tipo_complexo: {
                type: :string,
                enum: ['Condomínio Privado', 'Conjunto Habitacional Popular', 'Residencial Minha Casa Minha Vida']
              },
              id_bairro: { type: :integer },
              latitude: { type: :number, format: :float, nullable: true },
              longitude: { type: :number, format: :float, nullable: true },
              numero_unidades: { type: :integer, nullable: true },
              populacao_estimada: { type: :integer, nullable: true },
              renda_media: { type: :number, format: :float, nullable: true },
              possui_seguranca: { type: :boolean, default: false },
              possui_controle_acesso: { type: :boolean, default: false },
              ano_inauguracao: { type: :integer, nullable: true },
              construtora: { type: :string, nullable: true },
              programa_governo: { type: :string, nullable: true },
              data_criacao: { type: :string, format: 'date-time', readOnly: true }
            },
            required: %w[nome_complexo tipo_complexo id_bairro]
          },
          EstatisticaBairro: {
            type: :object,
            properties: {
              id_estatistica: { type: :integer, readOnly: true },
              id_bairro: { type: :integer },
              ano: { type: :integer },
              mes: { type: :integer, nullable: true },
              total_ocorrencias: { type: :integer, default: 0 },
              total_crimes_cvp: { type: :integer, default: 0 },
              taxa_criminalidade_100k: { type: :number, format: :float, nullable: true },
              taxa_variacao_ano_anterior: { type: :number, format: :float, nullable: true },
              ranking_bairro: { type: :integer, nullable: true },
              percentual_crimes_zona: { type: :number, format: :float, nullable: true },
              crime_mais_frequente: { type: :string, nullable: true },
              periodo_maior_incidencia: { type: :string, nullable: true },
              data_calculo: { type: :string, format: 'date-time', readOnly: true }
            },
            required: %w[id_bairro ano]
          },
          IndicadorSocioeconomico: {
            type: :object,
            properties: {
              id_indicador: { type: :integer, readOnly: true },
              id_bairro: { type: :integer },
              ano_referencia: { type: :integer },
              indice_socioeconomico: { type: :number, format: :float, nullable: true },
              renda_media_mensal: { type: :number, format: :float, nullable: true },
              taxa_desemprego: { type: :number, format: :float, nullable: true },
              percentual_ensino_superior: { type: :number, format: :float, nullable: true },
              percentual_saneamento: { type: :number, format: :float, nullable: true },
              numero_estabelecimentos_comerciais: { type: :integer, nullable: true },
              numero_escolas: { type: :integer, nullable: true },
              numero_postos_saude: { type: :integer, nullable: true },
              iluminacao_publica: { type: :number, format: :float, nullable: true },
              presenca_policial: { type: :number, format: :float, nullable: true },
              distancia_centro_km: { type: :number, format: :float, nullable: true },
              qualidade_transporte_publico: { type: :number, format: :float, nullable: true },
              observacoes: { type: :string, nullable: true },
              data_criacao: { type: :string, format: 'date-time', readOnly: true },
              data_atualizacao: { type: :string, format: 'date-time', readOnly: true }
            },
            required: %w[id_bairro ano_referencia]
          },
          Pesquisa: {
            type: :object,
            properties: {
              id_pesquisa: { type: :integer, readOnly: true },
              id_complexo: { type: :integer, nullable: true },
              id_bairro: { type: :integer },
              data_pesquisa: { type: :string, format: :date },
              escolaridade: {
                type: :string,
                enum: ['Fundamental Incompleto', 'Fundamental Completo', 'Médio Incompleto', 'Médio Completo', 'Superior Incompleto', 'Superior Completo', 'Pós-graduação'],
                nullable: true
              },
              faixa_renda: {
                type: :string,
                enum: ['Até 1 SM', '1-3 SM', '3-6 SM', '6-9 SM', 'Acima de 9 SM'],
                nullable: true
              },
              zona_residencia_anterior: { type: :string, nullable: true },
              motivo_escolha_moradia: { type: :string, nullable: true },
              favoravel_normas_internas: { type: :boolean, nullable: true },
              zona_mais_violenta: { type: :string, nullable: true },
              concorda_controle_acesso: { type: :boolean, nullable: true },
              realiza_compras_local: { type: :boolean, nullable: true },
              interesse_mudanca: { type: :boolean, nullable: true },
              data_criacao: { type: :string, format: 'date-time', readOnly: true }
            },
            required: %w[id_bairro data_pesquisa]
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
