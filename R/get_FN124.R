
#' Get FN124 - Length Frequency Counts from FN_Portal API
#'
#' This function accesses the api endpoint to for FN124 records from
#' the FN_Portal. FN124 records contain information about the length frequency
#' by species for each effort in a sample.  For most gill
#' netting projects this corresponds to catches within a single panel
#' of a particular mesh size within a net set (gang). Group (GRP) is
#' occasionally included to further sub-divide the catch into user
#' defined groups that are usually specific to the project.  This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the catch including species,
#' or group code but also attributes of the effort, the sample or the
#' project(s) that the catches were made in.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn_124_list
#' for the full list of available filter keys (query parameters)
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Jeremy Holden \email{jeremy.holden@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' fn123 <- get_FN124(list(lake = "ON", year = 2012, spc = "334", gear = "GL"))
#'
#' filters <- list(
#'   lake = "ON",
#'   protocol = "TWL",
#'   year = 2021,
#'   spc = c("061", "121"),
#'   sidep__lte = 40
#' )
#' fn124 <- get_FN124(filters)
get_FN124 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn124", filter_list)
  my_url <- sprintf(
    "%s/fn124/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
