class EstatisticaBairro < ApplicationRecord
  self.table_name = "estatisticas_bairro"
  self.primary_key = "id_estatistica"

  belongs_to :bairro, foreign_key: "id_bairro", primary_key: "id_bairro"
end
