class PesquisaSerializer < ActiveModel::Serializer
  attributes :id_pesquisa, :id_complexo, :id_bairro, :data_pesquisa, :escolaridade, :faixa_renda,
             :zona_residencia_anterior, :motivo_escolha_moradia, :favoravel_normas_internas,
             :zona_mais_violenta, :concorda_controle_acesso, :realiza_compras_local,
             :interesse_mudanca, :data_criacao
end
