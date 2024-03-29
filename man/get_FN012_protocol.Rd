% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_FN012_protocol.R
\name{get_FN012_Protocol}
\alias{get_FN012_Protocol}
\title{Get FN012_Protocol - Sampling specs (species and group) for a
specific lake and protocol from FN_Portal API}
\usage{
get_FN012_Protocol(filter_list = list(), show_id = FALSE, to_upper = TRUE)
}
\arguments{
\item{filter_list}{list}

\item{show_id}{When 'FALSE', the default, the 'id' and 'slug'
fields are hidden from the data frame. To return these columns
as part of the data frame, use 'show_id = TRUE'.}

\item{to_upper}{\itemize{
\item should the names of the dataframe be converted to
upper case?
}}
}
\value{
dataframe
}
\description{
This function accesses the api endpoint for FN012 Protocol List
records. These records are the expected range of biodata values
(e.g. FLEN, TLEN, RWT, K) for the typical species caught in using
a given protocol in a given lake. These constraints are used
by ProcVal to check that biodata for fish caught during the project is
reasonable. The protocol and lake MUST be specified for retrieving
records using this function. This is a useful function for building
a template database for a new project or for adding an FN012 table to
an existing project.
}
\details{
Use \code{show_filters("fn012_protocol")} to see the full list of available filter
keys (query parameters). Refer to
\url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
and filter by "fn012_protocol" for additional information.
}
\examples{

fn012_protocol <- get_FN012_Protocol(list(lake = "ON", protocol = "TWL"))

fn012_protocol <- get_FN012_Protocol(list(lake = "HU", protocol = "BSM"))

fn012_protocol <- get_FN012_Protocol(list(lake = "ER", protocol = "Hydro"))
}
\author{
Adam Cottrill \email{adam.cottrill@ontario.ca}
}
