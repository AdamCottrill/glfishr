#' Get orientation options - A list of orientation codes used in GLIS
#'
#' This function accesses the api endpoint for orientation choices and returns
#' their labels, descriptions and whether they're in use. It fetches
#' the entire table of orientation codes - no other filter
#' parameters are currently available for this endpoint.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/orient/
#' for the full list of orientation code options
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
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' orientations <- get_orientations()
#' orientation_slugs <- get_orientations(show_id = TRUE)
get_orientations <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("orient", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/orient/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
