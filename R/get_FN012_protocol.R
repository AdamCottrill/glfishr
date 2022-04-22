#' Get FN012_protocol - Sampling specs (species and group) for a
#' specific lake and protocol from FN_Portal API
#'
#' This function accesses the api endpoint for FN012 Protocol List
#' records. These records are the expected range of biodata values
#' (e.g. FLEN, TLEN, RWT, K) for the typical species caught in using
#' a given protocol in a given lake. These constraints are used
#' by ProcVal to check that biodata for fish caught during the project is
#' reasonable. The protocol and lake MUST be specified for retrieving
#' records using this function. This is a useful function for building
#' a template database for a new project or for adding an FN012 table to
#' an existing project.
#'
#' See
#' http://10.167.37.157/fn_portal/redoc/#operation/fn012_protocol_list
#' for the full list of available filter keys (query parameters)
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
#' fn012_protocol <- get_FN012_protocol(list(lake = "ON", protocol = "TWL"))
#'
#' fn012_protocol <- get_FN012_protocol(list(lake = "HU", protocol = "BSM"))
#'
#' fn012_protocol <- get_FN012_protocol(list(lake = "ER", protocol = "Hydro"))
get_FN012_protocol <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("fn012_protocol", filter_list)
  my_url <- sprintf(
    "%s/fn012_protocol/%s",
    get_fn_portal_root(),
    query_string
  )
  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
