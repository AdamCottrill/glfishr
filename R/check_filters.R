#' Check the filters against api filters
#'
#' This function is used within data fetching functions to verify that
#' the list of provided filters are known to exist.  If a filter
#' cannot be found, a warning is printed out the screen. If the global
#' api filter object does exist, it is populated before proceeding.
#'
#' @param endpoint - the name of the api endpoint
#' @param filters - list of filter names that are to be applied to the
#'   endpoint.
#' @param api_app - the name of the api application to fetch the
#' filters from.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return list
#' @export
#' @examples
#' check_filters("fn125", list(year = "2022", lake = "ON"), "fn_portal")
#' check_filters("fn125", list(year = "2022", lake = "ON", colour = "blue"), "fn_portal")
#' check_filters("foo", list(year = "2022", lake = "ON"), "fn_portal")
check_filters <- function(endpoint, filters, api_app) {
  if (!exists("api_filters")) get_api_filters(api_app = api_app)

  endpoint <- tolower(endpoint)

  known_filters <- api_filters[[endpoint]]
  if (is.null(known_filters)) {
    known_filters <- refresh_filters(endpoint, api_app = api_app)
  }

  diff <- setdiff(names(filters), known_filters$name)
  if (length(diff)) {
    tmp <- paste(diff, collapse = "\n + ")
    msg <- "Unknown filters provided. These will be ignored:\n + %s"
    msg <- sprintf(msg, tmp)
    warning(msg)
  }
}
