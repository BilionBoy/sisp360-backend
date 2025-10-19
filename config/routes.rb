Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API v1
  namespace :api do
    namespace :v1 do
      resources :auditorias
      resources :bairros
      resources :complexos_habitacionais
      resources :estatisticas_bairro
      resources :indicadores_socioeconomicos
      resources :ocorrencias
      resources :pesquisas
      resources :tipos_crime
      resources :usuarios
      resources :zonas
    end
  end

  # Você pode definir o root se quiser
  # root "posts#index"
end
