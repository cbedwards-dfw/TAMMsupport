#' Read Chinook TAMM files to extract the key sheets
#'
#'
#' @param file  #Tamm file name
#'
#' @return List of dataframes: `$overview`, `$limiting`, and `$input`
#' @export
#'
read_key_tamm_sheets_chin <- function(file) {
  sheets.list <- list()
  sheets.list$overview <- readxl::read_excel(file,
    sheet = "ER_ESC_Overview_New",
    range = "A1:H37",
    col_names = FALSE, .name_repair = "unique_quiet"
  )
  sheets.list$limiting <- readxl::read_excel(file,
    sheet = "LimitingStkComplete mod",
    range = "J1:DL474",
    col_names = FALSE, .name_repair = "unique_quiet"
  )
  sheets.list$input <- readxl::read_excel(file,
    sheet = "Input Page",
    range = "A1:AE299",
    col_names = FALSE, .name_repair = "unique_quiet"
  )
  return(sheets.list)
}


#' Read Chinook TAMM files to extract the key sheets
#' @param file  #Tamm file name
#'
#' @return List of dataframes: `$two`, `$tami`, and `$wacoast`
#' @export
#'
read_key_tamm_sheets_coho <- function(file) {
  sheets.list <- list()
  sheets.list$two <- readxl::read_excel(file,
    sheet = "2",
    range = "A1:BY108",
    col_names = FALSE, .name_repair = "unique_quiet"
  )
  sheets.list$tami <- readxl::read_excel(file,
    sheet = "Tami",
    range = "A1:M93",
    col_names = FALSE, .name_repair = "unique_quiet"
  )
  sheets.list$wacoast <- readxl::read_excel(file,
    sheet = "WACoastTerminal",
    range = "A1:AF187",
    col_names = FALSE, .name_repair = "unique_quiet"
  )
  return(sheets.list)
}
