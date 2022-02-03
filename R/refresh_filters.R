#' Refresh the global api filter list
#'
#' A function to refresh or fetch available filters for an endpoint.
#  This function is called the first time filters are applied or
#  requested and any time an unknown or new endpoint is specified.
#  This function is not intended to be called directly by users, but
#  is called by the show_filters and check_filter functions.
#'
#' @param endpoint - the name of the api endpoint
#' @param api_app - the name of the api application to fetch the
#' filters from. Defaults to 'fn_portal'
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return list
refresh_filters <- function(endpoint, api_app='fn_portal') {
  # todo update with appropriate url for endpoint and try again
  get_api_filters(api_app = api_app)
  filters <- api_filters[[endpoint]]
  if (is.null(filters)) {
    msg <- sprintf("Filters could not be found for the '%s' endpoint", endpoint)
    warning(msg)
  }
  return(filters)
}