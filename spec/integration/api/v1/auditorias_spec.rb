# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Auditorias', type: :request do
  path '/api/v1/auditorias' do
    get 'Lista todos os registros de auditoria' do
      tags 'Auditoria'
      produces 'application/json'
      description 'Lista logs de auditoria do sistema para rastreamento de ações dos usuários.'

      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :id_usuario, in: :query, type: :integer, required: false, description: 'Filtrar por ID do usuário'
      parameter name: :acao, in: :query, type: :string, required: false, description: 'Filtrar por tipo de ação'
      parameter name: :tabela_afetada, in: :query, type: :string, required: false, description: 'Filtrar por tabela afetada'

      response '200', 'Lista de auditorias' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer },
                 per_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer },
                 auditorias: { type: :array, items: { '$ref' => '#/components/schemas/Auditoria' } }
               }
        run_test!
      end
    end

    post 'Cria um novo registro de auditoria' do
      tags 'Auditoria'
      consumes 'application/json'
      produces 'application/json'
      description 'Registra uma ação de auditoria no sistema.'

      parameter name: :auditoria, in: :body, schema: {
        type: :object,
        properties: {
          auditoria: {
            type: :object,
            properties: {
              id_usuario: { type: :integer, example: 1, nullable: true },
              acao: { type: :string, example: 'CREATE' },
              tabela_afetada: { type: :string, example: 'ocorrencias', nullable: true },
              id_registro_afetado: { type: :integer, example: 123, nullable: true },
              dados_anteriores: {
                type: :object,
                example: { status: 'Registrada' },
                nullable: true
              },
              dados_novos: {
                type: :object,
                example: { status: 'Em Investigação' },
                nullable: true
              },
              ip_origem: { type: :string, format: :ipv4, example: '192.168.1.1', nullable: true },
              user_agent: { type: :string, example: 'Mozilla/5.0...', nullable: true }
            },
            required: %w[acao]
          }
        },
        required: ['auditoria']
      }

      response '201', 'Auditoria criada' do
        schema '$ref' => '#/components/schemas/Auditoria'
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end
  end

  path '/api/v1/auditorias/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retorna um registro de auditoria específico' do
      tags 'Auditoria'
      produces 'application/json'

      response '200', 'Auditoria encontrada' do
        schema '$ref' => '#/components/schemas/Auditoria'
        run_test!
      end

      response '404', 'Auditoria não encontrada' do
        run_test!
      end
    end

    patch 'Atualiza um registro de auditoria' do
      tags 'Auditoria'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :auditoria, in: :body, schema: {
        type: :object,
        properties: {
          auditoria: { '$ref' => '#/components/schemas/Auditoria' }
        }
      }

      response '200', 'Auditoria atualizada' do
        schema '$ref' => '#/components/schemas/Auditoria'
        run_test!
      end

      response '404', 'Auditoria não encontrada' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    put 'Atualiza um registro de auditoria' do
      tags 'Auditoria'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :auditoria, in: :body, schema: {
        type: :object,
        properties: {
          auditoria: { '$ref' => '#/components/schemas/Auditoria' }
        }
      }

      response '200', 'Auditoria atualizada' do
        schema '$ref' => '#/components/schemas/Auditoria'
        run_test!
      end

      response '404', 'Auditoria não encontrada' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    delete 'Remove um registro de auditoria' do
      tags 'Auditoria'

      response '204', 'Auditoria removida' do
        run_test!
      end

      response '404', 'Auditoria não encontrada' do
        run_test!
      end
    end
  end
end
