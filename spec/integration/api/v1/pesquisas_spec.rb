# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Pesquisas', type: :request do
  path '/api/v1/pesquisas' do
    get 'Lista todas as pesquisas' do
      tags 'Pesquisas'
      produces 'application/json'
      description 'Retorna dados de pesquisas sociais realizadas em bairros e complexos habitacionais.'

      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :id_bairro, in: :query, type: :integer, required: false
      parameter name: :id_complexo, in: :query, type: :integer, required: false
      parameter name: :data_pesquisa, in: :query, type: :string, format: :date, required: false

      response '200', 'Lista de pesquisas' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer },
                 per_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer },
                 pesquisas: { type: :array, items: { '$ref' => '#/components/schemas/Pesquisa' } }
               }
        run_test!
      end
    end

    post 'Cria uma nova pesquisa' do
      tags 'Pesquisas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :pesquisa, in: :body, schema: {
        type: :object,
        properties: {
          pesquisa: { '$ref' => '#/components/schemas/Pesquisa' }
        },
        required: ['pesquisa']
      }

      response '201', 'Pesquisa criada' do
        schema '$ref' => '#/components/schemas/Pesquisa'
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end
  end

  path '/api/v1/pesquisas/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retorna uma pesquisa específica' do
      tags 'Pesquisas'
      produces 'application/json'

      response '200', 'Pesquisa encontrada' do
        schema '$ref' => '#/components/schemas/Pesquisa'
        run_test!
      end

      response '404', 'Pesquisa não encontrada' do
        run_test!
      end
    end

    patch 'Atualiza uma pesquisa' do
      tags 'Pesquisas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :pesquisa, in: :body, schema: {
        type: :object,
        properties: {
          pesquisa: { '$ref' => '#/components/schemas/Pesquisa' }
        }
      }

      response '200', 'Pesquisa atualizada' do
        schema '$ref' => '#/components/schemas/Pesquisa'
        run_test!
      end

      response '404', 'Pesquisa não encontrada' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    put 'Atualiza uma pesquisa' do
      tags 'Pesquisas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :pesquisa, in: :body, schema: {
        type: :object,
        properties: {
          pesquisa: { '$ref' => '#/components/schemas/Pesquisa' }
        }
      }

      response '200', 'Pesquisa atualizada' do
        schema '$ref' => '#/components/schemas/Pesquisa'
        run_test!
      end

      response '404', 'Pesquisa não encontrada' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    delete 'Remove uma pesquisa' do
      tags 'Pesquisas'

      response '204', 'Pesquisa removida' do
        run_test!
      end

      response '404', 'Pesquisa não encontrada' do
        run_test!
      end
    end
  end
end
