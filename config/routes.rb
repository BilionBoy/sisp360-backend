Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # API v1
  namespace :api do
    namespace :v1 do
      resources :ocorrencias
    end
  end

  # Você pode definir o root se quiser
  # root "posts#index"
end
