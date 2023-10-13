#' Get fisheries office options - A list of fisheries office codes used in GLIS
#'
#' This function accesses the api endpoint for fisheries office choices and returns
#' their labels, descriptions and whether they're in use. It fetches
#' the entire table of accepted fisheries offices - no other filter
#' parameters are currently available for this endpoint. Fisheries office codes
#' represent the first three digits of project code (PRJ_CD).
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/fisheries_offices/
#' for the full list of fisheries_office options
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
#' fisheries_offices <- get_fisheries_offices()
#' fisheries_office_slugs <- get_fisheries_offices(show_id = TRUE)
get_fisheries_offices <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("fisheries_offices", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter
  
  my_url <- sprintf(
    "%s/fisheries_offices/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)
  
  return(payload)
}
