
#' Get FN124 - Length Frequency Counts from FN_Portal API
#'
#' This function accesses the api endpoint for FN124 records from
#' the FN_Portal. FN124 records contain information about the length frequency
#' by species for each effort in a sample. For most gill
#' netting projects this corresponds to catches within a single panel
#' of a particular mesh size within a net set (gang). Group (GRP) is
#' occasionally included to further sub-divide the catch into user
#' defined groups that are usually specific to the project. This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the catch including species
#' or group code but also attributes of the effort, the sample or the
#' project(s) that the catches were made in.
#'
#' Use ~show_filters("fn124")~ to see the full list of available filter
#' keys (query parameters). Refer to https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/
#' and filter by "fn124" for additional information.
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param uncount - should the binned data be expanded to represent
#' indivual measurements.  A FN124 record with sizcnt=5 will be
#' repeated 5 times in the returned data frame.
#'
#' @author Jeremy Holden \email{jeremy.holden@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' fn124 <- get_FN124(list(lake = "ON", year = 2021, spc = "334"))
#'
#' filters <- list(
#'   lake = "ON",
#'   protocol = "TWL",
#'   year = 2021,
#'   spc = c("061", "121"),
#'   sidep__lte = 40
#' )
#' fn124 <- get_FN124(filters)
#'
#' LOA_IA21_TW1 <- get_FN124(list(prj_cd = "LOA_IA21_TW1"),
#'   uncount = TRUE
#' )
get_FN124 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, uncount = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn124", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn124/%s",
    get_fn_portal_root(),
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
