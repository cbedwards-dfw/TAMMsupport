#'  `r lifecycle::badge("experimental")`
#'
#' Extract Treaty and Nontreaty numbers from "2A_CU&M_H+N" TAMM sheet
#'
#' Currently provides dataframe with `fishery.original` column identifying the fishery.
#' With advice from Derek, will add a `fishery` column that is human-readable version of above. Might
#' Try to create same naming conventions as in `read_overview_complete()`.
#'
#' @param xlsxFile Character vector. Filename (including path) for chinook TAMM
#' @return dataframe with the treaty and nontreaty mortalities at each fishery.
#' @export

read_tnt_allocation_chin = function(xlsxFile){
  raw = readxl::read_excel(xlsxFile, sheet = "2A_CU&M_H+N",
                     col_names = FALSE)
  ## rows and columns identified by hand
  df = raw[c(9, 10, 56, 57), c(4:10, 15:21, 25:33)] |>
    t() |>
    data.frame(row.names = NULL)
  names(df) = c("name.1", "name.2", "nontreaty", "treaty")
  df = df |>
    dplyr::mutate(fishery.original = paste0(.data$name.1, " ", .data$name.2), .before = "nontreaty") |>
    dplyr::select(-"name.1", -"name.2")
  return(df)
}
