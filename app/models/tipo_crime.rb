class TipoCrime < ApplicationRecord
  self.table_name = "tipos_crime"
  self.primary_key = "id_tipo_crime"

  has_many :ocorrencias, foreign_key: "id_tipo_crime", primary_key: "id_tipo_crime"
end
