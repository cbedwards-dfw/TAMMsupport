


#' Generate report of figures from TAMM file
#'
#' @param tamm_name Name of tamm file (including .xlsx suffix). Character atomic
#' @param tamm_path Absolute path to directory containing the tamm file. `here::here()` can be useful in identifying appropriate path. Character atomic; defaults to current working directory.
#' @param clean Should the intermediate .qmd files used to make the report be deleted afterwards? Logical, defaults to `TRUE`. Set to `FALSE`
#' to explore the .qmd files underlying the report.
#' @param overwrite Should the intermediate .qmd files or the final report be overwritten if those files already exist?; Logical, defaults to `TRUE`.
#' @param additional_children Optional argument with filepath(s) to additional quarto child documents (see `Details`). Defaults to `NULL`.
#' @param additional_support_files Optional argument with filepath(s) to additional files needed by additional quarto documents. Files will be copied into the same directory as the TAMM for
#' easy reading/use by `additional_children` quarto files, and then deleted after the report is generated
#'
#' @details
#' This function generates a summary report of a single chinook TAMM (\href{https://framverse.github.io/fram_doc/calcs_data_chin.html#5_Terminal_Area_Management_Module}{Terminal Area Management Module}) file.
#' The common use case is to call this function for a tamm, and then view the resulting html report (which will be generated in the same folder as the TAMM).
#' However, this function also provides substantial flexibility in the form of optional user-created child quarto documents, which requires
#' some additional context to develop and use.
#'
#' `tamm_report` is implemented using a parameterized quarto report and a child quarto document, which are included in the package.
#' The resulting report includes some broadly useful content -- currently, a replication of the overview TAMM sheet and
#' bar charts showing the breakdown of exploitation rates by fishery for each stock listed in the
#' `limiting stock complete` TAMM sheet. However, individuals or organizations may consistently want
#' additional, specific visualizations based on their own needs. For example, individual tribes may want
#' to visualize impacts on a single stock, but use AEQ instead of ER rates. The `tamm_report` function is
#' designed to integrate these extra components with the `additional_children` argument.
#'
#' The basic principle is that the individual or group can write a reusable "child" .qmd file, \href{https://bookdown.org/yihui/rmarkdown-cookbook/child-document.html}{see this explanation using Rmarkdown}), which will effectively
#' be inserted into the main report. As an example, we might create a simple additional
#' child .qmd file called `extra-tamm-child.qmd` to include a small table summarizing a few
#' key aspects of the Nooksack Earlies stock. The contents of that file are provided in the example below.
#'
#' When we call `tamm_report()`, we can include as an argument `additional_children = ` with the file name (including file path) for
#' our new file. In this way we can easily include this extra content any time we create a tamm report. If desired,
#' multiple child files can be created, and `additional_children` can take a character vector with each child file name.
#'
#' When writing child documents, formatting and chunks work akin to copy-pasting a section of a quarto file out of the main file. (To easily
#' access the main quarto file, run tamm_report() with `clean = FALSE`, which will leave `tamm-visualizer.qmd` and `tamm-visualizer-child.qmd` files in the folder with the TAMM file).
#' The child document will have access to key objects
#' - `dat.all`: the output of \code{\link{read_limiting_stock}} with `longform = TRUE` called on the TAMM;
#' - `dat_overview`: the output of of \code{\link{read_overview}} called on the TAMM;
#' - and `dat`: the specific filtered and formatted version of the limiting stock data generated in the `limiting stock tab` chunk of `tamm-visualizer.qmd` and used in generating the unmarked natural stock exploitation rate figures.
#' When developing a child document, it may be useful to create in the working environment versions of `dat.all` and `dat_overview` from an example TAMM to facilitate
#' writing appropriate filters, plot-making code, etc. The primary quarto report loads in the tidyverse, framrsquared, kableExtra, and TAMMsupport packages,
#' but you can include additional packages for the child documents as needed by adding `library(packagename` calls just
#' like in any other context.
#'
#' If the `additional_children` files need to read contents of additional files (or call children .qmd files of their own
#' to streamline looping over stocks or fisheries), the file paths to these supplemental
#' files can be provided in the `additional.support files` argument. These files will be copied into the
#' same folder as the .qmd files, so the children quarto files can be written to access the supplemental
#' files without dealing with file paths.
#'
#' For questions/support in developing child documents to extend the report, contact Collin Edwards at WDFW.
#'
#'
#' @return Nothing
#' @export
#'
#' @examples
#' \dontrun{
#' ##### CONTENTS FOR extra-tamm-child.qmd #####-----------------------------
#' ## Test section
#'
#' Hypothetical world in which we want a table summarizing the impacts of three
#' fisheries on the "Nooksack Earlies" stock.
#'
#'```{r}
#'kable(dat |> filter(stock == "Nooksack Earlies") |> filter(fishery_id %in% 16:18))
#'```
#' #### END CONTENTS FOR extra-tamm-child.qmd #####--------------------------
#'
#' tamm_path = "C:/Users/edwc1477/Documents/WDFW FRAM team work/NOF material/NOF 2024/NOF 2"
#' tamm_name = "Chin2124.xslx"
#' tamm_report(tamm_name = "Chin2124.xlsx", tamm_path = tamm_path)
#' ## Now with our extra content, presuming `extra-tamm-child.qmd` is saved in our documents folder
#' tamm_report(tamm_name = "Chin2124.xlsx", tamm_path = tamm_path,
#'   additional_children = "C:/Users/JohnDoe/Documents/extra-tamm-child.qmd")
#' }
tamm_report <-
  function(tamm_name,
           tamm_path = getwd(),
           clean = TRUE,
           overwrite = TRUE,
           additional_children = NULL,
           additional_support_files = NULL) {
    if (!is.character(tamm_name)) {
      cli::cli_abort("`tamm_name` must be character string of tamm file name (including .xlsx suffix).")
    }
    if (gsub(".*[.]", "", tamm_name) != "xlsx") {
      cli::cli_abort("`tamm_name` must describe .xlsx file.")
    }
    if (!is.character(tamm_path)) {
      cli::cli_abort(
        "`tamm_path` must character string of absolute path to directory containing TAMM. Try using `here` package to help."
      )
    }
    if (!is.logical(clean)) {
      cli::cli_abort("`clean` must be logical.")
    }
    if (!file.exists(paste0(tamm_path, "/", tamm_name))) {
      cli::cli_abort("TAMM file was not found. Check that `tamm_path` and `tamm_name` are correct.")
    }
    if (!is.null(additional_children) &
        !is.character(additional_children)) {
      cli::cli_abort(
        "`additional_children` must be NULL or character vector of additional child qmd files."
      )
    }
    if (!is.null(additional_children)) {
      if (!all(file.exists(additional_children))) {
        cli::cli_abort("`additional_children` file(s) not found. Check paths and spelling.")
      }
    }
    if (!is.null(additional_support_files) &
        !is.character(additional_support_files)) {
      cli::cli_abort(
        "`additional_support_files` must be NULL or character vector of additional file names (including file paths)."
      )
    }
    if (!is.null(additional_support_files)) {
      if (!all(file.exists(additional_support_files))) {
        cli::cli_abort("`additional_support_files` file(s) not found. Check paths and spelling.")
      }
    }


    ##identify path to children
    qmd.path = system.file("tamm-visualizer.qmd", package = "TAMMsupport")
    qmd.child.path = system.file("tamm-visualizer-child.qmd", package = "TAMMsupport")
    ## generate report name
    report.name = gsub("[.].*", "-Visualization.html", tamm_name)

    ## copy qmd files
    cli::cli_alert(paste0("Copying parameterized report .qmd files to `", tamm_path, "`."))
    file.copy (
      c(
        qmd.path,
        qmd.child.path,
        additional_children,
        additional_support_files
      ),
      tamm_path,
      overwrite = overwrite
    )

    ## create additional parameter file. Parameterized reports don't like vectors as parameters.
    cat.file = paste0(tamm_path, "/tamm-report-parameters-intermediate.R")
    ## start populating parameter file
    if (!is.null(additional_children)) {
      cat("additional_children = ", file = cat.file)
      utils::capture.output(dput(additional_children),
                            file = cat.file,
                            append = TRUE)
    } else{
      cat("additional_children = NULL\n", file = cat.file)

    }

    ## generate report
    cli::cli_alert(paste0("Generating report."))
    quarto::quarto_render(
      paste0(tamm_path, "/tamm-visualizer.qmd"),
      execute_params = list(tamm_path = tamm_path, tamm_name = tamm_name)
    )
    file.rename(paste0(tamm_path, "/tamm-visualizer.html"),
                paste0(tamm_path, "/", report.name))

    if (clean) {
      cli::cli_alert("Deleting intermediate .qmd files.")
      file.remove(paste0(
        tamm_path,
        "/",
        c("tamm-visualizer.qmd", "tamm-visualizer-child.qmd")
      ))
      if (!is.null(additional_children)) {
        additional.names = gsub(".*/", "", additional_children)
        file.remove(paste0(tamm_path, "/", additional.names))
      }
      if (!is.null(additional_support_files)) {
        additional.names = gsub(".*/", "", additional_support_files)
        file.remove(paste0(tamm_path, "/", additional.names))
      }
    }
    file.remove(paste0(tamm_path, "/tamm-report-parameters-intermediate.R"))

    cli::cli_alert(
      paste0(
        "Finished!\nTAMM report is in ",
        tamm_path,
        ", with filename ",
        report.name,
        "."
      )
    )
  }
