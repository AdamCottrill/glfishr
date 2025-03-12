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
#' Use \code{show_filters("fn121electrofishing")} to see the full list
#' of available filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
#' and filter by "fn121electrofishing" for additional information.
#'
#' @param filter_list list
#'
#' @param show_id When 'FALSE', the default, the 'slug'
#' field is hidden from the data frame. To return this field
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @param add_year_col - should a 'year' column be added to the
#'   returned dataframe?  This argument is ignored if the data frame
#'   does not contain a 'prj_cd' column.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#' \dontrun{
#' show_filters("fn121electrofishing")
#' }
#'
#' fn121_efish_huron <- get_FN121_Electrofishing(list(lake = "HU", year = 2018))
#'
#' fn121_efish_500ss <- get_FN121_Electrofishing(list(shock_sec__gte = 500))
get_FN121_Electrofishing <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE, add_year_col = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn121electrofishing", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn121electrofishing/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper, add_year_col = add_year_col)

  return(payload)
}
