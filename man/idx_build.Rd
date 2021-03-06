% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{idx_build}
\alias{idx_build}
\title{Construct "INDEX_RC" based on given X and Y information}
\usage{
idx_build(col = NULL, row = NULL)
}
\arguments{
\item{col}{Integer {1:79}}

\item{row}{Integer {1:107}}
}
\value{
A string containing the unique representation of the relevant
"INDEX_RC" field.
}
\description{
Construct "INDEX_RC" based on given X and Y information
}
\examples{
\dontrun{
idx_build(11, 49)
}
}
