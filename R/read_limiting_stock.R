#' Read TAMM limiting stock complete tab
#'
#' Reads in the table, adds fishery type information.
#'
#' @param filename Tamm name (and path)
#' @importFrom rlang .data
#'
#' @return data frame summarizing the TAMM limiting stock tab.
#' @export
#'
read_limiting_stock <- function(filename){
  column.names <- c("Fishery", "FisheryID",
                    filename  |>
                      readxl::read_excel(range = "LimitingStkComplete mod!L3:DL3", col_names = F) |>
                      unlist() |> stats::na.omit() |> unique() |> rep(each = 7) |>
                      paste(rep(c("t2_aeq", "t3_aeq", "t4_aeq", "t2_er", "t3_er", "t4_er", "yr_er"), 15), sep = "_")
  )

  res = dplyr::bind_rows(
    readxl::read_excel(filename, range = "LimitingStkComplete mod!J163:DL234", col_names = column.names) |> dplyr::mutate(stock_type = "UM_H"),
    readxl::read_excel(filename, range = "LimitingStkComplete mod!J242:DL313", col_names = column.names) |> dplyr::mutate(stock_type = "UM_N"),
    readxl::read_excel(filename, range = "LimitingStkComplete mod!J321:DL392", col_names = column.names) |> dplyr::mutate(stock_type = "M_H"),
    readxl::read_excel(filename, range = "LimitingStkComplete mod!J400:DL471", col_names = column.names) |> dplyr::mutate(stock_type = "M_N")
  ) |>
    dplyr::mutate(
      fish_type = dplyr::case_when(
        FisheryID %in% c(as.character(1:12), "13-15") ~ "Northern",
        FisheryID %in% as.character(30:35) ~ "Southern",
        FisheryID %in% as.character(c(16,18:20,22:23,25:29)) ~ "NT Ocean/ColR",
        FisheryID %in% as.character(c(36,42,45,48,53,54,56,57,60,62,64,67)) ~ "NT PS Spt",
        FisheryID %in% as.character(c(37,39,43,46,49,51,58,65,68,70)) ~ "NT PS Net",
        FisheryID %in% as.character(c(17,21,24,38,40,41,44,47,50,52,55,59,61,63,66,69,71)) ~ "TR Mar",
        FisheryID == "72" ~ "NT FW",
        FisheryID == "73" ~ "TR FW",
        FisheryID == "74" ~ "Escapement")
    ) |>
    dplyr::select(.data$stock_type, .data$fish_type, .data$FisheryID, .data$Fishery, dplyr::everything())
  res
}


#' Generates clean read of TAMM limiting stock sheet
#'
#' Effectively a wrapper function for read_limiting_stock with some formatting
#' added in. Filters to unmarked naturals, just present ER values.
#'
#' @param filename Name (and path) for TAMM files
#' @importFrom rlang .data
#' @return dataframe
#' @export
#'
clean_limiting_stock = function(filename){
  dat = read_limiting_stock(filename)
  run.num = readxl::read_excel(filename, range = "1!B2", col_names = FALSE)
  if(grepl("Chin", run.num)){attr(dat, "species") <- "CHINOOK"}
  if(grepl("Coho", run.num)){attr(dat, "species") <- "COHO"}
  if(grepl("Coho", run.num) & grepl("Chin", run.num)){attr(dat, "species") <- "UNCLEAR"}
  if(!grepl("Coho", run.num) & !grepl("Chin", run.num)){attr(dat, "species") <- "UNCLEAR"}
  if(attr(dat, "species") == "UNCLEAR"){cli::cli_alert_warning("Species is not clear from TAMM")}

  dat = dat |>
    dplyr::rename(fishery_id = "FisheryID") |>
    dplyr::filter(.data$stock_type == "UM_N") |>
    dplyr::select(1:4, dplyr::ends_with("_er")) |>
    dplyr::rename_at(.vars = dplyr::vars(dplyr::ends_with("_er")),
                     .funs = ~ gsub("_er$", "", .x)) |>
    tidyr::pivot_longer(cols = -(1:4), names_to = c("stock", "timestep"),
                        names_sep ="_")
  dat
}
