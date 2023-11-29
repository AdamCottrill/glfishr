#' Get Gear Effort Process Types from the FN_Portal API
#'
#' Process type describes how the catch in a sample is handled -
#' either by net, by mesh size, by groups of panels, or individual
#' panels.  The available process types are constrained depending on
#' the gear type.  This function returns the known gear, effort and
#' process type combinations from the FN_Prortal api, which can then
#' be used to validee FN122 and FN123 records, or used to populate the
#' ProcessEffortGear table in the template database before submitting
#' to Process Validate.
#'
#' Use \code{show_filters("gear_effort_process_types")} to see the
#' full list of available filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
#' and filter by "gear_effort_process_types" for additional
#' information.
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
#' ptype <- get_gear_process_types(list(gr = "GL10"))
#' ptype <- get_gear_process_types(list(gr = c("GL10", "GL21")))
#' ptype <- get_gear_process_types(list(gr__like = "GL1"))
get_gear_process_types <- function(filter_list = list(), show_id = FALSE,
                                   to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("gear_effort_process_types", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/gear_effort_process_types/%s",
    get_fn_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
