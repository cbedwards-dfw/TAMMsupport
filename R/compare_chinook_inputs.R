#' Compare differences in input sheets of two TAMM files
#'
#' Summarizes the differences in input sheets and returns them as a tibble.
#'
#' @param file1 Filename of first TAMM file
#' @param file2 Filename of second TAMM file
#' @param digits.signif How many digits should be rounded to before looking for differences? Without this, miniscule excel numerical differences (e.g. differing by 0.000000001) can get picked up and overwhelm the meaningful differences.
#' @param trim.cols Should columns that contain no differences be cut from the results? Defaults to TRUE.
#' @param diff.only Should entries that do not contain differences be replaced by "" to help spot differences? Defaults to TRUE.
#'
#' @return Tibble of differences in the input files; only rows with differences are included. `row_name` variable gives the row name in the TAMM file, and column names match excel column names.
#' @export
#'
compare_chinook_inputs = function(file1,
                                  file2,
                                  digits.signif = 4,
                                  trim.cols = TRUE,
                                  diff.only = TRUE){
  t1 = readxl::read_excel(file1,
                          sheet = "Input Page",
                          col_names = FALSE, .name_repair = "unique_quiet"
  )
  t2 = readxl::read_excel(file2,
                          sheet = "Input Page",
                          col_names = FALSE, .name_repair = "unique_quiet"
  )
  xldiff::present_rows_changed(t1, t2, digits.signif = digits.signif, trim.cols = trim.cols,
                               diff.only = diff.only)
}
