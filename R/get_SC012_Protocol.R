#' Get SC012_Protocol - Creel Sampling specs (species and group) for a
#' specific lake and from the Creel_Portal API
#'
#' This function accesses the api endpoint for SC012 Protocol List
#' records. These records are the expected range of biodata values
#' (e.g. FLEN, TLEN, RWT, K) for the typical species sampled in a
#' creel conducted in a given lake. These constraints are used
#' by ProcVal to check that biodata for fish sampled during the creel is
#' reasonable. This is a useful function for building
#' a template database for a new project or for adding an SC012 table to
#' an existing project.
#'
#' Use \code{show_filters("sc012_protocol")} to see the full list of available filter
#' keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/sc_portal/api/v1/swagger/}
#' and filter by "sc012_protocol" for additional information.
#'
#' @param filter_list list
#' @param show_id When 'FALSE', the default, the 'id' and 'slug'
#' fields are hidden from the data frame. To return these columns
#' as part of the data frame, use 'show_id = TRUE'.
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Adam Cottrill \email{adam.cottrill@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' sc012_protocol <- get_SC012_Protocol(list(lake = "ON"))
#'
#' sc012_protocol <- get_SC012_Protocol(list(lake = c("HU", "ER"), protocol = "BSM"))
#'
get_SC012_Protocol <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("sc012_protocol", filter_list, "creel_portal")
  my_url <- sprintf(
    "%s/sc012_protocol/%s",
    get_sc_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
