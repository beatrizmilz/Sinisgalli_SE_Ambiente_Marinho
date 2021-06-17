devtools::load_all()
# Frases para buscar -----------

servicos_ecosistemicos <-
  c("servicos ecossistemicos|ecosystem services")

## MCES -------------
food_provision <-
  c(
    "food provision",
    "provisao de alimentos",
    "alimento",
    "food",
    "fishing",
    "pesca",
    "fisheries",
    "aquaculture",
    "aquacultura",
    "pescaria"
  )

water_storage_and_provision <-
  c(
    "water storage",
    "water provision",
    "coastal lake",
    "deltaic aquifer",
    "desaliation",
    "marine water",
    "armazenamento de agua",
    "provisao de agua",
    "aproveitamento de agua",
    "chuva",
    "fluxo de agua"
  )

biotic_materials_and_biofuels <-
  c(
    "biotic materials",
    "biofuels",
    "materiais bioticos",
    "biotico",
    "material biotico",
    "biocombustivel",
    "biocombustiveis",
    "extracao de materiais",
    "extracao de madeira"
  )

water_purification <- c("water purification",
                        "purificacao da agua",
                        "purificacao",
                        "autodepuracao",
                        "bioremediacao",
                        "bioremediation",
                        "tratamento de esgoto",
                        "diluicao de esgoto",
                        "qualidade da agua")

air_quality_regulation <- c("qualidade do ar",
                            "air quality",
                            "air pollutants",
                            "poluentes do ar",
                            "qualidade do ar")

coastal_protection <- c("coastal protection",
                        "protecao costeira",
                        "protecao da costa",
                        "coastal zone",
                        "area costeira",
                        "coastal protection")

climate_regulation <- c("climate regulation",
                        "regulacao climatica",
                        "regulacao do clima",
                        "clima global",
                        "sink",
                        "climate regulation")

weather_regulation <- c("weather regulation",
                        "regulacao do clima",
                        "clima local",
                        "regulacao climatica",
                        "weather control")

ocean_nourishment <- c("ocean nourishment",
                       "nutricao do oceano",
                       "nutricao dos oceanos",
                       "qualidade da agua")


life_cycle_maintenance <- c("life cycle maintenance",
                            "manutencao", "habitat",
                            "manutencao do ciclo da vida",
                            "ciclo de vida",
                            "pollination",
                            "polinizacao",
                            "dispersao de semente",
                            "seed dispersal")

biological_regulation <- c("biological regulation",
                           "regulacao biologica",
                           "controle de patogenos",
                           "controle biologico",
                           "biological control")

symbolic_and_aesthetic_values <- c("aesthetic values",
                                   "symbiotic values",
                                   "valores simbolicos",
                                   "valor simbolico",
                                   "valores esteticos",
                                   "valor estetico",
                                   "simbolico e estetico",
                                   "simbolicos e esteticos")

recreation_and_tourism <- c("recreation",
                            "tourism",
                            "recreação",
                            "turismo",
                            "lazer")

cognitive_effects <- c("cognitive effects",
                       "efeitos cognitivos")

# funcao ----

detect_mces <- function(mces){stringr::str_detect(df_limpo$texto_limpo,  paste(mces,collapse = '|'))}



df_limpo <- df_arquivos %>%
  # remove o trabalho usado no referencial
  dplyr::filter(nome_arquivo != "data-raw/1-arquivos-pdf/pone_0067737_1.pdf") %>%
  dplyr::select(-texto) %>%
  dplyr::mutate(texto_limpo = abjutils::rm_accent(texto_limpo),
                texto_limpo = stringr::str_to_lower(texto_limpo))



resultado_busca <- df_limpo %>%
  dplyr::mutate(
    p_servicos_ecosistemicos = detect_mces(servicos_ecosistemicos),
    p_food_provision = detect_mces(food_provision),
    p_water_storage_and_provision = detect_mces(water_storage_and_provision),
    p_biotic_materials_and_biofuels = detect_mces(biotic_materials_and_biofuels),
    p_water_purification = detect_mces(water_purification),
    p_air_quality_regulation = detect_mces(air_quality_regulation),
    p_coastal_protection = detect_mces(coastal_protection),
    p_climate_regulation = detect_mces(climate_regulation),
    p_weather_regulation = detect_mces(weather_regulation),
    p_ocean_nourishment = detect_mces(ocean_nourishment),
    p_life_cycle_maintenance = detect_mces(life_cycle_maintenance),
    p_biological_regulation = detect_mces(biological_regulation),
    p_symbolic_and_aesthetic_values = detect_mces(symbolic_and_aesthetic_values),
    p_recreation_and_tourism = detect_mces(recreation_and_tourism),
    p_cognitive_effects = detect_mces(cognitive_effects)
  )

  View(resultado_busca)

 contagem_temas <-  resultado_busca %>%
    tidyr::pivot_longer(cols = tidyselect::starts_with("p_")) %>%
    dplyr::filter(value == TRUE) %>%
    dplyr::count(name, sort = TRUE)


resumo <-  resultado_busca %>%
   tidyr::pivot_longer(cols = tidyselect::starts_with("p_")) %>%
   dplyr::filter(value == TRUE) %>%
    dplyr::mutate(tema = stringr::str_remove(name,"p_"),
                  tema = stringr::str_replace_all(tema, "_", " "),
                  nome_arquivo = stringr::str_remove(nome_arquivo, "data-raw/1-arquivos-pdf/")) %>%
    dplyr::select(-name, -value) %>%
    dplyr::group_by(nome_arquivo, tema) %>%
    dplyr::summarise(pagina = knitr::combine_words(num_pagina, and = " e "))

resumo %>%
  dplyr::left_join(lista_de_arquivos[, 1:2], by = c("nome_arquivo" = "nome_limpo")) %>%
  dplyr::rename("nome_original" = name) %>%
  dplyr::relocate(nome_original, .before = nome_arquivo) %>%
  readr::write_csv2("data-raw/data-output/resumo_termos.csv")
