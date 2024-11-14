#'  `r lifecycle::badge("experimental")`
#'
#' Extract Treaty and Nontreaty numbers from "2A_CU&M_H+N" TAMM sheet. For Elwha and Dungeoness,
#' separate allocations are calculated using column O of the JDF tab
#'
#' Currently provides dataframe with `fishery.original` column identifying the fishery.
#' With advice from Derek, will add a `fishery` column that is human-readable version of above. Might
#' Try to create same naming conventions as in `read_overview_complete()`.
#'
#' @param xlsxFile Character vector. Filename (including path) for chinook TAMM
#' @return dataframe with the treaty and nontreaty mortalities at each fishery.
#' @export

read_tnt_allocation_chin = function(xlsxFile){
  name.mapping = c("NOOKSACK Early [*]" = "Nooksack Spring",
                   "SKAGIT Spr H[+]W" = "Skagit Spring",
                   "SKAGIT S[/]F H[+]W" = "Skagit Summer/Fall",
                   "STILLAG. Sum[/]Fall" = "Stillaguamish",
                   "SNOHOM S[/]F H[+]W" = "Snohomish",
                   "Skykomish S[/]F H[+]W" = "Skykomish S/F H+W (recommend just using Snohomish, which includes Skykomish and Snoqualmie)",
                   "WHITE R. Spring[*][*][*]" = "White River Fingerlings",
                   "NOOKSACK S[/]F N&H" = "Samish Falls Hatchery",
                   "TULALIP S[/]F H" = "Tulalip Hatchery",
                   "HDCNL S[/]F N&H" = "Hoodsport, Mid HC, and Skokomish",
                   "Mid[-]HDCNL [(]12B[)] Natural" = "Mid Hood Canal",
                   "Skok. R Natural" = "Skokomish",
                   "Dung/Elwha S/F N&H" = "Dung/Elwha S/F N&H (recommend using separate Elwha and Dungeoness entries instead)",
                   "Hoko S/F N&H" = "Hoko",
                   "Misc 10 & 10E" = "Gorst and Grovers Hatchery",
                   "Lake Wash." = "Lake Washington",
                   "Green River" = "Green River",
                   "Puyallup River" = "Puyallup",
                   "Carr Inlet" = "Minter Hatchery",
                   "Cham- bers" = "Chambers Hatchery",
                   "Nisq. River" = "Nisqually",
                   "McAll. Creek" = "McAllister Hatchery",
                   "Deschutes & 13D-K" = "Deschutes Hatchery",
                   "Elwha" = "Elhwa",
                   "Dungeness" = "Dungeness"
  )



  raw = readxl::read_excel(xlsxFile, sheet = "2A_CU&M_H+N",
                           col_names = FALSE)
  ## rows and columns identified by hand
  df = raw[c(9, 10, 56, 57), c(4:10, 15:21, 25:33)] |>
    t() |>
    data.frame(row.names = NULL)
  names(df) = c("name.1", "name.2", "nontreaty", "treaty")

  df = df |>
    dplyr::mutate(fishery.original = paste0(.data$name.1, " ", .data$name.2), .before = "nontreaty") |>
    dplyr::select(-"name.1", -"name.2") |>
    dplyr::mutate(nontreaty = as.numeric(.data$nontreaty),
                  treaty = as.numeric(.data$treaty))

  ## elwha and dungeness separate calculations
  raw = readxl::read_excel(xlsxFile, sheet = "JDF",
                           col_names = FALSE)
  ## trimming to the relevant region
  dat.jdf = raw[-(1:7),15:18]
  ## need to trim off the bottom section with summaries
  dat.jdf = dat.jdf[1:32,]
  names(dat.jdf) = c("fishery", "treaty.status", "Dungeness", "Elwha")
  ## we exclude Canada and Alaska, and then sumthe treaty and nontreaty separately
  dat.jdf = dat.jdf |>
    dplyr::filter(! .data$fishery %in% c("FISHERY", "Canada", "Alaska")) |>
    dplyr::filter(! is.na(.data$treaty.status)) |>
    dplyr::filter(.data$treaty.status != "-") |>
    dplyr::mutate(Dungeness = as.numeric(.data$Dungeness),
                  Elwha = as.numeric(.data$Elwha))

  dat.jdf = dat.jdf |>
    dplyr::group_by(.data$treaty.status) |>
    dplyr::mutate(treaty.status = stringr::str_replace_all(.data$treaty.status,
                                                           c("^NTrty" = "nontreaty",
                                                             "^Ntrty" = "nontreaty",
                                                             "^Ntry" = "nontreaty",
                                                             "^Trty" = "treaty"))) |>
    dplyr::summarize(Dungeness = sum(.data$Dungeness),
                     Elwha = sum(.data$Elwha)) |>
    tidyr::pivot_longer(cols = c("Dungeness", "Elwha")) |>
    tidyr::pivot_wider(names_from = .data$treaty.status, values_from = .data$value) |>
    dplyr::rename("fishery.original" = "name")
  df = rbind(df, dat.jdf)
  df = df |>
    dplyr::mutate(fishery.clean = stringr::str_replace_all(.data$fishery.original, pattern = name.mapping))

  return(df)
}
