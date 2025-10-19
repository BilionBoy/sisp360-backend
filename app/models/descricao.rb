# frozen_string_literal: true

class Descricao < ApplicationRecord
  
  validates :tipo_ocorrencia, :prioridade, :data_ocorrencia, presence: true
  
end
