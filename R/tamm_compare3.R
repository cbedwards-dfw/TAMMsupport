#' Generate summary comparison of 3 TAMM files
#'
#' Intended use case is to compare low, mid, and high ocean option.
#'
#' @param tamm_names character vector of the three tamm files to compare (including .xlsx suffix).
#' @param tamm_path Absolute path to directory containing the tamm file. `here::here()` can be useful in identifying appropriate path. Character atomic; defaults to current working directory.
#' @param clean Should the intermediate .qmd files used to make the report be deleted afterwards? Logical, defaults to `TRUE`. Set to `FALSE`
#' to explore the .qmd files underlying the report.
#' @param overwrite Should the intermediate .qmd files or the final report be overwritten if those files already exist?; Logical, defaults to `TRUE`.
#'
#' @return Nothing
#' @export
#'
#' @examples
#' \dontrun{
#' tamm_path <- "C:/Users/edwc1477/Documents/WDFW FRAM team work/NOF material/NOF 2024/FRAM"
#' tamm_names <- c("Chin1024.xlsx", "Chin1124.xlsx", "Chin1224.xlsx")
#' tamm_compare3(tamm_names = tamm_names, tamm_path = tamm_path)
#' }
tamm_compare3 <- function(tamm_names, tamm_path = getwd(), clean = TRUE, overwrite = TRUE) {
  if (!is.character(tamm_names)) {
    cli::cli_abort("`tamm_name` must be character string of tamm file name (including .xlsx suffix).")
  }
  if (length(tamm_names) != 3) {
    cli::cli_abort("`tamm_names` must have three file names.")
  }
  if (!all(gsub(".*[.]", "", tamm_names) == "xlsx")) {
    cli::cli_abort("`tamm_name` must describe .xlsx files.")
  }
  if (!is.character(tamm_path)) {
    cli::cli_abort("`tamm_path` must character string of absolute path to directory containing TAMM. Try using `here` package to help.")
  }
  if (!is.logical(clean)) {
    cli::cli_abort("`clean` must be logical.")
  }
  if (!all(file.exists(paste0(tamm_path, "/", tamm_names)))) {
    cli::cli_abort("One or more TAMM files was not found. Check that `tamm_path` and `tamm_names` are correct.")
  }
  #### MAYBE UPDATED TO HERE
  ## identify path to children
  qmd.path <- system.file("tamm-compare3.qmd", package = "TAMMsupport")
  qmd.child.path <- system.file("tamm-compare3-child.qmd", package = "TAMMsupport")
  ## generate report name
  report.name <- paste0(paste0(gsub("[.].*", "", tamm_names), collapse = "-vs-"), "-compare.html")

  ## copy qmd files
  cli::cli_alert(paste0("Copying parameterized report .qmd files to `", tamm_path, "`."))
  file.copy(c(qmd.path, qmd.child.path), tamm_path, overwrite = overwrite)

  ## generate report
  cli::cli_alert(paste0("Generating report."))
  quarto::quarto_render(paste0(tamm_path, "/tamm-compare3.qmd"),
    execute_params = list(
      tamm_path = tamm_path, tamm_name1 = tamm_names[1],
      tamm_name2 = tamm_names[2], tamm_name3 = tamm_names[3]
    )
  )
  file.rename(
    paste0(tamm_path, "/tamm-compare3.html"),
    paste0(tamm_path, "/", report.name)
  )

  if (clean) {
    cli::cli_alert("Deleting intermediate .qmd files.")
    file.remove(paste0(tamm_path, "/", c("tamm-compare3.qmd", "tamm-compare3-child.qmd")))
  }

  cli::cli_alert("Finished!")
}
