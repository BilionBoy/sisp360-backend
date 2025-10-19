# frozen_string_literal: true

module Api
  module V1
    class ComplexosHabitacionaisController < ApplicationController
      include Pagy::Backend

      before_action :set_complexo_habitacional, only: [ :show, :update, :destroy ]

      # GET /api/v1/complexos_habitacionais
      def index
        records = ComplexoHabitacional.all
        records = apply_filters(records)

        @pagy, @complexos_habitacionais = pagy(records.order(:id_complexo))

        render json: {
          current_page: @pagy.page,
          per_page: @pagy.limit,
          total_pages: @pagy.pages,
          total_count: @pagy.count,
          complexos_habitacionais: ActiveModelSerializers::SerializableResource.new(@complexos_habitacionais)
        }
      end

      # GET /api/v1/complexos_habitacionais/:id
      def show
        render json: @complexo_habitacional
      end

      # POST /api/v1/complexos_habitacionais
      def create
        @complexo_habitacional = ComplexoHabitacional.new(complexo_habitacional_params)

        if @complexo_habitacional.save
          render json: @complexo_habitacional, status: :created
        else
          render json: @complexo_habitacional.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/complexos_habitacionais/:id
      def update
        if @complexo_habitacional.update(complexo_habitacional_params)
          render json: @complexo_habitacional
        else
          render json: @complexo_habitacional.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/complexos_habitacionais/:id
      def destroy
        @complexo_habitacional.destroy!
        head :no_content
      end

      private

      def set_complexo_habitacional
        @complexo_habitacional = ComplexoHabitacional.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "ComplexoHabitacional não encontrado" }, status: :not_found
      end

      def complexo_habitacional_params
        params.require(:complexo_habitacional).permit(
          :nome_complexo,
          :tipo_complexo,
          :id_bairro,
          :latitude,
          :longitude,
          :numero_unidades,
          :populacao_estimada,
          :renda_media,
          :possui_seguranca,
          :possui_controle_acesso,
          :ano_inauguracao,
          :construtora,
          :programa_governo,
          :data_criacao
        )
      end

      def apply_filters(records)
        filterable_fields = %w[id_bairro tipo_complexo nome_complexo possui_seguranca possui_controle_acesso]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end
    end
  end
end
