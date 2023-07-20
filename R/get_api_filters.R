#' Create global list of available API filters
#'
#' This function connects to the openapi/swagger endpoint provided by
#' fn_portal, creels, and common APIs and fetches all of the available
#' filters for each endpoint. The filters are available in a global
#' list 'api_filters' which subsequently used by other functions -
#' check_filters, show_filters. Generally, this function is not
#' intended to be called directly by the user.
#'
#'
#' @param api_app - the name of the api application to fetch the
#' filters from.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return list
get_api_filters <- function(api_app, create_list = TRUE) {
  domain <- get_domain()
  swagger_url <- sprintf("%s%s/api/v1/swagger.json", domain, api_app)

  
  # need to run GET(swagger_url) twice until Azure login is working
  redundant_response <- tryCatch(httr::GET(swagger_url),
                                 error = function(err) {
                                   print("unable to fetch filters from the server. Is your VPN active?")
                                 }
  )
  
  response <- tryCatch(httr::GET(swagger_url),
    error = function(err) {
      print("unable to fetch filters from the server. Is your VPN active?")
    }
  )

  json <- httr::content(response, "text", encoding = "UTF-8")

  payload <- tryCatch(
    jsonlite::fromJSON(json, flatten = TRUE),
      error = function(err) {
      print("unable able to parse the json response from:")
      print(swagger_url)
      return(list(paths = list()))
    }
  )

  api_filters <- list()
  for (name in names(payload$paths)) {
    endpoint <- gsub("/", "", name)
    parameters <- payload$paths[[name]]$get$parameters
    if (length(parameters) & !grepl("\\{", endpoint)) {
      values <- subset(parameters, select = c("name", "description"))

      if (name == "/fn121/") {
        values <- rbind(values, data.frame(name = "mu_type", description = "Run get_mu_list() for a list of accepted abbreviations."))
      }

      if (name == "/gear/") {
        values <- rbind(values, data.frame(
          name = c("all", "depreciated", "confirmed"),
          description = c("Boolean value.", "Boolean value.", "Boolean value.")
        ))
      }

      if (name == "/fn012_protocol/") {
        values <- rbind(values, data.frame(
          name = c("all", "active", "confirmed"),
          description = c("Boolean value.", "Boolean value.", "Boolean value.")
        ))
      }

      if (name == "/prj_ldr/") {
        values <- rbind(values, data.frame(name = "all", description = "Boolean value; default is FALSE."))
      }

      if (name == "/species/") {
        values <- rbind(values, data.frame(name = "detail", description = "Boolean value; default is FALSE."))
      }

      # api_filters <- c(api_filters, parse(endpoint) = values)
      api_filters[[endpoint]] <- values
    }
  }
  if (create_list == TRUE) {
    assign("api_filters", api_filters, envir = .GlobalEnv)
  } else {
    api_filters
  }
}
