class Pesquisa < ApplicationRecord
  self.table_name = "pesquisas"
  self.primary_key = "id_pesquisa"

  belongs_to :bairro, foreign_key: "id_bairro", primary_key: "id_bairro"
  belongs_to :complexo_habitacional, foreign_key: "id_complexo", primary_key: "id_complexo"
end
