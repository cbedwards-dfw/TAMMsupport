% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/format_key_tamm_sheets.R
\name{format_key_tamm_sheets_coho}
\alias{format_key_tamm_sheets_coho}
\title{Modify list of Coho TAMM spreadsheet dataframes to facilitate comparison.}
\usage{
format_key_tamm_sheets_coho(
  dat,
  percent.digits = 1,
  numeric.digits = 1,
  numeric.digits.small = 4
)
}
\arguments{
\item{dat}{list of dataframes corresponding to the overview, limiting stock, and inputs tabs. Must be named \verb{$overview}, \verb{$limiting}, and \verb{$input}}

\item{percent.digits}{Optional, number of decimal places to round percentages to before comparison. Defaults to 1.}

\item{numeric.digits}{Optional, number of decimal places to round non-percentage numerics to before comparison. Applied to numbers that are expected to have natural units of whole numbers (e.g. numbers of fish). Defaults to 1.}

\item{numeric.digits.small}{Optional, number of decimal places to round non-percentage numerics to before comparison. Applied to numbers that are expected to be small (e.g. rates, proportions) Defaults to 4.}
}
\value{
list of dataframes with same structure as \code{dat}, contents modified.
}
\description{
Modify list of Coho TAMM spreadsheet dataframes to facilitate comparison.
}
