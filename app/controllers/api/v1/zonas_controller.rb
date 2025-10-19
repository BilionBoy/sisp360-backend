# frozen_string_literal: true

module Api
  module V1
    class ZonasController < ApplicationController
      include Pagy::Backend

      before_action :set_zona, only: [ :show, :update, :destroy ]

      # GET /api/v1/zonas
      def index
        records = Zona.all
        records = apply_filters(records)

        @pagy, @zonas = pagy(records.order(:id_zona))

        render json: {
          current_page: @pagy.page,
          per_page: @pagy.limit,
          total_pages: @pagy.pages,
          total_count: @pagy.count,
          zonas: ActiveModelSerializers::SerializableResource.new(@zonas)
        }
      end

      # GET /api/v1/zonas/:id
      def show
        render json: @zona
      end

      # POST /api/v1/zonas
      def create
        @zona = Zona.new(zona_params)

        if @zona.save
          render json: @zona, status: :created
        else
          render json: @zona.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/zonas/:id
      def update
        if @zona.update(zona_params)
          render json: @zona
        else
          render json: @zona.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/zonas/:id
      def destroy
        @zona.destroy!
        head :no_content
      end

      private

      def set_zona
        @zona = Zona.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Zona não encontrada" }, status: :not_found
      end

      def zona_params
        params.require(:zona).permit(
          :nome_zona,
          :descricao,
          :area_km2,
          :populacao_estimada,
          :percentual_populacao,
          :latitude_centro,
          :longitude_centro,
          :data_criacao,
          :data_atualizacao
        )
      end

      def apply_filters(records)
        filterable_fields = %w[nome_zona]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end
    end
  end
end
