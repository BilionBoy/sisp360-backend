class Auditoria < ApplicationRecord
  self.table_name = "auditoria"
  self.primary_key = "id_auditoria"

  belongs_to :usuario, foreign_key: "id_usuario", primary_key: "id_usuario"
end
