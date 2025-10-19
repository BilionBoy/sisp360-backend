# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Bairros', type: :request do
  path '/api/v1/bairros' do
    get 'Lista todos os bairros' do
      tags 'Bairros'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :id_zona, in: :query, type: :integer, required: false, description: 'Filtrar por ID da zona'
      parameter name: :nome_bairro, in: :query, type: :string, required: false, description: 'Filtrar por nome do bairro'
      parameter name: :codigo_ibge, in: :query, type: :string, required: false, description: 'Filtrar por código IBGE'
      parameter name: :status_bairro, in: :query, type: :string, required: false,
                schema: { type: :string, enum: ['Oficial', 'Não Oficial', 'Em Processo'] }

      response '200', 'Lista de bairros' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer },
                 per_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer },
                 bairros: { type: :array, items: { '$ref' => '#/components/schemas/Bairro' } }
               }
        run_test!
      end
    end

    post 'Cria um novo bairro' do
      tags 'Bairros'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :bairro, in: :body, schema: {
        type: :object,
        properties: {
          bairro: { '$ref' => '#/components/schemas/Bairro' }
        },
        required: ['bairro']
      }

      response '201', 'Bairro criado' do
        schema '$ref' => '#/components/schemas/Bairro'
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end
  end

  path '/api/v1/bairros/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retorna um bairro específico' do
      tags 'Bairros'
      produces 'application/json'

      response '200', 'Bairro encontrado' do
        schema '$ref' => '#/components/schemas/Bairro'
        run_test!
      end

      response '404', 'Bairro não encontrado' do
        run_test!
      end
    end

    patch 'Atualiza um bairro' do
      tags 'Bairros'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :bairro, in: :body, schema: {
        type: :object,
        properties: {
          bairro: { '$ref' => '#/components/schemas/Bairro' }
        }
      }

      response '200', 'Bairro atualizado' do
        schema '$ref' => '#/components/schemas/Bairro'
        run_test!
      end

      response '404', 'Bairro não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    put 'Atualiza um bairro' do
      tags 'Bairros'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :bairro, in: :body, schema: {
        type: :object,
        properties: {
          bairro: { '$ref' => '#/components/schemas/Bairro' }
        }
      }

      response '200', 'Bairro atualizado' do
        schema '$ref' => '#/components/schemas/Bairro'
        run_test!
      end

      response '404', 'Bairro não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    delete 'Remove um bairro' do
      tags 'Bairros'

      response '204', 'Bairro removido' do
        run_test!
      end

      response '404', 'Bairro não encontrado' do
        run_test!
      end
    end
  end
end
