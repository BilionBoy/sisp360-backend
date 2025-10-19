# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Indicadores Socioeconômicos', type: :request do
  path '/api/v1/indicadores_socioeconomicos' do
    get 'Lista todos os indicadores socioeconômicos' do
      tags 'Indicadores Socioeconômicos'
      produces 'application/json'
      description 'Retorna indicadores socioeconômicos por bairro para análise de correlação com criminalidade.'

      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :id_bairro, in: :query, type: :integer, required: false
      parameter name: :ano_referencia, in: :query, type: :integer, required: false

      response '200', 'Lista de indicadores socioeconômicos' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer },
                 per_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer },
                 indicadores_socioeconomicos: { type: :array, items: { '$ref' => '#/components/schemas/IndicadorSocioeconomico' } }
               }
        run_test!
      end
    end

    post 'Cria um novo indicador socioeconômico' do
      tags 'Indicadores Socioeconômicos'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :indicador_socioeconomico, in: :body, schema: {
        type: :object,
        properties: {
          indicador_socioeconomico: { '$ref' => '#/components/schemas/IndicadorSocioeconomico' }
        },
        required: ['indicador_socioeconomico']
      }

      response '201', 'Indicador socioeconômico criado' do
        schema '$ref' => '#/components/schemas/IndicadorSocioeconomico'
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end
  end

  path '/api/v1/indicadores_socioeconomicos/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retorna um indicador socioeconômico específico' do
      tags 'Indicadores Socioeconômicos'
      produces 'application/json'

      response '200', 'Indicador socioeconômico encontrado' do
        schema '$ref' => '#/components/schemas/IndicadorSocioeconomico'
        run_test!
      end

      response '404', 'Indicador socioeconômico não encontrado' do
        run_test!
      end
    end

    patch 'Atualiza um indicador socioeconômico' do
      tags 'Indicadores Socioeconômicos'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :indicador_socioeconomico, in: :body, schema: {
        type: :object,
        properties: {
          indicador_socioeconomico: { '$ref' => '#/components/schemas/IndicadorSocioeconomico' }
        }
      }

      response '200', 'Indicador socioeconômico atualizado' do
        schema '$ref' => '#/components/schemas/IndicadorSocioeconomico'
        run_test!
      end

      response '404', 'Indicador socioeconômico não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    put 'Atualiza um indicador socioeconômico' do
      tags 'Indicadores Socioeconômicos'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :indicador_socioeconomico, in: :body, schema: {
        type: :object,
        properties: {
          indicador_socioeconomico: { '$ref' => '#/components/schemas/IndicadorSocioeconomico' }
        }
      }

      response '200', 'Indicador socioeconômico atualizado' do
        schema '$ref' => '#/components/schemas/IndicadorSocioeconomico'
        run_test!
      end

      response '404', 'Indicador socioeconômico não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    delete 'Remove um indicador socioeconômico' do
      tags 'Indicadores Socioeconômicos'

      response '204', 'Indicador socioeconômico removido' do
        run_test!
      end

      response '404', 'Indicador socioeconômico não encontrado' do
        run_test!
      end
    end
  end
end
