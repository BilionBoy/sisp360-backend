Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Action Cable endpoint
  mount ActionCable.server => '/cable'

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

      # Rotas de notificações
      post "notifications/broadcast", to: "notifications#broadcast"
      post "notifications/sistema", to: "notifications#sistema"
      post "notifications/test", to: "notifications#test"
      get "notifications/status", to: "notifications#status"
    end
  end

  # Você pode definir o root se quiser
  # root "posts#index"
end
