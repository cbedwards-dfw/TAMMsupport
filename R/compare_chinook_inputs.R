#' Compare differences in input sheets of two TAMM files
#'
#' Summarizes the differences in input sheets and returns as a table. Wrapper for `xldiff::excel_diff_table()`
#'
#' @param file_1 Filename of first TAMM file
#' @param file_2 Filename of second TAMM file
#' @inheritParams xldiff::present_rows_changed
#' @param trim_cols Should columns that contain no differences be cut from the results? Defaults to TRUE.
#' @param diff_only Should entries that do not contain differences be replaced by "" to help spot differences? Defaults to TRUE.
#'
#' @return Tibble of differences in the input files; only rows with differences are included. `row_name` variable gives the row name in the TAMM file, and column names match excel column names.
#' @export
#'
compare_chinook_inputs = function(file_1,
                                  file_2,
                                  proportional_threshold = 0.001,
                                  absolute_threshold = NULL,
                                  digits_show = 6,
                                  trim_cols = TRUE,
                                  diff_only = TRUE){

  xldiff::excel_diff_table(file_1, file_2,
                            sheet_name = "Input Page",
                            proportional_threshold = proportional_threshold,
                            absolute_threshold = absolute_threshold,
                            digits_show = digits_show)
}
