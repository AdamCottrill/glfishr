#' Get tag types - A list of tag types used in GLIS
#'
#' This function accesses the api endpoint for tag type choices and returns
#' their labels, descriptions and whether they're in use. It can fetch
#' the entire table of accepted tag types, or it accepts the filter parameter
#' all=TRUE to return depreciated tag type choices too. No other filter
#' parameters are currently available for this endpoint. Tag types are
#' first character of TAGDOC.
#'
#'
#' See
#' http://10.167.37.157/common/tag_types
#' for the full list of tag types
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
#' tag_types <- get_tag_types()
#' all_tag_types <- get_tag_types(list(all = TRUE))
#' tag_slugs <- get_tag_types(show_id = TRUE)
get_tag_types <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("tag_types", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/tag_type_choice/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
