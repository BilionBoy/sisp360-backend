# frozen_string_literal: true

class Agente < ApplicationRecord
  
  validates :nome_completo, :matricula, presence: true
  
end
