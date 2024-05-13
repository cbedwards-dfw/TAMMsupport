#' Filters a dataframe to Washington State fisheries.
#'
#' Adapted from framrsquared::filter_wa(), but (a) only for Chinook (at present), and (b) uses TAMM fishery ids, so includes
#' ids 72 and 73. Includes code for COHO based on FRAM ids.
#'
#' a `fishery_id` column name.
#' @param .data Dataframe generated within this package
#' @export
#' @examples
#' \dontrun{
#' fram_dataframe |> filter_wa()
#' }
#'
filter_tamm_wa <- function(.data){
  validate_data_frame(.data)
  if(!'fishery_id' %in% colnames(.data)){
    cli::cli_abort('fishery_id column must be present in dataframe.')
  }

  if(attr(.data, 'species') == 'CHINOOK'){
    .data |>
      dplyr::filter(
        .data$fishery_id %in% c(16:73)
      )
  } else if(attr(.data, 'species') == 'COHO') {
    cli::cli_alert("COHO dataframe. Using *FRAM* fishery ids.")
    .data |>
      dplyr::filter(
        .data$fishery_id %in% c(23:166)
      )
  } else {
    cli::cli_abort('Table metadata missing... Table not generated from this package?')
  }

}
