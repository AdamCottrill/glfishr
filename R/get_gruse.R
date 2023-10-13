#' Get gear use options - A list of gear use codes used in GLIS
#'
#' This function accesses the api endpoint for gear use choices and returns
#' their labels, descriptions and whether they're in use. It fetches
#' the entire table of gear use codes - no other filter
#' parameters are currently available for this endpoint.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/gruse/
#' for the full list of gear use code options
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
#' gruse <- get_gruse()
#' gruse_slugs <- get_gruse(show_id = TRUE)
get_gruse <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("gruse", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/gruse/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
