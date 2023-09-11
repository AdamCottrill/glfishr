#' Get aging structure options - A list of aging structure codes used in GLIS
#'
#' This function accesses the api endpoint for aging structure choices and returns
#' their labels, descriptions and whether they're in use. It can fetch the entire
#' table of valid aging structures, or it accepts the filter parameter all=TRUE
#' to return all aging structures, including those no longer in use. No other
#' filter parameters are currently available for this endpoint.
#'
#' Note that aging structures are valid for the AGEST field and the first
#' character of the AGEMT field.
#'
#'
#' See
#' http://10.167.37.157/common/aging_structures
#' for the full list of aging structure code options
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
#' agest <- get_agest()
#' agest_all <- get_agest(list(all = TRUE))
#' agest_slugs <- get_agest(show_id = TRUE)
get_agest <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  # check_filters("age_structure", filter_list, "common")
  # TODO: add a warning about 'all=TRUE' being the only allowed filter

  my_url <- sprintf(
    "%s/age_structure/%s",
    common_api_url,
    query_string
  )
  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, show_id, to_upper)

  return(payload)
}
