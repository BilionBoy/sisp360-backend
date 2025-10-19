# config/initializers/cors.rb

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"   # permite qualquer origem, cuidado em produção!

    resource "*",
      headers: :any,
      methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
      expose: [ "Authorization" ],
      max_age: 600
  end

  # Configuração específica para Action Cable WebSocket
  allow do
    origins "*"
    resource "/cable",
      headers: :any,
      methods: [ :get, :post, :options ]
  end
end
