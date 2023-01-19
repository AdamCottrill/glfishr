#' Get list of management units from GLIS API
#'
#' @param filter_list list
#' @param to_upper should the names of the dataframe be converted to
#' upper case?
#'
#' @return dataframe
#' @export
#'
#' @examples
#' get_mu_list()
#' get_mu_list(list(lake = "HU"))
#' get_mu_list(list(lake = "HU", mu_type = "basin"))
get_mu_list <- function(filter_list = list(), to_upper = TRUE) {
  query_string <- build_query_string(filter_list)
  # TODO - add check_filters() when there's a swagger endpoint for common api
  # check_filters("species_list", filter_list)
  common_api_url <- get_common_portal_root()
  check_filters("common_filters", filter_list)
  my_url <- sprintf(
    "%s/management_units/%s",
    common_api_url,
    query_string
  )

  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, to_upper = to_upper)
  return(payload)
}
