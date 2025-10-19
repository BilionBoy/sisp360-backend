class ZonaSerializer < ActiveModel::Serializer
  attributes :id_zona, :nome_zona, :descricao, :area_km2, :populacao_estimada,
             :percentual_populacao, :latitude_centro, :longitude_centro, :data_criacao, :data_atualizacao
end
