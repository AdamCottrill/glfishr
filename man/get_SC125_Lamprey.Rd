% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_SC125_Lamprey.R
\name{get_SC125_Lamprey}
\alias{get_SC125_Lamprey}
\title{Get SC125_Lamprey - Lamprey Wound data from Creel_Portal API}
\usage{
get_SC125_Lamprey(filter_list = list(), show_id = FALSE, to_upper = TRUE)
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
This function accesses the api endpoint to for SC125 Lamprey
records. SC125 Lam records contain information about the individual
lamprey wounds observed on a sampled fish.  Historically, lamprey
wounds were reported as a single field (XLAM) in the SC125 table.
In the early 2000 the Great Lakes fishery community agreed to
capture lamprey wounding data in a more consistent fashion the
basin, using the conventions described in Ebener et al. 2006.  The
SC125Lam table captures data from individual lamprey wounds
collected using those conventions.  A sampled fish with no observed
wound will have a single record in this table (with lamijc value of
0), while fish with lamprey wounds, will have one record for every
observed wound. This function takes an optional filter list which
can be used to return records based on several different attributes
of the wound (wound type, degree of healing, and wound size) as
well as, attributes of the sampled fish such as the species, or
group code, or attributes of the interview, or the creel(s) that
the samples were collected in.
}
\details{
Use \code{show_filters("sc125lamprey")} to see the full list of
available filter keys (query parameters). Refer to
\url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
filter by "sc125lamprey" for additional information.
}
\examples{

sc125Lam <- get_SC125_Lamprey(list(lake = "HU", spc = "081", year = 2000))


filters <- list(lake = "HU", spc = "076", year__gte = 2018)
sc125Lam <- get_SC125_Lamprey(filters)
sc125Lam <- get_SC125_Lamprey(filters, show_id = TRUE)
}
\author{
Adam Cottrill \email{adam.cottrill@ontario.ca}
}
