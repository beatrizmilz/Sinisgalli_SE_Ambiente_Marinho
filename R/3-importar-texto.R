fs::dir_ls("data-raw/2-texto-arquivos/") %>% length()

arquivos_texto <- lista_de_arquivos %>%
  dplyr::mutate(caminho_ = glue::glue("data-raw/1-arquivos-pdf/{nome_limpo}"),
                texto = pdftools::pdf_text(pdf = ))
