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
#' filters from. Defaults to fn_portal.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return list
#' @export
#' @examples
#' check_filters("fn125", c("year", "prj_cd"))
#' check_filters("fn125", c("year", "prj_cd", "red", "yellow"))
#' check_filters("common_filters", c("mu_type"))
#' check_filters("common_filters", c("mu_type", "taxon_name"))
#' check_filters("foo", c("year", "prj_cd"))
check_filters <- function(endpoint, filters, api_app = "fn_portal") {
  
  #TODO: remove common_filters when api_app can be equal to "common"
  common_filters <- data.frame(name = c("mu_type", "lake", 'taxon', 'itiscode', 'taxon_name', 'taxon_label',
                                        'taxonomic_rank', 'vertinvert', 'omnr_provincial_code', 'page_size',
                                        'detail'),
                               description = c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA))
  
  if (!exists("api_filters")) get_api_filters(api_app = api_app)
  
  api_filters_manual <- api_filters
  api_filters_manual$common_filters <- common_filters
  
  endpoint <- ifelse(tolower(endpoint)=="fn121gpstracks", "fn121GpsTracks", tolower(endpoint))

  known_filters <- api_filters_manual[[endpoint]]
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
