
#' Format vector of mixed characters to present numbers as percents
#'
#' Intended for internal use within formatting functions. Note that percents in excel are read in
#' as proportions in R -- this makes them percents to make saved files more readable.
#'
#' @param x Character vector, presumably containing some entries that are numbers in character form
#' @param percent.digits Number of digits to round to after converting to percents
#'
#' @return character vector with individual entries converted to percentages and rounded as appropriate.
#'
fun_percenter = function(x, percent.digits){
  stopifnot(is.character(x))
  stopifnot(is.numeric(percent.digits))
  ind = suppressWarnings(!is.na(as.numeric(x)))
  x[ind] = paste0(round(as.numeric(x[ind])*100, percent.digits),"%")
  return(x)
}

#' Format vector of mixed characters to round numbers to specified digits
#'
#' Intended for internal use within formatting functions.
#'
#' @inheritParams fun_percenter
#' @param digits Number of digits to round numeric items to
fun_rounder = function(x, digits){
  ind = suppressWarnings(!is.na(as.numeric(x)))
  x[ind] = round(as.numeric(x[ind]), digits)
  return(x)
}


chunk_formater_percenter = function(){
  ## take multiple chunks in excel cell address format
  ## For each, takes the subset, and applies the same procedure as fun_percenter
}
chunk_formater_rounder = function(){
  ## as above, but just rounds numerics
}
