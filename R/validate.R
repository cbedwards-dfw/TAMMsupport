
validate_data_frame <- function(x, ..., arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  # checks for data frame, stolen from the tidyr package
  if (!is.data.frame(x)) {
    cli::cli_abort("{.arg {arg}} must be a data frame, not {.obj_type_friendly {x}}.", ..., call = call)
  }
}


validate_numeric <- function(x, n = NULL, min = NULL, max = NULL, ..., arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is.numeric(x)) {
    cli::cli_abort("{.arg {arg}} must be a numeric, not {class(x)}.", ..., call = call)
  }
  if (!is.null(n)) {
    if (length(x) != n) {
      cli::cli_abort("{.arg {arg}} must be a numeric of length {n}.", ..., call = call)
    }
  }
  if (!is.null(min)) {
    if (any(x < min)) {
      if (!is.null(n) && n > 1) {
        cli::cli_abort("All values of {.arg {arg}} must be no less than {min}.", ..., call = call)
      } else {
        cli::cli_abort("{.arg {arg}} must be no less than {min}.", ..., call = call)
      }
    }
  }
  if (!is.null(max)) {
    if (any(x > max)) {
      if (!is.null(n) && n > 1) {
        cli::cli_abort("All values of {.arg {arg}} must be no greater than than {max}.", ..., call = call)
      } else {
        cli::cli_abort("{.arg {arg}} must be no greater than than {max}.", ..., call = call)
      }
    }
  }
}

validate_character <- function(x, n = NULL, ..., arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  if (!is.character(x)) {
    cli::cli_abort("{.arg {arg}} must be a character, not {class(x)}.", ..., call = call)
  }
  if(!is.null(n)){
    if(length(x) != n){
      cli::cli_abort("{.arg {arg}} must be a character of length {n}.", ..., call = call)
    }
  }
}

validate_flag <- function(x, ..., arg = rlang::caller_arg(x), call = rlang::caller_env()){
  if (!is.logical(x) | length(x) != 1) {
    cli::cli_abort("{.arg {arg}} must be a a logical of length 1.", ..., call = call)
  }
}

validate_integer <- function(x, n = NULL, ..., arg = rlang::caller_arg(x), call = rlang::caller_env()) {
  validate_numeric(x, n, arg = arg, call = call, ...)
  if (any(x %% 1 != 0)) {
    if (!is.null(n) && n > 1) {
      cli::cli_abort("{.arg {arg}} must contain only whole numbers.", ..., call = call)
    } else {
      cli::cli_abort("{.arg {arg}} must be a whole number.", ..., call = call)
    }
  }
}
