# frozen_string_literal: true

module Api
  module V1
    class AuditoriasController < ApplicationController
      include Pagy::Backend

      before_action :set_auditoria, only: [ :show, :update, :destroy ]

      # GET /api/v1/auditorias
      def index
        records = Auditoria.all
        records = apply_filters(records)

        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 5000].min

        cache_key = generate_cache_key(limit)

        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          count = get_fast_count(records)

          @pagy, @auditorias = pagy(
            records.select(selected_fields).order(id_auditoria: :desc),
            limit: limit,
            count: count
          )

          {
            current_page: @pagy.page,
            per_page: @pagy.limit,
            total_pages: @pagy.pages,
            total_count: @pagy.count,
            auditorias: @auditorias.as_json(only: selected_fields)
          }
        end

        render json: result
      end

      # GET /api/v1/auditorias/:id
      def show
        render json: @auditoria
      end

      # POST /api/v1/auditorias
      def create
        @auditoria = Auditoria.new(auditoria_params)

        if @auditoria.save
          render json: @auditoria, status: :created
        else
          render json: @auditoria.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/auditorias/:id
      def update
        if @auditoria.update(auditoria_params)
          render json: @auditoria
        else
          render json: @auditoria.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/auditorias/:id
      def destroy
        @auditoria.destroy!
        head :no_content
      end

      private

      def set_auditoria
        @auditoria = Auditoria.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Auditoria não encontrada" }, status: :not_found
      end

      def auditoria_params
        params.require(:auditoria).permit(
          :id_usuario,
          :acao,
          :tabela_afetada,
          :id_registro_afetado,
          :dados_anteriores,
          :dados_novos,
          :ip_origem,
          :user_agent,
          :data_hora
        )
      end

      def apply_filters(records)
        filterable_fields = %w[id_usuario acao tabela_afetada id_registro_afetado data_hora]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end

      def selected_fields
        # Exclude large JSON fields (dados_anteriores, dados_novos) from listing
        # They're available in the show endpoint
        %w[
          id_auditoria id_usuario acao tabela_afetada
          id_registro_afetado ip_origem data_hora
        ]
      end

      def get_fast_count(records)
        filterable_fields = %w[id_usuario acao tabela_afetada id_registro_afetado data_hora]
        if params.keys.any? { |k| filterable_fields.include?(k) }
          return records.count
        end

        Rails.cache.fetch("auditorias_total_count", expires_in: 1.hour) do
          Auditoria.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='auditorias'"
          )[0]["estimate"].to_i
        end
      end

      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice(
          "id_usuario", "acao", "tabela_afetada", "id_registro_afetado", "data_hora", "page"
        )
        "auditorias_index_#{filter_params.to_json}_limit_#{limit}"
      end
    end
  end
end
