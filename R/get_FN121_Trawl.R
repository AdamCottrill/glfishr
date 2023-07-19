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
#' http://10.167.37.157/fn_portal/api/v1/redoc/#operation/fn121trawl_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#' @param with_121 When 'FALSE', the default, only the trawl fields
#' from the FN121 table are returned. To return the whole FN121 table
#' (excluding limnology, weather, and trapnet fields), use 'with_121 = TRUE'.
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
#' fn121_trawl <- get_FN121_Trawl(list(lake = "ER", year = 2018))
#' fn121_trawl <- get_FN121_Trawl(list(lake = "ER", year = 2018), with_121 = TRUE)
#' fn121_trawl <- get_FN121_Trawl(list(lake = "ER", year = 2018, mu_type = "qma"), with_121 = TRUE)
#' fn121_trawl <- get_FN121_Trawl(list(lake = "ER", year = 2018), show_id = TRUE)
get_FN121_Trawl <- function(filter_list = list(), with_121 = FALSE, show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  
  trawl_filters <- filter_list[names(filter_list) != "mu_type"]
  
  query_string <- build_query_string(trawl_filters)
  check_filters("fn121trawl", trawl_filters, "fn_portal")
  my_url <- sprintf(
    "%s/fn121trawl/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  
  if (with_121==TRUE){
    
    trawl_filters <- setdiff(names(filter_list), api_filters$fn121$name)
    new_filters <- filter_list[names(filter_list) %in% trawl_filters == FALSE]
    
    FN121 <- get_FN121(new_filters)
    
    payload <- merge(FN121, payload)
    
  }

  return(payload)
}
