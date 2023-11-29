#' Get Gear List from the FN_Portal API
#'
#'  This function returns basic details about fishing gear(s) from the
#'  FN_Prortal api. Use get_gear_process_types() for more detail about
#'  the corresponding process type
#'
#' Use \code{show_filters("gear")} to see the full list of available
#' filter keys (query parameters). Refer to
#' \url{https://intra.glis.mnr.gov.on.ca/fn_portal/api/v1/swagger/}
#' and filter by "gear" for additional information.
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
#' GL10 <- get_gear(list(gr = "GL10"))
#' GL_n <- get_gear(list(gr = c("GL10", "GL21")))
#' GL1x <- get_gear(list(gr__like = "GL1"))
get_gear <- function(filter_list = list(), show_id = FALSE,
                     to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  check_filters("gear", filter_list, "fn_portal")
  my_url <- sprintf(
    "%s/gear/%s",
    get_fn_portal_root(),
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive = recursive)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
