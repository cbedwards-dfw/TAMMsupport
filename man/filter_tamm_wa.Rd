% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_tamm_wa.R
\name{filter_tamm_wa}
\alias{filter_tamm_wa}
\alias{filter_tamm_wa_chin}
\alias{filter_tamm_wa_coho}
\title{Filters a dataframe to Washington State fisheries.}
\usage{
filter_tamm_wa(.data)

filter_tamm_wa_chin(.data)

filter_tamm_wa_coho(.data)
}
\arguments{
\item{.data}{Dataframe generated within this package}
}
\description{
Adapted from framrsquared::filter_wa(), but (a) only for Chinook (at present), and (b) uses TAMM fishery ids, so includes
ids 72 and 73. Includes code for COHO based on FRAM ids. \code{filter_tamm_wa()} uses attributes to specify chinook or coho. To
directly filter for chinook or coho, use \code{filter_tamm_wa_chin()} or \code{filter_tamm_wa_coho()}.
}
\details{
a \code{fishery_id} column name.
}
\examples{
\dontrun{
fram_dataframe |> filter_wa()
}

}
