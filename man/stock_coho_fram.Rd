% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{stock_coho_fram}
\alias{stock_coho_fram}
\title{Coho stock information}
\format{
A data frame with 78 rows and 7 columns:
\describe{
\item{species}{Species name}
\item{stock_version}{}
\item{stock_id}{stock id number in FRAM}
\item{production_region_number}{}
\item{management_unit_number}{}
\item{stock_name}{stock name in FRAM}
\item{stock_long_name}{\code{stock_name} but more human readable}
}
}
\source{
2024NOF_CohoFRAMdatabase_distribution.mdb
}
\usage{
stock_coho_fram
}
\description{
Mapping of stock_id to stock name for Coho salmon, taken from the \code{Stock} table of
the Coho FRAM database.
}
\keyword{datasets}
