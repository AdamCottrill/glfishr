#' Get SC124 - Length Frequency Counts from Creel_Portal API
#'
#' This function accesses the api endpoint for SC124 records from
#' the Creel_Portal. SC124 records contain information about the length frequency
#' by species associated with an angler interview. Group (GRP) is
#' occasionally included to further sub-divide the catch into user
#' defined groups that are usually specific to the project. This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the catch including species
#' or group code but also attributes of the effort, the sample or the
#' project(s) that the catches were made in.
#'
#' See
#' http://10.167.37.157/creels/api/v1/redoc/#operation/sc124_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param uncount - should the binned data be expanded to represent
#' indivual measurements.  A SC124 record with sizcnt=5 will be
#' repeated 5 times in the returned data frame.
#'
#' @author Jeremy Holden \email{jeremy.holden@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' sc124 <- get_SC124(list(lake = "ON", year = 2021, spc = "334"))
#'
#' filters <- list(
#'   lake = "ON",
#'   year = 2021,
#'   spc = c("061", "121")
#' )
#' sc124 <- get_SC124(filters)
#'
#' sc124 <- get_SC124(list(prj_cd = "LOA_SC19_002"),
#'     uncount = TRUE)
#'
get_SC124 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, uncount = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc124", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc124/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  
  if (uncount == TRUE) {
    payload <- uncount_tally(payload, "SIZCNT")
    return(payload)
  }
  
  return(payload)
}
