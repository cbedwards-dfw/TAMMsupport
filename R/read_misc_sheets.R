## For reading each sheet, I've written a "chunk reader" (gets an individual
## table part) and then a sheet reader. The "chunk readers" need to do a lot of
## tasks that are identical between sheets. I've extracted that code and put it
## in `chunk_read_finisher`. basic work flow: individual chunk readers grab one
## of the tables from one of the sheets (the aeq and er sections), making sure
## to use the right rows and adding an appropriately placed "total" to one of
## the er fishery_assignment entries. Then it calls "chunk_read_finisher" to do
## a bunch of processing. The individual chunk readers (e.g.,
## chunk_reader_2A_Cmrkd) basically take the table from the excel sheet and
## cleans it up while keeping it the same shape.

## The "read_*" function like read_2acmrkd() read all the tables from a single
## sheet, and do some additional processing: making stock names consistent, and
## convert to longform

## Finally, read_2a_sheets() calls each of the individual read_* functions for
## the 2A sheets (those with functions to handle them) and then combines those
## into a single longform "aeq" and a single longform "er" sheet.
##
## read_jdf() does something similar, but combines the chunk and sheet reading
## into one function, and it's not included in read_2a_sheets(), as the data is
## somewhat differently shaped.

## In terms of actual usage, we should be able to get all the relevant info of a
## TAMM with read_jdf() and read_2a_sheets(), each of which will return a list
## containing an aeq and er dataframe. (for read_jdf, there's no er info, but
## I've got it returning a list of the same shape to make it easier to write
## consistent code.)

#' Safely convert character numerics into numeric
#'
#' Function to translate columns that "should" be numeric into numeric
#' but doesn't do so if that would mean converting a true character string to NA.
#'
#' @param x Character vector
#'
#' @return Either numeric vector of x or (if that is lossy) character returns input.
#'
as_numeric_safe <-  function(x){
  attempt_numeric <- as.numeric(x)
  ## did we add NAs by converting? If not, it's safe
  if(sum(is.na(attempt_numeric)) == sum(is.na(x))){
    return(attempt_numeric)
  }else{
    return(x)
  }
}





#'  `r lifecycle::badge("experimental")`
## function to process + combine the aeq sections from tables 2a-2c, used below
#' Read and combine aeq sections form tables 2a-2c
#'
#' @param tab_2a the "Table 2a" section of one of the 2ac sheets, read in with
#'  a `chunk_reader_2A_*()` function
#' @param tab_2b same, but 2b
#' @param tab_2c same, but 2c
#'
#' @return dataframe of AEQ values for each stock in longform
#'
process_2ac_aeqs <- function(tab_2a, tab_2b, tab_2c) {
  rename_df_2a <- dplyr::tribble(
    ~from, ~to,
    "^Pgt Snd 8-13$", "Pgt Snd 8-13 Sport",
    "^Preterm. Pgt Snd or$", "Preterm. Pgt Snd or Out-of-Region net:",
    "^Out-of-Region net:$", "Preterm. Pgt Snd or Out-of-Region net:",
    "^Terminal Pgt Snd or$", "Terminal Pgt Snd or Local Terminal Net:",
    "^Local Terminal Net:$", "Terminal Pgt Snd or Local Terminal Net:"
  )

  rename_df_2b <- dplyr::tribble(
    ~from, ~to,
    "^Pgt Snd 8-13$", "Pgt Snd 8-13 Sport"
  )

  rename_df_2c <- dplyr::tribble(
    ~from, ~to,
    "^Pgt Snd 8-13$", "Pgt Snd 8-13 Sport",
    "^Local Terminal Net:$", "Local Terminal Net (&/or SAF sport):",
    "^[(]&/or SAF sport[)]$", "Local Terminal Net (&/or SAF sport):"
  )
  for (i in 1:nrow(rename_df_2a)) {
    tab_2a$aeq$fishery <- gsub(
      rename_df_2a$from[i],
      rename_df_2a$to[i],
      tab_2a$aeq$fishery
    )
  }
  for (i in 1:nrow(rename_df_2b)) {
    tab_2b$aeq$fishery <- gsub(
      rename_df_2b$from[i],
      rename_df_2b$to[i],
      tab_2b$aeq$fishery
    )
  }
  for (i in 1:nrow(rename_df_2c)) {
    tab_2c$aeq$fishery <- gsub(
      rename_df_2c$from[i],
      rename_df_2c$to[i],
      tab_2c$aeq$fishery
    )
  }

  aeq <- dplyr::bind_rows(
    tab_2a$aeq |>
      tidyr::pivot_longer(
        cols = -tidyr::any_of(c("fishery", "fishery_assignment", "sheet", "table")),
        names_to = "stock"
      ),
    tab_2b$aeq |>
      tidyr::pivot_longer(
        cols = -tidyr::any_of(c("fishery", "fishery_assignment", "sheet", "table")),
        names_to = "stock"
      ),
    tab_2c$aeq |>
      tidyr::pivot_longer(
        cols = -tidyr::any_of(c("fishery", "fishery_assignment", "sheet", "table")),
        names_to = "stock"
      )
  ) |>
    # dplyr::filter(!is.na(.data$value)) |>
    janitor::clean_names()

  ## fix weird \1 values in fishery labels. Doing separate from those above
  ## because needs to be done with fixed = TRUE

  aeq$fishery <- gsub("Freshwater Sport: \1", "Freshwater Sport:", aeq$fishery, fixed = TRUE)
  aeq$fishery <- gsub("Freshwater Sport: \\1", "Freshwater Sport:", aeq$fishery, fixed = TRUE)
  ## cut out leading/trailing whitespaces
  aeq$stock <- trimws(aeq$stock)

  return(aeq)
}


