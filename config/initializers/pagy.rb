
require "pagy/extras/i18n"
require "pagy/extras/bootstrap"

# Configuração de paginação
Pagy::DEFAULT[:limit] = 25  # items por página (padrão)

# Nota: Para usar paginação customizável (?items=X ou ?per_page=X),
# os controllers devem passar explicitamente o parâmetro para pagy()
# Exemplo: pagy(records, limit: params[:items] || params[:per_page] || 25)
