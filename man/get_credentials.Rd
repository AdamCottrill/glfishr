% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_credentials.R
\name{get_credentials}
\alias{get_credentials}
\title{Get GLIS Credentials}
\usage{
get_credentials()
}
\value{
named list
}
\description{
A helper function to prompt a user for their GLIS username and
password, if the global variables GLIS_USER and GLIS_PASSWORD are
not found. The default function uses the rstudioapi which provides
pop-up to enter credentials so that usernames and passwords are not
saved, and passwords are not visible.  If the users is not using
Rstudio, the default readline interface is used.  Depending on the
R client, the password characters may not be obscured when the
readlines function is called.
}
\details{
Users can by-pass the prompts by setting up global variable for
their account. These values will be used preferentially if they
exists.
}
\author{
Adam Cottrill \email{adam.cottrill@ontario.ca}
}
