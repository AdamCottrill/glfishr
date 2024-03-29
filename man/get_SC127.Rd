% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_SC127.R
\name{get_SC127}
\alias{get_SC127}
\title{Get SC127 - Diet data from Creel_Portal API}
\usage{
get_SC127(filter_list = list(), show_id = FALSE, to_upper = TRUE)
}
\arguments{
\item{filter_list}{list}

\item{show_id}{When 'FALSE', the default, the 'id' and 'slug'
fields are hidden from the data frame. To return these columns as
part of the data frame, use 'show_id = TRUE'.}

\item{to_upper}{\itemize{
\item should the names of the dataframe be converted to
upper case?
}}
}
\value{
dataframe
}
\description{
This function accesses the api endpoint to for SC127 - age
estimate/interpretations.  This function takes an optional filter
list which can be used to return records based on several different
attributes of the age estimate such as the assigned age, the aging
structure, confidence, number of complete annuli and edge code, or
whether or not it was identified as the 'preferred' age for this
fish. Additionally, filters can be applied to select age estimates
based on attributes of the sampled fish such as the species, or
group code, or attributes of the effort, the sample, or the
project(s) that the samples were collected in.
}
\details{
Use \code{show_filters("sc127")} to see the full list of available filter
keys (query parameters). Refer to
\url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/}
and filter by "sc127" for additional information.
}
\examples{

sc127 <- get_SC127(list(lake = "ON", year = 2012, spc = "334"))

filters <- list(lake = "HU", spc = "076", grp = "55")
sc127 <- get_SC127(filters)
sc127 <- get_SC127(filters, show_id = TRUE)
}
\author{
Adam Cottrill \email{adam.cottrill@ontario.ca}
}
