#' Internal function to url to the common api.
#'
#' This function is intended to be used by all of the functions that
#' call an api endpoint exposed by common. Each of the portals
#' (tfat, fn_portal, sc_portal etc.)  all have a slightly different
#' access point, and each will have a similar function. If the api
#' endpoint for that portal changes in the future, (i.e. the version
#' changes) we just need to update the value in this file and all of
#' the dependent functions will use it. Note that the url string does
#' *NOT* include a trailing slash.
#'
#'
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#'
#' @return string
#'
get_common_portal_root <- function() {
  api_url <- "common/api/v1"

  domain <- get_domain()

  return(paste0(domain, api_url))
}
