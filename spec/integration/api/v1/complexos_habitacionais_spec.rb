# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Complexos Habitacionais', type: :request do
  path '/api/v1/complexos_habitacionais' do
    get 'Lista todos os complexos habitacionais' do
      tags 'Complexos Habitacionais'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :id_bairro, in: :query, type: :integer, required: false
      parameter name: :tipo_complexo, in: :query, type: :string, required: false,
                schema: { type: :string, enum: ['Condomínio Privado', 'Conjunto Habitacional Popular', 'Residencial Minha Casa Minha Vida'] }

      response '200', 'Lista de complexos habitacionais' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer },
                 per_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer },
                 complexos_habitacionais: { type: :array, items: { '$ref' => '#/components/schemas/ComplexoHabitacional' } }
               }
        run_test!
      end
    end

    post 'Cria um novo complexo habitacional' do
      tags 'Complexos Habitacionais'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :complexo_habitacional, in: :body, schema: {
        type: :object,
        properties: {
          complexo_habitacional: { '$ref' => '#/components/schemas/ComplexoHabitacional' }
        },
        required: ['complexo_habitacional']
      }

      response '201', 'Complexo habitacional criado' do
        schema '$ref' => '#/components/schemas/ComplexoHabitacional'
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end
  end

  path '/api/v1/complexos_habitacionais/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retorna um complexo habitacional específico' do
      tags 'Complexos Habitacionais'
      produces 'application/json'

      response '200', 'Complexo habitacional encontrado' do
        schema '$ref' => '#/components/schemas/ComplexoHabitacional'
        run_test!
      end

      response '404', 'Complexo habitacional não encontrado' do
        run_test!
      end
    end

    patch 'Atualiza um complexo habitacional' do
      tags 'Complexos Habitacionais'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :complexo_habitacional, in: :body, schema: {
        type: :object,
        properties: {
          complexo_habitacional: { '$ref' => '#/components/schemas/ComplexoHabitacional' }
        }
      }

      response '200', 'Complexo habitacional atualizado' do
        schema '$ref' => '#/components/schemas/ComplexoHabitacional'
        run_test!
      end

      response '404', 'Complexo habitacional não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    put 'Atualiza um complexo habitacional' do
      tags 'Complexos Habitacionais'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :complexo_habitacional, in: :body, schema: {
        type: :object,
        properties: {
          complexo_habitacional: { '$ref' => '#/components/schemas/ComplexoHabitacional' }
        }
      }

      response '200', 'Complexo habitacional atualizado' do
        schema '$ref' => '#/components/schemas/ComplexoHabitacional'
        run_test!
      end

      response '404', 'Complexo habitacional não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    delete 'Remove um complexo habitacional' do
      tags 'Complexos Habitacionais'

      response '204', 'Complexo habitacional removido' do
        run_test!
      end

      response '404', 'Complexo habitacional não encontrado' do
        run_test!
      end
    end
  end
end
