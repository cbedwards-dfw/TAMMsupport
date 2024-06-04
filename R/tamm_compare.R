#' Generate summary comparison of any number of TAMM files
#'
#' Intended use case is to compare low, mid, and high ocean option.
#'
#' @param tamm.names character vector of the three tamm files to compare (including .xlsx suffix).
#' @param tamm.path Absolute path to directory containing the tamm file. `here::here()` can be useful in identifying appropriate path. Character atomic; defaults to current working directory.
#' @param fisheries Optional, numeric vector of fishery IDs to filter to before plotting fishery-specific ER for each stock. Defaults to NULL (no filtering).
#' @param clean Should the intermediate .qmd files used to make the report be deleted afterwards? Logical, defaults to `TRUE`. Set to `FALSE`
#' to explore the .qmd files underlying the report.
#' @param overwrite Should the intermediate .qmd files or the final report be overwritten if those files already exist?; Logical, defaults to `TRUE`.
#'
#' @return Nothing
#' @export
#'
#' @examples
#' \dontrun{
#' tamm.path = "C:/Users/edwc1477/Documents/WDFW FRAM team work/NOF material/NOF 2024/FRAM"
#' tamm.names =c("Chin1024.xlsx", "Chin1124.xlsx", "Chin1224.xlsx")
#' tamm_compare3(tamm.names = tamm.names, tamm.path = tamm.path)
#' }
tamm_compare <- function(tamm.names, tamm.path = getwd(), fisheries = NULL, clean = TRUE, overwrite = TRUE){
  if(!is.character(tamm.names)){
    cli::cli_abort("`tamm.name` must be character string of tamm file name (including .xlsx suffix).")
  }
  if(!all(gsub(".*[.]", "", tamm.names) == "xlsx")){
    cli::cli_abort("`tamm.name` must describe .xlsx files.")
  }
  if(!is.character(tamm.path)){
    cli::cli_abort("`tamm.path` must character string of absolute path to directory containing TAMM. Try using `here` package to help.")
  }
  if(!is.numeric(fisheries) & !is.null(fisheries)){
    cli::cli_abort("`fisheries` must be NULL or a numeric vector of fishery id numbers. Fishery \'13-15\' will be handled appropriately if any number 13 to 15 is included.")
  }
  if(!is.logical(clean)){
    cli::cli_abort("`clean` must be logical.")
  }
  if(!all(file.exists(paste0(tamm.path, "/", tamm.names)))){
    cli::cli_abort("One or more TAMM files was not found. Check that `tamm.path` and `tamm.names` are correct.")
  }

  ## create additional parameter file. Parameterized reports don't like vectors as parameters.
  cat.file = paste0(tamm.path,"/tamm-compare-parameters-intermediate.R")
  ## start populating parameter file
  cat("tamm.names = ", file = cat.file)
  utils::capture.output(dput(tamm.names),  file = cat.file, append = TRUE)
  cat("fisheries = ", file = cat.file, append = TRUE)
  utils::capture.output(dput(fisheries),  file = cat.file, append = TRUE)


  ##identify path to children
  qmd.path = system.file("tamm-comparen.qmd", package = "TAMMsupport")
  qmd.child1.path = system.file("tamm-comparen-child1.qmd", package = "TAMMsupport")
  qmd.child2.path = system.file("tamm-comparen-child2.qmd", package = "TAMMsupport")
  ## generate report name

  report.name = paste0(paste0(gsub("[.].*", "",  tamm.names), collapse = "-vs-"),"-compare.html")
  if(length(tamm.names) > 4){
    tamm.names.abrev = c(tamm.names[1:2], paste0(length(tamm.names)-3, " more"), tail(tamm.names, 1))
    report.name = paste0(paste0(gsub("[.].*", "",  tamm.names.abrev), collapse = "-vs-"),"-compare.html")
  }

  ## copy qmd files
  cli::cli_alert(paste0("Copying parameterized report .qmd files to `", tamm.path, "`."))
  file.copy (c(qmd.path, qmd.child1.path, qmd.child2.path), tamm.path, overwrite = overwrite)

  ## generate report
  cli::cli_alert(paste0("Generating report."))
  quarto::quarto_render(paste0(tamm.path,"/tamm-comparen.qmd"),
                        execute_params = list(tamm.path = tamm.path))
  file.rename(paste0(tamm.path,"/tamm-comparen.html"),
              paste0(tamm.path, "/", report.name))

  if(clean){
    cli::cli_alert("Deleting intermediate .qmd files.")
    file.remove(paste0(tamm.path,"/", c("tamm-comparen.qmd", "tamm-comparen-child1.qmd", "tamm-comparen-child2.qmd")))
  }
  file.remove(paste0(tamm.path,"/tamm-compare-parameters-intermediate.R"))
  cli::cli_alert(paste0("Finished!\nTAMM comparison file is in ", tamm.path, ", with filename ", report.name,"."))
}
