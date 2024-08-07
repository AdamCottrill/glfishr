% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_SC111.R
\name{get_SC111}
\alias{get_SC111}
\title{Get SC111 - Creel Interview Logs from Creel_Portal API}
\usage{
get_SC111(filter_list = list(), show_id = FALSE, to_upper = TRUE)
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
This function accesses the api endpoint to for SC111 records.  This
function takes an optional filter list which can be used to return
record based on several attributes of the creel such as project
code, or part of the project code, lake, first year, last year,
contact, or any of the strata
}
\details{
Use \code{show_filters("sc111")} to see the full list of available
filter keys (query parameters). Refer to
\url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
filter by "sc111" for additional information.
}
\examples{

sc111 <- get_SC111(list(lake = "ON", year = 2012))

sc111 <- get_SC111(list(prj_cd = "LHA_SC08_120"))

sc111 <- get_SC111(list(prj_cd = "LHA_SC08_120"), show_id = TRUE)
}
\author{
Adam Cottrill \email{adam.cottrill@ontario.ca}
}
