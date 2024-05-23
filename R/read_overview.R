

#' Read overview sheet from TAMM
#'
#' @param path filename (including path) to TAMM
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
