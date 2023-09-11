#' Get list of lake management unit types from GLIS API
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
  common_api_url <- get_common_portal_root()
  check_filters("lake_management_unit_types", filter_list, "common")
  my_url <- sprintf(
    "%s/lake_management_unit_types/%s",
    common_api_url,
    query_string
  )

  payload <- api_to_dataframe(my_url)
  payload <- prepare_payload(payload, to_upper = to_upper)
  return(payload)
}
