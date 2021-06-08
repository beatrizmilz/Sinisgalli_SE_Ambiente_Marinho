## code to prepare `dados-drive` dataset goes here

# usethis::use_data(dados-drive, overwrite = TRUE)

# Primeiro vamos baixar os dados! --------------

# link da pasta do google drive
url <- "https://drive.google.com/drive/folders/12LwvJwsqIN5duKPsTa794qf1J-xN0OxH?usp=sharing"


# listar os arquivos que são PDFs
lista_de_arquivos <- googledrive::drive_ls(
  path = url,
  pattern = ".pdf",
  recursive = TRUE
) %>%
  dplyr::mutate(
    nome_limpo = janitor::make_clean_names(name),
    nome_limpo = stringr::str_replace_all(nome_limpo, "_pdf", ".pdf")
  ) %>%
  dplyr::relocate(nome_limpo, .after = name)

# Criar uma pasta para fazer download dos arquivos
fs::dir_create("data-raw/arquivos")

# Criar uma função para baixar os arquivos
baixar_arquivo <- function(indice) {
  arquivo <- lista_de_arquivos %>%
    tibble::rowid_to_column() %>%
    dplyr::filter(rowid == indice)

  caminho_arquivo <- glue::glue("data-raw/arquivos/{arquivo$nome_limpo}")

  if(as.vector(fs::file_exists(caminho_arquivo)) == FALSE){
    googledrive::drive_download(
      file = googledrive::as_id(arquivo$id),
      path = caminho_arquivo,
      overwrite = TRUE
    )
  }

}

# Baixar todos
purrr::map_dfr(.x = 1:nrow(lista_de_arquivos), .f = baixar_arquivo)

# Ver quais são os arquivos baixados
fs::dir_ls("data-raw/arquivos/") %>% length()
