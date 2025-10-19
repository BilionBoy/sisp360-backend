# frozen_string_literal: true

module Api
  module V1
    class PesquisasController < ApplicationController
      include Pagy::Backend

      before_action :set_pesquisa, only: [ :show, :update, :destroy ]

      # GET /api/v1/pesquisas
      def index
        records = Pesquisa.all
        records = apply_filters(records)

        limit = [params[:items].to_i, params[:per_page].to_i, 25].max
        limit = [limit, 5000].min

        cache_key = generate_cache_key(limit)

        result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
          count = get_fast_count(records)

          @pagy, @pesquisas = pagy(
            records.select(selected_fields).order(data_pesquisa: :desc, id_pesquisa: :desc),
            limit: limit,
            count: count
          )

          {
            current_page: @pagy.page,
            per_page: @pagy.limit,
            total_pages: @pagy.pages,
            total_count: @pagy.count,
            pesquisas: @pesquisas.as_json(only: selected_fields)
          }
        end

        render json: result
      end

      # GET /api/v1/pesquisas/:id
      def show
        render json: @pesquisa
      end

      # POST /api/v1/pesquisas
      def create
        @pesquisa = Pesquisa.new(pesquisa_params)

        if @pesquisa.save
          render json: @pesquisa, status: :created
        else
          render json: @pesquisa.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/pesquisas/:id
      def update
        if @pesquisa.update(pesquisa_params)
          render json: @pesquisa
        else
          render json: @pesquisa.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/pesquisas/:id
      def destroy
        @pesquisa.destroy!
        head :no_content
      end

      private

      def set_pesquisa
        @pesquisa = Pesquisa.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Pesquisa não encontrada" }, status: :not_found
      end

      def pesquisa_params
        params.require(:pesquisa).permit(
          :id_complexo,
          :id_bairro,
          :data_pesquisa,
          :escolaridade,
          :faixa_renda,
          :zona_residencia_anterior,
          :motivo_escolha_moradia,
          :favoravel_normas_internas,
          :zona_mais_violenta,
          :concorda_controle_acesso,
          :realiza_compras_local,
          :interesse_mudanca,
          :data_criacao
        )
      end

      def apply_filters(records)
        filterable_fields = %w[id_complexo id_bairro data_pesquisa escolaridade faixa_renda]
        filterable_fields.each do |field|
          records = records.where(field => params[field]) if params[field].present?
        end
        records
      end

      def selected_fields
        %w[
          id_pesquisa id_complexo id_bairro data_pesquisa
          escolaridade faixa_renda zona_residencia_anterior
          motivo_escolha_moradia favoravel_normas_internas
          zona_mais_violenta concorda_controle_acesso
          realiza_compras_local interesse_mudanca
        ]
      end

      def get_fast_count(records)
        filterable_fields = %w[id_complexo id_bairro data_pesquisa escolaridade faixa_renda]
        if params.keys.any? { |k| filterable_fields.include?(k) }
          return records.count
        end

        Rails.cache.fetch("pesquisas_total_count", expires_in: 1.hour) do
          Pesquisa.connection.execute(
            "SELECT reltuples::bigint AS estimate FROM pg_class WHERE relname='pesquisas'"
          )[0]["estimate"].to_i
        end
      end

      def generate_cache_key(limit)
        filter_params = params.to_unsafe_h.slice(
          "id_complexo", "id_bairro", "data_pesquisa", "escolaridade", "faixa_renda", "page"
        )
        "pesquisas_index_#{filter_params.to_json}_limit_#{limit}"
      end
    end
  end
end
