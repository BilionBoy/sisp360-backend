class ComplexoHabitacionalSerializer < ActiveModel::Serializer
  attributes :id_complexo, :nome_complexo, :tipo_complexo, :id_bairro, :latitude, :longitude,
             :numero_unidades, :populacao_estimada, :renda_media, :possui_seguranca,
             :possui_controle_acesso, :ano_inauguracao, :construtora, :programa_governo, :data_criacao
end
