
#' Extract and format management criterion from Chinook TAMM
#'
#' @param file filename, including filepath if appropriate
#'
#' @return Tibble, with `$management_name` giving the name of the management criteria as specified in
#' the TAMM, `$management_criteria` giving a list of dataframes with the associated management criteria, formatted appropriately, and
#' `$notes` giving a list of character vectors with notes (if any) to help interpret the criteria.
#' @export
#'
#' @examples
#' \dontrun{
#' cur.management = read_management_chin("Code Inputs/Pre-Season/TAMMs/2013_Final W_BP7.1.xlsx")
#' }

read_management_chin = function(file){
  man.page <- suppressMessages(readxl::read_excel(file,
                                                  sheet = "RMP_Mgmt_Criteria",
                                                  range = "A1:M85",
                                                  col_names = FALSE,
                                                  .name_repair = "unique_quiet"))
  ## split based on whitespage rows
  n <- rowSums(is.na(man.page)) == ncol(man.page)
  cs <- cumsum(n) + 1
  man.raw <- split(man.page[!n, ], cs[!n])

  names(man.raw) = purrr::map_chr(man.raw, ~ .x[[1,1]])

  ## trim NA columns
  fun_trimmer = function(x){x[, apply(x, 2, function(x){!all(is.na(x))})]}
  man.raw <- purrr::map(man.raw, fun_trimmer)

  man.list = suppressWarnings(list(
    "Nooksack" = man.raw$Nooksack |>
      reformat_management(cols.percent = 4:6),
    "Skagit Spring" = man.raw[["Skagit Spring"]] |>
      reformat_management(cols.percent = 5:6),
    "White River Spring" = man.raw[["White River Spring"]] |>
      reformat_management(cols.percent = 4:5),
    "Dungeness" = man.raw[["Dungeness"]] |>
      reformat_management(cols.percent = 4:5),
    "Skagit S/F" = man.raw[["Skagit S/F"]] |>
      reformat_management(cols.percent = 5:7),
    "Stillaguamish" = man.raw[["Stillaguamish"]] |>
      reformat_management(rows.header = 1,
                          cols.percent = 3:5),
    "Snohomish" = man.raw[["Snohomish"]] |>
      reformat_management(cols.percent = 5,
                          rows.percent = "CERC (SUS)"),
    "Mid Puget Sound" = man.raw[["Mid Puget Sound"]] |>
      reformat_management(rows.header = 2,
                          cols.percent = 6:9),
    "Nisqually" = man.raw[["Nisqually"]] |>
      reformat_management(cols.percent = 5,
                          notes = "CERC (SUS) is half the allowable SUS ER (i.e., (ERC - Northern)/2)."),
    "Hoko" = man.raw[["Hoko"]] |>
      reformat_management(cols.percent = 4:5),
    "Elwha" = man.raw[["Elwha"]] |>
      reformat_management(cols.percent = 5:6),
    "Mid-Hood Canal" = man.raw[["Mid-Hood Canal"]] |>
      reformat_management(cols.percent = 4:5),
    "Skokomish" = man.raw[["Skokomish"]] |>
      reformat_management(cols.percent = 5:6)
  ))
  dplyr::tibble(management_name = names(man.list),
                management_criteria = man.list |> purrr::map( ~ .x[["df"]]),
                notes = man.list |> purrr::map( ~ .x[["notes"]])
  )
}

#' Convenience function for formatting TAMM management criterion chunks
#'
#' Internal tool to simplify converting TAMM sheet to stock management criterion lists. See
#' `read_management_chin()` for example use.
#'
#' @param df dataframe trimmed from TAMM management page to just the relevant stock's criterion.
#' @param cols.percent Column numbers for columns that should be converted to percents.
#' @param rows.percent Character vector of row sub-stock names identifying rows (if any) that should be translated to percents. Defaults to NULL.
#' Developed to accomodate "CERC (SUS)" in Snohomish.
#' @param rows.header How many rows are used to make up the header? Defaults to 2, but sometimes header block
#' in TAMM is 1 row.
#' @param notes Optional. Character vector, each item of which is a separate note
#' associated with this stock. Generally based on comments in excel doc, can also feed in "extra" rows from TAMM that
#' contain caveats.
#'
#' @return Stock management criterion list, containing dataframe extracted from TAMM and notes hard-coded in based on TAMM cell comments.
#'
reformat_management = function(df, ## dataframe extracted from RMP_Mgmt_criteria
                               cols.percent,
                               rows.percent = NULL,
                               rows.header = 2,
                               notes = NULL
){
  ## clear out whitespace columns
  df = df[apply(df, 1, function(x){!all(is.na(x))}),]
  header.text = apply(df[1:rows.header,], 2, function(x){paste(stats::na.omit(x), collapse = " ")})
  res = df[-(1:rows.header),]
  names(res) = header.text
  names(res)[1] = "Sub-stock"
  if("NOTES:" %in% names(res)){
    notes = c(notes, stats::na.omit(res$`NOTES:`))
    res = res |> dplyr::select(-"NOTES:")
  }
  if(any(stringr::str_detect(res[,1] |> tibble::deframe(), "^[*]"))){
    lines.notes = which(stringr::str_detect(res[,1] |> tibble::deframe(), "^[*]"))
    notes = c(notes, res[lines.notes,1] |> tibble::deframe())
    res[lines.notes,1] <- NA
    res = res[apply(res, 1, function(x){!all(is.na(x))}),]
  }

  res = res |>
    # dplyr::mutate(dplyr::across(-1, ~ as.numeric(.x))) |>
    dplyr::mutate(dplyr::across(cols.percent, ~ if_else(is.na(.x),
                                                        NA_character_,
                                                        if_else(is.na(as.numeric(.x)),
                                                                .x,
                                                                paste0(round(as.numeric(.x)*100, 1), "%")))))
  ## Snohomish has a "CERC (SUS)" row that appeared in recent year tamms, needs %s.
  ## The following has some gross code -- would welcome suggestions to make easier to read.
  if(!is.null(rows.percent)){
    if(rows.percent %in% (res[,1] |> tibble::deframe())){
      temp = res[ (res[,1] |> tibble::deframe()) %in% rows.percent, -1]
      res = res |> dplyr::mutate(dplyr::across(dplyr::everything(), as.character))
      res[ (res[,1] |> tibble::deframe()) %in% rows.percent, -1] =
        temp |>
        dplyr::mutate(dplyr::across(dplyr::everything(),
                                    ~dplyr::if_else(is.na(.x),
                                                    NA_character_,
                                                    paste0(round(as.numeric(.x)*100, 1), "%"))))
    }

  }
  return(list(df = res, notes = notes))
}


