class Zona < ApplicationRecord
  self.table_name = "zonas"
  self.primary_key = "id_zona"

  has_many :bairros, foreign_key: "id_zona", primary_key: "id_zona"
end
