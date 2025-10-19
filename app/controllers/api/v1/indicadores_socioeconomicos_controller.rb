# frozen_string_literal: true

module Api
  module V1
    class IndicadoresSocioeconomicosController < ApplicationController
      include Pagy::Backend

      before_action :set_indicador_socioeconomico, only: [ :show, :update, :destroy ]

      # GET /api/v1/indicadores_socioeconomicos
      def index
        records = IndicadorSocioeconomico.all
        records = apply_filters(records)

        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 5000].min

        cache_key = generate_cache_key(limit)

        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          count = get_fast_count(records)

          @pagy, @indicadores_socioeconomicos = pagy(
            records.select(selected_fields).order(ano_referencia: :desc, id_indicador: :desc),
            limit: limit,
            count: count
          )

          {
            current_page: @pagy.page,
            per_page: @pagy.limit,
            total_pages: @pagy.pages,
            total_count: @pagy.count,
            indicadores_socioeconomicos: @indicadores_socioeconomicos.as_json(only: selected_fields)
          }
        end

        render json: result
      end

      # GET /api/v1/indicadores_socioeconomicos/:id
      def show
        render json: @indicador_socioeconomico
      end

      # POST /api/v1/indicadores_socioeconomicos
      def create
        @indicador_socioeconomico = IndicadorSocioeconomico.new(indicador_socioeconomico_params)

        if @indicador_socioeconomico.save
          render json: @indicador_socioeconomico, status: :created
        else
          render json: @indicador_socioeconomico.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/indicadores_socioeconomicos/:id
      def update
        if @indicador_socioeconomico.update(indicador_socioeconomico_params)
          render json: @indicador_socioeconomico
        else
          render json: @indicador_socioeconomico.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/indicadores_socioeconomicos/:id
      def destroy
        @indicador_socioeconomico.destroy!
        head :no_content
      end

      private

      def set_indicador_socioeconomico
        @indicador_socioeconomico = IndicadorSocioeconomico.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "IndicadorSocioeconomico não encontrado" }, status: :not_found
      end

      def indicador_socioeconomico_params
        params.require(:indicador_socioeconomico).permit(
          :id_bairro,
          :ano_referencia,
          :indice_socioeconomico,
          :renda_media_mensal,
          :taxa_desemprego,
          :percentual_ensino_superior,
          :percentual_saneamento,
          :numero_estabelecimentos_comerciais,
          :numero_escolas,
          :numero_postos_saude,
          :iluminacao_publica,
          :presenca_policial,
          :distancia_centro_km,
          :qualidade_transporte_publico,
          :observacoes,
          :data_criacao,
          :data_atualizacao
        )
      end

      def apply_filters(records)
        filterable_fields = %w[id_bairro ano_referencia]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end

      def selected_fields
        # Exclude observacoes (TEXT field) from listing
        %w[
          id_indicador id_bairro ano_referencia indice_socioeconomico
          renda_media_mensal taxa_desemprego percentual_ensino_superior
          percentual_saneamento numero_estabelecimentos_comerciais
          numero_escolas numero_postos_saude iluminacao_publica
          presenca_policial distancia_centro_km qualidade_transporte_publico
        ]
      end

      def get_fast_count(records)
        filterable_fields = %w[id_bairro ano_referencia]
        if params.keys.any? { |k| filterable_fields.include?(k) }
          return records.count
        end

        Rails.cache.fetch("indicadores_socioeconomicos_total_count", expires_in: 1.hour) do
          IndicadorSocioeconomico.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='indicadores_socioeconomicos'"
          )[0]["estimate"].to_i
        end
      end

      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice(
          "id_bairro", "ano_referencia", "page"
        )
        "indicadores_socioeconomicos_index_#{filter_params.to_json}_limit_#{limit}"
      end
    end
  end
end
