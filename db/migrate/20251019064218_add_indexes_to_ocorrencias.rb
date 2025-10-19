class AddIndexesToOcorrencias < ActiveRecord::Migration[7.2]
  def change
    # indices para colunas usadas em filtros


# aprende dhiogo meu amigo, index na tabela melhora muito o select no banco, porem custa mais para a gravacao dos dados, perfeito para o nosso caso
# o melhor mesmo serio um redis porem isso fica para um proximo commit se der tempo

    add_index :ocorrencias, :id_tipo_crime, if_not_exists: true
    add_index :ocorrencias, :id_bairro, if_not_exists: true
    add_index :ocorrencias, :data_ocorrencia, if_not_exists: true
    add_index :ocorrencias, :status_ocorrencia, if_not_exists: true
    add_index :ocorrencias, :periodo_dia, if_not_exists: true
    add_index :ocorrencias, :numero_bo, if_not_exists: true

    # inndice composto para queries comuns bairo + data
    add_index :ocorrencias, [:id_bairro, :data_ocorrencia], if_not_exists: true, name: 'index_ocorrencias_on_bairro_and_data'

    #  inndice composto para queries comuns tipo_crime + data
    add_index :ocorrencias, [:id_tipo_crime, :data_ocorrencia], if_not_exists: true, name: 'index_ocorrencias_on_tipo_crime_and_data'
  end
end
