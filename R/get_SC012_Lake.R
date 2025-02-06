#' Get FN012_Lake - Sampling specs (species and group) for a specific lake from Creel_Portal API
#'
#' This function accesses the api endpoint for FN012 Lake List records.
#' These records are the expected range of biodata values
#' (e.g. FLEN, TLEN, RWT, K) for the typical species caught during a creel
#' survey in a given lake. These constraints are used by ProcVal to check
#' that biodata for fish caught during the project is reasonable.
#' The lake MUST be specified for retrieving records using this function.
#' This is a useful function for building a template database for a new
#' creel project or for adding an FN012 table to an existing project.
#'
#' Use \code{show_filters("sc012_protocol")} to see the full list of
#' available filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/creels/api/v1/swagger/} and
#' filter by "sc012_protocol" for additional information.
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' sc012_lake <- get_SC012_Lake(list(lake = "ON"))
#'
#' sc012_lake <- get_SC012_Lake(list(lake = "ER", biosam = "1"))
#'
get_SC012_Lake <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc012_protocol", filter_list, "creels")
  my_url <- sprintf(
    "%s/sc012_protocol/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
