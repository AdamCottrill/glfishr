#' Get age preparation 1 options - A list of age preparation 1 codes used in GLIS
#'
#' This function accesses the api endpoint for age preparation 1 choices and returns
#' their labels, descriptions and whether they're in use. It fetches the entire
#' table of valid age preparation 1 codes - no other
#' filter parameters are currently available for this endpoint.
#'
#' Note that age preparation 1 codes are valid for the second
#' character of the AGEMT field.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/ageprep1/
#' for the full list of age preparation 1 code options
#'
#'
#' @param filter_list list
#'
#' @param show_id include the fields the 'id' and 'slug' in the
#'   returned data frame
#'
#' @param to_upper - should the names of the dataframe be converted to
#'   upper case?
#'
#' @param add_year_col - should a 'year' column be added to the
#'   returned dataframe?  This argument is ignored if the data frame
#'   does not contain a 'prj_cd' column or already has a 'year' column
#'
#' @author Rachel Henderson \email{rachel.henderson@@ontario.ca}
#' @return dataframe
#' @export
#' @examples
#'
#' ageprep1 <- get_ageprep1()
#' ageprep1_slugs <- get_ageprep1(show_id = TRUE)
get_ageprep1 <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE, add_year_col=FAlSE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("ageprep1", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/ageprep1/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper, add_year_col)

  return(payload)
}
