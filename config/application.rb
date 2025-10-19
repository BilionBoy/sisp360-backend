require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Apirails
  class Application < Rails::Application
    # Rails version.
    config.load_defaults 7.2

    config.autoload_paths += %W[#{config.root}/lib]               # Adiciona diretórios ao autoload do Rails em desevolvimento
    config.autoload_lib(ignore: %w[assets tasks])

    config.time_zone = "La Paz"                                   # Configuração do Time Zone
    config.i18n.default_locale = :'pt-BR'                         # Configuração do idioma padrão

    config.api_only = true

    # Compressão HTTP (Gzip) para reduzir tamanho das respostas
    # Pode reduzir em 70-90% o tamanho do JSON
    config.middleware.use Rack::Deflater
  end
end
