% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/refresh_filters.R
\name{refresh_filters}
\alias{refresh_filters}
\title{Refresh the global api filter list}
\usage{
refresh_filters(endpoint, api_app)
}
\arguments{
\item{endpoint}{\itemize{
\item the name of the api endpoint
}}

\item{api_app}{\itemize{
\item the name of the api application to fetch the
filters from. Defaults to 'fn_portal'
}}
}
\value{
list
}
\description{
A function to refresh or fetch available filters for an endpoint.
This function is called the first time filters are applied or
requested and any time an unknown or new endpoint is specified.
This function is not intended to be called directly by users, but
is called by the \code{show_filters} and \code{check_filter}
functions.
}
\author{
Adam Cottrill \email{adam.cottrill@ontario.ca}
}
