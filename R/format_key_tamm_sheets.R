#' Modify list of Chinook TAMM spreadsheet dataframes to facilitate comparison.
#'
#' @param dat list of dataframes corresponding to the overview, limiting stock, and inputs tabs. Must be named `$overview`, `$limiting`, and `$input`
#' @param percent.digits Optional, number of decimal places to round percentages to before comparison. Defaults to 1.
#' @param numeric.digits Optional, number of decimal places to round non-percentage numerics to before comparison. Applied to numbers that are expected to have natural units of whole numbers (e.g. numbers of fish). Defaults to 1.
#' @param numeric.digits.small Optional, number of decimal places to round non-percentage numerics to before comparison. Applied to numbers that are expected to be small (e.g. rates, proportions) Defaults to 4.
#'
#' @return list of dataframes with same structure as `dat`, contents modified.
#'
format_key_tamm_sheets_chin <- function(dat, percent.digits = 1, # decimal digits to track/display for %s
                                        numeric.digits = 1,
                                        numeric.digits.small = 4) { # if numeric vector, avoid percantage-ing those rows.
  ## overview tab
  dat$overview[, c(3, 6:8)] <- apply(dat$overview[, c(3, 6:8)], 2, fun_percenter, percent.digits = percent.digits)
  dat$overview[, 5] <- fun_rounder(dat$overview[, 5, drop = TRUE], digits = numeric.digits)

  ## limiting stock complete
  ## stock chunks start on col 3.
  stk.start <- seq(3, 101, by = 7)
  cols.escape <- rowSums(tidyr::expand_grid(stk.start, 0:2))

  cols.perc <- rowSums(tidyr::expand_grid(stk.start, 3:6))
  ## Note: for formatting to percents, we want to skip the "under" rows.
  rows.unders <- c(3, 82, 161, 240, 319, 398) + 76 # starting rows for each chunk plus offset

  dat$limiting[, cols.escape] <- apply(dat$limiting[, cols.escape], 2, fun_rounder, digits = numeric.digits)
  dat$limiting[-(rows.unders), cols.perc] <- apply(dat$limiting[-(rows.unders), cols.perc], 2, fun_percenter, percent.digits = percent.digits)

  ## inputs tab
  ## Percentage cells
  dat$input <- chunk_formater_percenter(dat$input,
    block.ranges = c(
      "D14:F16", "B20:B26",
      "D30:F34", "B35",
      "D41:D47", "B53:E70",
      "B77:F83", "B89:E91",
      "T54:T72", "R77:T77",
      "S85:S86", "P46",
      "B89:E92", "D93:D94",
      "E102:F120", "M104:M105",
      "D126:F178", "I153:I169",
      "J200", "L200", "AC201",
      "Q220", "L284"
    ),
    percent.digits = percent.digits
  )
  ## cells to round to 2 digits (e.g. fish counts)
  dat$input <- chunk_formater_rounder(dat$input,
    block.ranges = c(
      "K14:N91", "O53:R72",
      "S87:S88", "S78:S80",
      "J117:L117",
      "D180:F191", "O198:U193",
      "X197:Y202", "Z208:AA213",
      "X211:X213", "O210:Q222",
      "S213:U221", "J220:J221",
      "I281:O281", "Q278:T278"
    ),
    digits = numeric.digits
  )
  ## Cells to round to 4 digits (e.g., proportions)
  dat$input <- chunk_formater_rounder(dat$input,
    block.ranges = c(
      "B18", "B41:C47",
      "B101:B299", "L183:O191",
      "P77:P80", "AB198:AC199",
      "D251:F299", "L278:O278",
      "R267:R276", "D18", "D101:D117"
    ),
    digits = numeric.digits.small
  )

  return(dat)
}


#' Modify list of Coho TAMM spreadsheet dataframes to facilitate comparison.
#'
#' @inheritParams format_key_tamm_sheets_chin
#'
#' @return list of dataframes with same structure as `dat`, contents modified.
#'
format_key_tamm_sheets_coho <- function(dat, percent.digits = 1, # decimal digits to track/display for %s
                                        numeric.digits = 1,
                                        numeric.digits.small = 4) { # if numeric vector, avoid percantage-ing those rows.

  return(dat)
}
