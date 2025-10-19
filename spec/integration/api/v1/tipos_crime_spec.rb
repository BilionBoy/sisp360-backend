# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Tipos Crime', type: :request do
  path '/api/v1/tipos_crime' do
    get 'Lista todos os tipos de crime' do
      tags 'Tipos de Crime'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :codigo_senasp, in: :query, type: :string, required: false, description: 'Filtrar por código SENASP'
      parameter name: :categoria, in: :query, type: :string, required: false,
                schema: { type: :string, enum: ['CVP', 'CVLI', 'Outros'] }
      parameter name: :gravidade, in: :query, type: :string, required: false,
                schema: { type: :string, enum: ['Baixa', 'Média', 'Alta', 'Altíssima'] }
      parameter name: :ativo, in: :query, type: :boolean, required: false
      parameter name: :nome_crime, in: :query, type: :string, required: false

      response '200', 'Lista de tipos de crime' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer },
                 per_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer },
                 tipos_crime: { type: :array, items: { '$ref' => '#/components/schemas/TipoCrime' } }
               }
        run_test!
      end
    end

    post 'Cria um novo tipo de crime' do
      tags 'Tipos de Crime'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :tipo_crime, in: :body, schema: {
        type: :object,
        properties: {
          tipo_crime: { '$ref' => '#/components/schemas/TipoCrime' }
        },
        required: ['tipo_crime']
      }

      response '201', 'Tipo de crime criado' do
        schema '$ref' => '#/components/schemas/TipoCrime'
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end
  end

  path '/api/v1/tipos_crime/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retorna um tipo de crime específico' do
      tags 'Tipos de Crime'
      produces 'application/json'

      response '200', 'Tipo de crime encontrado' do
        schema '$ref' => '#/components/schemas/TipoCrime'
        run_test!
      end

      response '404', 'Tipo de crime não encontrado' do
        run_test!
      end
    end

    patch 'Atualiza um tipo de crime' do
      tags 'Tipos de Crime'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :tipo_crime, in: :body, schema: {
        type: :object,
        properties: {
          tipo_crime: { '$ref' => '#/components/schemas/TipoCrime' }
        }
      }

      response '200', 'Tipo de crime atualizado' do
        schema '$ref' => '#/components/schemas/TipoCrime'
        run_test!
      end

      response '404', 'Tipo de crime não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    put 'Atualiza um tipo de crime' do
      tags 'Tipos de Crime'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :tipo_crime, in: :body, schema: {
        type: :object,
        properties: {
          tipo_crime: { '$ref' => '#/components/schemas/TipoCrime' }
        }
      }

      response '200', 'Tipo de crime atualizado' do
        schema '$ref' => '#/components/schemas/TipoCrime'
        run_test!
      end

      response '404', 'Tipo de crime não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    delete 'Remove um tipo de crime' do
      tags 'Tipos de Crime'

      response '204', 'Tipo de crime removido' do
        run_test!
      end

      response '404', 'Tipo de crime não encontrado' do
        run_test!
      end
    end
  end
end
