class BairroSerializer < ActiveModel::Serializer
  attributes :id_bairro, :nome_bairro, :id_zona, :codigo_ibge, :populacao, :area_km2,
             :densidade_populacional, :latitude, :longitude, :status_bairro,
             :data_criacao_bairro, :lei_criacao, :observacoes, :data_criacao, :data_atualizacao
end
