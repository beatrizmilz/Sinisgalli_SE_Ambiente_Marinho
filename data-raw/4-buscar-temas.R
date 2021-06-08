termos_pesquisar <- c("servicos ecossistemicos|ecosystem services")

df_limpo <- df_arquivos %>%
  dplyr::select(-texto) %>%
  dplyr::mutate(texto_limpo = abjutils::rm_accent(texto_limpo),
                texto_limpo = stringr::str_to_lower(texto_limpo))


df_limpo %>%
  dplyr::mutate(detectado = stringr::str_detect(texto_limpo, termos_pesquisar)) %>%
  dplyr::filter(detectado == TRUE) %>%
  dplyr::count(nome_arquivo)
  # dplyr::pull(texto_limpo) %>%
  # print()
