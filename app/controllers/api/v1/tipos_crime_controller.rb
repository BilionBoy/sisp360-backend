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

        # Dynamic limit with max 1000
        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 5000].min

        # Generate cache key
        cache_key = generate_cache_key(limit)

        # Cache the result for 5 minutes
        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          # Fast COUNT using PostgreSQL statistics or actual count if filtered
          count = get_fast_count(records)

          @pagy, @tipos_crime = pagy(
            records.select(selected_fields).order(:id_tipo_crime),
            limit: limit,
            count: count
          )

          {
            current_page: @pagy.page,
            per_page: @pagy.limit,
            total_pages: @pagy.pages,
            total_count: @pagy.count,
            tipos_crime: @tipos_crime.as_json(only: selected_fields)
          }
        end

        render json: result
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

      # Select only essential fields to reduce response size
      def selected_fields
        %w[
          id_tipo_crime
          codigo_senasp
          nome_crime
          categoria
          descricao
          gravidade
          ativo
        ]
      end

      # Fast COUNT using PostgreSQL statistics when no filters applied
      def get_fast_count(records)
        # If any filter is applied, use accurate count
        filterable_fields = %w[codigo_senasp categoria gravidade ativo nome_crime]
        if params.keys.any? { |k| filterable_fields.include?(k) }
          return records.count
        end

        # Use PostgreSQL statistics for fast estimation
        Rails.cache.fetch("tipos_crime_total_count", expires_in: 1.hour) do
          TipoCrime.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='tipos_crime'"
          )[0]["estimate"].to_i
        end
      end

      # Generate cache key based on request parameters
      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice(
          "codigo_senasp", "categoria", "gravidade", "ativo", "nome_crime", "page"
        )
        "tipos_crime_index_#{filter_params.to_json}_limit_#{limit}"
      end
    end
  end
end
