class AddIndexesToTiposCrime < ActiveRecord::Migration[7.2]
  def change
    add_index :tipos_crime, :gravidade, if_not_exists: true
    add_index :tipos_crime, :ativo, if_not_exists: true
    add_index :tipos_crime, :nome_crime, if_not_exists: true
  end
end