#'  `r lifecycle::badge("experimental")`
#' function to process + combine the er sections from tables 2a-2c, used below
#'
#' @inheritParams process_2ac_aeqs
#'
#' @return dataframe of ers in longform
#'
process_2ac_ers <- function(tab_2a, tab_2b, tab_2c) {
  er <- dplyr::bind_rows(
    tab_2a$er |>
      tidyr::pivot_longer(
        cols = -tidyr::any_of(c("fishery", "fishery_assignment", "sheet", "table")),
        names_to = "stock"
      ),
    tab_2b$er |>
      tidyr::pivot_longer(
        cols = -tidyr::any_of(c("fishery", "fishery_assignment", "sheet", "table")),
        names_to = "stock"
      ),
    tab_2c$er |>
      tidyr::pivot_longer(
        cols = -tidyr::any_of(c("fishery", "fishery_assignment", "sheet", "table")),
        names_to = "stock"
      )
  ) |>
    dplyr::filter(!is.na(.data$value)) |>
    janitor::clean_names() |>
    dplyr::mutate(stock = trimws(.data$stock))
}

# ---------------------------------------------

#' Finishes a chunk after initial reading
#'
#' Handles some of the repetitive tasks of processing individual chunks; this part is generalized
#' and does not need to be different for each sheet. Lots of fiddliness in here
#' because TAMM formatting is terrible
#'
#' @param sheet_name Name of sheet
#' @param table_name Name of table
#' @param raw .
#' @param raw_titles .
#' @param data_er .
#' @param do_er Should ER be done? If FALSE, skips ER (useful for processing sections with no ER.)
#'
#' @return A list with $aeq and $er, each a dataframe
#'
chunk_read_finisher = function(sheet_name, table_name, raw, raw_titles, data_er, do_er = TRUE){
  raw_titles[is.na(raw_titles)] = ""

  raw_titles = apply(raw_titles, 2, paste0, collapse = " ")
  raw_titles = gsub("[*]", "", raw_titles)
  raw_titles = gsub("^ ", "", raw_titles)
  # raw_titles = janitor::make_clean_names(raw_titles)

  data = raw
  names(data) = raw_titles
  names(data)[1] = "fishery"
  names(data)[2] = "fishery_assignment"

  data = data |>
    dplyr::filter(.data$fishery != "-" | is.na(.data$fishery)) |>
    dplyr::filter(.data$fishery != "=" | is.na(.data$fishery)) |>
  ## weird special case: in some cases 2B has "Freshwater Test" in the $fishery_assignment column
  ## instead of $fishery column. Fixing this:
    dplyr::mutate(fishery = dplyr::if_else(is.na(fishery) & fishery_assignment == "Freshwater Test",
                                           "Freshwater Test",
                                           fishery)) |>
    dplyr::mutate(fishery_assignment = dplyr::if_else(fishery == "Freshwater Test" & fishery_assignment == "Freshwater Test",
                                           NA,
                                           fishery_assignment))



  for(i in 2:nrow(data)){
    if(is.na(data$fishery[i]) & (!is.na(data$fishery_assignment[i]))){
      data$fishery[i] = data$fishery[i-1]
    }
  }
  ## tired. Want to cut out rows that are all NAs. Base R solution
  inds.allna = which(apply(data, 1, function(x){all(is.na(x))}))
  data = data[-inds.allna,]
  data = data |>
    #deal with inconsistent "NA" designation in sheet
    dplyr::mutate(dplyr::across(-tidyr::any_of(c("fishery", "fishery_assignment")),
                                ~ dplyr::if_else(.x %in% c("na", "NA", "Na"),
                                                 NA,
                                                 .x
                                )))
  ## want non-elementwise approach, so looping
  ## for any columns but the first two, if we safely can, convert to numeric
  cols_numeric = setdiff(colnames(data), c("fishery", "fishery_assignment"))
  for(cur_col in cols_numeric){
    data[[cur_col]] =  as_numeric_safe(data[[cur_col]])
  }

  if(do_er){

    ## annoying fixes to fix implied values
    ## drop down "SUS OCean Only ER" label to the next two rows
    ## give a "total" label for SUS ocean only ER row 1
    names(data_er) = names(data)
    for(i in 2:nrow(data_er)){
      if(is.na(data_er$fishery[i]) & (!is.na(data_er$fishery_assignment[i]))){
        data_er$fishery[i] = data_er$fishery[i-1]
      }
    }
    data_er = data_er |>
      dplyr::filter(.data$fishery != "-" | is.na(.data$fishery)) |>
      dplyr::filter(.data$fishery != "=" | is.na(.data$fishery))

    cols_numeric = setdiff(colnames(data_er), c("fishery", "fishery_assignment"))
    for(cur_col in cols_numeric){
      data_er[[cur_col]] =  as_numeric_safe(data_er[[cur_col]])
    }

    data_er$sheet = sheet_name
    data_er$table = table_name
  } else{
    data_er = NULL
  }

  data$sheet = sheet_name
  data$table = table_name

  return(list(aeq = data, er = data_er))
}

