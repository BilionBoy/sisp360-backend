class Ocorrencia < ApplicationRecord
  self.table_name = "ocorrencias"
  self.primary_key = "id_ocorrencia"  # chave primária correta
end
