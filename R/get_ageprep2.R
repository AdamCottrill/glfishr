#' Get age preparation 2 options - A list of age preparation 2 codes used in GLIS
#'
#' This function accesses the api endpoint for age preparation 2 choices and returns
#' their labels, descriptions and whether they're in use. It fetches the entire
#' table of valid age preparation 2 codes - no other
#' filter parameters are currently available for this endpoint.
#'
#' Note that age preparation 2 codes are valid for the second
#' character of the AGEMT field.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/ageprep2/
#' for the full list of age preparation 2 code options
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
#' ageprep2 <- get_ageprep2()
#' ageprep2_slugs <- get_ageprep2(show_id = TRUE)
get_ageprep2 <- function(
    filter_list = list(),
    show_id = FALSE,
    to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("ageprep2", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/ageprep2/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
