#' Get FN028 - Fishing Modes from FN_Portal API
#'
#' This function accesses the api endpoint to for FN028 records. FN028
#' records contain information about the fishing modes defined for a
#' project.  Fishing mode describes the gear, its orientation, and set
#' type.
#'
#' Use \code{show_filters("fn028")} to see the full list of available filter
#' keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
#' and filter by "fn028" for additional information.
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' fn028 <- get_FN028(list(lake = "ON", year = 2012))
#'
#' fn028 <- get_FN028(list(prj_cd = "LHA_IA19_812"))
#' fn028 <- get_FN028(list(prj_cd = "LHA_IA19_812"), show_id = TRUE)
get_FN028 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn028", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/fn028/%s",
    get_fn_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
