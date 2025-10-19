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

        @pagy, @auditorias = pagy(records.order(:id_auditoria))

        render json: {
          current_page: @pagy.page,
          per_page: @pagy.limit,
          total_pages: @pagy.pages,
          total_count: @pagy.count,
          auditorias: ActiveModelSerializers::SerializableResource.new(@auditorias)
        }
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
    end
  end
end
