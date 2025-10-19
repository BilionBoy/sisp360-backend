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

        @pagy, @estatisticas_bairro = pagy(records.order(:id_estatistica))

        render json: {
          current_page: @pagy.page,
          per_page: @pagy.limit,
          total_pages: @pagy.pages,
          total_count: @pagy.count,
          estatisticas_bairro: ActiveModelSerializers::SerializableResource.new(@estatisticas_bairro)
        }
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
    end
  end
end
