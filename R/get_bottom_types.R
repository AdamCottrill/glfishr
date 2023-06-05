#' Get bottom types - A list of bottom types used in GLIS
#'
#' This function accesses the api endpoint for lake bottom types and returns
#' their names, descriptions and whether they're in use. It can fetch
#' the entire table of accepted bottom type codes, or it accepts filter parameter
#' all=TRUE to return depreciated bottom type codes too. No other filter
#' parameters are currently available for this endpoint.
#'
#'
#' See
#' http://10.167.37.157/common/bottom_types
#' for the full list of bottom types
#'
#'
#' @param filter_list list
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' bottom_types <- get_bottom_types()
#' all_bottom_types <- get_bottom_types(list(all = TRUE))
#' bottom_type_slugs <- get_bottom_types(show_id = TRUE)
get_bottom_types <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("bottom_types", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/bottom_types/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
