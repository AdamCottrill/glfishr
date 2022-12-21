#' Get FN121_Trawl - Trawl data from FN_Portal API
#'
#' This function accesses the api endpoint for fn121trawl
#' records. fn121trawl records contain details on the vessel, its speed and direction,
#' and warp. Other relevant details for each SAM are found in the FN121 table. 
#' This function takes an optional filter list which can be used to return records 
#' based on attributes of the SAM including site depth, start and end date 
#' and time, effort duration, gear, and location as well as attributes of the projects 
#' they are associated with such as project code, or part of the project code, lake, 
#' first year, last year, protocol, etc. This function can also take filters related to 
#' the vessel/warp.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn121trawl_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
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
#' fn121_trawl <- get_FN121_Trawl(list(lake = "ER", year = 2018))
get_FN121_Trawl <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn121trawl", filter_list)
  my_url <- sprintf(
    "%s/fn121trawl/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  
  return(payload)
}
