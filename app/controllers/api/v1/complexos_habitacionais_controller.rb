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

        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 5000].min

        cache_key = generate_cache_key(limit)

        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          count = get_fast_count(records)

          @pagy, @complexos_habitacionais = pagy(
            records.select(selected_fields).order(:id_complexo),
            limit: limit,
            count: count
          )

          {
            current_page: @pagy.page,
            per_page: @pagy.limit,
            total_pages: @pagy.pages,
            total_count: @pagy.count,
            complexos_habitacionais: @complexos_habitacionais.as_json(only: selected_fields)
          }
        end

        render json: result
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

      def selected_fields
        %w[
          id_complexo nome_complexo tipo_complexo id_bairro
          latitude longitude numero_unidades populacao_estimada
          renda_media possui_seguranca possui_controle_acesso
          ano_inauguracao
        ]
      end

      def get_fast_count(records)
        filterable_fields = %w[id_bairro tipo_complexo nome_complexo possui_seguranca possui_controle_acesso]
        if params.keys.any? { |k| filterable_fields.include?(k) }
          return records.count
        end

        Rails.cache.fetch("complexos_habitacionais_total_count", expires_in: 1.hour) do
          ComplexoHabitacional.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='complexos_habitacionais'"
          )[0]["estimate"].to_i
        end
      end

      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice(
          "id_bairro", "tipo_complexo", "nome_complexo", "possui_seguranca", "possui_controle_acesso", "page"
        )
        "complexos_habitacionais_index_#{filter_params.to_json}_limit_#{limit}"
      end
    end
  end
end
