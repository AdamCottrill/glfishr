#' Get management units from GLIS API
#'
#' @param filter_list list
#' @param to_upper should the names of the dataframe be converted to
#' upper case?
#'
#' @return dataframe
#' @export
#'
#' @examples
#' get_management_units()
#' get_management_units(list(lake = "HU"))
#' get_management_units(list(lake = "HU", mu_type = "basin"))
get_management_units <- function(filter_list = list(), show_id = FALSE, to_upper = TRUE) {
  recursive <- ifelse(length(filter_list) == 0, FALSE, TRUE)
  query_string <- build_query_string(filter_list)
  common_api_url <- get_common_portal_root()
  check_filters("management_units", filter_list, "common")
  my_url <- sprintf(
    "%s/management_units/%s",
    common_api_url,
    query_string
  )

  payload <- api_to_dataframe(my_url, recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  return(payload)
}
