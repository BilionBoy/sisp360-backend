class IndicadorSocioeconomico < ApplicationRecord
  self.table_name = "indicadores_socioeconomicos"
  self.primary_key = "id_indicador"

  belongs_to :bairro, foreign_key: "id_bairro", primary_key: "id_bairro"
end
