class Bairro < ApplicationRecord
  self.table_name = "bairros"
  self.primary_key = "id_bairro"

  belongs_to :zona, foreign_key: "id_zona", primary_key: "id_zona"
  has_many :complexos_habitacionais, foreign_key: "id_bairro", primary_key: "id_bairro"
  has_many :estatisticas_bairros, foreign_key: "id_bairro", primary_key: "id_bairro"
  has_many :indicadores_socioeconomicos, foreign_key: "id_bairro", primary_key: "id_bairro"
  has_many :ocorrencias, foreign_key: "id_bairro", primary_key: "id_bairro"
  has_many :pesquisas, foreign_key: "id_bairro", primary_key: "id_bairro"
end
