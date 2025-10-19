# frozen_string_literal: true

module Api
  module V1
    class OcorrenciasController < ApplicationController
      include Pagy::Backend

      before_action :set_ocorrencia, only: [ :show, :update, :destroy ]

      # GET /api/v1/ocorrencias
      def index
        records = Ocorrencia.all

        # Filtros automáticos opcionais: ?campo=valor
        records = apply_filters(records)

        # Paginação Pagy usando a chave primária correta
        # Aceita ?items=X ou ?per_page=X, com limite máximo de 5000
        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 5000].min  # Máximo de 5000 registros por página

        # Gerar chave de cache baseada nos parâmetros da request
        cache_key = generate_cache_key(limit)

        # Cache completo da resposta por 5 minutos (ajuste conforme necessário)
        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          # Usar contagem aproximada para melhor performance
          count = get_fast_count(records)

          # OTIMIZAÇÃO: Buscar apenas campos essenciais (reduz transferência de rede)
          pagy, ocorrencias = pagy(
            records.select(selected_fields).order(:id_ocorrencia),
            limit: limit,
            count: count
          )

          {
            current_page: pagy.page,
            per_page: pagy.limit,
            total_pages: pagy.pages,
            total_count: pagy.count,
            ocorrencias: ocorrencias.as_json
          }
        end

        render json: result
      end

      # GET /api/v1/ocorrencias/:id
      def show
        render json: @ocorrencia
      end

      # POST /api/v1/ocorrencias
      def create
        @ocorrencia = Ocorrencia.new(ocorrencia_params)

        if @ocorrencia.save
          # Enviar notificação em tempo real
          NotificationsService.broadcast_ocorrencia_criada(@ocorrencia)

          render json: @ocorrencia, status: :created
        else
          render json: @ocorrencia.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/ocorrencias/:id
      def update
        # Capturar o status anterior para detectar mudanças
        status_anterior = @ocorrencia.status_ocorrencia

        if @ocorrencia.update(ocorrencia_params)
          # Detectar mudanças e enviar notificação apropriada
          if status_anterior != @ocorrencia.status_ocorrencia
            if @ocorrencia.status_ocorrencia == "Resolvida"
              NotificationsService.broadcast_ocorrencia_finalizada(@ocorrencia)
            else
              NotificationsService.broadcast_ocorrencia_atualizada(@ocorrencia, {
                status: { from: status_anterior, to: @ocorrencia.status_ocorrencia }
              })
            end
          else
            NotificationsService.broadcast_ocorrencia_atualizada(@ocorrencia)
          end

          render json: @ocorrencia
        else
          render json: @ocorrencia.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/ocorrencias/:id
      def destroy
        # Salvar informações antes de deletar
        ocorrencia_id = @ocorrencia.id_ocorrencia
        numero_bo = @ocorrencia.numero_bo

        @ocorrencia.destroy!

        # Enviar notificação de remoção
        NotificationsService.broadcast_ocorrencia_removida(ocorrencia_id, numero_bo)

        head :no_content
      end

      private

      def set_ocorrencia
        # Usando a primary_key correta
        @ocorrencia = Ocorrencia.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Ocorrencia não encontrada" }, status: :not_found
      end

      def ocorrencia_params
        # Substitua pelos campos reais da sua tabela
        params.require(:ocorrencia).permit(
          :numero_bo,
          :id_tipo_crime,
          :id_bairro,
          :data_ocorrencia,
          :hora_ocorrencia,
          :dia_semana,
          :periodo_dia,
          :latitude_ocorrencia,
          :longitude_ocorrencia,
          :logradouro,
          :numero_endereco,
          :ponto_referencia,
          :descricao_ocorrencia,
          :vitimas,
          :valor_prejuizo,
          :recuperado,
          :status_ocorrencia,
          :origem_registro,
          :data_registro,
          :usuario_registro
        )
      end

      # Filtros automáticos via query string
      def apply_filters(records)
        filterable_fields = %w[numero_bo id_tipo_crime id_bairro data_ocorrencia periodo_dia status_ocorrencia]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end

      # Conta registros de forma otimizada
      # Usa contagem exata para queries pequenas ou com filtros
      # Usa contagem aproximada (estatísticas do PG) para queries grandes sem filtros
      def get_fast_count(records)
        # Se houver filtros aplicados, usar contagem exata (será mais rápida com índices)
        if params.keys.any? { |k| %w[numero_bo id_tipo_crime id_bairro data_ocorrencia periodo_dia status_ocorrencia].include?(k) }
          return records.count
        end

        # Para queries sem filtros, usar contagem aproximada do PostgreSQL
        # Isso é MUITO mais rápido para tabelas grandes
        Rails.cache.fetch("ocorrencias_total_count", expires_in: 1.hour) do
          Ocorrencia.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='ocorrencias'"
          )[0]["estimate"].to_i
        end
      end

      # Gera chave de cache baseada nos parâmetros da request
      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice(:numero_bo, :id_tipo_crime, :id_bairro, :data_ocorrencia, :periodo_dia, :status_ocorrencia, :page)
        "ocorrencias/index/#{filter_params.to_query}/limit-#{limit}"
      end

      # Define campos a serem selecionados (reduz transferência de dados)
      # Omite campos pesados que podem não ser necessários
      def selected_fields
        %w[
          id_ocorrencia
          numero_bo
          id_tipo_crime
          id_bairro
          data_ocorrencia
          hora_ocorrencia
          dia_semana
          periodo_dia
          latitude_ocorrencia
          longitude_ocorrencia
          status_ocorrencia
          vitimas
          recuperado
        ]
      end
    end
  end
end