## 2A_Cmrkd -----------------------------
#' Read in chunks of the 2A_Cmrkd sheet
#'
#' @param tamm_filepath tame file path
#' @param start_col Letter of the column the chunk starts on
#' @param end_col Letter of the column the chunk ends on
#' @param table_name name of table
#'
chunk_read_2A_Cmrkd = function(tamm_filepath, start_col, end_col, table_name){
  sheet_name = "2A_Cmrkd"
  raw = readxl::read_excel(tamm_filepath,
                           sheet = sheet_name,
                           range = glue::glue("{start_col}12:{end_col}46"),
                           col_names = FALSE,
                           .name_repair = "unique_quiet")

  raw_titles = readxl::read_excel(tamm_filepath,
                                  sheet = sheet_name,
                                  range = glue::glue("{start_col}9:{end_col}10"),
                                  col_names = FALSE,
                                  .name_repair = "unique_quiet")
  data_er = readxl::read_excel(tamm_filepath,
                               sheet = sheet_name,
                               range = glue::glue("{start_col}59:{end_col}62"),
                               col_names = FALSE,
                               .name_repair = "unique_quiet")
  ## drop down "SUS OCean Only ER label to the next two rows
  ## give a "total" label for SUS ocean only ER row 1
  data_er[1, 2] = "Total"

  res = chunk_read_finisher(sheet_name, table_name, raw, raw_titles, data_er)

  return(res)
}

