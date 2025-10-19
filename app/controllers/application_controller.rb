class ApplicationController < ActionController::API
  # Normaliza parâmetros de paginação
  before_action :normalize_pagination_params

  private

  # Aceita tanto 'items' quanto 'per_page' como parâmetros de paginação
  def normalize_pagination_params
    if params[:per_page].present? && params[:items].blank?
      params[:items] = params[:per_page]
    end
  end
end
