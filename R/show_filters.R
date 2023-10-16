#' Show filters available on the provided api endpoint
#'
#' Most of the API endpoints have a large number of
#' available filters. This function takes an API endpoint name and
#' prints out all of the available filters. If 'filter_like' is
#' provided, only those filters that contain the provided string are
#' printed. If no endpoint name is provided, a list of available
#' endpoints will be displayed.
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/project_tracker/api/v1/swagger/,
#' https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/,
#' https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/, and
#' https://intra.glis.mnr.gov.on.ca/common/api/v1/swagger/
#' for an alternative way to view the full list of available filter keys (query parameters)
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
#' show_filters("sc121", "mode")
#' show_filters("species")
#' show_filters("sc121", "cats")
#' #show_filters("foo")
show_filters <- function(endpoint = "", filter_like = "") {
  fn_portal_endpoints <- names(get_api_filters("fn_portal", FALSE))
  creels_endpoints <- names(get_api_filters("creels", FALSE))
  common_endpoints <- names(get_api_filters("common", FALSE))
  pt_endpoints <- names(get_api_filters("project_tracker", FALSE))
  all_endpoints <- do.call(c, list(fn_portal_endpoints, creels_endpoints, common_endpoints, pt_endpoints))

  if (endpoint == "") {
    msg <-
      "An endpoint name needs to be provided. Currently available endpoint names are:\n"
    cat(msg)
    print(all_endpoints)
  } else {
    endpoint <- tolower(endpoint)
    if (endpoint %in% fn_portal_endpoints) api_app <- "fn_portal"
    if (endpoint %in% creels_endpoints) api_app <- "creels"
    if (endpoint %in% common_endpoints) api_app <- "common"
    if (endpoint %in% pt_endpoints) api_app <- "project_tracker"
    if (!endpoint %in% all_endpoints) stop("Oops, that endpoint is not valid. Run show_filters() for a list of valid endpoints.")

    if (!exists("api_filters")) get_api_filters(api_app = api_app)
    filters <- api_filters[[endpoint]]
    if (is.null(filters)) {
      filters <- refresh_filters(endpoint, api_app = api_app)
    }
    if (!filter_like == "") {
      print(subset(filters, grepl(filter_like, filters$name)))
    } else {
      print(filters)
    }
  }
}
