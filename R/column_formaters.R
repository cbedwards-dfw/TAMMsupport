#' Format vector of mixed characters to present numbers as percents
#'
#' Intended for internal use within formatting functions. Note that percents in excel are read in
#' as proportions in R -- this makes them percents to make saved files more readable.
#'
#' @param x Character vector, presumably containing some entries that are numbers in character form
#' @param percent_digits Number of digits to round to after converting to percents
#'
#' @return character vector with individual entries converted to percentages and rounded as appropriate.
#'
fun_percenter <- function(x, percent_digits) {
  stopifnot(is.character(x))
  stopifnot(is.numeric(percent_digits))
  ind <- suppressWarnings(!is.na(as.numeric(x)))
  x[ind] <- paste0(round(as.numeric(x[ind]) * 100, percent_digits), "%")
  return(x)
}

#' Format vector of mixed characters to round numbers to specified digits
#'
#' Intended for internal use within formatting functions.
#'
#' @inheritParams fun_percenter
#' @param digits Number of digits to round numeric items to
fun_rounder <- function(x, digits) {
  ind <- suppressWarnings(!is.na(as.numeric(x)))
  x[ind] <- round(as.numeric(x[ind]), digits)
  return(x)
}


#' Format chunks of dataframe to present as %s, round digits
#'
#' @param df dataframe of sheet to apply formatting to.
#' @param block_ranges vector of characters specifying blocks of cells (in excel nomenclature) to format as %s
#' @param percent_digits Decimal place to round to in percent
#'
#' @return Formatted version of `df`
#'
chunk_formater_percenter <- function(df, block_ranges, percent_digits = 1) {
  df <- as.matrix(df)
  cells.ls <- do.call(rbind, lapply(block_ranges, xldiff::cell_range_translate))
  ind <- suppressWarnings(!is.na(as.numeric(df[as.matrix(cells.ls)])))
  df[as.matrix(cells.ls)[ind, ]] <-
    paste0(round(
      as.numeric(df[as.matrix(cells.ls[ind, ])]) * 100,
      percent_digits
    ), "%")
  df <- tibble::as_tibble(df)
  return(df)
}

#' Format chunks of dataframe to round digits
#'
#' @inheritParams chunk_formater_percenter
#' @param digits Decimal place to round to.
#' @return Formatted version of `df`

chunk_formater_rounder <- function(df, block_ranges, digits = 1) {
  ## as above, but just rounds numbers
  df <- as.matrix(df)
  cells.ls <- do.call(rbind, lapply(block_ranges, xldiff::cell_range_translate))
  ind <- suppressWarnings(!is.na(as.numeric(df[as.matrix(cells.ls)])))
  df[as.matrix(cells.ls)[ind, ]] <-
    round(
      as.numeric(df[as.matrix(cells.ls[ind, ])]),
      digits
    )
  df <- tibble::as_tibble(df)
  return(df)
}
