#' Compare key sheets of TAMM files
#'
#'
#'
#' @param file_1 name of first TAMM file to compare. Include file path if file is not in working directory.
#' @param file_2 name of second TAMM file to compare. Include file path if file is not in working directory.
#' @param results_name name of output sheets. Include file path if save location is not in working directory.
#' @inheritParams xldiff::excel_diff
#'
#' @export
#' @examples
#' \dontrun{
#' tamm_diff(
#'   file_1 = here("FRAM/Chin1124.xlsx"),
#'   file_2 = here("NOF 2/Chin2524.xlsx"),
#'   results_name = here("Chin 1124 vs Chin 2524.xlsx")
#' )
#' }
tamm_diff <- function(file_1, file_2, results_name, proportional_threshold = 0.001, absolute_threshold = NULL,
                      extra_width = NULL) {
  if (!all(grepl(".xlsx$|.xlsm$", c(file_1, file_2, results_name)))) {
    cli::cli_abort("`file_1`, `file_2`, and `results_name` must end in \".xlsx\" or \".xlsm\".")
  }
  ## identify species
  ## Listing just the key sheets for each species. If other sheets change, we don't want to have to rewrite this.
  sheets_chin <- c("ER_ESC_Overview_New", "Input Page", "LimitingStkComplete mod")
  sheets_coho <- c("2", "Tami", "WACoastTerminal")

  f1.sheets <- readxl::excel_sheets(file_1)

  if (all(sheets_chin %in% f1.sheets)) {
    spec.f1 <- "chin"
  } else if (all(sheets_coho %in% f1.sheets)) {
    spec.f1 <- "coho"
  } else {
    cli::cli_abort("`file_1` does not appear to be either a Chinook or Coho TAMM file.")
  }

  f2.sheets <- readxl::excel_sheets(file_2)
  if (all(sheets_chin %in% f2.sheets)) {
    spec.f2 <- "chin"
    sheets_cur = sheets_chin
  } else if (all(sheets_coho %in% f2.sheets)) {
    spec.f2 <- "coho"
    sheets_cur = sheets_coho
  } else {
    cli::cli_abort("`file_2` does not appear to be either a Chinook or Coho TAMM file.")
  }

  if (spec.f1 != spec.f2) {
    cli::cli_abort("`file_1` and `file_2` must be TAMMs for the same species.")
  }

  xldiff::excel_diff(file_1 = file_1,
             file_2 = file_2,
             sheet_name = sheets_cur,
             results_name = results_name,
             proportional_threshold = proportional_threshold,
             absolute_threshold = absolute_threshold,
             extra_width = extra_width,
             verbose = TRUE)

}

