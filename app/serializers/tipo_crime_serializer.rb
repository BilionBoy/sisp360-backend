class TipoCrimeSerializer < ActiveModel::Serializer
  attributes :id_tipo_crime, :codigo_senasp, :nome_crime, :categoria, :descricao,
             :gravidade, :ativo, :data_criacao
end
