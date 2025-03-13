#' Get SC124 - Length Frequency Counts from Creel_Portal API
#'
#' This function accesses the api endpoint for SC124 records from the
#' Creel_Portal. SC124 records contain information about the length
#' frequency by species associated with an angler interview. Group
#' (GRP) is occasionally included to further sub-divide the catch into
#' user defined groups that are usually specific to the project. This
#' function takes an optional filter list which can be used to return
#' record based on several attributes of the catch including species
#' or group code but also attributes of the effort, the sample or the
#' project(s) that the catches were made in.
#'
#' Use \code{show_filters("sc124")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc124" for additional information.
#'
#' @param filter_list list
#'
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#'     fields are hidden from the data frame. To return these columns
#'     as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the data-frame be converted to
#' upper case?
#'
#' @param uncount - should the binned data be expanded to represent
#' individual measurements.  A SC124 record with sizcnt=5 will be
#' repeated 5 times in the returned data frame.
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @param add_year_col - should a 'year' column be added to the
#'   returned dataframe?  This argument is ignored if the data frame
#'   does not contain a 'prj_cd' column.
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
#'   uncount = TRUE
#' )
get_SC124 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, uncount = FALSE,
                      record_count = FALSE, add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc124", filter_list, api_app = "creels")
  my_url <- sprintf(
    "%s/sc124/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  if (uncount & length(payload)) {
    payload <- uncount_tally(payload, "SIZCNT")
  }

  if (add_year_col) payload <- add_year_col(payload)

  return(payload)
}
