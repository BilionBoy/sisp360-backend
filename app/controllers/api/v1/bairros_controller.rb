# frozen_string_literal: true

module Api
  module V1
    class BairrosController < ApplicationController
      include Pagy::Backend

      before_action :set_bairro, only: [ :show, :update, :destroy ]

      # GET /api/v1/bairros
      def index
        records = Bairro.all
        records = apply_filters(records)

        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 1000].min

        cache_key = generate_cache_key(limit)

        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          count = get_fast_count(records)

          @pagy, @bairros = pagy(
            records.select(selected_fields).order(:id_bairro),
            limit: limit,
            count: count
          )

          {
            current_page: @pagy.page,
            per_page: @pagy.limit,
            total_pages: @pagy.pages,
            total_count: @pagy.count,
            bairros: @bairros.as_json(only: selected_fields)
          }
        end

        render json: result
      end

      # GET /api/v1/bairros/:id
      def show
        render json: @bairro
      end

      # POST /api/v1/bairros
      def create
        @bairro = Bairro.new(bairro_params)

        if @bairro.save
          render json: @bairro, status: :created
        else
          render json: @bairro.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/bairros/:id
      def update
        if @bairro.update(bairro_params)
          render json: @bairro
        else
          render json: @bairro.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/bairros/:id
      def destroy
        @bairro.destroy!
        head :no_content
      end

      private

      def set_bairro
        @bairro = Bairro.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Bairro não encontrado" }, status: :not_found
      end

      def bairro_params
        params.require(:bairro).permit(
          :nome_bairro,
          :id_zona,
          :codigo_ibge,
          :populacao,
          :area_km2,
          :densidade_populacional,
          :latitude,
          :longitude,
          :status_bairro,
          :data_criacao_bairro,
          :lei_criacao,
          :observacoes,
          :data_criacao,
          :data_atualizacao
        )
      end

      def apply_filters(records)
        filterable_fields = %w[id_zona nome_bairro codigo_ibge status_bairro]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end

      def selected_fields
        %w[
          id_bairro nome_bairro id_zona codigo_ibge
          populacao area_km2 densidade_populacional
          latitude longitude status_bairro
        ]
      end

      def get_fast_count(records)
        filterable_fields = %w[id_zona nome_bairro codigo_ibge status_bairro]
        if params.keys.any? { |k| filterable_fields.include?(k) }
          return records.count
        end

        Rails.cache.fetch("bairros_total_count", expires_in: 1.hour) do
          Bairro.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='bairros'"
          )[0]["estimate"].to_i
        end
      end

      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice(
          "id_zona", "nome_bairro", "codigo_ibge", "status_bairro", "page"
        )
        "bairros_index_#{filter_params.to_json}_limit_#{limit}"
      end
    end
  end
end
