#' Get tag position options - A list of tag position codes used in GLIS
#'
#' This function accesses the api endpoint for tag position choices and returns
#' their labels, descriptions and whether they're in use. It fetches
#' the entire table of accepted tag positions - no other filter
#' parameters are currently available for this endpoint. Tag position is the
#' second character of TAGDOC.
#'
#'
#' See
#' http://10.167.37.157/common/tag_postisions
#' for the full list of tag position options
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
#' tag_positions <- get_tag_positions()
#' tag_position_slugs <- get_tag_positions(show_id = TRUE)
get_tag_positions <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("tag_position", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/tag_position/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