#' Reads sheet of 2A_Cmrkd
#'
#' @param tamm_filepath path to file
#' @param stock_cleanup Do cleanup of capitalization?
#'
#' @return a list, with $aeq (the main parts of each table) and $er (the very bottom section)
#'
read_2aCmrkd = function(tamm_filepath, stock_cleanup = TRUE){

  tab_2a = chunk_read_2A_Cmrkd(tamm_filepath, "A", "J", table_name = "2A")
  tab_2b = chunk_read_2A_Cmrkd(tamm_filepath, "M", "V", table_name = "2B")
  tab_2c = chunk_read_2A_Cmrkd(tamm_filepath, "X", "AH", table_name = "2C")

  aeq = process_2ac_aeqs(tab_2a, tab_2b, tab_2c)
  er = process_2ac_ers(tab_2a, tab_2b, tab_2c)

  if(stock_cleanup){
    aeq$stock = stringr::str_to_lower(aeq$stock)
    er$stock = stringr::str_to_lower(er$stock)
  }

  return(list(aeq = aeq, er = er))
}


## 2A_CUnmrkd ---------------

#' Reads chunk of 2A_CUnmrkd sheet
#'
#' @inheritParams chunk_read_2A_Cmrkd
#'
chunk_read_2A_CUnmrkd = function(tamm_filepath, start_col, end_col, table_name){
  sheet_name = "2A_CUnmrkd"
  raw = readxl::read_excel(tamm_filepath,
                           sheet = sheet_name,
                           range = glue::glue("{start_col}12:{end_col}46"),
                           col_names = FALSE,
                           .name_repair = "unique_quiet")

  raw_titles = readxl::read_excel(tamm_filepath,
                                  sheet = sheet_name,
                                  range = glue::glue("{start_col}9:{end_col}10"),
                                  col_names = FALSE,
                                  .name_repair = "unique_quiet")
  # grab the "SUS Ocean Only ER and PS Pertimina Net" section at the bottom
  data_er = readxl::read_excel(tamm_filepath,
                               sheet = sheet_name,
                               range = glue::glue("{start_col}57:{end_col}64"),
                               col_names = FALSE,
                               .name_repair = "unique_quiet")
  data_er[5, 2] = "Total"

  res = chunk_read_finisher(sheet_name, table_name, raw, raw_titles, data_er)

  return(res)
}

#' read all info for 2aCUnmrkd and process it.
#'
#' @param tamm_filepath Tamm filepath
#' @param stock_cleanup Logical, defaults to TRUE. Convert weird capitalization to lowercase?
#'
#' @return a list, with $aeq (the main parts of the table) and $er (the very bottom section)
#'
read_2aCUnmrkd = function(tamm_filepath, stock_cleanup = TRUE){

  tab_2a = chunk_read_2A_CUnmrkd(tamm_filepath, "A", "K", table_name = "2A")
  tab_2b = chunk_read_2A_CUnmrkd(tamm_filepath, "M", "V", table_name = "2B")
  tab_2c = chunk_read_2A_CUnmrkd(tamm_filepath, "X", "AH", table_name = "2C")

  aeq = process_2ac_aeqs(tab_2a, tab_2b, tab_2c)
  er = process_2ac_ers(tab_2a, tab_2b, tab_2c)

  if(stock_cleanup){
    aeq$stock = stringr::str_to_lower(aeq$stock)
    er$stock = stringr::str_to_lower(er$stock)
  }

  return(list(aeq = aeq, er = er))
}

