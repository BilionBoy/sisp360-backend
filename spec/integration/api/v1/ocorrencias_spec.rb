# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'API V1 Ocorrências', type: :request do
  path '/api/v1/ocorrencias' do
    get 'Lista todas as ocorrências criminais' do
      tags 'Ocorrências'
      produces 'application/json'

      parameter name: :page, in: :query, type: :integer, required: false,
                description: 'Número da página (default: 1)'
      parameter name: :items, in: :query, type: :integer, required: false,
                description: 'Itens por página (default: 25)'
      parameter name: :numero_bo, in: :query, type: :string, required: false,
                description: 'Filtrar por número do Boletim de Ocorrência'
      parameter name: :id_tipo_crime, in: :query, type: :integer, required: false,
                description: 'Filtrar por ID do tipo de crime'
      parameter name: :id_bairro, in: :query, type: :integer, required: false,
                description: 'Filtrar por ID do bairro'
      parameter name: :data_ocorrencia, in: :query, type: :string, format: :date, required: false,
                description: 'Filtrar por data da ocorrência (YYYY-MM-DD)'
      parameter name: :periodo_dia, in: :query, type: :string, required: false,
                description: 'Filtrar por período do dia',
                schema: {
                  type: :string,
                  enum: ['Madrugada', 'Manhã', 'Tarde', 'Noite']
                }
      parameter name: :status_ocorrencia, in: :query, type: :string, required: false,
                description: 'Filtrar por status da ocorrência',
                schema: {
                  type: :string,
                  enum: ['Registrada', 'Em Investigação', 'Resolvida', 'Arquivada']
                }

      response '200', 'Lista de ocorrências com paginação' do
        schema type: :object,
               properties: {
                 current_page: { type: :integer, example: 1 },
                 per_page: { type: :integer, example: 25 },
                 total_pages: { type: :integer, example: 10 },
                 total_count: { type: :integer, example: 250 },
                 ocorrencias: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Ocorrencia' }
                 }
               },
               required: %w[current_page per_page total_pages total_count ocorrencias]

        run_test!
      end
    end

    post 'Cria uma nova ocorrência' do
      tags 'Ocorrências'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :ocorrencia, in: :body, schema: {
        type: :object,
        properties: {
          ocorrencia: {
            type: :object,
            properties: {
              numero_bo: { type: :string, example: 'BO-2024-001234' },
              id_tipo_crime: { type: :integer, example: 1 },
              id_bairro: { type: :integer, example: 5 },
              data_ocorrencia: { type: :string, format: :date, example: '2024-01-15' },
              hora_ocorrencia: { type: :string, format: :time, example: '14:30:00' },
              dia_semana: {
                type: :string,
                enum: ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'],
                example: 'Segunda'
              },
              periodo_dia: {
                type: :string,
                enum: ['Madrugada', 'Manhã', 'Tarde', 'Noite'],
                example: 'Tarde'
              },
              latitude_ocorrencia: { type: :number, format: :float, example: -8.7619 },
              longitude_ocorrencia: { type: :number, format: :float, example: -63.8722 },
              logradouro: { type: :string, example: 'Av. Jorge Teixeira' },
              numero_endereco: { type: :string, example: '1500' },
              ponto_referencia: { type: :string, example: 'Próximo ao supermercado' },
              descricao_ocorrencia: { type: :string, example: 'Furto de veículo na via pública' },
              vitimas: { type: :integer, example: 1, default: 1 },
              valor_prejuizo: { type: :number, format: :float, example: 25000.00 },
              recuperado: { type: :boolean, example: false, default: false },
              status_ocorrencia: {
                type: :string,
                enum: ['Registrada', 'Em Investigação', 'Resolvida', 'Arquivada'],
                example: 'Registrada',
                default: 'Registrada'
              },
              origem_registro: {
                type: :string,
                enum: ['PM', 'PC', 'Sistema Integrado', 'Outro'],
                example: 'PM',
                default: 'PM'
              },
              usuario_registro: { type: :string, example: 'joao.silva' }
            },
            required: %w[id_tipo_crime id_bairro data_ocorrencia]
          }
        },
        required: ['ocorrencia']
      }

      response '201', 'Ocorrência criada com sucesso' do
        schema '$ref' => '#/components/schemas/Ocorrencia'
        run_test!
      end

      response '422', 'Erro de validação' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   additionalProperties: { type: :array, items: { type: :string } }
                 }
               },
               example: {
                 errors: {
                   id_tipo_crime: ["can't be blank"],
                   id_bairro: ["can't be blank"],
                   data_ocorrencia: ["can't be blank"]
                 }
               }
        run_test!
      end
    end
  end

  path '/api/v1/ocorrencias/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'ID da ocorrência', required: true

    get 'Retorna uma ocorrência específica' do
      tags 'Ocorrências'
      produces 'application/json'

      response '200', 'Ocorrência encontrada' do
        schema '$ref' => '#/components/schemas/Ocorrencia'
        run_test!
      end

      response '404', 'Ocorrência não encontrada' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Ocorrencia não encontrada' }
               }
        run_test!
      end
    end

    patch 'Atualiza uma ocorrência' do
      tags 'Ocorrências'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :ocorrencia, in: :body, schema: {
        type: :object,
        properties: {
          ocorrencia: {
            type: :object,
            properties: {
              numero_bo: { type: :string },
              id_tipo_crime: { type: :integer },
              id_bairro: { type: :integer },
              data_ocorrencia: { type: :string, format: :date },
              hora_ocorrencia: { type: :string, format: :time },
              dia_semana: {
                type: :string,
                enum: ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo']
              },
              periodo_dia: {
                type: :string,
                enum: ['Madrugada', 'Manhã', 'Tarde', 'Noite']
              },
              latitude_ocorrencia: { type: :number, format: :float },
              longitude_ocorrencia: { type: :number, format: :float },
              logradouro: { type: :string },
              numero_endereco: { type: :string },
              ponto_referencia: { type: :string },
              descricao_ocorrencia: { type: :string },
              vitimas: { type: :integer },
              valor_prejuizo: { type: :number, format: :float },
              recuperado: { type: :boolean },
              status_ocorrencia: {
                type: :string,
                enum: ['Registrada', 'Em Investigação', 'Resolvida', 'Arquivada']
              },
              origem_registro: {
                type: :string,
                enum: ['PM', 'PC', 'Sistema Integrado', 'Outro']
              },
              usuario_registro: { type: :string }
            }
          }
        },
        required: ['ocorrencia']
      }

      response '200', 'Ocorrência atualizada com sucesso' do
        schema '$ref' => '#/components/schemas/Ocorrencia'
        run_test!
      end

      response '404', 'Ocorrência não encontrada' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Ocorrencia não encontrada' }
               }
        run_test!
      end

      response '422', 'Erro de validação' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   additionalProperties: { type: :array, items: { type: :string } }
                 }
               }
        run_test!
      end
    end

    put 'Atualiza uma ocorrência' do
      tags 'Ocorrências'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :ocorrencia, in: :body, schema: {
        type: :object,
        properties: {
          ocorrencia: {
            type: :object,
            properties: {
              numero_bo: { type: :string },
              id_tipo_crime: { type: :integer },
              id_bairro: { type: :integer },
              data_ocorrencia: { type: :string, format: :date },
              hora_ocorrencia: { type: :string, format: :time },
              dia_semana: {
                type: :string,
                enum: ['Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo']
              },
              periodo_dia: {
                type: :string,
                enum: ['Madrugada', 'Manhã', 'Tarde', 'Noite']
              },
              latitude_ocorrencia: { type: :number, format: :float },
              longitude_ocorrencia: { type: :number, format: :float },
              logradouro: { type: :string },
              numero_endereco: { type: :string },
              ponto_referencia: { type: :string },
              descricao_ocorrencia: { type: :string },
              vitimas: { type: :integer },
              valor_prejuizo: { type: :number, format: :float },
              recuperado: { type: :boolean },
              status_ocorrencia: {
                type: :string,
                enum: ['Registrada', 'Em Investigação', 'Resolvida', 'Arquivada']
              },
              origem_registro: {
                type: :string,
                enum: ['PM', 'PC', 'Sistema Integrado', 'Outro']
              },
              usuario_registro: { type: :string }
            }
          }
        },
        required: ['ocorrencia']
      }

      response '200', 'Ocorrência atualizada com sucesso' do
        schema '$ref' => '#/components/schemas/Ocorrencia'
        run_test!
      end

      response '404', 'Ocorrência não encontrada' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Ocorrencia não encontrada' }
               }
        run_test!
      end

      response '422', 'Erro de validação' do
        schema type: :object,
               properties: {
                 errors: {
                   type: :object,
                   additionalProperties: { type: :array, items: { type: :string } }
                 }
               }
        run_test!
      end
    end

    delete 'Remove uma ocorrência' do
      tags 'Ocorrências'
      produces 'application/json'

      response '204', 'Ocorrência removida com sucesso' do
        run_test!
      end

      response '404', 'Ocorrência não encontrada' do
        schema type: :object,
               properties: {
                 error: { type: :string, example: 'Ocorrencia não encontrada' }
               }
        run_test!
      end
    end
  end
end
