# frozen_string_literal: true

class Viatura < ApplicationRecord
  
  validates :placa, :localidade, :descricao, presence: true
  
end
