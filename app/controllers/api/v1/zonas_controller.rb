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

        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 5000].min

        cache_key = generate_cache_key(limit)

        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          count = get_fast_count(records)

          @pagy, @zonas = pagy(
            records.select(selected_fields).order(:id_zona),
            limit: limit,
            count: count
          )

          {
            current_page: @pagy.page,
            per_page: @pagy.limit,
            total_pages: @pagy.pages,
            total_count: @pagy.count,
            zonas: @zonas.as_json(only: selected_fields)
          }
        end

        render json: result
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

      def selected_fields
        %w[
          id_zona nome_zona descricao area_km2
          populacao_estimada percentual_populacao
          latitude_centro longitude_centro
        ]
      end

      def get_fast_count(records)
        if params[:nome_zona].present?
          return records.count
        end

        Rails.cache.fetch("zonas_total_count", expires_in: 1.hour) do
          Zona.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='zonas'"
          )[0]["estimate"].to_i
        end
      end

      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice("nome_zona", "page")
        "zonas_index_#{filter_params.to_json}_limit_#{limit}"
      end
    end
  end
end
