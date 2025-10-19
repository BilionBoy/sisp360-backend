class AuditoriaSerializer < ActiveModel::Serializer
  attributes :id_auditoria, :id_usuario, :acao, :tabela_afetada, :id_registro_afetado,
             :dados_anteriores, :dados_novos, :ip_origem, :user_agent, :data_hora
end
