#' Identify all cells in Excel sheet or sheets with matching cell colors
#'
#' Designed for tracking the status of TAMM inputs, which are typically color coded.
#'
#' @param file Character string of excel file name, including path if relevant
#' @param target_cell Character string of excel address of cell with the cell shading of interest (e.g., "B4")
#' @param sheets character string or character vector of sheets to search through
#'
#' @return tibble summarizing entries with the color of interest, including sheet, row and column ids, and row name (entry of first column in sheet)
#' @export
#'
#' @examples
#' \dontrun{
#' file = "chin tamms/Chin2023_Final.xlsx"
#' find_color_matches(file, "B20")
#' }
find_color_matches = function(file, #name of excel file, presumably chinook tamm
                              target_cell, #cell with the desired color, excell format, e.g. "B4"
                              sheets = "Input Page" #sheet name (presumably Input Page, for chinook tamm)
){
  dat = tidyxl::xlsx_cells(file, sheets = "Input Page")
  dat.formats = tidyxl::xlsx_formats(file)

  ## QAQC: making sure we're targetting the right cell
  target.content.type = dat |>
    dplyr::filter(.data$address == target_cell) |>
    dplyr::pull(.data$data_type)
  target.content = dat |>
    dplyr::filter(.data$address == target_cell)
  target.content = target.content[[target.content.type]]
  cli::cli_alert("Targetting formatting of cell {target_cell} with contents \"{target.content}\" ")

  ## get target rgb and tint
  target.id = dat |>
    dplyr::filter(.data$address == target_cell) |>
    dplyr::pull(.data$local_format_id)

  rgb.waiting = dat.formats$local$fill$patternFill$fgColor$rgb[target.id]
  tint.waiting = dat.formats$local$fill$patternFill$fgColor$tint[target.id]

  ## now we can find all the format ids that use that color:
  formats.waiting = which((dat.formats$local$fill$patternFill$fgColor$rgb == rgb.waiting) &
                        (dat.formats$local$fill$patternFill$fgColor$tint == tint.waiting))

  ## Now we can find all the cells with those formats:

  row_of_interest = dat |>
    dplyr::filter(.data$local_format_id %in% formats.waiting) |>
    dplyr::group_by(.data$row, .data$sheet) |>
    dplyr::summarize(cols = paste0(LETTERS[.data$col], collapse = "; ")) |>
    dplyr::ungroup()

  res = row_of_interest |>
    dplyr::left_join(dat |>
                dplyr::filter(.data$col == 1) |>
                dplyr::select(label = "character", "row"), by = "row") |>
    dplyr::relocate("label")
  return(res)
}


