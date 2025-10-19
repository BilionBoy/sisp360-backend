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

        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 1000].min

        cache_key = generate_cache_key(limit)

        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          count = get_fast_count(records)

          @pagy, @usuarios = pagy(
            records.select(selected_fields).order(:id_usuario),
            limit: limit,
            count: count
          )

          {
            current_page: @pagy.page,
            per_page: @pagy.limit,
            total_pages: @pagy.pages,
            total_count: @pagy.count,
            usuarios: @usuarios.as_json(only: selected_fields)
          }
        end

        render json: result
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

      def selected_fields
        # SECURITY: NEVER return senha_hash in API responses
        %w[
          id_usuario nome_completo cpf email
          tipo_usuario orgao cargo ativo
          ultimo_acesso
        ]
      end

      def get_fast_count(records)
        filterable_fields = %w[cpf email tipo_usuario orgao ativo]
        if params.keys.any? { |k| filterable_fields.include?(k) }
          return records.count
        end

        Rails.cache.fetch("usuarios_total_count", expires_in: 1.hour) do
          Usuario.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='usuarios'"
          )[0]["estimate"].to_i
        end
      end

      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice(
          "cpf", "email", "tipo_usuario", "orgao", "ativo", "page"
        )
        "usuarios_index_#{filter_params.to_json}_limit_#{limit}"
      end
    end
  end
end
