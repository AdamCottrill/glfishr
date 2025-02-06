#' Get tagging agency options - A list of tagging agency codes used in GLIS
#'
#' This function accesses the api endpoint for tagging agency choices and returns
#' their labels, descriptions and whether they're in use. It fetches
#' the entire table of tagging agency codes - no other filter
#' parameters are currently available for this endpoint.
#' Tagging agency is the third and fourth characters of TAGDOC.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/tagging_agencies/
#' for the full list of tagging agency code options
#'
#'
#' @param filter_list list
#'
#' @param show_id include the fields the 'id' and 'slug' in the
#' returned data frame
#'
#' @param to_upper - should the names of the dataframe be converted to
#' upper case?
#'
#' @param record_count - should data be returned, or just the number
#'   of records that would be returned given the current filters.
#'
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' orientations <- get_orientations()
#' orientation_slugs <- get_orientations(show_id = TRUE)
get_tag_agencies <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, record_count = FALSE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("tagging_agencies", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/tagging_agencies/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url, record_count = record_count)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
