

#' Format TAMM overview for easy printing
#'
#' @param dat.overview dataframe of TAMM overview page, as produced by read_overview()
#'
#' @importFrom rlang .data
#' @return list with the formatted data, a vector of indent information, and a vector of bolding information.
#' @export
#'

format_overview = function(dat.overview){
  dat.overview <- dat.overview |>
    dplyr::mutate(er_ceiling = quick_er_format(.data$er_ceiling),
                  escapement = round(.data$escapement, 1),
                  total_er = quick_er_format(.data$total_er),
                  sus_er = quick_er_format(.data$sus_er),
                  pt_sus_er = quick_er_format(.data$pt_sus_er)
    )
  ## bold appropriate data
  dat.overview <- dat.overview |>
    dplyr::mutate(col.bold = dplyr::case_when(
      er_type == "PT-SUS" ~ "pt_sus_er",
      grepl("SUS$", er_type) ~ "sus_er",
      er_type == "Total" ~ "total_er"
    ))

  dat.overview = as.data.frame(lapply(dat.overview, function(x){x[is.na(x)] = "";
  return(x)}))

  col.bold = dat.overview$col.bold
  dat.overview <- dat.overview |>
    dplyr::select(-col.bold)

  ## handling stock labels: want indentations
  vec.indent = c("NF NOOKSACK SPRING", "SF NOOKSACK SPRING", "Upper Sauk", "Upper Cascade",
                 "Suiattle", "Upper Skagit", "Sauk", "Lower Skagit", "STILLAGUAMISH UM", "STILLAGUAMISH M",
                 "Skykomish", "Snoqualmie")
  ind.indent = which(dat.overview$stock %in% vec.indent)
  return(list(dat.overview = dat.overview,
              ind.indent = ind.indent,
              col.bold = col.bold))
}



#' Print table of overview using kable and kableExtra
#'
#' Uses output of format_overview()
#'
#' @param dat.overview formatted data, first item of format_overview() output
#' @param ind.indent Vector of indices that need indenting to match TAMM overview formatting. Second item of format_overview() output
#' @param col.bold vector of names for bolding to match TAMM overview formatting. Third item of format_overview() output.
#'
#' @return html table
#' @export
#'
kable_overview = function(dat.overview, ind.indent, col.bold){
  kableExtra::kbl(dat.overview, format = "html",
      align = c("l", "c", "r", "c", "r", "r", "r", "r"),
      col.names = c("Stock", "Abund. Tier", "ER Ceiling", "ER Type", "Escape.", "Total ER", "SUS ER", "PT-SUS ER")) |>
    kableExtra::kable_classic(full_width = F, html_font = "Cambria") |>
    kableExtra::add_indent(ind.indent, level_of_indent = 1) |> # this line needs to be before any extra_css
    kableExtra::row_spec(1, extra_css = "border-top: 2px solid;") |>
    kableExtra::column_spec(2:4, width = ".9cm") |>
    kableExtra::column_spec(6, bold = col.bold == "total_er") |>
    kableExtra::column_spec(7, bold = col.bold == "sus_er") |>
    kableExtra::column_spec(8, bold = col.bold == "pt_sus_er") |>
    kableExtra::column_spec(c(1, 4, 8), extra_css = "border-right: 2px solid;") |>
    kableExtra::column_spec(c(1), extra_css = "border-left: 2px solid;") |>
    kableExtra::row_spec(c(3, 7, 8, 13, 16, 19, 20:(nrow(dat.overview)-2)), extra_css = "border-bottom: 1px solid") |>
    kableExtra::row_spec(c(9, nrow(dat.overview)-1), extra_css = "border-bottom: 2px solid;")
}

#' Quick helper function to format vectors that contain text and ERs
#'
#' @param x character vector
#'
quick_er_format <-  function(x){
  #we know the following will give warnings. That's the point.
  suppressWarnings({can.numeric = !is.na(as.numeric(x))})
  x[can.numeric] = paste0(round(as.numeric(x[can.numeric]), 4)*100, "%")
  return(x)
}
