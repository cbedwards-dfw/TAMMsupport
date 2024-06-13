#' Compare key sheets of TAMM files
#'
#' @details
#' If TAMM formatting is changes (e.g. the addition of rows, etc), make changes in the following areas:
#'   - `read_key_tamm_sheets_SPECIES()`: The `range` argument in each `read_excel` call should change to match the new dimensions of each sheet.
#'   - `format_key_tamm_sheets_SPECIES()`: These functions designate groups of cells to be
#'   Depending on the sheets that change, any amount of the content here may need to change. In the case of
#'   the inputs tab section, the cell ranges can be reported directly. Remember that we are separately designating cells which should be rounded to the nearest
#'   `numeric.digits` (generally measures of fish) and those that should be rounded to the nearest `numeric.digits.small` (generall proportions and rates; typically
#'   values that are less than 1.). Note that the earlier code was written before the more flexible `chunk_formater_percenter` and `chunk_formater_rounder` had been developed.
#'   If rewriting, lean into those tools, as they will streamline designating regions of cells for the various rounding criterion.
#'   - `tamm_format_SHEETNAME()` (for the sheet formatting functions relevant to that species): each individual
#'   sheet has custom formatting to generally match the corresponding TAMM sheets. If the locations of cells move,
#'   the changes to font size, addition of borders, etc, will also need to move. Note that `tamm_format_limiting` and `tamm_format_overview` were written
#'   before the development of the more flexible `add_cell_borders`, or the combined use of `purrr::map` and `cell_range_translate`. Look to `tamm_format_input`
#'   for relatively inputting of formatting. Consider developing other helper functions as needed (esp for merging).
#'
#'
#' @param filename.1 name of first TAMM file to compare. Include file path if file is not in working directory.
#' @param filename.2 name of second TAMM file to compare. Include file path if file is not in working directory.
#' @param results.name name of output sheets. Include file path if save location is not in working directory.
#' @param percent.digits Number of decimals to round percentages to before comparing. Defaults to 1.
#' @param numeric.digits Number of decimals to round numbers to before comparing. Applied to cells which expect to be whole numbers (e.g. #s of fish). Defaults to 1.
#' @param numeric.digits.small Number of decimals to round numbers to before comparing. Applied to cells which expect to be small decimals. Defaults to 4.
#' @param dim.override Should we force comparisons even if one or more of the sheets don't have matching dimensions between the two files? Defaults to FALSE.
#' @param wrap.text Should specific cells with long contents (e.g., input "Fishery Description" cells) use text wrapping? Defaults to FALSE
#'
#' @export
#' @examples
#' \dontrun{
#' tamm_diff(
#'   filename.1 = here("FRAM/Chin1124.xlsx"),
#'   filename.2 = here("NOF 2/Chin2524.xlsx"),
#'   results.name = here("Chin 1124 vs Chin 2524.xlsx")
#' )
#' }
tamm_diff <- function(filename.1, filename.2, results.name, percent.digits = 1, numeric.digits = 1,
                      numeric.digits.small = 4, dim.override = FALSE, wrap.text = FALSE) {
  if (!all(grepl(".xlsx$|.xlsm$", c(filename.1, filename.2, results.name)))) {
    cli::cli_abort("`filename.1`, `filename.2`, and `results.name` must end in \".xlsx\" or \".xlsm\".")
  }
  ## identify species
  ## Listing just the key sheets for each species. If other sheets change, we don't want to have to rewrite this.
  sheets.chin <- c("ER_ESC_Overview_New", "Input Page", "LimitingStkComplete mod")
  sheets.coho <- c("2", "Tami", "WACoastTerminal")

  f1.sheets <- readxl::excel_sheets(filename.1)

  if (all(sheets.chin %in% f1.sheets)) {
    spec.f1 <- "chin"
  } else if (all(sheets.coho %in% f1.sheets)) {
    spec.f1 <- "coho"
  } else {
    cli::cli_abort("`filename.1` does not appear to be either a Chinook or Coho TAMM file.")
  }

  f2.sheets <- readxl::excel_sheets(filename.2)
  if (all(sheets.chin %in% f2.sheets)) {
    spec.f2 <- "chin"
  } else if (all(sheets.coho %in% f2.sheets)) {
    spec.f2 <- "coho"
  } else {
    cli::cli_abort("`filename.2` does not appear to be either a Chinook or Coho TAMM file.")
  }

  if (spec.f1 != spec.f2) {
    cli::cli_abort("`filename.1` and `filename.2` must be TAMMs for the same species.")
  } else {
    spec.all <- spec.f1
  }


  if (spec.all == "chin") {
    tamm_diff_chin(
      filename.1 = filename.1, filename.2 = filename.2, results.name = results.name, percent.digits = percent.digits,
      numeric.digits = numeric.digits,
      numeric.digits.small = numeric.digits.small,
      dim.override = dim.override,
      wrap.text = wrap.text
    )
  }
  if (spec.all == "coho") {
    tamm_diff_coho(
      filename.1 = filename.1, filename.2 = filename.2, results.name = results.name, percent.digits = percent.digits,
      numeric.digits = numeric.digits,
      numeric.digits.small = numeric.digits.small,
      dim.override = dim.override,
      wrap.text = wrap.text
    )
  }
}

