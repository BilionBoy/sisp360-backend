# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_10_19_083830) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "tipo_categoria_crime", ["CVP", "CVLI", "Outros"]
  create_enum "tipo_complexo", ["Condomínio Privado", "Conjunto Habitacional Popular", "Residencial Minha Casa Minha Vida"]
  create_enum "tipo_dia_semana", ["Segunda", "Terça", "Quarta", "Quinta", "Sexta", "Sábado", "Domingo"]
  create_enum "tipo_escolaridade", ["Fundamental Incompleto", "Fundamental Completo", "Médio Incompleto", "Médio Completo", "Superior Incompleto", "Superior Completo", "Pós-graduação"]
  create_enum "tipo_faixa_renda", ["Até 1 SM", "1-3 SM", "3-6 SM", "6-9 SM", "Acima de 9 SM"]
  create_enum "tipo_gravidade", ["Baixa", "Média", "Alta", "Altíssima"]
  create_enum "tipo_origem_registro", ["PM", "PC", "Sistema Integrado", "Outro"]
  create_enum "tipo_periodo_dia", ["Madrugada", "Manhã", "Tarde", "Noite"]
  create_enum "tipo_status_bairro", ["Oficial", "Não Oficial", "Em Processo"]
  create_enum "tipo_status_ocorrencia", ["Registrada", "Em Investigação", "Resolvida", "Arquivada"]
  create_enum "tipo_usuario", ["Admin", "Analista", "Operador", "Consulta"]

  create_table "auditoria", primary_key: "id_auditoria", force: :cascade do |t|
    t.integer "id_usuario"
    t.string "acao", limit: 100, null: false
    t.string "tabela_afetada", limit: 50
    t.integer "id_registro_afetado"
    t.jsonb "dados_anteriores"
    t.jsonb "dados_novos"
    t.inet "ip_origem"
    t.text "user_agent"
    t.datetime "data_hora", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["dados_novos"], name: "idx_auditoria_dados", using: :gin
    t.index ["data_hora"], name: "idx_auditoria_data"
    t.index ["id_usuario"], name: "idx_auditoria_usuario"
    t.index ["tabela_afetada"], name: "idx_auditoria_tabela"
  end

  create_table "bairros", primary_key: "id_bairro", id: :serial, force: :cascade do |t|
    t.string "nome_bairro", limit: 100, null: false
    t.integer "id_zona", null: false
    t.string "codigo_ibge", limit: 20
    t.integer "populacao", default: 0, null: false
    t.decimal "area_km2", precision: 10, scale: 4
    t.virtual "densidade_populacional", type: :decimal, precision: 10, scale: 2, as: "\nCASE\n    WHEN (area_km2 > (0)::numeric) THEN ((populacao)::numeric / area_km2)\n    ELSE (0)::numeric\nEND", stored: true
    t.decimal "latitude", precision: 10, scale: 8, null: false
    t.decimal "longitude", precision: 11, scale: 8, null: false
    t.enum "status_bairro", default: "Oficial", enum_type: "tipo_status_bairro"
    t.date "data_criacao_bairro"
    t.string "lei_criacao", limit: 100
    t.text "observacoes"
    t.datetime "data_criacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "data_atualizacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index "point((longitude)::double precision, (latitude)::double precision)", name: "idx_bairros_geom", using: :gist
    t.index ["id_zona"], name: "idx_bairros_zona"
    t.index ["latitude", "longitude"], name: "idx_bairros_coordenadas"
    t.index ["nome_bairro"], name: "idx_bairros_nome"
    t.unique_constraint ["nome_bairro", "id_zona"], name: "uk_bairro_zona"
  end

  create_table "complexos_habitacionais", primary_key: "id_complexo", id: :serial, force: :cascade do |t|
    t.string "nome_complexo", limit: 150, null: false
    t.enum "tipo_complexo", null: false, enum_type: "tipo_complexo"
    t.integer "id_bairro", null: false
    t.decimal "latitude", precision: 10, scale: 8
    t.decimal "longitude", precision: 11, scale: 8
    t.integer "numero_unidades"
    t.integer "populacao_estimada"
    t.decimal "renda_media", precision: 10, scale: 2
    t.boolean "possui_seguranca", default: false
    t.boolean "possui_controle_acesso", default: false
    t.integer "ano_inauguracao"
    t.string "construtora", limit: 100
    t.string "programa_governo", limit: 100
    t.datetime "data_criacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["id_bairro"], name: "idx_complexos_bairro"
    t.index ["tipo_complexo"], name: "idx_complexos_tipo"
  end

  create_table "estatisticas_bairro", primary_key: "id_estatistica", id: :serial, force: :cascade do |t|
    t.integer "id_bairro", null: false
    t.integer "ano", null: false
    t.integer "mes"
    t.integer "total_ocorrencias", default: 0
    t.integer "total_crimes_cvp", default: 0
    t.decimal "taxa_criminalidade_100k", precision: 10, scale: 2
    t.decimal "taxa_variacao_ano_anterior", precision: 6, scale: 2
    t.integer "ranking_bairro"
    t.decimal "percentual_crimes_zona", precision: 5, scale: 2
    t.string "crime_mais_frequente", limit: 100
    t.string "periodo_maior_incidencia", limit: 20
    t.datetime "data_calculo", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["ano"], name: "idx_estatisticas_ano"
    t.index ["ranking_bairro"], name: "idx_estatisticas_ranking"
    t.index ["taxa_criminalidade_100k"], name: "idx_estatisticas_taxa"
    t.unique_constraint ["id_bairro", "ano", "mes"], name: "uk_bairro_periodo"
  end

  create_table "indicadores_socioeconomicos", primary_key: "id_indicador", id: :serial, force: :cascade do |t|
    t.integer "id_bairro", null: false
    t.integer "ano_referencia", null: false
    t.decimal "indice_socioeconomico", precision: 4, scale: 2
    t.decimal "renda_media_mensal", precision: 10, scale: 2
    t.decimal "taxa_desemprego", precision: 5, scale: 2
    t.decimal "percentual_ensino_superior", precision: 5, scale: 2
    t.decimal "percentual_saneamento", precision: 5, scale: 2
    t.integer "numero_estabelecimentos_comerciais"
    t.integer "numero_escolas"
    t.integer "numero_postos_saude"
    t.decimal "iluminacao_publica", precision: 4, scale: 2
    t.decimal "presenca_policial", precision: 4, scale: 2
    t.decimal "distancia_centro_km", precision: 6, scale: 2
    t.decimal "qualidade_transporte_publico", precision: 4, scale: 2
    t.text "observacoes"
    t.datetime "data_criacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "data_atualizacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["ano_referencia"], name: "idx_indicadores_ano"
    t.index ["indice_socioeconomico"], name: "idx_indicadores_indice"
    t.check_constraint "iluminacao_publica >= 0::numeric AND iluminacao_publica <= 10::numeric", name: "indicadores_socioeconomicos_iluminacao_publica_check"
    t.check_constraint "indice_socioeconomico >= 0::numeric AND indice_socioeconomico <= 10::numeric", name: "indicadores_socioeconomicos_indice_socioeconomico_check"
    t.check_constraint "presenca_policial >= 0::numeric AND presenca_policial <= 10::numeric", name: "indicadores_socioeconomicos_presenca_policial_check"
    t.check_constraint "qualidade_transporte_publico >= 0::numeric AND qualidade_transporte_publico <= 10::numeric", name: "indicadores_socioeconomicos_qualidade_transporte_publico_check"
    t.unique_constraint ["id_bairro", "ano_referencia"], name: "uk_bairro_ano"
  end

  create_table "ocorrencias", primary_key: "id_ocorrencia", force: :cascade do |t|
    t.string "numero_bo", limit: 50
    t.integer "id_tipo_crime", null: false
    t.integer "id_bairro", null: false
    t.date "data_ocorrencia", null: false
    t.time "hora_ocorrencia"
    t.enum "dia_semana", enum_type: "tipo_dia_semana"
    t.enum "periodo_dia", enum_type: "tipo_periodo_dia"
    t.decimal "latitude_ocorrencia", precision: 10, scale: 8
    t.decimal "longitude_ocorrencia", precision: 11, scale: 8
    t.string "logradouro", limit: 255
    t.string "numero_endereco", limit: 20
    t.text "ponto_referencia"
    t.text "descricao_ocorrencia"
    t.integer "vitimas", default: 1
    t.decimal "valor_prejuizo", precision: 10, scale: 2
    t.boolean "recuperado", default: false
    t.enum "status_ocorrencia", default: "Registrada", enum_type: "tipo_status_ocorrencia"
    t.enum "origem_registro", default: "PM", enum_type: "tipo_origem_registro"
    t.datetime "data_registro", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.string "usuario_registro", limit: 100
    t.index "EXTRACT(year FROM data_ocorrencia), EXTRACT(month FROM data_ocorrencia)", name: "idx_ocorrencias_ano_mes"
    t.index "point((longitude_ocorrencia)::double precision, (latitude_ocorrencia)::double precision)", name: "idx_ocorrencias_geom", using: :gist
    t.index "to_tsvector('portuguese'::regconfig, descricao_ocorrencia)", name: "idx_ocorrencias_descricao_fts", using: :gin
    t.index ["data_ocorrencia"], name: "idx_ocorrencias_data"
    t.index ["data_ocorrencia"], name: "index_ocorrencias_on_data_ocorrencia"
    t.index ["id_bairro", "data_ocorrencia"], name: "idx_ocorrencias_bairro_data"
    t.index ["id_bairro", "data_ocorrencia"], name: "index_ocorrencias_on_bairro_and_data"
    t.index ["id_bairro"], name: "index_ocorrencias_on_id_bairro"
    t.index ["id_tipo_crime", "data_ocorrencia"], name: "idx_ocorrencias_tipo_data"
    t.index ["id_tipo_crime", "data_ocorrencia"], name: "index_ocorrencias_on_tipo_crime_and_data"
    t.index ["id_tipo_crime"], name: "index_ocorrencias_on_id_tipo_crime"
    t.index ["latitude_ocorrencia", "longitude_ocorrencia"], name: "idx_ocorrencias_coordenadas"
    t.index ["numero_bo"], name: "index_ocorrencias_on_numero_bo"
    t.index ["periodo_dia"], name: "idx_ocorrencias_periodo"
    t.index ["periodo_dia"], name: "index_ocorrencias_on_periodo_dia"
    t.index ["status_ocorrencia"], name: "idx_ocorrencias_status"
    t.index ["status_ocorrencia"], name: "index_ocorrencias_on_status_ocorrencia"
    t.unique_constraint ["numero_bo"], name: "ocorrencias_numero_bo_key"
  end

  create_table "pesquisas", primary_key: "id_pesquisa", id: :serial, force: :cascade do |t|
    t.integer "id_complexo"
    t.integer "id_bairro", null: false
    t.date "data_pesquisa", null: false
    t.enum "escolaridade", enum_type: "tipo_escolaridade"
    t.enum "faixa_renda", enum_type: "tipo_faixa_renda"
    t.string "zona_residencia_anterior", limit: 50
    t.string "motivo_escolha_moradia", limit: 100
    t.boolean "favoravel_normas_internas"
    t.string "zona_mais_violenta", limit: 50
    t.boolean "concorda_controle_acesso"
    t.boolean "realiza_compras_local"
    t.boolean "interesse_mudanca"
    t.datetime "data_criacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["data_pesquisa"], name: "idx_pesquisas_data"
    t.index ["id_complexo"], name: "idx_pesquisas_complexo"
  end

  create_table "tipos_crime", primary_key: "id_tipo_crime", id: :serial, force: :cascade do |t|
    t.string "codigo_senasp", limit: 20
    t.string "nome_crime", limit: 100, null: false
    t.enum "categoria", default: "CVP", enum_type: "tipo_categoria_crime"
    t.text "descricao"
    t.enum "gravidade", default: "Média", enum_type: "tipo_gravidade"
    t.boolean "ativo", default: true
    t.datetime "data_criacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["ativo"], name: "index_tipos_crime_on_ativo"
    t.index ["categoria"], name: "idx_tipos_crime_categoria"
    t.index ["gravidade"], name: "index_tipos_crime_on_gravidade"
    t.index ["nome_crime"], name: "index_tipos_crime_on_nome_crime"
    t.unique_constraint ["codigo_senasp"], name: "tipos_crime_codigo_senasp_key"
  end

  create_table "usuarios", primary_key: "id_usuario", id: :serial, force: :cascade do |t|
    t.string "nome_completo", limit: 150, null: false
    t.string "cpf", limit: 14
    t.string "email", limit: 100, null: false
    t.string "senha_hash", limit: 255, null: false
    t.enum "tipo_usuario", default: "Consulta", enum_type: "tipo_usuario"
    t.string "orgao", limit: 100
    t.string "cargo", limit: 100
    t.boolean "ativo", default: true
    t.datetime "ultimo_acesso", precision: nil
    t.datetime "data_criacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "data_atualizacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["email"], name: "idx_usuarios_email"
    t.index ["tipo_usuario"], name: "idx_usuarios_tipo"
    t.unique_constraint ["cpf"], name: "usuarios_cpf_key"
    t.unique_constraint ["email"], name: "usuarios_email_key"
  end

  create_table "zonas", primary_key: "id_zona", id: :serial, force: :cascade do |t|
    t.string "nome_zona", limit: 50, null: false
    t.text "descricao"
    t.decimal "area_km2", precision: 10, scale: 2
    t.integer "populacao_estimada"
    t.decimal "percentual_populacao", precision: 5, scale: 2
    t.decimal "latitude_centro", precision: 10, scale: 8
    t.decimal "longitude_centro", precision: 11, scale: 8
    t.datetime "data_criacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "data_atualizacao", precision: nil, default: -> { "CURRENT_TIMESTAMP" }
    t.index ["nome_zona"], name: "idx_zonas_nome"
    t.unique_constraint ["nome_zona"], name: "zonas_nome_zona_key"
  end

  add_foreign_key "auditoria", "usuarios", column: "id_usuario", primary_key: "id_usuario", name: "auditoria_id_usuario_fkey", on_delete: :nullify
  add_foreign_key "bairros", "zonas", column: "id_zona", primary_key: "id_zona", name: "bairros_id_zona_fkey", on_delete: :restrict
  add_foreign_key "complexos_habitacionais", "bairros", column: "id_bairro", primary_key: "id_bairro", name: "complexos_habitacionais_id_bairro_fkey", on_delete: :restrict
  add_foreign_key "estatisticas_bairro", "bairros", column: "id_bairro", primary_key: "id_bairro", name: "estatisticas_bairro_id_bairro_fkey", on_delete: :cascade
  add_foreign_key "indicadores_socioeconomicos", "bairros", column: "id_bairro", primary_key: "id_bairro", name: "indicadores_socioeconomicos_id_bairro_fkey", on_delete: :cascade
  add_foreign_key "ocorrencias", "bairros", column: "id_bairro", primary_key: "id_bairro", name: "ocorrencias_id_bairro_fkey", on_delete: :restrict
  add_foreign_key "ocorrencias", "tipos_crime", column: "id_tipo_crime", primary_key: "id_tipo_crime", name: "ocorrencias_id_tipo_crime_fkey", on_delete: :restrict
  add_foreign_key "pesquisas", "bairros", column: "id_bairro", primary_key: "id_bairro", name: "pesquisas_id_bairro_fkey", on_delete: :cascade
  add_foreign_key "pesquisas", "complexos_habitacionais", column: "id_complexo", primary_key: "id_complexo", name: "pesquisas_id_complexo_fkey", on_delete: :nullify
end
