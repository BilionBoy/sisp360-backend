namespace :api do
  desc "Gera relatório completo da API auto-gerada"
  task report: :environment do
    puts "=" * 80
    puts "RELATÓRIO COMPLETO DA API - SISP360 Backend"
    puts "=" * 80
    puts ""

    models = [
      { class_name: 'Zona', table: 'zonas', pk: 'id_zona' },
      { class_name: 'Bairro', table: 'bairros', pk: 'id_bairro' },
      { class_name: 'TipoCrime', table: 'tipos_crime', pk: 'id_tipo_crime' },
      { class_name: 'Usuario', table: 'usuarios', pk: 'id_usuario' },
      { class_name: 'ComplexoHabitacional', table: 'complexos_habitacionais', pk: 'id_complexo' },
      { class_name: 'Ocorrencia', table: 'ocorrencias', pk: 'id_ocorrencia' },
      { class_name: 'EstatisticaBairro', table: 'estatisticas_bairro', pk: 'id_estatistica' },
      { class_name: 'IndicadorSocioeconomico', table: 'indicadores_socioeconomicos', pk: 'id_indicador' },
      { class_name: 'Pesquisa', table: 'pesquisas', pk: 'id_pesquisa' },
      { class_name: 'Auditoria', table: 'auditoria', pk: 'id_auditoria' }
    ]

    models.each do |model_info|
      model = model_info[:class_name].constantize

      puts "─" * 80
      puts "MODEL: #{model_info[:class_name]}"
      puts "─" * 80
      puts "Tabela: #{model_info[:table]}"
      puts "Primary Key: #{model_info[:pk]}"
      puts "Registros: #{model.count}"
      puts ""

      # Colunas
      puts "COLUNAS:"
      columns = ActiveRecord::Base.connection.columns(model_info[:table])
      columns.each do |col|
        puts "  - #{col.name.ljust(30)} | #{col.type.to_s.ljust(15)} | #{col.null ? 'NULL' : 'NOT NULL'}"
      end
      puts ""

      # Associations
      puts "ASSOCIATIONS:"

      if model.reflect_on_all_associations(:belongs_to).any?
        puts "  belongs_to:"
        model.reflect_on_all_associations(:belongs_to).each do |assoc|
          puts "    - #{assoc.name} (FK: #{assoc.foreign_key})"
        end
      end

      if model.reflect_on_all_associations(:has_many).any?
        puts "  has_many:"
        model.reflect_on_all_associations(:has_many).each do |assoc|
          puts "    - #{assoc.name} (FK: #{assoc.foreign_key})"
        end
      end

      if model.reflect_on_all_associations(:belongs_to).empty? && model.reflect_on_all_associations(:has_many).empty?
        puts "  Nenhuma association definida"
      end

      puts ""
      puts ""
    end

    puts "=" * 80
    puts "ENDPOINTS DISPONÍVEIS"
    puts "=" * 80

    Rails.application.routes.routes.each do |route|
      if route.path.spec.to_s.include?('/api/v1')
        puts "#{route.verb.ljust(8)} #{route.path.spec.to_s.ljust(50)} #{route.defaults[:controller]}##{route.defaults[:action]}"
      end
    end

    puts ""
    puts "=" * 80
    puts "RELATÓRIO COMPLETO GERADO COM SUCESSO"
    puts "=" * 80
  end
end
