class Usuario < ApplicationRecord
  self.table_name = "usuarios"
  self.primary_key = "id_usuario"

  has_many :auditorias, foreign_key: "id_usuario", primary_key: "id_usuario"
end
