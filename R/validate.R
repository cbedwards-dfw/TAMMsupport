#' Confirm object is dataframe
#'
#' @param x Object to check
#' @param ... additional arguments
#' @param arg name of argument in calling function, identified programmatically using rlang
#' @param call name of calling function, identified programmatically using rlang
#'
validate_data_frame <- function(x, ..., arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  # checks for data frame, stolen from the tidyr package
  if (!is.data.frame(x)) {
    cli::cli_abort("{.arg {arg}} must be a data frame, not {.obj_type_friendly {x}}.", ..., call = call)
  }
}
