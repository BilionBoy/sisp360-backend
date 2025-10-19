# frozen_string_literal: true

module Api
  module V1
    class TiposCrimeController < ApplicationController
      include Pagy::Backend

      before_action :set_tipo_crime, only: [ :show, :update, :destroy ]

      # GET /api/v1/tipos_crime
      def index
        records = TipoCrime.all
        records = apply_filters(records)

        @pagy, @tipos_crime = pagy(records.order(:id_tipo_crime))

        render json: {
          current_page: @pagy.page,
          per_page: @pagy.limit,
          total_pages: @pagy.pages,
          total_count: @pagy.count,
          tipos_crime: ActiveModelSerializers::SerializableResource.new(@tipos_crime)
        }
      end

      # GET /api/v1/tipos_crime/:id
      def show
        render json: @tipo_crime
      end

      # POST /api/v1/tipos_crime
      def create
        @tipo_crime = TipoCrime.new(tipo_crime_params)

        if @tipo_crime.save
          render json: @tipo_crime, status: :created
        else
          render json: @tipo_crime.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/tipos_crime/:id
      def update
        if @tipo_crime.update(tipo_crime_params)
          render json: @tipo_crime
        else
          render json: @tipo_crime.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/tipos_crime/:id
      def destroy
        @tipo_crime.destroy!
        head :no_content
      end

      private

      def set_tipo_crime
        @tipo_crime = TipoCrime.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "TipoCrime não encontrado" }, status: :not_found
      end

      def tipo_crime_params
        params.require(:tipo_crime).permit(
          :codigo_senasp,
          :nome_crime,
          :categoria,
          :descricao,
          :gravidade,
          :ativo,
          :data_criacao
        )
      end

      def apply_filters(records)
        filterable_fields = %w[codigo_senasp categoria gravidade ativo nome_crime]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end
    end
  end
end
