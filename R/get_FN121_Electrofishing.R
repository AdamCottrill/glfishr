#' Get FN121_Electrofishing - Electrofishing data from FN_Portal API
#'
#' This function accesses the api endpoint for FN121_Electrofishing
#' records. FN121_Electrofishing records contain information about 
#' electrofishing sampling events, including shocking seconds, volts,
#' amps, and power used for each SAM. Other relevant details for the SAM
#' are found in the FN121 and optionally the FN121_GPS_Tracks tables. 
#' This function takes an optional filter list which can be used to 
#' return records based on attributes of the SAM including start and end 
#' date and time, effort duration, gear, site depth and location as well as
#' attributes of the projects they are associated with such project
#' code, or part of the project code, lake, first year, last year,
#' protocol, etc.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn121electrofishing_list
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
#' TODO: Update with relevant examples when data exists in the portal
#'
#' fn121_efish <- get_FN121_Electrofishing(list(lake = "ON", year = 2012))
#' fn121_efish <- get_FN121_Electrofishing(list(
#'   lake = "ER", protocol = "TWL",
#'   sidep__lte = 20, year__gte = 2010
#' ))
#' filters <- list(
#'   lake = "SU",
#'   prj_cd = c("LSA_IA15_CIN", "LSA_IA17_CIN")
#' )
#' fn121_efish <- get_FN121_Electrofishing(filters)
#' fn121_efish <- get_FN121_Electrofishing(list(lake = "HU", prj_cd__like = "_003"))
#' fn121_efish <- get_FN121_Electrofishing(list(lake = "HU", prj_cd__like = "_003"), show_id = TRUE)
get_FN121_Electrofishing <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn121electrofishing", filter_list)
  my_url <- sprintf(
    "%s/fn121electrofishing/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