#' Compare key sheets of Chinook TAMM files
#'
#' @inheritParams tamm_diff
#'
tamm_diff_chin <- function(filename.1, filename.2, results.name, percent.digits = 1, numeric.digits = 1,
                           numeric.digits.small = 4, dim.override = FALSE,
                           wrap.text = FALSE) {
  ## Note: working with all the sheets was really time consuming. Working with just the 3
  ## key sheets seems to take more like a couple minutes.
  f1 <- read_key_tamm_sheets_chin(filename.1)
  f1 <- format_key_tamm_sheets_chin(f1,
    percent.digits = percent.digits, numeric.digits = numeric.digits,
    numeric.digits.small = numeric.digits.small
  )
  f2 <- read_key_tamm_sheets_chin(filename.2)
  f2 <- format_key_tamm_sheets_chin(f2,
    percent.digits = percent.digits, numeric.digits = numeric.digits,
    numeric.digits.small = numeric.digits.small
  )

  ## check to see that dimensions match.
  if (!all(do.call(c, lapply(f1, dim)) == do.call(c, lapply(f2, dim)))) {
    cli::cli_alert_warning("Dimensions of one or more key TAMM sheets do not match between files.
                           This could be caused by the addition of rows or columns (common if comparing across years),
                           or an accidental non-empty cell outside of the main areas used in one of the key TAMM sheets in one of the files.")
    if (!dim.override) {
      cli::cli_abort("Aborting due to dimension mismatch. To force override, add argument `dim.override = TRUE`. Code will function when doing so, but if columns or rows have been inserted, the resulting diff file may be less informative.")
    } else {
      mat.fill <- matrix(NA, nrow = 0, ncol = 8)
      dim.max <- pmax(do.call(c, lapply(f1, dim)), do.call(c, lapply(f2, dim)))
      ## padding with NAs until dimensions match
      f1$overview <- rbind(f1$overview, matrix(NA, nrow = dim.max[1] - nrow(f1$overview), ncol = ncol(f1$overview)))
      f1$overview <- cbind(f1$overview, matrix(NA, nrow = nrow(f1$overview), ncol = dim.max[2] - ncol(f1$overview)))
      f2$overview <- rbind(f2$overview, matrix(NA, nrow = dim.max[1] - nrow(f2$overview), ncol = ncol(f2$overview)))
      f2$overview <- cbind(f2$overview, matrix(NA, nrow = nrow(f2$overview), ncol = dim.max[2] - ncol(f2$overview)))

      f1$limiting <- rbind(f1$limiting, matrix(NA, nrow = dim.max[3] - nrow(f1$limiting), ncol = ncol(f1$limiting)))
      f1$limiting <- cbind(f1$limiting, matrix(NA, nrow = nrow(f1$limiting), ncol = dim.max[4] - ncol(f1$limiting)))
      f2$limiting <- rbind(f2$limiting, matrix(NA, nrow = dim.max[3] - nrow(f2$limiting), ncol = ncol(f2$limiting)))
      f2$limiting <- cbind(f2$limiting, matrix(NA, nrow = nrow(f2$limiting), ncol = dim.max[4] - ncol(f2$limiting)))

      f1$input <- rbind(f1$input, matrix(NA, nrow = dim.max[5] - nrow(f1$input), ncol = ncol(f1$input)))
      f1$input <- cbind(f1$input, matrix(NA, nrow = nrow(f1$input), ncol = dim.max[6] - ncol(f1$input)))
      f2$input <- rbind(f2$input, matrix(NA, nrow = dim.max[5] - nrow(f2$input), ncol = ncol(f2$input)))
      f2$input <- cbind(f2$input, matrix(NA, nrow = nrow(f2$input), ncol = dim.max[6] - ncol(f2$input)))
    }
  }

  out <- list()
  for (i in 1:length(f1)) {
    out[[i]] <- xldiff::sheet_comp(f1[[i]], f2[[i]], digits.signif = 10)
  }
  names(out) <- names(f1)

  # out = map2(f1, f2, sheet_comp)

  ## handle formatting


  wb <- openxlsx::createWorkbook()
  names(f1) |>
    purrr::walk(~ openxlsx::addWorksheet(wb, .)) |>
    purrr::walk(~ openxlsx::writeData(wb, sheet = ., x = out[[.]]$sheet.diff, colNames = FALSE, keepNA = FALSE))

  tamm_format_overview(wb, diff.sheet = out$overview$sheet.diff)
  tamm_format_limiting(wb)
  tamm_format_input(wb, wrap.text = wrap.text)

  wb <- xldiff::add_changed_formats(wb, cur.sheet = "overview", out$overview, cols.invert = c(3, 5)) # invert ER  ceiling and escapement colors
  wb <- xldiff::add_changed_formats(wb, cur.sheet = "limiting", out$limiting, rows.invert = c(3, 82, 161, 240, 319, 398) + 73) # invert escapement rows
  wb <- xldiff::add_changed_formats(wb, cur.sheet = "input", out$input)




  ## rename sheets to include count of changes
  for (i in 1:length(out)) {
    i
    sum.change <- sum(out[[i]]$mat.changed)
    if (sum.change > 999) {
      sum.change <- ">999"
    }
    openxlsx::renameWorksheet(wb, names(out)[i], paste0(names(out)[i], " (", sum.change, ")"))
  }

  ## add fit info
  dat.info <- data.frame(c("FILES", "\'Original\'", "\'new\'", "", "DATE COMPARED"),
    c("", filename.1, filename.2, "", as.character(as.Date(Sys.Date()))),
    fix.empty.names = FALSE
  )
  openxlsx::addWorksheet(wb, "COMPARISON INFO")
  openxlsx::writeData(wb, "COMPARISON INFO",
    dat.info,
    colNames = FALSE
  )

  openxlsx::saveWorkbook(wb, file = results.name, overwrite = TRUE)
}

#' Compare key sheets of Coho TAMM files
#'
#' @inheritParams tamm_diff
#'
tamm_diff_coho <- function(filename.1, filename.2, results.name, percent.digits = 1, numeric.digits = 1,
                           numeric.digits.small = 4, dim.override = FALSE,
                           wrap.text = FALSE) {
  f1 <- read_key_tamm_sheets_coho(filename.1)
  f1 <- format_key_tamm_sheets_coho(f1,
    percent.digits = percent.digits, numeric.digits = numeric.digits,
    numeric.digits.small = numeric.digits.small
  )
  f2 <- read_key_tamm_sheets_coho(filename.2)
  f2 <- format_key_tamm_sheets_coho(f2,
    percent.digits = percent.digits, numeric.digits = numeric.digits,
    numeric.digits.small = numeric.digits.small
  )

  ## check to see that dimensions match.
  if (!all(do.call(c, lapply(f1, dim)) == do.call(c, lapply(f2, dim)))) {
    cli::cli_alert_warning("Dimensions of one or more key TAMM sheets do not match between files.
                           This could be caused by the addition of rows or columns (common if comparing across years),
                           or an accidental non-empty cell outside of the main areas used in one of the key TAMM sheets in one of the files.")
    if (!dim.override) {
      cli::cli_abort("Aborting due to dimension mismatch. To force override, add argument `dim.override = TRUE`. Code will function when doing so, but if columns or rows have been inserted, the resulting diff file may be less informative.")
    } else {
      mat.fill <- matrix(NA, nrow = 0, ncol = 8)
      dim.max <- pmax(do.call(c, lapply(f1, dim)), do.call(c, lapply(f2, dim)))
      ## padding with NAs until dimensions match
      f1$two <- rbind(f1$two, matrix(NA, nrow = dim.max[1] - nrow(f1$two), ncol = ncol(f1$two)))
      f1$two <- cbind(f1$two, matrix(NA, nrow = nrow(f1$two), ncol = dim.max[2] - ncol(f1$two)))
      f2$two <- rbind(f2$two, matrix(NA, nrow = dim.max[1] - nrow(f2$two), ncol = ncol(f2$two)))
      f2$two <- cbind(f2$two, matrix(NA, nrow = nrow(f2$two), ncol = dim.max[2] - ncol(f2$two)))

      f1$tami <- rbind(f1$tami, matrix(NA, nrow = dim.max[3] - nrow(f1$tami), ncol = ncol(f1$tami)))
      f1$tami <- cbind(f1$tami, matrix(NA, nrow = nrow(f1$tami), ncol = dim.max[4] - ncol(f1$tami)))
      f2$tami <- rbind(f2$tami, matrix(NA, nrow = dim.max[3] - nrow(f2$tami), ncol = ncol(f2$tami)))
      f2$tami <- cbind(f2$tami, matrix(NA, nrow = nrow(f2$tami), ncol = dim.max[4] - ncol(f2$tami)))

      f1$wacoast <- rbind(f1$wacoast, matrix(NA, nrow = dim.max[5] - nrow(f1$wacoast), ncol = ncol(f1$wacoast)))
      f1$wacoast <- cbind(f1$wacoast, matrix(NA, nrow = nrow(f1$wacoast), ncol = dim.max[6] - ncol(f1$wacoast)))
      f2$wacoast <- rbind(f2$wacoast, matrix(NA, nrow = dim.max[5] - nrow(f2$wacoast), ncol = ncol(f2$wacoast)))
      f2$wacoast <- cbind(f2$wacoast, matrix(NA, nrow = nrow(f2$wacoast), ncol = dim.max[6] - ncol(f2$wacoast)))
    }
  }


  out <- list()
  for (i in 1:length(f1)) {
    out[[i]] <- xldiff::sheet_comp(f1[[i]], f2[[i]], digits.signif = 10)
  }
  names(out) <- names(f1)

  wb <- openxlsx::createWorkbook()
  names(f1) |>
    purrr::walk(~ openxlsx::addWorksheet(wb, .)) |>
    purrr::walk(~ openxlsx::writeData(wb, sheet = ., x = out[[.]]$sheet.diff, colNames = FALSE, keepNA = FALSE))

  # tamm_format_overview(wb, diff.sheet = out$overview$sheet.diff)
  # # tamm_format_limiting(wb)
  # tamm_format_input(wb)

  wb <- xldiff::add_changed_formats(wb, cur.sheet = "two", out$two) # invert ER  ceiling and escapement colors
  wb <- xldiff::add_changed_formats(wb, cur.sheet = "tami", out$tami) # invert escapement rows
  wb <- xldiff::add_changed_formats(wb, cur.sheet = "wacoast", out$wacoast)


  tamm_format_wacoast(wb)

  for (i in 1:length(out)) {
    i
    sum.change <- sum(out[[i]]$mat.changed)
    if (sum.change > 999) {
      sum.change <- ">999"
    }
    openxlsx::renameWorksheet(wb, names(out)[i], paste0(names(out)[i], " (", sum.change, ")"))
  }

  ## add fit info
  dat.info <- data.frame(c("FILES", "\'Original\'", "\'new\'", "", "DATE COMPARED"),
    c("", filename.1, filename.2, "", as.character(as.Date(Sys.Date()))),
    fix.empty.names = FALSE
  )
  openxlsx::addWorksheet(wb, "COMPARISON INFO")
  openxlsx::writeData(wb, "COMPARISON INFO",
    dat.info,
    colNames = FALSE
  )

  openxlsx::saveWorkbook(wb, file = results.name, overwrite = TRUE)
}
