% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_precip.R
\name{get_precip}
\alias{get_precip}
\title{Get precipitation height for a specified duration and return period}
\usage{
get_precip(data = NULL, d = NULL, tn = NULL)
}
\arguments{
\item{data}{A tibble containing grid cell statistics from KOSTRA-2010R.}

\item{d}{Duration in minutes.}

\item{tn}{Return period in years.}
}
\value{
A numerical vector including the precipitation height.
}
\description{
Get precipitation height for a specified duration and return period
}
\examples{
\dontrun{
get_precip(kostra, d = 60, tn = 50)
}
}
