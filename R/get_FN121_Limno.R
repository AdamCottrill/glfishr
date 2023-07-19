#' Get FN121_Limno - Net set limnological data from FN_Portal API
#'
#' This function accesses the api endpoint to for FN121limno
#' records. FN121limno records contain limnological data associated
#' with individual net sets. There is a 1:1 relationship between a
#' net set and a FN121Lino record. The FN121limno record contains
#' information like dissolved oxygen at the surface or at the gear at
#' the start and/or end of a sampling event. This function takes an
#' optional filter list which can be used to return records based on
#' several attributes of the limnological data as well as attributes
#' of the net set including set and lift date and
#' time, effort duration, gear, site depth and location as well as
#' attributes of the projects they are associated with such project
#' code, or part of the project code, lake, first year, last year,
#' protocol, etc.  The limnological data can be joined back to the
#' associated net set in R using the function \code{\link{join_fn_fields}}
#'
#' See \href{http://10.167.37.157/fn_portal/api/v1/redoc/#operation/fn121limno}{fn121limno}
#' or type \code{\link{show_filters}} to see
#' the full list of available filter keys (query parameters).
#'
#' @param filter_list list
#' @param with_121 When 'FALSE', the default, only the limnology fields
#' from the FN121 table are returned. To return the whole FN121 table
#' (excluding trapnet, weather, and trawl fields), use 'with_121 = TRUE'.
#' @param show_id When 'FALSE', the default, the 'slug'
#' field is hidden from the data frame. To return this field
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?  Defaults to TRUE to match the FISHNET-II  convention
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' # see the available filters that contain the string 'o2' (oxygen)
#' show_filters("fn121limno", "o2")
#'
#' fn121_limno <- get_FN121_Limno(list(lake = "ER", year = 2019, o2surf0__not_null = TRUE))
#' fn121_limno <- get_FN121_Limno(list(lake = "ER", year = 2019, o2surf0__not_null = TRUE), with_121 = TRUE)
#' fn121_limno <- get_FN121_Limno(list(lake = "ER", year = 2019, o2surf0__not_null = TRUE, mu_type = "moe"), with_121 = TRUE)
#' fn121_limno <- get_FN121_Limno(list(lake = "ER", year = 2019, o2surf0__not_null = TRUE), show_id = TRUE)
#' 
get_FN121_Limno <- function(filter_list = list(), with_121 = FALSE, show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  
  limno_filters <- filter_list[names(filter_list) != "mu_type"]
  
  query_string <- build_query_string(limno_filters)
  check_filters("fn121limno", limno_filters, "fn_portal")
  my_url <- sprintf(
    "%s/fn121limno/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  
  if (with_121==TRUE){
    
    limno_filters <- setdiff(names(filter_list), api_filters$fn121$name)
    new_filters <- filter_list[names(filter_list) %in% limno_filters == FALSE]
    
    FN121 <- get_FN121(new_filters)
    
    payload <- merge(FN121, payload)
    
  }

  return(payload)
}
