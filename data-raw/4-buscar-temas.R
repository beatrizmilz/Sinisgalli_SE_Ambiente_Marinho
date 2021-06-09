
# Frases para buscar -----------
servicos_ecosistemicos <- c("servicos ecossistemicos|ecosystem services")

## MCES -------------
food_provision <- c("food provision", "provisao de alimentos", "alimento", "food", "fishing", "pesca", "fisheries", "aquaculture", "aquacultura", "pescaria")

water_storage_and_provision <- c("water storage", "water provision", "coastal lake", "deltaic aquifer", "desaliation", "marine water", "armazenamento de agua", "provisao de agua", "aproveitamento de agua")

biotic_materials_and_biofuels <- c("biotic materials", "biofuels", "materiais bioticos", "biotico", "biocombustivel", "biocombustiveis")

water_purification <- c("")

air_quality_regulation <- c("")

coastal_protection <- c("")

climate_regulation <- c("")

weather_regulation <- c("")

ocean_nourishment <- c("")

life_cycle_maintenance <- c("")

biological_regulation <- c("")

symbolic_and_aesthetic_values <- c("")

recreation_and_tourism <- c("")

cognitive_effects <- c("")




detect_mces <- function(mces){stringr::str_detect(df_limpo$texto_limpo,  paste(mces,collapse = '|'))}



df_limpo <- df_arquivos %>%
  # remove o trabalho usado no referencial
  dplyr::filter(nome_arquivo != "data-raw/1-arquivos-pdf/pone_0067737_1.pdf") %>%
  dplyr::select(-texto) %>%
  dplyr::mutate(texto_limpo = abjutils::rm_accent(texto_limpo),
                texto_limpo = stringr::str_to_lower(texto_limpo))



df_limpo %>%
  dplyr::mutate(
    p_servicos_ecosistemicos = detect_mces(servicos_ecosistemicos),
    p_food_provision = detect_mces(food_provision),
    p_water_storage_and_provision = detect_mces(water_storage_and_provision),
    p_water_storage_and_provision = detect_mces(biotic_materials_and_biofuels),
    p_biotic_materials_and_biofuels = detect_mces(biotic_materials_and_biofuels),


    p_water_purification = detect_mces(...),

    p_air_quality_regulation = detect_mces(...),

    p_coastal_protection = detect_mces(...),

    p_climate_regulation = detect_mces(...),

    p_weather_regulation = detect_mces(...),

    p_ocean_nourishment = detect_mces(...),

    p_life_cycle_maintenance = detect_mces(...),

    p_biological_regulation = detect_mces(...),

    p_symbolic_and_aesthetic_values = detect_mces(...),

    p_recreation_and_tourism = detect_mces(...),

    p_cognitive_effects = detect_mces(...),


  ) %>%

  View()
 # dplyr::filter(detectado == TRUE) %>%
  dplyr::count(nome_arquivo)
  # dplyr::pull(texto_limpo) %>%
  # print()
