
#' Extract and format management criterion from Chinook TAMM
#'
#' @param file filename, including filepath if appropriate
#'
#' @return List of stock lists
#' @export
#'
#' @examples
#' \dontrun{
#' cur.management = read_management_chin("Code Inputs/Pre-Season/TAMMs/2013_Final W_BP7.1.xlsx")
#' }

read_management_chin = function(file){
  man.page <- suppressMessages(readxl::read_excel(file,
                              sheet = "RMP_Mgmt_Criteria",
                              range = "A1:I85",
                              col_names = FALSE))
  suppressWarnings(list(
    "Nooksack" = man.page[2:6, 1:6] |>
      reformat_management(cols.percent = 4:6,
                          notes = "All abundance thresholds are based on natural origin escapement"),
    "Skagit Spring" = man.page[9:14, 1:6] |>
      reformat_management(cols.percent = 5:6,
                          notes = "All abundance thresholds are based on natural origin escapement"),
    "White River Spring" = man.page[17:19, 1:5] |>
      reformat_management(cols.percent = 4:5,
                          notes = "Abundance threhold based on natural origins and AP (??)"),
    "Dungeness" = man.page[22:24, 1:5] |>
      reformat_management(cols.percent = 4:5,
                          notes = "Abundance threshold based on TRS and natural origin escapement"),
    "Skagit S/F" = man.page[27:32, 1:7] |>
      reformat_management(cols.percent = 5:7,
                          notes = "All abundance thresholds are based on natural origin escapement"),
    "Stillaguamish" = man.page[35:42, 1:5] |>
      reformat_management(cols.percent = 3:5,
                          rows.header = 1,
                          notes = tibble::deframe(man.page[43:44, 1])),
    "Snohomish" = man.page[47:51, 1:6] |>
      reformat_management(cols.percent = 5:6,
                          notes = tibble::deframe(man.page[52, 1])),
    "Mid Puget Sound" = man.page[55:59, 1:9] |>
      reformat_management(cols.percent = 6:9,
                          notes = "All abundance thresholds are based on natural origin escapement"),
    "Nisqually" = man.page[62:64, 1:5] |>
      reformat_management(cols.percent = 5,
                          notes = "CERC is half the allowable SUS ER (i.e., (ERC - Northern)/2)."),
    "Hoko" = man.page[67:69, 1:5] |>
      reformat_management(cols.percent = 4:5,
                          notes = "All abundance thresholds are based on natural origin escapement"),
    "Elwha" = man.page[72:74, 1:6] |>
      reformat_management(cols.percent = 5:6,
                          notes = "All abundance thresholds are based on natural origin escapement"),
    "Mid-Hood Canal" = man.page[77:79, 1:5] |>
      reformat_management(cols.percent = 4:5),
    "Skokomish" = man.page[82:85, 1:6] |>
      reformat_management(cols.percent = 5:6,
                          notes = "CERC is triggered if either natural of hatchery escapement is projected to be below respective LAT.  Additionally, \"terminal fisheries will be shaped to increase escapement by reducing recreational and net fishing opportunity in southern Hood Canal and the Skokomish River.\"")
  )
  )
}

#' Convenience function for formatting TAMM management criterion chunks
#'
#' Internal tool to simplify converting TAMM sheet to stock management criterion lists. See
#' `read_management_chin()` for example use.
#'
#' @param df dataframe trimmed from TAMM management page to just the relevant stock's criterion.
#' @param cols.percent Column numbers for columns that should be converted to percents.
#' @param rows.header How many rows are used to make up the header? Defaults to 2, but sometimes header block
#' in TAMM is 1 row.
#' @param notes Optional. Character vector, each item of which is a separate note
#' associated with this stock. Generally based on comments in excel doc, can also feed in "extra" rows from TAMM that
#' contain caveats.
#'
#' @return Stock managament criterion list, containing dataframe extracted from TAMM and notes hard-coded in based on TAMM cell comments.
#'
reformat_management = function(df, ## dataframe extracted from RMP_Mgmt_criteria
                               cols.percent,
                               rows.header = 2,
                               notes = ""
){
  header.text = apply(df[1:rows.header,], 2, function(x){paste(stats::na.omit(x), collapse = " ")})
  res = df[-(1:rows.header),]
  names(res) = header.text
  names(res)[1] = "Sub-stock"
  res = res |>
    dplyr::mutate(dplyr::across(-1, ~ as.numeric(.x))) |>
    dplyr::mutate(dplyr::across(cols.percent, ~ if_else(is.na(.x),
                                                        NA_character_,
                                                        paste0(round(.x*100, 1), "%"))))
  return(list(df = res, notes = notes))
}


