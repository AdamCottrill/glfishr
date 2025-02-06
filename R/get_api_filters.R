#' Connect to the api endpoint and return swagger documentation
#'
#' This function connects to the openapi/swagger endpoint specified by
#' the api_api argument and convertes the json response into an r list
#' (payload) that can be parsed by other functions to extract
#' information about the available filters or data fields contained in
#' the response from each endpoint.
#'
#'
#' @param api_app - the name of the api application to fetch the
#' filters from.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return list

get_swagger_payload <- function(api_app) {
  swagger_url <- get_swagger_url(api_app)

  response <- tryCatch(httr::GET(swagger_url),
    error = function(err) {
      stop("unable to fetch filters from the server. Is your VPN active?")
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
}


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
#' @param create_list - create the global list of api_filters if it
#' does not exist? Defaults to True.
#'
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return list
get_api_filters <- function(api_app, create_list = TRUE) {
  payload <- get_swagger_payload(api_app)

  api_filters <- parse_swagger_payload(payload)

  if (create_list == TRUE) {
    assign("api_filters", api_filters, envir = .GlobalEnv)
  } else {
    api_filters
  }
}


##' Build the url to fetch the swagger data for a give app
##'
##' An internal  helper function that combines the applicaiton name
##' with the current domain to build the url for the swagger
##' documentation for that app.
##' @param api_app - the name of the api application to fetch the
##' filters infromation from.
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return character vector
get_swagger_url <- function(api_app = c(
                              "common", "project_tracker",
                              "fn_portal", "creels", "tfat"
                            )) {
  api_app <- match.arg(api_app)
  domain <- get_domain()

  # HACK!!
  if (api_app == "tfat") {
    # tfat is still in the dev environment
    domain <- gsub("intra.glis", "intra.dev.glis", domain)
  }

  swagger_url <- sprintf("%s%s/api/v1/swagger.json", domain, api_app)
  return(swagger_url)
}

##' Convert swagger response into named list
##'
##' the response from the swagger endpoint include a large number of
##' attributes and details that are not need for glfishr. this
##' function takes the named list created from the json response and
##' extracts the name and description of each GET parameter that can
##' be used as filters.
##'
##' Given the complexity of the payload, this function is not
##' currently tested
##'
##' TODO: add option to parse schemas from payload
##'
##'
##' @param payload - list parsed from swagger api response
##'
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return  list
parse_swagger_payload <- function(payload) {
  api_filters <- list()
  for (name in names(payload$paths)) {
    endpoint_name <- gsub("/", "", name)
    parameters <- payload$paths[[name]]$get$parameters
    if (length(parameters) && !grepl("\\{", endpoint_name)) {
      values <- parameters[, c("name", "description")]
      values <- add_special_filters(endpoint_name, values)
      # api_filters <- c(api_filters, parse(endpoint) = values)
      api_filters[[endpoint_name]] <- values
    }
  }
  return(api_filters)
}


##' Add special filter options to selected endpoints
##'
##' Some of the the api endpoints accept filter arguments that are not
##' captured in the automatically generated swagger documentation.  These need
##' to be added so they can be presented to glfishr users.
##' @param endpoint_name - the name of api endpoint
##' @param values - data-frame with existing filter attributes
##' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
##' @return list
add_special_filters <- function(endpoint_name, values) {
  if (endpoint_name == "fn121") {
    values <- rbind(values, data.frame(
      name = "mu_type",
      description = "Run get_mu_list() for a list of accepted abbreviations."
    ))
  }

  if (endpoint_name == "gear") {
    values <- rbind(values, data.frame(
      name = c("all", "depreciated", "confirmed"),
      description = c("Boolean value.", "Boolean value.", "Boolean value.")
    ))
  }

  if (endpoint_name == "fn012_protocol") {
    values <- rbind(values, data.frame(
      name = c("all", "active", "confirmed"),
      description = c("Boolean value.", "Boolean value.", "Boolean value.")
    ))
  }

  if (endpoint_name == "prj_ldr") {
    values <- rbind(values, data.frame(
      name = "all",
      description = "Boolean value; default is FALSE."
    ))
  }

  if (endpoint_name == "species") {
    values <- rbind(values, data.frame(
      name = "detail",
      description = "Boolean value; default is FALSE."
    ))
  }

  if (endpoint_name == "fn126") {
    values <- rbind(values, data.frame(
      name = "itiscode",
      description = "Boolean value; default is FALSE."
    ))
  }


  return(values)
}
