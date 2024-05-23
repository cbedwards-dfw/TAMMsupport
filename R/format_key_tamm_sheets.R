#' Modify list of TAMM spreadsheet dataframes to facilitate comparison.
#'
#' @param dat list of dataframes corresponding to the overview, limiting stock, and inputs tabs. Must be named `$overview`, `$limiting`, and `$input`
#' @param percent.digits Optional, number of decimal places to round percentages to before comparison. Defaults to 1.
#' @param numeric.digits Optional, number of decimal places to round non-percentage numerics to before comparison. Defaults to 1.
#'
#' @return list of dataframes with same structure as `dat`, contents modified.
#'
format_key_tamm_sheets = function(dat, percent.digits = 1, #decimal digits to track/display for %s
                                  numeric.digits = 1){#if numeric vector, avoid percantage-ing those rows.
  ## overview tab
  dat$overview[,c(3, 6:8)] = apply(dat$overview[,c(3, 6:8)], 2, fun_percenter, percent.digits = percent.digits)
  dat$overview[ , 5] = fun_rounder(dat$overview[ , 5, drop = TRUE], digits = numeric.digits)

  ## limiting stock complete
  ## stock chunks start on col 3.
  stk.start = seq(3,101, by = 7)
  cols.escape = rowSums(tidyr::expand_grid(stk.start, 0:2))

  cols.perc = rowSums(tidyr::expand_grid(stk.start, 3:6))
  ## Note: for formatting to percents, we want to skip the "under" rows.
  rows.unders =  c(3, 82, 161, 240, 319, 398) + 76 #starting rows for each chunk plus offset

  dat$limiting[, cols.escape] = apply(dat$limiting[, cols.escape], 2, fun_rounder,  digits = numeric.digits)
  dat$limiting[-(rows.unders), cols.perc] = apply(dat$limiting[-(rows.unders), cols.perc], 2, fun_percenter, percent.digits = percent.digits)

  ## inputs tab!!
  dat$input = chunk_formater_percenter(dat$input, block.ranges = c("D14:F16", "B20:B26"))

  return(dat)
}
