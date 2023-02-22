#' Get vessels - A list of vessel names used in GLIS
#'
#' This function accesses the api endpoint for vessels and returns
#' their names, descriptions and whether they're in use. It can fetch
#' the entire table of active vessels, or it accepts filter parameter
#' all=TRUE to return depreciated vessels too. No other filter
#' parameters are currently available for this endpoint.
#' 
#'
#' See
#' http://10.167.37.157/common/vessels
#' for the full list of vessels
#' 
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' vessel_list <- get_vessels()
#' all_vessels <- get_vessels(list(all=TRUE))
get_vessels <- function(filter_list = list(), to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  #check_filters("vessels", filter_list, "common")
  #TODO: add a warning about 'all=TRUE' being the only allowed filter
  
  my_url <- sprintf(
    "%s/vessels/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, to_upper)

  return(payload)
}
