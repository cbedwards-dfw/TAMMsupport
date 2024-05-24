#' Compare key sheets of Chinook TAMM files
#'
#' @param filename.1 name of first TAMM file to compare. Include file path if file is not in working directory.
#' @param filename.2 name of second TAMM file to compare. Include file path if file is not in working directory.
#' @param results.name name of output sheets. Include file path if save location is not in working directory.
#' @param percent.digits Number of decimals to round percentages to before comparing. Defaults to 1.
#' @param numeric.digits Number of decimals to round numbers to before comparing. Applied to cells which expect to be whole numbers (e.g. #s of fish). Defaults to 1.
#' @param numeric.digits.small Number of decimals to round numbers to before comparing. Applied to cells which expect to be small decimals. Defaults to 4.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' tamm_diff(filename.1 = here("FRAM/Chin1124.xlsx"),
#' filename.2 = here("NOF 2/Chin2524.xlsx"),
#' results.name = here("Chin 1124 vs Chin 2524.xlsx")
#' )
#' }
tamm_diff = function(filename.1, filename.2, results.name, percent.digits = 1, numeric.digits = 1,
                     numeric.digits.small = 4){
  if(!all(grepl(".xlsx$", c(filename.1, filename.2, results.name)))){
    cli::cli_abort("`filename.1`, `filename.2`, and `results.name` must end in \".xlsx\".")
  }
  ## Note: working with all the sheets was really time consuming. Working with just the 3
  ## key sheets seems to take more like a couple minutes.
  f1 = read_key_tamm_sheets(filename.1)
  f1 = format_key_tamm_sheets(f1, percent.digits = percent.digits, numeric.digits = numeric.digits,
                              numeric.digits.small = numeric.digits.small)
  f2 = read_key_tamm_sheets(filename.2)
  f2 = format_key_tamm_sheets(f2, percent.digits = percent.digits, numeric.digits = numeric.digits,
                              numeric.digits.small = numeric.digits.small)

  out = list()
  for(i in 1:length(f1)){
    out[[i]] = xldiff::sheet_comp(f1[[i]], f2[[i]], digits.signif = 10)
  }
  names(out) = names(f1)

  # out = map2(f1, f2, sheet_comp)

  ## handle formatting


  wb = openxlsx::createWorkbook()
  names(f1) |>
    purrr::walk(~ openxlsx::addWorksheet(wb, .)) |>
    purrr::walk(~ openxlsx::writeData(wb, sheet = ., x = out[[.]]$sheet.diff, colNames = FALSE, keepNA = FALSE))

  tamm_format_overview(wb, diff.sheet = out$overview$sheet.diff)
  tamm_format_limiting(wb)
  tamm_format_input(wb)

  wb = xldiff::add_changed_formats(wb, cur.sheet = "overview", out$overview, cols.invert = c(3, 5)) #invert ER  ceiling and escapement colors
  wb = xldiff::add_changed_formats(wb, cur.sheet = "limiting", out$limiting, rows.invert =  c(3, 82, 161, 240, 319, 398) + 73) #invert escapement rows
  wb = xldiff::add_changed_formats(wb, cur.sheet = "input", out$input)




  ## rename sheets to include
  for(i in 1:length(out)){i
    sum.change = sum(out[[i]]$mat.changed)
    if(sum.change > 999){sum.change = ">999"}
    openxlsx::renameWorksheet(wb, names(out)[i], paste0(names(out)[i], " (", sum.change, ")"))
  }

  ## add fit info
  dat.info = data.frame(c("FILES", "\'Original\'", "\'new\'", "", "DATE COMPARED"),
                        c("", filename.1, filename.2, "", as.character(as.Date(Sys.Date()))),
                        fix.empty.names = FALSE)
  openxlsx::addWorksheet(wb, "COMPARISON INFO")
  openxlsx::writeData(wb, "COMPARISON INFO",
            dat.info, colNames = FALSE)

  openxlsx::saveWorkbook(wb, file = results.name, overwrite = TRUE)
}
