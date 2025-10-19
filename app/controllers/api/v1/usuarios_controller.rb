# frozen_string_literal: true

module Api
  module V1
    class UsuariosController < ApplicationController
      include Pagy::Backend

      before_action :set_usuario, only: [ :show, :update, :destroy ]

      # GET /api/v1/usuarios
      def index
        records = Usuario.all
        records = apply_filters(records)

        @pagy, @usuarios = pagy(records.order(:id_usuario))

        render json: {
          current_page: @pagy.page,
          per_page: @pagy.limit,
          total_pages: @pagy.pages,
          total_count: @pagy.count,
          usuarios: ActiveModelSerializers::SerializableResource.new(@usuarios)
        }
      end

      # GET /api/v1/usuarios/:id
      def show
        render json: @usuario
      end

      # POST /api/v1/usuarios
      def create
        @usuario = Usuario.new(usuario_params)

        if @usuario.save
          render json: @usuario, status: :created
        else
          render json: @usuario.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/usuarios/:id
      def update
        if @usuario.update(usuario_params)
          render json: @usuario
        else
          render json: @usuario.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/usuarios/:id
      def destroy
        @usuario.destroy!
        head :no_content
      end

      private

      def set_usuario
        @usuario = Usuario.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Usuario não encontrado" }, status: :not_found
      end

      def usuario_params
        params.require(:usuario).permit(
          :nome_completo,
          :cpf,
          :email,
          :senha_hash,
          :tipo_usuario,
          :orgao,
          :cargo,
          :ativo,
          :ultimo_acesso,
          :data_criacao,
          :data_atualizacao
        )
      end

      def apply_filters(records)
        filterable_fields = %w[cpf email tipo_usuario orgao ativo]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end
    end
  end
end
