#' Chinook fishery information
#'
#' Mapping of fishery_id to fishery name for Chinook salmon, taken from the `Fishery` table of
#' the Chinook FRAM database.
#'
#' @format A data frame with 74 rows and 5 columns:
#' \describe{
#'   \item{species}{Species name}
#'   \item{version_number}{}
#'   \item{fishery_id}{fishery id number in FRAM}
#'   \item{fishery_name}{fishery name in FRAM}
#'   \item{fishery_title}{consistent and more human readable version of `fishery_name`}
#' }
#' @source 2024 Pre-Season Chinook DB.mdb
"fishery_chinook_fram"


#' Coho fishery information
#'
#' Mapping of fishery_id to fishery name for Coho salmon, taken from the `Fishery` table of
#' the Coho FRAM database.
  #' @format A data frame with 198 rows and 5 columns:
#' \describe{
#'   \item{species}{Species name}
#'   \item{version_number}{}
#'   \item{fishery_id}{fishery id number in FRAM}
#'   \item{fishery_name}{fishery name in FRAM}
#'   \item{fishery_title}{consistent and more human readable version of `fishery_name`}
#' }
#' @source 2024NOF_CohoFRAMdatabase_distribution.mdb
"fishery_coho_fram"

#' Chinook stock information
#'
#' Mapping of stock_id to stock name for Chinook salmon, taken from the `Stock` table of
#' the Chinook FRAM database.
#'
#' @format A data frame with 78 rows and 7 columns:
#' \describe{
#'   \item{species}{Species name}
#'   \item{stock_version}{}
#'   \item{stock_id}{stock id number in FRAM}
#'   \item{production_region_number}{}
#'   \item{management_unit_number}{}
#'   \item{stock_name}{stock name in FRAM}
#'   \item{stock_long_name}{`stock_name` but more human readable}
#' }
#' @source 2024 Pre-Season Chinook DB.mdb
"stock_chinook_fram"

#' Coho stock information
#'
#' Mapping of stock_id to stock name for Coho salmon, taken from the `Stock` table of
#' the Coho FRAM database.
#'
#' @format A data frame with 78 rows and 7 columns:
#' \describe{
#'   \item{species}{Species name}
#'   \item{stock_version}{}
#'   \item{stock_id}{stock id number in FRAM}
#'   \item{production_region_number}{}
#'   \item{management_unit_number}{}
#'   \item{stock_name}{stock name in FRAM}
#'   \item{stock_long_name}{`stock_name` but more human readable}
#' }
#' @source 2024NOF_CohoFRAMdatabase_distribution.mdb
"stock_coho_fram"


#' Chinook timestep information stock information
#'
#' Mapping of timestep numbers to dates in the year, taken from the `TimeStep` table of
#' the Chinook FRAM database
#'
#' @format A data frame with 4 rows and 5 columns:
#' \describe{
#'   \item{species}{Species name}
#'   \item{version_number}{}
#'   \item{time_step_id}{id number for the time step}
#'   \item{time_step_name}{Span of each timestep. Timesteps start on the first of the month, and end on the last of the month. Note that `Oct-Apr-2` is highlighting that timestep 4 runs from October of the current year to April of the NEXT year (equivalent to timestep 1 of the following year).}
#'   \item{time_step_title}{`time_step_name`, but months are written out}
#' }
#' @source 2024 Pre-Season Chinook DB.mdb
"timestep_chinook_fram"

#' Coho timestep information stock information
#'
#' Mapping of timestep numbers to dates in the year, taken from the `TimeStep` table of
#' the Chinook FRAM database
#'
#' @format A data frame with 5 rows and 5 columns:
#' \describe{
#'   \item{species}{Species name}
#'   \item{version_number}{}
#'   \item{time_step_id}{id number for the time step}
#'   \item{time_step_name}{Span of each timestep. Timesteps start on the first of the month, and end on the last of the month.}
#'   \item{time_step_title}{`time_step_name`, but months are written out consistently}
#' }
#' @source 2024NOF_CohoFRAMdatabase_distribution.mdb
"timestep_coho_fram"
