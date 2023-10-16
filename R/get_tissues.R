#' Get tissues - A list of tissue types used in GLIS
#'
#' This function accesses the api endpoint for tissue types and returns
#' their names, descriptions and whether they're in use. It can fetch
#' the entire table of accepted tissue codes, or it accepts filter parameter
#' all=TRUE to return depreciated tissue codes too. No other filter
#' parameters are currently available for this endpoint.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/tissues/
#' for the full list of tissues
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
#' tissues <- get_tissues()
#' all_tissues <- get_tissues(list(all = TRUE))
#' tissue_slugs <- get_tissues(show_id = TRUE)
get_tissues <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("tissues", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/tissues/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
