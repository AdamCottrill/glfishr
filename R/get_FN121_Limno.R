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
#' See See \href{http://10.167.37.157/fn_portal/redoc/#operation/fn121limno}{fn121limno}
#' or type \code{\link{show_filters}} to see
#' the full list of available filter keys (query parameters).
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
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
#' filter_list <- list(prj_cd = "LEA_TR19_003")
#' fn121_limno <- get_FN121_Limno(filter_list)
#'
#' # pass the same filter to our FN121 to get the associated net sets:
#'
#' fn121 <- get_FN121(filter_list)
#' joined <- join_fn_fields(fn121, fn121_limno)
#' # net sets are now associated with their limnological data:
#' head(joined)
get_FN121_Limno <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn121limno", filter_list)
  my_url <- sprintf(
    "%s/fn121limno/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