## 2A_CU&M -------------------
#' Read chunk for table 2A_CUandM
#'
#' @inheritParams chunk_read_2A_Cmrkd
#'
chunk_read_2A_CUandM = function(tamm_filepath, start_col, end_col, table_name){
  sheet_name = "2A_CU&M"
  raw = readxl::read_excel(tamm_filepath,
                           sheet = sheet_name,
                           range = glue::glue("{start_col}12:{end_col}46"),
                           col_names = FALSE,
                           .name_repair = "unique_quiet")

  raw_titles = readxl::read_excel(tamm_filepath,
                                  sheet = sheet_name,
                                  range = glue::glue("{start_col}9:{end_col}10"),
                                  col_names = FALSE,
                                  .name_repair = "unique_quiet")

  data_er = readxl::read_excel(tamm_filepath,
                               sheet = sheet_name,
                               range = glue::glue("{start_col}56:{end_col}68"),
                               col_names = FALSE,
                               .name_repair = "unique_quiet")
  data_er[4, 2] = "Total"
  res = chunk_read_finisher(sheet_name, table_name, raw, raw_titles, data_er)

  return(res)
}


#' Read and process all parts of sheet 2A CU and M
#'
#' @param tamm_filepath Tamm filepath
#' @param stock_cleanup Clean up weird capitalization? Logical, defaults to TRUE
#'
#' @return a list, with $aeq (the main parts of the table) and $er (the very bottom section) @return
#'
read_2aCUandM = function(tamm_filepath, stock_cleanup = TRUE){

  tab_2a = chunk_read_2A_CUandM(tamm_filepath, "A", "J", table_name = "2A")
  tab_2b = chunk_read_2A_CUandM(tamm_filepath, "M", "V", table_name = "2B")
  tab_2c = chunk_read_2A_CUandM(tamm_filepath, "X", "AH", table_name = "2C")

  aeq = process_2ac_aeqs(tab_2a, tab_2b, tab_2c)
  er = process_2ac_ers(tab_2a, tab_2b, tab_2c)

  if(stock_cleanup){
    aeq$stock = stringr::str_to_lower(aeq$stock)
    er$stock = stringr::str_to_lower(er$stock)
  }

  return(list(aeq = aeq, er = er))
}

#' Read in individual chunks for sheet 2A_Cu&M_N
#'
#' @inheritParams chunk_read_2A_Cmrkd
chunk_read_2A_CUandM_N = function(tamm_filepath, start_col, end_col, table_name){
  sheet_name = "2A_CU&M_N"
  raw = readxl::read_excel(tamm_filepath,
                           sheet = sheet_name,
                           range = glue::glue("{start_col}12:{end_col}46"),
                           col_names = FALSE,
                           .name_repair = "unique_quiet")

  raw_titles = readxl::read_excel(tamm_filepath,
                                  sheet = sheet_name,
                                  range = glue::glue("{start_col}9:{end_col}10"),
                                  col_names = FALSE,
                                  .name_repair = "unique_quiet")
  res = chunk_read_finisher(sheet_name, table_name, raw, raw_titles, data_er = NULL, do_er = FALSE)

  return(res)
}


#' Read and combine all chunks for sheet 2A CU and M_N
#'
#' @param tamm_filepath Tamm filepath
#' @param stock_cleanup Clean up stock name capitalization? Logical, defaults to TRUE
#'
#'
read_2aCUandM_N = function(tamm_filepath, stock_cleanup = TRUE){
  ## Note: No "er" chunks in this one

  tab_2a = chunk_read_2A_CUandM_N(tamm_filepath, "A", "J", table_name = "2A")
  tab_2b = chunk_read_2A_CUandM_N(tamm_filepath, "L", "U", table_name = "2B")
  tab_2c = chunk_read_2A_CUandM_N(tamm_filepath, "W", "AG", table_name = "2C")

  aeq = process_2ac_aeqs(tab_2a, tab_2b, tab_2c)

  if(stock_cleanup){
    aeq$stock = stringr::str_to_lower(aeq$stock)
  }

  return(list(aeq = aeq, er = NULL))
}



