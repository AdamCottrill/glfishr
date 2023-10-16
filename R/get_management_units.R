#' Get management units - A list of management units in GLIS
#'
#' This function accesses the api endpoint for management units (MUs) and returns
#' MU names, types, centroids, envelopes, and associated lakes. It is useful for
#' fetching a table of all MUs currently in GLIS, but it also accepts the filter parameters
#' 'lake' and 'mu_type' to further filter results.
#'
#'
#' See
#' https://intra.glis.mnr.gov.on.ca/common/management_units/
#' for the full list of management units
#'
#' @param filter_list list
#'
#' @param show_id include the fields the 'id' and 'slug' in the
#' returned data frame
#'
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

  payload <- api_to_dataframe(my_url, recursive=recursive)
  payload <- prepare_payload(payload, show_id, to_upper)
  return(payload)
}
