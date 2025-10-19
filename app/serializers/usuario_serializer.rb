class UsuarioSerializer < ActiveModel::Serializer
  attributes :id_usuario, :nome_completo, :cpf, :email, :tipo_usuario, :orgao, :cargo,
             :ativo, :ultimo_acesso, :data_criacao, :data_atualizacao

  # Não expor senha_hash no serializer por questões de segurança
end
