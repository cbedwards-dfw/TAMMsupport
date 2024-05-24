

#' Read overview sheet from TAMM and return key stock
#'
#' @param path filename (including path) to Chinook TAMM
#' @importFrom rlang .data
#'
#' @return dataframe
#' @export
#'
read_overview <- function(path){
  s <- readxl::read_excel(path, range = "ER_ESC_Overview_New!A2:H34",
                  .name_repair = janitor::make_clean_names) |>
    dplyr::filter(!grepl("Spring/Early:|Summer/Fall:", .data$stock))
  s[1,1] <- "NOOKSACK SPRING"
  s[2,1] <- "NF NOOKSACK SPRING"
  s[3,1] <- "SF NOOKSACK SPRING"
  s[4,1] <- "SKAGIT SPRING"
  s[10,1] <- "SKAGIT S/F"
  s[14,1] <- "STILLAGUAMISH"
  s[15,1] <- "STILLAGUAMISH UM"
  s[16,1] <- "STILLAGUAMISH M"
  s[17,1] <- "SNOHOMISH"
  s[20,1] <- "LAKE WASHINGTON"
  s[22,1] <- "GREEN"
  s[24,1] <- "PUYALLUP"
  s[26,1] <- "HOKO"
  s[30,1] <- "SKOKOMISH"
  return(s)
}

#' Read overview sheet from TAMM and return all stock
#'
#' The stock column of the overview tab uses R-unfriendly approaches to store
#' season, overall stock name, and individual stocks in the `stock` column of the TAMM. `read_overview_complete`
#' splits these into separate columns: `season`, `primary_stock`, and `stock`.
#' For three stock (Green, Puyallup, Skokomish), the tamm presents model predictions across two rows with
#' a single stock name due to merged cells. The `stock` column in the output preserves this information;
#'  the entry corresponding to the second row has the suffix "_row2".
#'
#' @inheritParams read_overview
#'
#' @importFrom rlang .data
#' @return Dataframe containing all infomration from cells A2:H34 of the "ER_ESC_Overview_New" sheet.
#' @export
#'
read_overview_complete <- function(path){
  raw = readxl::read_excel(path,
                   sheet = "ER_ESC_Overview_New",
                   range = "A2:H34"
  )|> janitor::clean_names()

  ## some annoyances: manually construct season and primary stock labels to provide clarity. Based on
  ##    walking through TAMM by hand.
  raw = raw |>
    dplyr::mutate(season = c(rep("spring/early", 10), rep("summer/fall", 20), "misc", "misc")) |>
    dplyr::mutate(primary_stock = c(NA, rep("Nooksack", 3), rep("Skagit", 4), "White", "Dungeness",
                             NA, rep("Skagit", 4), rep("Stillaguramish", 3), rep("snohomish", 3),
                             "Lake WA (Cedar R.)", rep("Green", 2), rep("Puyallup", 2),
                             "Nisqually", "Western Strait-Hoko", "Elwha", "Mid-Hood Canal",
                             rep("Skokomish", 2))) |>
    dplyr::relocate(.data$season, .data$primary_stock, .before = "stock")
  ## handle second rows of green, puyallup, skokomish
  raw$stock[c(24, 26, 32)] = paste0(raw$stock[c(24, 26, 32)-1], "_row2")
  ## simplify "total" stock labels now that we have "primary_stock"
  raw$stock[grepl("- Total$", raw$stock)] = "Total"

  raw <- raw |>
    dplyr::filter(!grepl("Spring/Early:|Summer/Fall:", .data$stock))
}
