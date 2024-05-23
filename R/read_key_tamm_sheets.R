#' Read TAMM files to extract the key sheets
#'
#'
#' @param xlsxFile  #Tamm file name
#'
#' @return List of dataframes: `$overview`, `$limiting`, and `$input`
#' @export
#'
read_key_tamm_sheets = function(xlsxFile){
  sheets.list = list()
  sheets.list$overview = readxl::read_excel(xlsxFile,
                                    sheet = "ER_ESC_Overview_New",
                                    range = "A1:H37",
                                    col_names = FALSE, .name_repair = "unique_quiet")
  sheets.list$limiting = readxl::read_excel(xlsxFile,
                                    sheet = "LimitingStkComplete mod",
                                    range = "J1:DL474",
                                    col_names = FALSE, .name_repair = "unique_quiet")
  sheets.list$input = readxl::read_excel(xlsxFile,
                                 sheet = "Input Page",
                                 range = "A1:AE299",
                                 col_names = FALSE, .name_repair = "unique_quiet")
  return(sheets.list)
}
