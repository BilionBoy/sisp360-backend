class Ocorrencia < ApplicationRecord
  self.table_name = "ocorrencias"
  self.primary_key = "id_ocorrencia"

  belongs_to :bairro, foreign_key: "id_bairro", primary_key: "id_bairro"
  belongs_to :tipo_crime, foreign_key: "id_tipo_crime", primary_key: "id_tipo_crime"
end
