#' Create global list of available API filters
#'
#' This function connects to the openapi/swagger endpoint provided by
#' fn_portal and fetches all of the available filters for each
#' endpoint.  The filters are available in a global list 'api_filters'
#' which subsequently used by other functions - check_filters,
#' show_filters.  Generally, this function is not intended to be
#' called directly by the user.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn_011_list for the
#' full list of available filter keys (query parameters)
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return list
get_api_filters <- function() {
  # TODO: make url dynamic to accomodate multiple apps.
  swagger_url <- "http://10.167.37.157/fn_portal/swagger.json"
  response <- tryCatch(httr::GET(swagger_url),
    error = function(err) {
      print("unable to fetch from the server. Is your VPN active?")
    }
  )

  json <- httr::content(response, "text", encoding = "UTF-8")
  payload <- jsonlite::fromJSON(json)

  api_filters <- list()
  for (name in names(payload$paths)) {
    endpoint <- gsub("/", "", name)
    parameters <- payload$paths[[name]]$get$parameters
    if (length(parameters) & !grepl("\\{", endpoint)) {
      values <- subset(parameters, select = c("name", "description"))
      # api_filters <- c(api_filters, parse(endpoint) = values)
      api_filters[[endpoint]] <- values
    }
  }
  assign("api_filters", api_filters, envir = .GlobalEnv)
}
