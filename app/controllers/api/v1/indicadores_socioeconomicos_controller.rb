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

        @pagy, @indicadores_socioeconomicos = pagy(records.order(:id_indicador))

        render json: {
          current_page: @pagy.page,
          per_page: @pagy.limit,
          total_pages: @pagy.pages,
          total_count: @pagy.count,
          indicadores_socioeconomicos: ActiveModelSerializers::SerializableResource.new(@indicadores_socioeconomicos)
        }
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
    end
  end
end