#' Read in AEQ and ER information from the JDF sheet
#'
#' @param tamm_filepath TAMM filepath
#' @param stock_cleanup Clean up stock name capitalization? Logical, defaults to TRUE.
#'
#' @return List, with $aeq containing the combined AEQ information that is spread across multiple chunks in the TAMM sheet. List also contains $er = NULL, to provide parallel outputs to `read_2a_sheets`, which *does* have a non-null $er item in the output list.
#' @export
#'
#' @examples
#' \dontrun{
#' library(here)
#' filepath <- here("tamms/Chin2025.xlsx")
#' jdf = read_jdf(filepath)
#' }
read_jdf = function(tamm_filepath, stock_cleanup = TRUE){
  #joint chunk-reader and sheet reader, since one and the same, plus can't use
  #process_*()
  sheet_name = "JDF"
  data = readxl::read_excel(tamm_filepath,
                            sheet = sheet_name,
                            range = "O8:T49",
                            col_names = TRUE,
                            .name_repair = "unique_quiet")

  names(data)[1] = "fishery"
  names(data)[2] = "fishery_assignment"

  data = data |>
    dplyr::filter(.data$fishery != "-" | is.na(.data$fishery)) |>
    dplyr::filter(.data$fishery != "=" | is.na(.data$fishery))


  for(i in 2:nrow(data)){
    if(is.na(data$fishery[i]) & (!is.na(data$fishery_assignment[i]))){
      data$fishery[i] = data$fishery[i-1]
    }
  }
  ## tired. Want to cut out rows that are all NAs. Base R solution
  inds.allna = which(apply(data, 1, function(x){all(is.na(x))}))
  data = data[-inds.allna,]
  data = data |>
    #deal with inconsistent "NA" designation in sheet
    dplyr::mutate(dplyr::across(-tidyr::any_of(c("fishery", "fishery_assignment")),
                                ~ dplyr::if_else(.x %in% c("na", "NA", "Na"),
                                                 NA,
                                                 .x
                                )))
  ## want non-elementwise approach, so looping
  ## for any columns but the first two, if we safely can, convert to numeric
  cols_numeric = setdiff(colnames(data), c("fishery", "fishery_assignment"))
  for(cur_col in cols_numeric){
    data[[cur_col]] =  as_numeric_safe(data[[cur_col]])
  }

  # grab the "SUS Ocean Only ER and PS Pertimina Net" section at the bottom
  data_er = NULL

  data$sheet = sheet_name
  data$table = "16E"

  aeq = data |>
    tidyr::pivot_longer(cols = -tidyr::any_of(c("fishery", "fishery_assignment", "sheet", "table")),
                        names_to = "stock") |>
    janitor::clean_names()

  aeq$fishery = gsub("Freshwater Sport: \1", "Freshwater Sport:", aeq$fishery, fixed = TRUE)
  aeq$fishery = gsub("Freshwater Sport: \\1", "Freshwater Sport:", aeq$fishery, fixed = TRUE)

  return(list(aeq = aeq, er = NULL))

}

#' Read and combine all 2a sheets from a TAMM file
#'
#' Gathers and cleans the AEQ and ER information for tamm sheets `2aCmrkd`,
#' `2aCUnmkrd`, `2aCUandM`, and `2aCUandM_N`.
#'
#' @inheritParams read_jdf
#'
#' @return list, with $aeq containing the primary information (AEQs of fishery impacts on each stock) and $er containing the ER information at the bottom of the spreadsheets.
#' @export
#'
#' @examples
#' \dontrun{
#' library(here)
#' filepath <- here("tamms/Chin2025.xlsx")
#' res = read_2a_sheets(filepath)
#' jdf = read_jdf(filepath)
#'}
read_2a_sheets = function(tamm_filepath, stock_cleanup = TRUE){
  aeq = NULL
  er = NULL
  fun_list = list(read_2aCmrkd, read_2aCUnmrkd, read_2aCUandM, read_2aCUandM_N)
  for(fun in fun_list){
    temp = fun(tamm_filepath, stock_cleanup)
    aeq = dplyr::bind_rows(aeq, temp$aeq)
    er = dplyr::bind_rows(er, temp$er)
  }
  return(list(aeq = aeq, er = er))
}
