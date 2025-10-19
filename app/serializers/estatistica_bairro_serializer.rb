class EstatisticaBairroSerializer < ActiveModel::Serializer
  attributes :id_estatistica, :id_bairro, :ano, :mes, :total_ocorrencias, :total_crimes_cvp,
             :taxa_criminalidade_100k, :taxa_variacao_ano_anterior, :ranking_bairro,
             :percentual_crimes_zona, :crime_mais_frequente, :periodo_maior_incidencia, :data_calculo
end
