# frozen_string_literal: true

module Api
  module V1
    class EstatisticasBairroController < ApplicationController
      include Pagy::Backend

      before_action :set_estatistica_bairro, only: [ :show, :update, :destroy ]

      # GET /api/v1/estatisticas_bairro
      def index
        records = EstatisticaBairro.all
        records = apply_filters(records)

        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 1000].min

        cache_key = generate_cache_key(limit)

        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          count = get_fast_count(records)

          @pagy, @estatisticas_bairro = pagy(
            records.select(selected_fields).order(ano: :desc, mes: :desc, id_estatistica: :desc),
            limit: limit,
            count: count
          )

          {
            current_page: @pagy.page,
            per_page: @pagy.limit,
            total_pages: @pagy.pages,
            total_count: @pagy.count,
            estatisticas_bairro: @estatisticas_bairro.as_json(only: selected_fields)
          }
        end

        render json: result
      end

      # GET /api/v1/estatisticas_bairro/:id
      def show
        render json: @estatistica_bairro
      end

      # POST /api/v1/estatisticas_bairro
      def create
        @estatistica_bairro = EstatisticaBairro.new(estatistica_bairro_params)

        if @estatistica_bairro.save
          render json: @estatistica_bairro, status: :created
        else
          render json: @estatistica_bairro.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/estatisticas_bairro/:id
      def update
        if @estatistica_bairro.update(estatistica_bairro_params)
          render json: @estatistica_bairro
        else
          render json: @estatistica_bairro.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/estatisticas_bairro/:id
      def destroy
        @estatistica_bairro.destroy!
        head :no_content
      end

      private

      def set_estatistica_bairro
        @estatistica_bairro = EstatisticaBairro.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "EstatisticaBairro não encontrada" }, status: :not_found
      end

      def estatistica_bairro_params
        params.require(:estatistica_bairro).permit(
          :id_bairro,
          :ano,
          :mes,
          :total_ocorrencias,
          :total_crimes_cvp,
          :taxa_criminalidade_100k,
          :taxa_variacao_ano_anterior,
          :ranking_bairro,
          :percentual_crimes_zona,
          :crime_mais_frequente,
          :periodo_maior_incidencia,
          :data_calculo
        )
      end

      def apply_filters(records)
        filterable_fields = %w[id_bairro ano mes ranking_bairro]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end

      def selected_fields
        %w[
          id_estatistica id_bairro ano mes
          total_ocorrencias total_crimes_cvp
          taxa_criminalidade_100k taxa_variacao_ano_anterior
          ranking_bairro percentual_crimes_zona
          crime_mais_frequente periodo_maior_incidencia
        ]
      end

      def get_fast_count(records)
        filterable_fields = %w[id_bairro ano mes ranking_bairro]
        if params.keys.any? { |k| filterable_fields.include?(k) }
          return records.count
        end

        Rails.cache.fetch("estatisticas_bairro_total_count", expires_in: 1.hour) do
          EstatisticaBairro.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='estatisticas_bairro'"
          )[0]["estimate"].to_i
        end
      end

      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice(
          "id_bairro", "ano", "mes", "ranking_bairro", "page"
        )
        "estatisticas_bairro_index_#{filter_params.to_json}_limit_#{limit}"
      end
    end
  end
end
