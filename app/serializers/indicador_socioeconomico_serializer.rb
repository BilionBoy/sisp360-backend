class IndicadorSocioeconomicoSerializer < ActiveModel::Serializer
  attributes :id_indicador, :id_bairro, :ano_referencia, :indice_socioeconomico, :renda_media_mensal,
             :taxa_desemprego, :percentual_ensino_superior, :percentual_saneamento,
             :numero_estabelecimentos_comerciais, :numero_escolas, :numero_postos_saude,
             :iluminacao_publica, :presenca_policial, :distancia_centro_km,
             :qualidade_transporte_publico, :observacoes, :data_criacao, :data_atualizacao
end
