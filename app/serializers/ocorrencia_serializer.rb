class OcorrenciaSerializer < ActiveModel::Serializer
  attributes :id_ocorrencia, :numero_bo, :id_tipo_crime, :id_bairro, :data_ocorrencia, :hora_ocorrencia,
             :dia_semana, :periodo_dia, :latitude_ocorrencia, :longitude_ocorrencia, :logradouro,
             :numero_endereco, :ponto_referencia, :descricao_ocorrencia, :vitimas, :valor_prejuizo,
             :recuperado, :status_ocorrencia, :origem_registro, :data_registro, :usuario_registro
end
