fs::dir_ls("data-raw/2-texto-arquivos/") %>% length()

df_arquivos_raw <- fs::dir_ls("data-raw/2-texto-arquivos/") %>%
  purrr::map_dfr(readr::read_rds)

df_arquivos <- df_arquivos_raw %>% dplyr::mutate(texto_limpo = stringr::str_squish(texto),
                              texto_limpo = stringr::str_trim(texto_limpo))


usethis::use_data(df_arquivos, overwrite = TRUE)


# Verificando
df_arquivos %>%
  dplyr::mutate(n_char = nchar(texto)) %>%
  dplyr::group_by(nome_arquivo) %>%
  dplyr::summarise(sum_nchar = sum(n_char, na.rm = TRUE)) %>%
  View()


# Deu erro nesses arquivos
# data-raw/1-arquivos-pdf/hebling1994.pdf - é um PDF digitalizado
# é possível tentar com OCR mas gera erros.
# data-raw/1-arquivos-pdf/quintana2004.pdf
# Erro: PDF error: Unknown font type: ''

arquivos[33]

pdftools::pdf_text(arquivos[33])
