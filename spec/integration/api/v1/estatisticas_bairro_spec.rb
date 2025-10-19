# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Estatísticas Bairro', type: :request do
  path '/api/v1/estatisticas_bairro' do
    get 'Lista todas as estatísticas de bairro' do
      tags 'Estatísticas'
      produces 'application/json'
      description 'Retorna estatísticas agregadas de criminalidade por bairro e período.'

      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :id_bairro, in: :query, type: :integer, required: false
      parameter name: :ano, in: :query, type: :integer, required: false
      parameter name: :mes, in: :query, type: :integer, required: false

      response '200', 'Lista de estatísticas de bairro' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer },
                 per_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer },
                 estatisticas_bairro: { type: :array, items: { '$ref' => '#/components/schemas/EstatisticaBairro' } }
               }
        run_test!
      end
    end

    post 'Cria uma nova estatística de bairro' do
      tags 'Estatísticas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :estatistica_bairro, in: :body, schema: {
        type: :object,
        properties: {
          estatistica_bairro: { '$ref' => '#/components/schemas/EstatisticaBairro' }
        },
        required: ['estatistica_bairro']
      }

      response '201', 'Estatística criada' do
        schema '$ref' => '#/components/schemas/EstatisticaBairro'
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end
  end

  path '/api/v1/estatisticas_bairro/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retorna uma estatística de bairro específica' do
      tags 'Estatísticas'
      produces 'application/json'

      response '200', 'Estatística encontrada' do
        schema '$ref' => '#/components/schemas/EstatisticaBairro'
        run_test!
      end

      response '404', 'Estatística não encontrada' do
        run_test!
      end
    end

    patch 'Atualiza uma estatística de bairro' do
      tags 'Estatísticas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :estatistica_bairro, in: :body, schema: {
        type: :object,
        properties: {
          estatistica_bairro: { '$ref' => '#/components/schemas/EstatisticaBairro' }
        }
      }

      response '200', 'Estatística atualizada' do
        schema '$ref' => '#/components/schemas/EstatisticaBairro'
        run_test!
      end

      response '404', 'Estatística não encontrada' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    put 'Atualiza uma estatística de bairro' do
      tags 'Estatísticas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :estatistica_bairro, in: :body, schema: {
        type: :object,
        properties: {
          estatistica_bairro: { '$ref' => '#/components/schemas/EstatisticaBairro' }
        }
      }

      response '200', 'Estatística atualizada' do
        schema '$ref' => '#/components/schemas/EstatisticaBairro'
        run_test!
      end

      response '404', 'Estatística não encontrada' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    delete 'Remove uma estatística de bairro' do
      tags 'Estatísticas'

      response '204', 'Estatística removida' do
        run_test!
      end

      response '404', 'Estatística não encontrada' do
        run_test!
      end
    end
  end
end
