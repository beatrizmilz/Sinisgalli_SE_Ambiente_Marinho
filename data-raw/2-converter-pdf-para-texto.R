fs::dir_create("data-raw/2-texto-arquivos")

converter_pdf_para_rds <- function(arquivo){
  nome_arquivo <- tools::file_path_sans_ext(basename(arquivo))
  path_arquivo <- glue::glue("data-raw/1-arquivos-pdf/{nome_arquivo}.pdf")
  path_salvar <- glue::glue("data-raw/2-texto-arquivos/{nome_arquivo}.Rds")
  if(as.vector(fs::file_exists(path_salvar) == FALSE)){
   teste <- pdftools::pdf_text(arquivo)  %>%
     tibble::as_tibble() %>%
     dplyr::mutate(nome_arquivo = arquivo) %>%
     tibble::rowid_to_column("num_pagina") %>%
     dplyr::rename("texto" = value) %>%
      readr::write_rds(path_salvar)
  }

}

arquivos <- fs::dir_ls("data-raw/1-arquivos-pdf/")
purrr::map(.x = arquivos, .f = converter_pdf_para_rds)

fs::dir_ls("data-raw/2-texto-arquivos/") %>% length()
