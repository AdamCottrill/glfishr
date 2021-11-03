#' Show filters available on the provided api endpoint
#'
#' Most of the fn_portal API endpoints have a large number of
#' available filters.  This function takes and api endpoint name and
#' prints out all of the available filters.  If 'filter_like' is
#' provided, only those filters that contain the provided string are
#' printed.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn_011_list for the
#' full list of available filter keys (query parameters)
#'
#' @param endpoint - the name of the api endpoint
#' @param filter_like - a partial string to match filter against
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return NULL
#' @export
#' @examples
#' show_filters("fn125")
#' show_filters("fn125", filter_like = "prj")
#' show_filters("foo")
show_filters <- function(endpoint, filter_like = "") {

  endpoint <- tolower(endpoint)
  api_app <- if(substr(endpoint, 1, 2) == "fn") "fn_portal" else "creels"

  if (!exists("api_filters")) get_api_filters(api_app=api_app)
  filters <- api_filters[[endpoint]]
  if (is.null(filters)) {
    filters <- refresh_filters(endpoint, api_app=api_app)
  }
  if (!filter_like == "") {
    print(subset(filters, grepl(filter_like, filters$name)))
  } else {
    print(filters)
  }
}
