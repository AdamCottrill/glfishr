#' Get FN121_Weather - Weather data from FN_Portal API
#'
#' This function accesses the api endpoint for fn121weather
#' records. fn121weather records contain air temperature, precipitation,
#' wind speed and direction, cloud cover, and wave height data collected
#' at time/location 0 and/or 1. Other relevant details for each SAM are 
#' found in the FN121 table. This function takes an optional filter list which can 
#' be used to return records based on attributes of the SAM including site 
#' depth, start and end date and time, effort duration, gear, and location 
#' as well as attributes of the projects they are associated with such as project
#' code, or part of the project code, lake, first year, last year,
#' protocol, etc. This function can also take filters related to weather.
#'
#' See
#' http://10.167.37.157/fn_portal/api/v1/redoc/#operation/fn121weather_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'slug'
#' field is hidden from the data frame. To return this field
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' TODO: Update with relevant examples when more data exists in the portal
#'
#' fn121_weather <- get_FN121_Weather(list(lake = "ER", year = 2018))
get_FN121_Weather <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn121weather", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn121weather/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  
  return(payload)
}
