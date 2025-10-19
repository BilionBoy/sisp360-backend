class ComplexoHabitacional < ApplicationRecord
  self.table_name = "complexos_habitacionais"
  self.primary_key = "id_complexo"

  belongs_to :bairro, foreign_key: "id_bairro", primary_key: "id_bairro"
  has_many :pesquisas, foreign_key: "id_complexo", primary_key: "id_complexo"
end
