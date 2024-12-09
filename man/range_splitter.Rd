% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trace_formula.R
\name{range_splitter}
\alias{range_splitter}
\title{Translate excel-style cell range to vector of cell addresses.}
\usage{
range_splitter(address)
}
\arguments{
\item{address}{Character string of excel cell range, as in "B10:C15" or "'Input Sheet'!AS30:AS40"}
}
\value{
vector of individual excel-style cell addresses within that range
}
\description{
Primarily intended as a helper function for \code{trace_formula()}, but could be useful for
other excel tasks. Drops \code{$} and \verb{'} symbols from addresses to simplify parsing.
}
\examples{
range_splitter("B10:C15")
range_splitter("'Input Sheet'!$AS30:$AS40")
}
