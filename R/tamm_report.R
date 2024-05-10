

#' Generate report of figures from TAMM file
#'
#' @param tamm.name Name of tamm file (including .xlsx suffix). Character atomic
#' @param tamm.path Absolute path to directory containing the tamm file. `here::here()` can be useful in identifying appropriate path. Character atomic; defaults to current working directory.
#' @param clean Should the intermediate .qmd files used to make the report be deleted afterwards? Logical, defaults to `TRUE`. Set to `FALSE`
#' to explore the .qmd files underlying the report.
#' @param overwrite Should the intermediate .qmd files or the final report be overwritten if those files already exist?; Logical, defaults to `TRUE`.
#'
#' @return Nothing
#' @export
#'
#' @examples
#' \dontrun{
#' tamm.path = "C:/Users/edwc1477/Documents/WDFW FRAM team work/NOF material/NOF 2024/NOF 2"
#' tamm.name = "Chin2124.xslx"
#' tamm_report(tamm.name = "Chin2124.xlsx", tamm.path = tamm.path)
#' }
tamm_report <- function(tamm.name, tamm.path = getwd(),  clean = TRUE, overwrite = TRUE){
  if(!is.character(tamm.name)){
    cli::cli_abort("`tamm.name` must be character string of tamm file name (including .xlsx suffix).")
  }
  if(gsub(".*[.]", "", tamm.name) != "xlsx"){
    cli::cli_abort("`tamm.name` must describe .xlsx file.")
  }
  if(!is.character(tamm.path)){
    cli::cli_abort("`tamm.path` must character string of absolute path to directory containing TAMM. Try using `here` package to help.")
  }
  if(!is.logical(clean)){
    cli::cli_abort("`clean` must be logical.")
  }
  if(!file.exists(paste0(tamm.path, "/", tamm.name))){
    cli::cli_abort("TAMM file was not found. Check that `tamm.path` and `tamm.name` are correct.")
  }

  ##identify path to children
  qmd.path = system.file("tamm-visualizer.qmd", package = "TAMMsupport")
  qmd.child.path = system.file("tamm-visualizer-child.qmd", package = "TAMMsupport")
  ## generate report name
  report.name = gsub("[.].*", "-Visualization.html", tamm.name)

  ## copy qmd files
  cli::cli_alert(paste0("Copying parameterized report .qmd files to `", tamm.path, "`."))
  file.copy (c(qmd.path, qmd.child.path), tamm.path, overwrite = overwrite)

  ## generate report
  cli::cli_alert(paste0("Generating report."))
  quarto::quarto_render(paste0(tamm.path,"/tamm-visualizer.qmd"),
                        execute_params = list(tamm.path = tamm.path, tamm.name = tamm.name))
  file.rename(paste0(tamm.path,"/tamm-visualizer.html"),
              paste0(tamm.path, "/", report.name))

  if(clean){
    cli::cli_alert("Deleting intermediate .qmd files.")
    file.remove(paste0(tamm.path,"/", c("tamm-visualizer.qmd", "tamm-visualizer-child.qmd")))
  }

  cli::cli_alert("Finished!")
}
