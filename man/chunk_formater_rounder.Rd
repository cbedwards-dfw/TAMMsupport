% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/column_formaters.R
\name{chunk_formater_rounder}
\alias{chunk_formater_rounder}
\title{Format chunks of dataframe to round digits}
\usage{
chunk_formater_rounder(df, block.ranges, digits = 1)
}
\arguments{
\item{df}{dataframe of sheet to apply formatting to.}

\item{block.ranges}{vector of characters specifying blocks of cells (in excel nomenclature) to format as \%s}

\item{digits}{Decimal place to round to.}
}
\value{
Formatted version of \code{df}
}
\description{
Format chunks of dataframe to round digits
}
