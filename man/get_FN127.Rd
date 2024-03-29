% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_FN127.R
\name{get_FN127}
\alias{get_FN127}
\title{Get FN127 - Age data from FN_Portal API}
\usage{
get_FN127(filter_list = list(), show_id = FALSE, to_upper = TRUE)
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
This function accesses the api endpoint to for FN127 - age
estimate/interpretations.  This function takes an optional filter
list which can be used to return records based on several
different attributes of the age estimate such as the assigned age,
the aging structure, confidence, number of complete annuli and
edge code, or whether or not it was identified as the 'preferred'
age for this fish. Additionally, filters can be applied to
select age estimates based on attributes of the sampled fish such
as the species, or group code, or attributes of the effort, the
sample, or the project(s) that the samples were collected in.
}
\details{
Use \code{show_filters("fn127")} to see the full list of available
filter keys (query parameters). Refer to
\url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
and filter by "fn127" for additional information.
}
\examples{

fn127 <- get_FN127(list(lake = "ON", year = 2012, spc = "334", gr = "GL"))

filters <- list(
  lake = "ER",
  protocol = "TWL",
  spc = c("331", "334"),
  year = 2010,
  sidep0__lte = 20
)
fn127 <- get_FN127(filters)

filters <- list(
  lake = "SU",
  prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN"),
  eff = "051",
  spc = "091"
)
fn127 <- get_FN127(filters)

filters <- list(lake = "HU", spc = "076", grp = "55")
fn127 <- get_FN127(filters)
fn127 <- get_FN127(filters, show_id = TRUE)
}
\author{
Adam Cottrill \email{adam.cottrill@ontario.ca}
}
