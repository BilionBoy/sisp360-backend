# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Zonas', type: :request do
  path '/api/v1/zonas' do
    get 'Lista todas as zonas' do
      tags 'Zonas'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :nome_zona, in: :query, type: :string, required: false, description: 'Filtrar por nome da zona'

      response '200', 'Lista de zonas' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer },
                 per_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer },
                 zonas: { type: :array, items: { '$ref' => '#/components/schemas/Zona' } }
               }
        run_test!
      end
    end

    post 'Cria uma nova zona' do
      tags 'Zonas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :zona, in: :body, schema: {
        type: :object,
        properties: {
          zona: { '$ref' => '#/components/schemas/Zona' }
        },
        required: ['zona']
      }

      response '201', 'Zona criada' do
        schema '$ref' => '#/components/schemas/Zona'
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end
  end

  path '/api/v1/zonas/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retorna uma zona específica' do
      tags 'Zonas'
      produces 'application/json'

      response '200', 'Zona encontrada' do
        schema '$ref' => '#/components/schemas/Zona'
        run_test!
      end

      response '404', 'Zona não encontrada' do
        run_test!
      end
    end

    patch 'Atualiza uma zona' do
      tags 'Zonas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :zona, in: :body, schema: {
        type: :object,
        properties: {
          zona: { '$ref' => '#/components/schemas/Zona' }
        }
      }

      response '200', 'Zona atualizada' do
        schema '$ref' => '#/components/schemas/Zona'
        run_test!
      end

      response '404', 'Zona não encontrada' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    put 'Atualiza uma zona' do
      tags 'Zonas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :zona, in: :body, schema: {
        type: :object,
        properties: {
          zona: { '$ref' => '#/components/schemas/Zona' }
        }
      }

      response '200', 'Zona atualizada' do
        schema '$ref' => '#/components/schemas/Zona'
        run_test!
      end

      response '404', 'Zona não encontrada' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    delete 'Remove uma zona' do
      tags 'Zonas'

      response '204', 'Zona removida' do
        run_test!
      end

      response '404', 'Zona não encontrada' do
        run_test!
      end
    end
  end
end
