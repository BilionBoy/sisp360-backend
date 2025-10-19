# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Usuários', type: :request do
  path '/api/v1/usuarios' do
    get 'Lista todos os usuários' do
      tags 'Usuários'
      produces 'application/json'
      description 'Lista todos os usuários do sistema. Nota: o campo senha_hash não é retornado nas respostas.'

      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :items, in: :query, type: :integer, required: false
      parameter name: :tipo_usuario, in: :query, type: :string, required: false,
                schema: { type: :string, enum: ['Admin', 'Analista', 'Operador', 'Consulta'] }
      parameter name: :ativo, in: :query, type: :boolean, required: false
      parameter name: :email, in: :query, type: :string, required: false

      response '200', 'Lista de usuários' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer },
                 per_page: { type: :integer },
                 total_pages: { type: :integer },
                 total_count: { type: :integer },
                 usuarios: { type: :array, items: { '$ref' => '#/components/schemas/Usuario' } }
               }
        run_test!
      end
    end

    post 'Cria um novo usuário' do
      tags 'Usuários'
      consumes 'application/json'
      produces 'application/json'
      description 'Cria um novo usuário. O campo senha_hash deve ser fornecido na criação mas não será retornado nas respostas.'

      parameter name: :usuario, in: :body, schema: {
        type: :object,
        properties: {
          usuario: {
            type: :object,
            properties: {
              nome_completo: { type: :string, example: 'João da Silva' },
              cpf: { type: :string, example: '123.456.789-00' },
              email: { type: :string, format: :email, example: 'joao.silva@gov.br' },
              senha_hash: { type: :string, example: 'hashed_password_here' },
              tipo_usuario: {
                type: :string,
                enum: ['Admin', 'Analista', 'Operador', 'Consulta'],
                example: 'Analista'
              },
              orgao: { type: :string, example: 'Polícia Militar' },
              cargo: { type: :string, example: 'Analista de Segurança' },
              ativo: { type: :boolean, example: true }
            },
            required: %w[nome_completo email senha_hash]
          }
        },
        required: ['usuario']
      }

      response '201', 'Usuário criado' do
        schema '$ref' => '#/components/schemas/Usuario'
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end
  end

  path '/api/v1/usuarios/{id}' do
    parameter name: :id, in: :path, type: :integer, required: true

    get 'Retorna um usuário específico' do
      tags 'Usuários'
      produces 'application/json'
      description 'Retorna detalhes de um usuário. O campo senha_hash não é retornado.'

      response '200', 'Usuário encontrado' do
        schema '$ref' => '#/components/schemas/Usuario'
        run_test!
      end

      response '404', 'Usuário não encontrado' do
        run_test!
      end
    end

    patch 'Atualiza um usuário' do
      tags 'Usuários'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :usuario, in: :body, schema: {
        type: :object,
        properties: {
          usuario: { '$ref' => '#/components/schemas/Usuario' }
        }
      }

      response '200', 'Usuário atualizado' do
        schema '$ref' => '#/components/schemas/Usuario'
        run_test!
      end

      response '404', 'Usuário não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    put 'Atualiza um usuário' do
      tags 'Usuários'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :usuario, in: :body, schema: {
        type: :object,
        properties: {
          usuario: { '$ref' => '#/components/schemas/Usuario' }
        }
      }

      response '200', 'Usuário atualizado' do
        schema '$ref' => '#/components/schemas/Usuario'
        run_test!
      end

      response '404', 'Usuário não encontrado' do
        run_test!
      end

      response '422', 'Erro de validação' do
        run_test!
      end
    end

    delete 'Remove um usuário' do
      tags 'Usuários'

      response '204', 'Usuário removido' do
        run_test!
      end

      response '404', 'Usuário não encontrado' do
        run_test!
      end
    end
  end
end
