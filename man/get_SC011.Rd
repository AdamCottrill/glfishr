% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_SC011.R
\name{get_SC011}
\alias{get_SC011}
\title{Get SC011 - Creel Project Meta from Creel_Portal API}
\usage{
get_SC011(filter_list = list(), show_id = FALSE, to_upper = TRUE)
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
This function accesses the api endpoint to for SC011
records. SC011 records contain the hi-level meta data about an
OMNR Creels.  The SC011 records contain information like
project code, project name, projet leader, start and end date,
contact meth, and the lake where the creel was conducted.  This
function takes an optional filter list which can be used to return
record based on several attributes of the project such as
project code, or part of the project code, lake, first year, last
year, contact, etc.
#'
Use ~show_filters("sc011")~ to see the full list of available filter
keys (query parameters)
}
\examples{

sc011 <- get_SC011(list(lake = "ON", year__gte = 2012, year__lte = 2018))

sc011 <- get_SC011(list(lake = "ER"))

sc011 <- get_SC011(list(lake = "HU", prj_cd__like = "_001"))

sc011 <- get_SC011(list(lake = "HU", protocol = "USA"), show_id = TRUE)
}
\author{
Adam Cottrill \email{adam.cottrill@ontario.ca}
}
