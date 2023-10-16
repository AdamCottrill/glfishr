#' Get clip code options - A list of clip codes used in GLIS
#'
#' This function accesses the api endpoint for clip code choices and returns
#' their labels, descriptions and whether they're in use. It fetches
#' the entire table of clip codes - no other filter
#' parameters are currently available for this endpoint. The same list of
#' clip codes are available for CLIPA and CLIPC.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/finclips/
#' for the full list of clip code options
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
#' clip_codes <- get_clip_codes()
#' clip_code_slugs <- get_clip_codes(show_id = TRUE)
get_clip_codes <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("finclips", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/finclips/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
