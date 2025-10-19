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
@pagy, @ocorrencias = pagy(records.order(:id_ocorrencia))

        render json: {
          current_page: @pagy.page,
          per_page: @pagy.limit,
          total_pages: @pagy.pages,
          total_count: @pagy.count,
          ocorrencias: ActiveModelSerializers::SerializableResource.new(@ocorrencias)
        }
      end

      # GET /api/v1/ocorrencias/:id
      def show
        render json: @ocorrencia
      end

      # POST /api/v1/ocorrencias
      def create
        @ocorrencia = Ocorrencia.new(ocorrencia_params)

        if @ocorrencia.save
          render json: @ocorrencia, status: :created
        else
          render json: @ocorrencia.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/ocorrencias/:id
      def update
        if @ocorrencia.update(ocorrencia_params)
          render json: @ocorrencia
        else
          render json: @ocorrencia.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/ocorrencias/:id
      def destroy
        @ocorrencia.destroy!
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
    end
  end
end
